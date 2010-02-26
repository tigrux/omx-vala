namespace Omx {
    public class Component: GLib.Object {
        public Omx.PortParam port_param;
        public Omx.Handle handle;
        string _component_name;
        Omx.Index _param_init_index;
        AsyncQueue<Omx.BufferHeader> buffer_queue;

        public Port[] ports;

        public string name {
            get; set;
        }

        public Component(string component_name, Omx.Index param_init_index) {
            _component_name = component_name;
            _param_init_index = param_init_index;
            buffer_queue = new AsyncQueue<Omx.BufferHeader>();
        }

        public void init() throws GLib.Error {
            Omx.try_run(
                Omx.get_handle(
                    out handle, _component_name,
                    this, callbacks));

            port_param.init();
            Omx.try_run(
                handle.get_parameter(
                    _param_init_index, port_param));
        }

        public void free() throws GLib.Error {
            Omx.try_run(
                handle.free_handle());
            handle = null;
        }

        public void allocate_ports() throws GLib.Error {
            uint n_ports = port_param.ports - port_param.start_port_number;
            ports = new Port[n_ports];
            for(uint i = 0; i<n_ports; i++) {
                var port = new Port(this, i);
                port.init();
                port.allocate_buffers();
                port.name = "%s:port%u".printf(name, i);
                ports[i] = port;
            }
        }

        public void free_ports() throws GLib.Error {
            foreach(var port in ports)
                port.free_buffers();
            ports = null;
        }

        public void fill_output_buffers() throws GLib.Error {
            foreach(var port in ports) {
                if(port.definition.dir == Omx.Dir.Output)
                    for(int i=0; i<port.buffers.length; i++)
                        port.push_buffer(port.pop_buffer());
            }
        }

        public void empty_input_buffers() throws GLib.Error {
            foreach(var port in ports) {
                if(port.definition.dir == Omx.Dir.Input)
                    foreach(var buffer in port.buffers)
                        buffer_queue.push(buffer);
            }
        }

        public Port pop_port() {
            var buffer = buffer_queue.pop();
            var port = buffer.app_private as Omx.Port;
            return port;
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

        public void set_state(Omx.State state) throws GLib.Error {
            Omx.try_run(
                handle.send_command(
                    Omx.Command.StateSet, state, null));
        }

        public Omx.State get_state() throws GLib.Error {
            Omx.State state;
            Omx.try_run(
                handle.get_state(
                    out state));
            return state;
        }

        Omx.Error event_handler(
                Omx.Handle component, Omx.Event event,
                uint32 data1, uint32 data2, void *event_data) {
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
            port.buffer_queue.push(buffer);
            buffer_queue.push(buffer);
            return Omx.Error.None;
        }
    }


    public class Port: GLib.Object {
        public Omx.Param.PortDefinition definition;
        public Omx.BufferHeader[] buffers;

        public AsyncQueue<Omx.BufferHeader> buffer_queue;
        public Component component;

        public string name {
            get; set;
        }

        public Port(Component parent_component, uint32 port_index) {
            component = parent_component;
            buffer_queue = new AsyncQueue<Omx.BufferHeader>();
            definition.init();
            definition.port_index = port_index;
        }

        public void init() throws GLib.Error {
            Omx.try_run(
                component.handle.get_parameter(
                    Omx.Index.ParamPortDefinition, definition));
        }

        public void allocate_buffers() throws GLib.Error {
            buffers = new Omx.BufferHeader[definition.buffer_count_actual];
            for(uint i=0; i<definition.buffer_count_actual; i++) {
                Omx.try_run(
                    component.handle.allocate_buffer(
                        out buffers[i], definition.port_index,
                        this, definition.buffer_size));
                buffer_queue.push(buffers[i]);
            }
        }

        public void free_buffers() throws GLib.Error {
            foreach(var buffer in buffers)
                Omx.try_run(
                    component.handle.free_buffer(
                        definition.port_index, buffer));
            buffers = null;
        }

        public Omx.BufferHeader pop_buffer() {
            return buffer_queue.pop();
        }

        public void push_buffer(Omx.BufferHeader buffer) throws GLib.Error {
            var port = buffer.app_private as Port;
            var handle = port.component.handle;
            switch(port.definition.dir) {
                case Omx.Dir.Input:
                    handle.empty_this_buffer(buffer);
                    break;
                case Omx.Dir.Output:
                    handle.fill_this_buffer(buffer);
                    break;
                default:
                    break;
            }
        }
    }
}
