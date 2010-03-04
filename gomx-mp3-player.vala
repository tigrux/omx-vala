int main(string[] args) {
    if(args.length != 2) {
        print("%s <file.mp3>\n", args[0]);
        return 1;
    }

    try {
        play(args[1]);
        return 0;
    }
    catch(GOmx.Error e) {
        print("An error of omx occurred\n");
        print("%s\n", e.message);
        return 1;
    }
    catch(Error e) {
        print("An error of glib occurred\n");
        print("%s\n", e.message);
        return 1;
    }
    
}


const int AUDIODEC_ID = 0;
const int AUDIOSINK_ID = 1;


public void play(string filename) throws Error,GOmx.Error {
    var fd = FileStream.open(filename, "rb");
    if(fd == null)
        throw new FileError.FAILED("Error opening %s", filename);

    var core = GOmx.Core.open("libomxil-bellagio.so.0");
    core.init();

    var audiodec = new GOmx.AudioComponent(core, "OMX.st.audio_decoder.mp3.mad");
    //audiodec.component_role = "audio_decoder.mp3";
    audiodec.name = "audiodec";

    var audiosink = new GOmx.AudioComponent(core,"OMX.st.alsa.alsasink");
    //audiosink.component_role = "alsa.alsasrc";
    audiosink.name = "audiosink";

    var engine = new GOmx.Engine();
    engine.add_component(AUDIODEC_ID, audiodec);
    engine.add_component(AUDIOSINK_ID, audiosink);

    engine.init();
    engine.set_state_and_wait(Omx.State.Idle);
    engine.set_state_and_wait(Omx.State.Executing);

    engine.buffers_begin_transfer();
    foreach(var port in engine.ports_with_buffer_done) {
        switch(port.component.id) {
            case AUDIODEC_ID:
                switch(port.definition.dir) {
                    case Omx.Dir.Input: {
                        var buffer = port.pop_buffer();
                        GOmx.buffer_read_from_file(buffer, fd);
                        port.push_buffer(buffer);
                        break;
                    }
                    case Omx.Dir.Output: {
                        var buffer = port.pop_buffer();
                        var audiosink_inport = audiosink.ports[0];
                        var audiosink_buffer = audiosink_inport.pop_buffer();
                        GOmx.buffer_copy(audiosink_buffer, buffer);
                        audiosink_inport.push_buffer(audiosink_buffer);
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

    engine.set_state_and_wait(Omx.State.Idle);
    engine.set_state_and_wait(Omx.State.Loaded);

    engine.free_handles();
    core.deinit();
}

