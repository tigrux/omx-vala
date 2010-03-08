void main(string[] args) {
    if(args.length != 2) {
        print("%s <file.mp3>\n", args[0]);
        return;
    }

    play(args[1]);
}

FileStream fd;

void play(string filename) {
    fd = FileStream.open(filename, "rb");
    if(fd == null) {
        print("Error opening %s", filename);
        return;
    }

    Omx.init();
    get_handles();

    handle_print_info("audiodec", audiodec_handle);
    handle_print_info("audiosink", audiosink_handle);

    set_state(Omx.State.Idle);
    allocate_buffers();
    wait_for_state_set();

    set_state(Omx.State.Executing);
    wait_for_state_set();
    move_buffers();
    wait_for_eos();

    set_state(Omx.State.Idle);
    wait_for_state_set();

    set_state(Omx.State.Loaded);
    free_buffers();
    wait_for_state_set();

    free_handles();
    Omx.deinit();
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

const string AUDIODEC_COMPONENT = "OMX.st.audio_decoder.mp3.mad";
const string AUDIOSINK_COMPONENT = "OMX.st.alsa.alsasink";

void get_handles() {
    Omx.get_handle(
        out audiodec_handle, AUDIODEC_COMPONENT, null, audiodec_callbacks);
    Omx.get_handle(
        out audiosink_handle, AUDIOSINK_COMPONENT, null, audiosink_callbacks);
}

void handle_print_info(string name, Omx.Handle handle) {
    var param = Omx.PortParam();
    param.init();

    handle.get_parameter(Omx.Index.ParamAudioInit, param);

    var port_definition = Omx.Param.PortDefinition();
    port_definition.init();

    print("%s (%p)\n", name, handle);
    var i = 0;
    while(i < param.ports) {
        print("\tPort %u:\n", i);
        port_definition.port_index = i;
        handle.get_parameter(Omx.Index.ParamPortDefinition, port_definition);
        print("\t\thas mime-type %s\n", port_definition.format.audio.mime_type);
        print("\t\thas direction %s\n", port_definition.dir.to_string());
        print("\t\thas %u buffers of size %u\n",
            port_definition.buffer_count_actual,
            port_definition.buffer_size);
        i++;
    }
}

void set_state(Omx.State state) {
    audiodec_handle.send_command(Omx.Command.StateSet, state, null);
    audiosink_handle.send_command(Omx.Command.StateSet, state, null);
}

Omx.BufferHeader[] in_buffer_audiosink;
Omx.BufferHeader[] in_buffer_audiodec;
Omx.BufferHeader[] out_buffer_audiodec;

const int N_BUFFERS = 2;
const int BUFFER_OUT_SIZE = 32768;
const int BUFFER_IN_SIZE = 4096;

void allocate_buffers() {
    in_buffer_audiodec = new Omx.BufferHeader[N_BUFFERS];
    out_buffer_audiodec = new Omx.BufferHeader[N_BUFFERS];
    in_buffer_audiosink = new Omx.BufferHeader[N_BUFFERS];

    var i=0;
    while(i < N_BUFFERS) {
        audiodec_handle.allocate_buffer(
            out in_buffer_audiodec[i], 0, null, BUFFER_IN_SIZE);
        audiodec_handle.allocate_buffer(
            out out_buffer_audiodec[i], 1, null, BUFFER_OUT_SIZE);
        audiosink_handle.allocate_buffer(
            out in_buffer_audiosink[i], 0, null, BUFFER_OUT_SIZE);
        i++;
    }
}

void read_buffer_from_fd(Omx.BufferHeader buffer) {
    buffer.offset = 0;
    buffer.length = (uint)fd.read(buffer.buffer);
}

void move_buffers() {
    var i=0;
    while(i < N_BUFFERS) {
        read_buffer_from_fd(in_buffer_audiodec[i]);
        audiodec_handle.empty_this_buffer(in_buffer_audiodec[i]);
        audiodec_handle.fill_this_buffer(out_buffer_audiodec[i]);
        i++;
    }
}

void free_buffers() {
    var i=0;
    while(i < N_BUFFERS) {
        audiodec_handle.free_buffer(0, in_buffer_audiodec[i]);
        audiodec_handle.free_buffer(1, out_buffer_audiodec[i]);
        audiosink_handle.free_buffer(0, in_buffer_audiosink[i]);
        i++;
    }
}

void free_handles() {
    Omx.free_handle(audiodec_handle);
    Omx.free_handle(audiosink_handle);
}

Bellagio.Semaphore audiodec_sem;
Bellagio.Semaphore audiosink_sem;
Bellagio.Semaphore eos_sem;

void wait_for_state_set() {
    audiodec_sem.down();
    audiosink_sem.down();
}

void wait_for_eos() {
    print("Waiting for eos\n");
    eos_sem.down();
}

Omx.Error audiodec_event_handler(
        Omx.Handle component,
        Omx.Event event,
        uint32 data1, uint32 data2) {
    switch(event) {
        case Omx.Event.CmdComplete:
            if(data1 == Omx.Command.StateSet)
                audiodec_sem.up();
            break;
        default:
            break;
    }

    return Omx.Error.None;
}

Omx.Error audiodec_empty_buffer_done(
        Omx.Handle component,
        Omx.BufferHeader buffer) {
    if(fd.eof())
        return Omx.Error.None;

    read_buffer_from_fd(buffer);

    if(fd.eof()) {
        print("Setting eos flag\n");
        buffer.set_eos();
    }
    return audiodec_handle.empty_this_buffer(buffer);
}

Omx.Error audiodec_fill_buffer_done(
        Omx.Handle component,
        Omx.BufferHeader buffer) {
    if(buffer.eos) {
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
            if(data1 == Omx.Command.StateSet)
                audiosink_sem.up();
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

