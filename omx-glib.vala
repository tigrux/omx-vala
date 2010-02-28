namespace Omx {

    public delegate Error InitFunc();

    public delegate Error DeinitFunc();

    public delegate Error GetHandleFunc(
        out Handle component, string component_name,
        void *app_data, Callback callbacks);

    public delegate Error FreeHandleFunc(Handle handle);

    public delegate Error SetupTunnelFunc(
        Handle output, uint32 port_output,
        Handle input, uint32 port_input);



    public class Core: GLib.Object {
        GLib.Module _module;

        InitFunc _init;
        DeinitFunc _deinit;
        GetHandleFunc _get_handle;
        FreeHandleFunc _free_handle;
        SetupTunnelFunc _setup_tunnel;


        public void init() throws GLib.Error {
            Omx.try_run(_init());
        }


        public void deinit() throws GLib.Error {
            Omx.try_run(_deinit());
        }


        public void get_handle(
                out Handle component, string component_name,
                void *app_data, Callback callbacks) throws GLib.Error {
            Omx.try_run(
                _get_handle(
                    out component, component_name, app_data, callbacks));
        }

        
        public void free_handle(Handle handle) throws GLib.Error {
            Omx.try_run(_free_handle(handle));
        }


        public void setup_tunnel(
                Handle output, uint32 port_output,
                Handle input, uint32 port_input) throws GLib.Error {
            Omx.try_run(
                _setup_tunnel(output, port_output, input, port_input));
        }


        public Component get_component(
                string component_name,
                Omx.Index param_init_index) throws GLib.Error {
            var component =
                new Component(this, component_name, param_init_index);
            component.name = component_name;
            component.init();
            return component;
        }


        public static Core? open(string soname) {
            var core = new Core();
    
            var module = GLib.Module.open(soname, GLib.ModuleFlags.BIND_LAZY);
            if(module == null)
                return null;

            void *symbol;
            module.symbol ("OMX_Init", out symbol);
            if(symbol == null)
                return null;
            core._init = (InitFunc)symbol;

            module.symbol ("OMX_Deinit", out symbol);
            if(symbol == null)
                return null;
            core._deinit = (DeinitFunc)symbol;

            module.symbol ("OMX_GetHandle", out symbol);
            if(symbol == null)
                return null;
            core._get_handle = (GetHandleFunc)symbol;            

            module.symbol ("OMX_FreeHandle", out symbol);
            if(symbol == null)
                return null;
            core._free_handle = (FreeHandleFunc)symbol;            

            module.symbol ("OMX_SetupTunnel", out symbol);
            if(symbol == null)
                return null;
            core._setup_tunnel = (SetupTunnelFunc)symbol;

            core._module = (owned)module;
            return core;
        }
    }



    public class Engine: Object {
        GLib.AsyncQueue<Omx.Port> _queue;
        GLib.List<Omx.Component> _components_list;


        public Engine() {
            _queue = new GLib.AsyncQueue<Omx.Port>();
            _components_list = new GLib.List<Omx.Component>();
        }


        public void add_component(Omx.Component component) {
            component.queue = _queue;
            _components_list.append(component);
        }


        public weak GLib.List<weak Omx.Component> get_components() {
            return _components_list;
        }

        public void start() throws GLib.Error {
            foreach(var component in get_components()) {
                component.prepare_ports();
                break;
            }
        }

        public void set_state(Omx.State state) throws GLib.Error {
            foreach(var component in get_components())
                component.set_state(state);
        }

        
        public void wait_for_state_set() {
            foreach(var component in get_components())
                component.wait_for_state_set();
        }


        public void allocate_ports() throws GLib.Error {
            foreach(var component in get_components())
                component.allocate_ports();
        }


        public void allocate_buffers() throws GLib.Error {
            foreach(var component in get_components())
                component.allocate_buffers();
        }

        
        public void free_ports() throws GLib.Error {
            foreach(var component in get_components())
                component.free_ports();
        }


        public void free_handles() throws GLib.Error {
            foreach(var component in get_components())
                component.free_handle();
        }


        public Iterator iterator() {
            return new Iterator(this);
        }

        
        public class Iterator {
            GLib.AsyncQueue<Omx.Port> _queue;
            bool _eos_found;

            public Iterator(Engine engine) {
                _queue = engine._queue;
            }
            
            public bool next() {
                return !_eos_found;
            }
            
            public Omx.Port get() {
                var port = _queue.pop();
                if(port.eos)
                    _eos_found = true;
                return port;
            }
        }    
    }



    public class Component: GLib.Object {
        public Omx.PortParam port_param;
        public int id;
        Omx.Handle _handle;

        string _component_name;
        Omx.Index _param_init_index;
        AsyncQueue<Omx.Port> _queue;
        Semaphore _wait_for_state_sem;
        Core _core;
        Port[] _ports;


        public string name {
            get; set;
        }


        public Handle handle {
            get {
                return _handle;
            }
        }


        public AsyncQueue<Omx.Port> queue {
            get {
                return _queue;
            }
            set {
                _queue = value;
            }
        }


        public Core core {
            get {
                return _core;
            }
        }


        public Component(
                Core core,
                string component_name,
                Omx.Index param_init_index) {
            _core = core;
            _component_name = component_name;
            _param_init_index = param_init_index;
            _queue = new AsyncQueue<Omx.Port>();
            _wait_for_state_sem = new Semaphore();
        }


        public void init() throws GLib.Error {
            _core.get_handle(
                out _handle, _component_name,
                this, callbacks);

            port_param.init();
            Omx.try_run(
                _handle.get_parameter(
                    _param_init_index, port_param));
        }



        public void free_handle() throws GLib.Error {
            _core.free_handle(_handle);
            _handle = null;
        }


        public uint get_n_ports() {
            return port_param.ports - port_param.start_port_number;
        }


        public Port[] get_ports() {
            return _ports;
        }


        public Port get_port(uint i) {
            return _ports[i];
        }


        public void allocate_ports() throws GLib.Error {
            uint n_ports = get_n_ports();
            _ports = new Port[n_ports];
            for(uint i = 0; i<n_ports; i++) {
                var port = new Port(this, i);
                port.init();
                port.name = "%s.port%u".printf(name, i);
                _ports[i] = port;
            }
        }


        public void allocate_buffers() throws GLib.Error {
            foreach(var port in _ports)
                port.allocate_buffers();
        }


        public void free_ports() throws GLib.Error {
            foreach(var port in _ports)
                port.free_buffers();
            _ports = null;
        }


        public void prepare_ports() throws GLib.Error {
            fill_output_buffers();
            empty_input_buffers();
        }


        public void fill_output_buffers() throws GLib.Error {
            foreach(var port in _ports) {
                if(port.definition.dir == Omx.Dir.Output) {
                    var n_buffers = port.get_n_buffers();
                    for(int i=0; i<n_buffers; i++)
                        port.push_buffer(port.pop_buffer());
                }
            }
        }


        public void empty_input_buffers() throws GLib.Error {
            foreach(var port in _ports) {
                if(port.definition.dir == Omx.Dir.Input) {
                    uint n_buffers = port.get_n_buffers();
                    for(uint i=0; i<n_buffers; i++)
                        _queue.push(port);
                }
            }
        }


        public void wait_for_state_set() {
            _wait_for_state_sem.down();
        }


        public void set_state(Omx.State state) throws GLib.Error {
            Omx.try_run(
                _handle.send_command(
                    Omx.Command.StateSet, state, null));
        }


        public Omx.State get_state() throws GLib.Error {
            Omx.State state;
            Omx.try_run(
                _handle.get_state(
                    out state));
            return state;
        }


        const Omx.Callback callbacks = {
            event_handler,
            empty_buffer_done,
            fill_buffer_done
        };


        Omx.Error event_handler(
                Omx.Handle component, Omx.Event event,
                uint32 data1, uint32 data2, void *event_data) {
            switch(event) {
                case Omx.Event.CmdComplete:
                    switch(data1) {
                        case Omx.Command.StateSet:
                            _wait_for_state_sem.up();
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


        Omx.Error empty_buffer_done(
                Omx.Handle component,
                Omx.BufferHeader buffer) {
            return buffer_done(get_port(buffer.input_port_index), buffer);
        }


        Omx.Error fill_buffer_done(
                Omx.Handle component,
                Omx.BufferHeader buffer) {
            return buffer_done(get_port(buffer.output_port_index), buffer);
        }


        protected virtual Omx.Error buffer_done(
                Omx.Port port,
                Omx.BufferHeader buffer) {
            port.queue.push(buffer);
            _queue.push(port);
            return Omx.Error.None;
        }
    }



    public class Port: GLib.Object {
        public Omx.Param.PortDefinition definition;
        
        Omx.BufferHeader[] _buffers;
        AsyncQueue<Omx.BufferHeader> _queue;
        Component _component;
        bool _eos;


        public string name {
            get; set;
        }


        public Component component {
            get {
                return _component;
            }
        }

        public bool eos {
            get {
                return _eos;
            }
        }

        public AsyncQueue<Omx.BufferHeader> queue {
            get {
                return _queue;
            }
        }

        
        public Port(Component parent_component, uint32 port_index) {
            _component = parent_component;
            _queue = new AsyncQueue<Omx.BufferHeader>();
            definition.init();
            definition.port_index = port_index;
        }


        public void init() throws GLib.Error {
            Omx.try_run(
                _component.handle.get_parameter(
                    Omx.Index.ParamPortDefinition, definition));
        }


        public void allocate_buffers() throws GLib.Error {
            uint n_buffers = get_n_buffers();
            _buffers = new Omx.BufferHeader[n_buffers];
            for(uint i=0; i<n_buffers; i++) {
                Omx.try_run(
                    _component.handle.allocate_buffer(
                        out _buffers[i], definition.port_index,
                        this, definition.buffer_size));
                _queue.push(_buffers[i]);
            }
        }


        public void use_buffers_of_port(Omx.Port port) throws GLib.Error {
            uint n_buffers = get_n_buffers();
            _buffers = new Omx.BufferHeader[n_buffers];
            for(uint i=0; i<n_buffers; i++) {
                Omx.try_run(
                    _component.handle.use_buffer(
                        out _buffers[i], definition.port_index,
                        _component, definition.buffer_size,
                        port.get_buffer(i).buffer));
                _queue.push(_buffers[i]);
            }
        }


        public weak Omx.BufferHeader get_buffer(uint i) {
            return _buffers[i];
        }


        public weak Omx.BufferHeader[] get_buffers() {
            return _buffers;
        }


        public uint get_n_buffers() {
            return definition.buffer_count_actual;
        }


        public void free_buffers() throws GLib.Error {
            foreach(var buffer in _buffers)
                Omx.try_run(
                    _component.handle.free_buffer(
                        definition.port_index, buffer));
            _buffers = null;
        }


        public Omx.BufferHeader pop_buffer() {
            var buffer = _queue.pop();
            if(buffer.eos)
                _eos = true;
            return buffer;
        }


        public void push_buffer(Omx.BufferHeader buffer) throws GLib.Error {
            var handle = component.handle;
            switch(definition.dir) {
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



    public class Semaphore {
        GLib.Cond _cond;
        GLib.Mutex _mutex;
        int counter;


        public Semaphore() {
            _cond = new GLib.Cond();
            _mutex = new GLib.Mutex();
            counter = 0;
        }


        public void up() {
            _mutex.lock();
            counter++;
            _cond.signal();
            _mutex.unlock();
        }


        public void down() {
            _mutex.lock();
            while(counter <= 0)
                _cond.wait(_mutex);
            counter--;
            _mutex.unlock();
        }
    }



    void buffer_copy(Omx.BufferHeader dest, Omx.BufferHeader source) {
        Memory.copy(dest.buffer, source.buffer, source.filled_len);
        dest.filled_len = source.filled_len;
        dest.offset = source.offset;
    }
}

