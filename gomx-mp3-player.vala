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


const int AUDIODEC_ID = 0;
const int AUDIOSINK_ID = 1;

const string AUDIODEC_COMPONENT = "OMX.st.audio_decoder.mp3.mad";
const string AUDIOSINK_COMPONENT = "OMX.st.alsa.alsasink";


public void play(string filename) throws Error {
    var fd = FileStream.open(filename, "rb");
    if(fd == null)
        throw new FileError.FAILED("Error opening %s", filename);

    var core = GOmx.Core.open("libomxil-bellagio.so.0");
    core.init();

    var audiodec =
        new GOmx.Component(core, AUDIODEC_COMPONENT, Omx.Index.ParamAudioInit);
    audiodec.name = "audiodec";
    audiodec.id = AUDIODEC_ID;

    var audiosink =
        new GOmx.Component(core, AUDIOSINK_COMPONENT, Omx.Index.ParamAudioInit);
    audiosink.name = "audiosink";
    audiosink.id = AUDIOSINK_ID;

    var engine = new GOmx.Engine();
    engine.add_component(audiodec);
    engine.add_component(audiosink);

    engine.init();
    engine.set_state_and_wait(Omx.State.Idle);
    engine.set_state_and_wait(Omx.State.Executing);


    engine.start();
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

