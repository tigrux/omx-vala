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
        print("Omx error caught\n");
        print("%s\n", e.message);
        return 1;
    }
    catch(FileError e) {
        print("File error caught\n");
        print("%s\n", e.message);
        return 1;
    }

}


const int AUDIODEC_ID = 0;
const int AUDIOSINK_ID = 1;

public void play(string filename) throws FileError, GOmx.Error {
    var fd = FileStream.open(filename, "rb");
    if(fd == null)
        throw new FileError.FAILED("Error opening %s", filename);

    var library = "libomxil-bellagio.so.0";

    var decoder = new GOmx.AudioComponent("OMX.st.audio_decoder.mp3.mad");
    decoder.name = "decoder";
    decoder.library = library;

    var sink = new GOmx.AudioComponent("OMX.st.alsa.alsasink");
    sink.name = "sink";
    sink.library = library;

    var engine = new GOmx.Engine();
    engine.add_component(AUDIODEC_ID, decoder);
    engine.add_component(AUDIOSINK_ID, sink);

    GOmx.Core core = GOmx.load_library(library);
    core.init();

    engine.components.init();
    engine.components.set_state_and_wait(Omx.State.Idle);
    engine.components.set_state_and_wait(Omx.State.Executing);
    engine.components.buffers_begin_transfer();

    var n_buffers_in = 0;
    var n_buffers_out = 0;

    foreach(var port in engine.ports_with_buffer_done) {
        switch(port.component.id) {
            case AUDIODEC_ID:
                switch(port.definition.dir) {
                    case Omx.Dir.Input: {
                        n_buffers_in++;
                        var buffer = port.pop_buffer();
                        GOmx.buffer_read_from_file(buffer, fd);
                        port.push_buffer(buffer);
                        break;
                    }
                    case Omx.Dir.Output: {
                        var buffer = port.pop_buffer();
                        var sink_inport = sink.ports[0];
                        var sink_buffer = sink_inport.pop_buffer();
                        GOmx.buffer_copy(sink_buffer, buffer);
                        sink_inport.push_buffer(sink_buffer);
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
                        n_buffers_out++;
                        break;
                    default:
                        break;
                }
                break;
        }
    }

    print("%d buffers were read\n", n_buffers_in);
    print("%d buffers were rendered\n", n_buffers_out);

    engine.components.set_state_and_wait(Omx.State.Idle);
    engine.components.set_state_and_wait(Omx.State.Loaded);
    engine.components.free_handles();
    core.deinit();
}

