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
            new Component(AUDIODEC_COMPONENT_NAME, Omx.Index.ParamAudioInit);

        Omx.try_run(Omx.init());

        audiodec.name = "audiodec";        
        audiodec.init();
        audiodec.set_state(Omx.State.Idle);
        audiodec.allocate_ports();
        audiodec.wait_for_state_set();
        audiodec.set_state(Omx.State.Executing);
        audiodec.wait_for_state_set();
        
        // move buffers

        audiodec.set_state(Omx.State.Idle);
        audiodec.wait_for_state_set();

        audiodec.set_state(Omx.State.Loaded);
        audiodec.free_ports();
        audiodec.wait_for_state_set();
        
        audiodec.deinit();

        Omx.try_run(Omx.deinit());
    }
}

public class Component: Object {
    public Omx.Port.Param port_param;
    public Omx.Handle handle;
    string _component_name;
    Omx.Index _param_init_index;

    public Port[] ports;

    public string name {
        get; set;
    }

    public Component(string component_name, Omx.Index param_init_index) {
        _component_name = component_name;
        _param_init_index = param_init_index;
    }

    public void init() throws Error {
        Omx.try_run(
            Omx.get_handle(
                out handle, _component_name,
                this, callbacks));

        port_param.init();

        Omx.try_run(
            handle.get_parameter(
                _param_init_index, port_param));

        var definition = Omx.Param.PortDefinition();
        definition.init();
    }

    public void deinit() throws Error {
        Omx.try_run(handle.free_handle());
        handle = null;
    }

    public void allocate_ports() throws Error {
        ports = new Port[port_param.ports - port_param.start_port_number];
        for(uint i = port_param.start_port_number; i<port_param.ports; i++) {
            var port = new Port(this, i);
            port.init();
            port.allocate_buffers();
            port.name = "%s:port%u".printf(name, i);
            ports[i] = port;
        }
    }

    public void free_ports() throws Error {
        foreach(var port in ports)
            port.free_buffers();
        ports = null;
    }

    const Omx.Callback callbacks = {
        event_handler,
        buffer_done,
        buffer_done
    };

    Bellagio.Semaphore wait_for_state_sem;

    public void wait_for_state_set() {
        wait_for_state_sem.down();
    }

    public void set_state(Omx.State state) throws Error {
        Omx.try_run(
            handle.send_command(
                Omx.Command.StateSet, state, null));
    }

    public Omx.State get_state() throws Error {
        Omx.State state;
        Omx.try_run(
            handle.get_state(out state));
        return state;
    }

    Omx.Error event_handler(
            Omx.Handle component, Omx.Event event,
            uint32 data1, uint32 data2) {
        switch(event) {
            case Omx.Event.CmdComplete:
                switch(data1) {
                    case Omx.Command.StateSet:
                        wait_for_state_sem.up();
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

    Omx.Error buffer_done(
            Omx.Handle component,
            Omx.BufferHeader buffer) {
        var port = buffer.app_private as Port;
        print("Pushing buffer to %s\n", port.name);
        port.queue.push(buffer);
        return Omx.Error.None;
    }
}

public class Port: Object {
    public Omx.Param.PortDefinition definition;
    public Omx.BufferHeader[] buffers;

    public AsyncQueue<Omx.BufferHeader> queue;
    public Component component;

    public string name {
        get; set;
    }

    public Port(Component parent_component, uint32 port_index) {
        component = parent_component;
        definition.init();
        definition.port_index = port_index;
        queue = new AsyncQueue<Omx.BufferHeader>();
    }

    public void init() throws Error {
        Omx.try_run(
            component.handle.get_parameter(
                Omx.Index.ParamPortDefinition, definition));
    }

    public void allocate_buffers() {
        buffers = new Omx.BufferHeader[definition.buffer_count_actual];
        for(int i=0; i<definition.buffer_count_actual; i++) {
            Omx.try_run(
                component.handle.allocate_buffer(
                    out buffers[i], definition.dir,
                    this, definition.buffer_size));
            queue.push(buffers[i]);
        }
    }

    public void free_buffers() {
        foreach(var buffer in buffers)
            Omx.try_run(
                component.handle.free_buffer(
                    definition.dir, buffer));
        buffers = null;
    }

    public Omx.BufferHeader pop_buffer() {
        return queue.pop();
    }

    public void push_buffer(Omx.BufferHeader buffer) throws Error {
        var port = buffer.app_private as Port;
        switch(port.definition.dir) {
            case Omx.Dir.Input:
                print("empty_this_buffer for %s\n", port.name);
                port.component.handle.empty_this_buffer(buffer);
                break;
            case Omx.Dir.Output:
                print("fill_this_buffer for %s\n", port.name);
                port.component.handle.fill_this_buffer(buffer);
                break;
            default:
                break;
        }
    }
}

