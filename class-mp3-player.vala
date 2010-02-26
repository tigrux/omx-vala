int main(string[] args) {
    if(args.length != 2) {
        print("%s <file.mp3>\n", args[0]);
        return 1;
    }

    var player = new Mp3Player();

    try {
        player.play(args[1]);
        return 0;
    }
    catch(Error e) {
        print("%s\n", e.message);
        return 1;
    }
}


public class Mp3Player: Object {
    const string AUDIODEC_COMPONENT_NAME = "OMX.st.audio_decoder.mp3.mad";

    public void play(string filename) throws Error {
        var fd = FileStream.open(filename, "rb");
        if(fd == null)
            throw new FileError.FAILED("Error opening %s", filename);

        var audiodec =
            new Omx.Component(AUDIODEC_COMPONENT_NAME, Omx.Index.ParamAudioInit);

        Omx.try_run(Omx.init());

        audiodec.name = "audiodec";        
        audiodec.init();

        audiodec.set_state(Omx.State.Idle);
        audiodec.allocate_ports();
        audiodec.wait_for_state_set();

        audiodec.set_state(Omx.State.Executing);
        audiodec.fill_output_buffers();
        audiodec.empty_input_buffers();
        audiodec.wait_for_state_set();

        bool eos_found = false;
        while(!eos_found) {
            var port = audiodec.pop_port();
            var buffer = port.pop_buffer();

            switch(port.definition.dir) {
                case Omx.Dir.Input:
                    buffer.offset = 0;
                    buffer.filled_len = fd.read(buffer.buffer);
                    if(fd.eof())
                        buffer.flags |= Omx.BufferFlag.EOS;
                    break;
                case Omx.Dir.Output:
                    print("Got %d bytes\n", (int)buffer.filled_len);
                    if(buffer.eos()) {
                        print("Got eos\n");
                        eos_found = true;
                    }
                    break;
                default:
                    break;
            }

            port.push_buffer(buffer);
        }

        audiodec.set_state(Omx.State.Idle);
        audiodec.wait_for_state_set();

        audiodec.set_state(Omx.State.Loaded);
        audiodec.free_ports();
        audiodec.wait_for_state_set();
        
        audiodec.free();

        Omx.try_run(Omx.deinit());
    }    
}

