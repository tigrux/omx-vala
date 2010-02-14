class SimpleMp3Player: Object {

    Bellagio.Semaphore audiodec_sem;
    Bellagio.Semaphore audiosink_sem;
    Bellagio.Semaphore eos_sem;

    Omx.Handle audiodec_handle;
    Omx.Handle audiosink_handle;

    Omx.BufferHeader[] in_buffer_audiosink;
    Omx.BufferHeader[] in_buffer_audiodec;
    Omx.BufferHeader[] out_buffer_audiodec;

    FileStream fd;
    bool eos_found;

    const int n_buffers = 2;
    const int buffer_out_size = 4*8192;
    const int buffer_in_size = 4096;

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

    Omx.Error audiodec_event_handler(
            Omx.Handle component,
            Omx.Event event,
            uint32 data1, uint32 data2,
            void *event_data) {
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
            case Omx.Event.BufferFlag:
                switch(data2) {
                    case Omx.BufferFlag.EOS:
                        eos_sem.up();
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

    Omx.Error audiodec_empty_buffer_done(
            Omx.Handle component,
            Omx.BufferHeader buffer) {
        var data_read = fd.read(buffer.buffer);
        buffer.offset = 0;

        if(eos_found)
            return Omx.Error.None;

        if(data_read == 0) {
            buffer.filled_len = 0;
            buffer.flags |= Omx.BufferFlag.EOS;
            eos_found = true;
        }
        else
            buffer.filled_len = data_read;

        return component.empty_this_buffer(buffer);
    }

    Omx.Error audiodec_fill_buffer_done(
            Omx.Handle component,
            Omx.BufferHeader buffer) {
        if(buffer.filled_len == 0)
            return Omx.Error.None;
        else
            return audiosink_handle.empty_this_buffer(buffer);
    }

    Omx.Error audiosink_event_handler(
            Omx.Handle component,
            Omx.Event event, 
            uint32 data1, uint32 data2,
            void *event_data) {
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

    construct {
        audiodec_sem.init(0);
        audiosink_sem.init(0);
        eos_sem.init(0);
    }

    void get_handles() throws GLib.Error {
        Omx.try_run(
            Omx.get_handle(
                out audiodec_handle, "OMX.st.audio_decoder.mp3.mad",
                this, audiodec_callbacks));
        Omx.try_run(
            Omx.get_handle(
                out audiosink_handle, "OMX.st.alsa.alsasink",
                this, audiosink_callbacks));
    }

    void pass_to_idle_and_allocate_buffers() throws GLib.Error {
        Omx.try_run(
            audiodec_handle.send_command(
                Omx.Command.StateSet, Omx.State.Idle, null));
        Omx.try_run(
            audiosink_handle.send_command(
                Omx.Command.StateSet, Omx.State.Idle, null));

        in_buffer_audiodec = new Omx.BufferHeader[n_buffers];
        for(int i=0; i<n_buffers; i++)
            Omx.try_run(
                audiodec_handle.allocate_buffer(
                    out in_buffer_audiodec[i], Omx.Dir.Input,
                    null, buffer_in_size));

        out_buffer_audiodec = new Omx.BufferHeader[n_buffers];
        for(int i=0; i<n_buffers; i++)
            Omx.try_run(
                audiodec_handle.allocate_buffer(
                    out out_buffer_audiodec[i], Omx.Dir.Output,
                    null, buffer_out_size));

        in_buffer_audiosink = new Omx.BufferHeader[n_buffers];
        for(int i=0; i<n_buffers; i++)
            Omx.try_run(
                audiosink_handle.use_buffer(
                    out in_buffer_audiosink[i], Omx.Dir.Input, null,
                    buffer_out_size, out_buffer_audiodec[i].buffer));

        audiodec_sem.down();
        audiosink_sem.down();
    }

    void pass_to_executing() throws GLib.Error {
        Omx.try_run(
            audiodec_handle.send_command(
                Omx.Command.StateSet, Omx.State.Executing, null));
        Omx.try_run(
            audiosink_handle.send_command(
                Omx.Command.StateSet, Omx.State.Executing, null));

        audiodec_sem.down();
        audiosink_sem.down();
    }

    void move_buffers(string filename) throws GLib.Error {
        fd = FileStream.open(filename, "rb");

        for(int i=0; i<n_buffers; i++) {
            var data_read = fd.read(in_buffer_audiodec[i].buffer);
            in_buffer_audiodec[i].filled_len = data_read;
            in_buffer_audiodec[i].offset = 0;
            Omx.try_run(
                audiodec_handle.empty_this_buffer(
                    in_buffer_audiodec[i]));
        }

        Omx.try_run(
            audiodec_handle.fill_this_buffer(
                out_buffer_audiodec[0]));

        eos_sem.down();
    }

    void pass_to_idle() throws GLib.Error {
        Omx.try_run(
            audiodec_handle.send_command(
                Omx.Command.StateSet, Omx.State.Idle, null));
        Omx.try_run(
            audiosink_handle.send_command(
                Omx.Command.StateSet, Omx.State.Idle, null));

        audiodec_sem.down();
        audiosink_sem.down();
    }

    void pass_to_loaded_and_free_buffers() throws GLib.Error {
        Omx.try_run(
            audiodec_handle.send_command(
                Omx.Command.StateSet, Omx.State.Loaded, null));
        Omx.try_run(
            audiosink_handle.send_command(
                 Omx.Command.StateSet, Omx.State.Loaded, null));

        for(int i=0; i<n_buffers; i++) {
            Omx.try_run(
                audiodec_handle.free_buffer(
                    Omx.Dir.Input, in_buffer_audiodec[i]));
            Omx.try_run(
                audiodec_handle.free_buffer(
                    Omx.Dir.Output, out_buffer_audiodec[i]));
            Omx.try_run(
                audiosink_handle.free_buffer(
                    Omx.Dir.Input, in_buffer_audiosink[i]));
        }

        audiodec_sem.down();
        audiosink_sem.down();
    }

    void free_handles() throws GLib.Error {
        Omx.try_run(
            audiodec_handle.free_handle());
        Omx.try_run(
            audiosink_handle.free_handle());
    }

    public void decode(string filename) throws GLib.Error {
        Omx.try_run(Omx.init());
        get_handles();
        pass_to_idle_and_allocate_buffers();
        pass_to_executing();
        move_buffers(filename);
        pass_to_idle();
        pass_to_loaded_and_free_buffers();
        free_handles();
        Omx.try_run(Omx.deinit());
    }
}

int main(string[] args) {
    if(args.length != 2) {
        print("%s <file.mp3>\n", args[0]);
        return 1;
    }

    var decoder = new SimpleMp3Player();
    try {
        decoder.decode(args[1]);
        return 0;
    }
    catch(Error e) {
        print(e.message);
        return 1;
    }
}

