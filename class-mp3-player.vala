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
    const string AUDIODEC_COMPONENT = "OMX.st.audio_decoder.mp3.mad";
    const int AUDIODEC_ID = 0;

    const string AUDIOSINK_COMPONENT = "OMX.st.alsa.alsasink";
    const int AUDIOSINK_ID = 1;

    public void play(string filename) throws Error {
        var fd = FileStream.open(filename, "rb");
        if(fd == null)
            throw new FileError.FAILED("Error opening %s", filename);

        var core = Omx.Core.open("libomxil-bellagio.so.0");
        core.init();
        var engine = new Omx.Engine();

        var audiodec =
            core.get_component(AUDIODEC_COMPONENT, Omx.Index.ParamAudioInit);
        audiodec.name = "audiodec";
        audiodec.id = AUDIODEC_ID;

        var audiosink =
            core.get_component(AUDIOSINK_COMPONENT, Omx.Index.ParamAudioInit);
        audiosink.name = "audiosink";
        audiosink.id = AUDIOSINK_ID;
        
        engine.add_component(audiodec);
        engine.add_component(audiosink);
        
        engine.set_state(Omx.State.Idle);
        engine.allocate_ports();
        engine.wait_for_state_set();
        
        engine.set_state(Omx.State.Executing);
        engine.wait_for_state_set();

        audiodec.prepare_ports();
        
        foreach(var port in engine) {
            Omx.BufferHeader buffer;

            switch(port.component.id) {
                case AUDIODEC_ID:
                    switch(port.definition.dir) {
                        case Omx.Dir.Input:
                            print("Got buffer from audiodec inport\n");
                            buffer = port.pop_buffer();
                            buffer.offset = 0;
                            buffer.filled_len = fd.read(buffer.buffer);
                            if(fd.eof())
                                buffer.flags |= Omx.BufferFlag.EOS;
                            port.push_buffer(buffer);
                            break;
                        case Omx.Dir.Output:
                            print("Got buffer from audiodec outport\n");
                            buffer = port.pop_buffer();
                            //audiosink.get_port(0).push_buffer(buffer);
                            port.push_buffer(buffer);
                            break;
                        default:
                            break;
                    }
                    break;
                    
                case AUDIOSINK_ID:
                    switch(port.definition.dir) {
                        case Omx.Dir.Input:
                            print("Got buffer from audiosink inport\n");
                            buffer = port.pop_buffer();
                            audiodec.get_port(1).push_buffer(buffer);
                            
                            break;
                        default:
                            break;
                    }
                    break;
            }
        }

        engine.set_state(Omx.State.Idle);
        engine.wait_for_state_set();

        engine.set_state(Omx.State.Loaded);
        engine.free_ports();
        engine.wait_for_state_set();
        
        engine.free_handles();

        core.deinit();
    }    
}

