const string AUDIODEC_COMPONENT = "OMX.st.audio_decoder.mp3.mad";
const int AUDIODEC_ID = 0;

const string AUDIOSINK_COMPONENT = "OMX.st.alsa.alsasink";
const int AUDIOSINK_ID = 1;


int main(string[] args) {
    if(args.length != 2) {
        print("%s <file.mp3>\n", args[0]);
        return 1;
    }

    try {
        play(args[1]);
        return 0;
    }
    catch(Error e) {
        print("%s\n", e.message);
        return 1;
    }
}


public void play(string filename) throws Error {
    var fd = FileStream.open(filename, "rb");
    if(fd == null)
        throw new FileError.FAILED("Error opening %s", filename);

    var core = Omx.Core.open("libomxil-bellagio.so.0");
    core.init();

    var audiodec =
        core.get_component(AUDIODEC_COMPONENT, Omx.Index.ParamAudioInit);
    audiodec.name = "audiodec";
    audiodec.id = AUDIODEC_ID;

    var audiosink =
        core.get_component(AUDIOSINK_COMPONENT, Omx.Index.ParamAudioInit);
    audiosink.name = "audiosink";
    audiosink.id = AUDIOSINK_ID;

    var engine = new Omx.Engine();
    engine.add_component(audiodec);
    engine.add_component(audiosink);

    engine.set_state(Omx.State.Idle);
    engine.allocate_ports();
    engine.allocate_buffers();
    engine.wait_for_state_set();

    engine.set_state(Omx.State.Executing);
    engine.wait_for_state_set();

    foreach(var component in engine.components) {
        print("Component %s\n", component.name);
        foreach(var port in component.ports) {
            print("\tPort %s\n", port.name);
            foreach(var buffer in port.buffers)
                print("\t\tBuffer %p\n", buffer);
        }
    }

    engine.start();
    foreach(var port in engine.ports) {
        switch(port.component.id) {
            case AUDIODEC_ID:
                switch(port.definition.dir) {
                    case Omx.Dir.Input: {
                        var buffer = port.pop_buffer();
                        Omx.buffer_read_from_file(buffer, fd);
                        port.push_buffer(buffer);
                        break;
                    }

                    case Omx.Dir.Output: {
                        var buffer = port.pop_buffer();
                        var audiosink_inport = audiosink.get_port(0);
                        var alsa_buffer = audiosink_inport.pop_buffer();
                        Omx.buffer_copy(alsa_buffer, buffer);
                        audiosink_inport.push_buffer(alsa_buffer);
                        port.push_buffer(buffer);
                        break;
                    }

                    default:
                        break;
                }
                break;

            case AUDIOSINK_ID:
                switch(port.definition.dir) {
                    case Omx.Dir.Input:
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

