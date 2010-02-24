int main(string[] args) {
    if(args.length != 2) {
        print("%s <file.mp3>\n", args[0]);
        return 1;
    }

    var player = new SimpleMp3Player();

    try {
        player.play(args[1]);
        return 0;
    }
    catch(Error e) {
        print("%s\n", e.message);
        return 1;
    }
}

class SimpleMp3Player: Object {
    const int N_BUFFERS = 2;
    const int BUFFER_OUT_SIZE = 32768;
    const int BUFFER_IN_SIZE = 4096;

    Bellagio.Semaphore audiodec_sem;
    Bellagio.Semaphore audiosink_sem;
    Bellagio.Semaphore eos_sem;

    construct {
        audiodec_sem.init(0);
        audiosink_sem.init(0);
        eos_sem.init(0);
    }


    FileStream fd;

    public void play(string filename) throws Error {
        fd = FileStream.open(filename, "rb");
        if(fd == null)
            throw new FileError.FAILED("Error opening %s", filename);

        Omx.try_run(Omx.init());
        get_handles();
        handle_print_info("audiodec", audiodec_handle);
        handle_print_info("audiosink", audiosink_handle);
        pass_to_idle_and_allocate_buffers();
        pass_to_executing();
        move_buffers();
        pass_to_idle();
        pass_to_loaded_and_free_buffers();
        free_handles();
        Omx.try_run(Omx.deinit());
    }

    const Omx.Callback audiodec_callbacks = {
        audiodec_event_handler,
        audiodec_empty_buffer_done,
        audiodec_fill_buffer_done
    };

    const Omx.Callback audiosink_callbacks = {
        audiosink_event_handler,
        audiosink_empty_buffer_done,
        null
    };

    Omx.Handle audiodec_handle;
    Omx.Handle audiosink_handle;

    const string AUDIODEC_COMPONENT_NAME = "OMX.st.audio_decoder.mp3.mad";
    const string AUDIOSINK_COMPONENT_NAME = "OMX.st.alsa.alsasink";

    void get_handles() throws Error {
        Omx.try_run(
            Omx.get_handle(
                out audiodec_handle, AUDIODEC_COMPONENT_NAME,
                this, audiodec_callbacks));
        Omx.try_run(
            Omx.get_handle(
                out audiosink_handle, AUDIOSINK_COMPONENT_NAME,
                this, audiosink_callbacks));
    }

    void handle_print_info(string name, Omx.Handle handle) throws Error {
        var param = Omx.Port.Param();
        param.init();
        
        Omx.try_run(
            handle.get_parameter(
                Omx.Index.ParamAudioInit, param));

        var port_def = Omx.Param.PortDefinition();
        port_def.init();

        print("%s (%p)\n", name, (void*)handle);
        for(uint i = param.start_port_number; i<param.ports; i++) {
            print("\tPort %u:\n", i);
            port_def.port_index = i;
            Omx.try_run(
                handle.get_parameter(
                    Omx.Index.ParamPortDefinition, port_def));
            print("\t\thas direction %s\n", port_def.dir.to_string());
            print("\t\thas %u buffers of size %u\n",
                port_def.buffer_count_actual, port_def.buffer_size);
        }
    }

    Omx.BufferHeader[] in_buffer_audiosink;
    Omx.BufferHeader[] in_buffer_audiodec;
    Omx.BufferHeader[] out_buffer_audiodec;

    void pass_to_idle_and_allocate_buffers() throws Error {
        Omx.try_run(
            audiodec_handle.send_command(
                Omx.Command.StateSet, Omx.State.Idle, null));
        Omx.try_run(
            audiosink_handle.send_command(
                Omx.Command.StateSet, Omx.State.Idle, null));

        in_buffer_audiodec = new Omx.BufferHeader[N_BUFFERS];
        out_buffer_audiodec = new Omx.BufferHeader[N_BUFFERS];
        in_buffer_audiosink = new Omx.BufferHeader[N_BUFFERS];

        for(int i=0; i<N_BUFFERS; i++) {
            Omx.try_run(
                audiodec_handle.allocate_buffer(
                    out in_buffer_audiodec[i], 0,
                    null, BUFFER_IN_SIZE));
            Omx.try_run(
                audiodec_handle.allocate_buffer(
                    out out_buffer_audiodec[i], 1,
                    null, BUFFER_OUT_SIZE));
            Omx.try_run(
                audiosink_handle.allocate_buffer(
                    out in_buffer_audiosink[i], 0,
                    null, BUFFER_OUT_SIZE));
        }

        audiodec_sem.down();
        audiosink_sem.down();
    }

    void pass_to_executing() throws Error {
        Omx.try_run(
            audiodec_handle.send_command(
                Omx.Command.StateSet, Omx.State.Executing, null));
        Omx.try_run(
            audiosink_handle.send_command(
                Omx.Command.StateSet, Omx.State.Executing, null));

        audiodec_sem.down();
        audiosink_sem.down();
    }

    void move_buffers() throws Error {
        for(int i=0; i<N_BUFFERS; i++) {
            var buffer = in_buffer_audiodec[i];
            var data_read = fd.read(buffer.buffer);

            in_buffer_audiodec[i].filled_len = data_read;
            in_buffer_audiodec[i].offset = 0;
    
            Omx.try_run(
                audiodec_handle.empty_this_buffer(
                    in_buffer_audiodec[i]));
            Omx.try_run(
                audiodec_handle.fill_this_buffer(
                    out_buffer_audiodec[i]));
        }

        print("Waiting for eos\n");
        eos_sem.down();
    }

    void pass_to_idle() throws Error {
        Omx.try_run(
            audiodec_handle.send_command(
                Omx.Command.StateSet, Omx.State.Idle, null));
        Omx.try_run(
            audiosink_handle.send_command(
                Omx.Command.StateSet, Omx.State.Idle, null));

        audiodec_sem.down();
        audiosink_sem.down();
    }

    void pass_to_loaded_and_free_buffers() throws Error {
        Omx.try_run(
            audiodec_handle.send_command(
                Omx.Command.StateSet, Omx.State.Loaded, null));
        Omx.try_run(
            audiosink_handle.send_command(
                 Omx.Command.StateSet, Omx.State.Loaded, null));

        for(int i=0; i<N_BUFFERS; i++) {
            Omx.try_run(
                audiodec_handle.free_buffer(
                    0, in_buffer_audiodec[i]));
            Omx.try_run(
                audiodec_handle.free_buffer(
                    1, out_buffer_audiodec[i]));
            Omx.try_run(
                audiosink_handle.free_buffer(
                    0, in_buffer_audiosink[i]));
        }

        audiodec_sem.down();
        audiosink_sem.down();
    }

    void free_handles() throws Error {
        Omx.try_run(
            audiodec_handle.free_handle());
        Omx.try_run(
            audiosink_handle.free_handle());
    }

    Omx.Error audiodec_event_handler(
            Omx.Handle component,
            Omx.Event event,
            uint32 data1, uint32 data2) {
        switch(event) {
            case Omx.Event.CmdComplete:
                switch(data1) {
                    case Omx.Command.StateSet:
                        audiodec_sem.up();
                        break;
                    default:
                        break;
                }
                break;
            default:
                break;
        }

        return Omx.Error.None;
    }

    bool eos_found;

    Omx.Error audiodec_empty_buffer_done(
            Omx.Handle component,
            Omx.BufferHeader buffer) {
        if(eos_found) {
            print("Buffer requested after eos was found\n");
            return Omx.Error.None;
        }

        buffer.offset = 0;
        buffer.filled_len = fd.read(buffer.buffer);
        
        if(fd.eof()) {
        	eos_found = true;
            print("Setting eos flag\n");
            buffer.flags |= Omx.BufferFlag.EOS;
        }

        return audiodec_handle.empty_this_buffer(buffer);
    }

    Omx.Error audiodec_fill_buffer_done(
            Omx.Handle component,
            Omx.BufferHeader buffer) {
        if((buffer.flags & Omx.BufferFlag.EOS) != 0) {
        	print("Got eos flag\n");
        	eos_sem.up();
        	return Omx.Error.None;
    	}
        return audiosink_handle.empty_this_buffer(buffer);
    }

    Omx.Error audiosink_event_handler(
            Omx.Handle component, Omx.Event event,
            uint32 data1, uint32 data2) {
        switch(event) {
            case Omx.Event.CmdComplete:
                switch(data1) {
                    case Omx.Command.StateSet:
                        audiosink_sem.up();
                        break;
                    default:
                        break;
                }
                break;
            default:
                break;
        }
        return Omx.Error.None;
    }

    Omx.Error audiosink_empty_buffer_done(
            Omx.Handle component,
            Omx.BufferHeader buffer) {
        return audiodec_handle.fill_this_buffer(buffer);
    }
}

