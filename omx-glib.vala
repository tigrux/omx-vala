namespace Omx {

    public class Core: Object {
        Module _module;

        InitFunc _init;
        DeinitFunc _deinit;
        GetHandleFunc _get_handle;
        FreeHandleFunc _free_handle;
        SetupTunnelFunc _setup_tunnel;


        public delegate Error InitFunc();

        public delegate Error DeinitFunc();

        public delegate Error GetHandleFunc(
            out Handle component, string component_name,
            void *app_data, Callback callbacks);

        public delegate Error FreeHandleFunc(Handle handle);

        public delegate Error SetupTunnelFunc(
            Handle output, uint32 port_output,
            Handle input, uint32 port_input);


        public void init() throws GLib.Error {
            try_run(_init());
        }


        public void deinit() throws GLib.Error {
            try_run(_deinit());
        }


        public void get_handle(
                out Handle component, string component_name,
                void *app_data, Callback callbacks) throws GLib.Error {
            try_run(
                _get_handle(
                    out component, component_name, app_data, callbacks));
        }


        public void free_handle(Handle handle) throws GLib.Error {
            try_run(_free_handle(handle));
        }


        public void setup_tunnel(
                Handle output, uint32 port_output,
                Handle input, uint32 port_input) throws GLib.Error {
            try_run(
                _setup_tunnel(output, port_output, input, port_input));
        }


        public Component get_component(
                string component_name,
                Index param_init_index) throws GLib.Error {
            var component =
                new Component(this, component_name, param_init_index);
            component.init();
            return component;
        }


        public static Core? open(string soname) {
            var core = new Core();

            var module = Module.open(soname, ModuleFlags.BIND_LAZY);
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
        AsyncQueue<Port> _buffers_queue;
        List<Component> _components_list;
        ComponentList _component_list;
        PortQueue _port_queue;


        public Engine() {
            _buffers_queue = new AsyncQueue<Port>();
            _components_list = new List<Component>();
            _component_list = new ComponentList(this);
            _port_queue = new PortQueue(this);
        }


        public ComponentList components {
            get {
                return _component_list;
            }
        }


        public PortQueue ports {
            get {
                return _port_queue;
            }
        }


        public void add_component(Component component) {
            component.queue = _buffers_queue;
            _components_list.append(component);
        }


        public uint get_n_components() {
            return _components_list.length();
        }


        public Component get_component(uint i) {
            return _components_list.nth_data(i);
        }


        public void start() throws GLib.Error {
            foreach(var component in _components_list) {
                component.prepare_ports();
                break;
            }
        }


        public void set_state(State state) throws GLib.Error {
            foreach(var component in _components_list)
                component.set_state(state);
        }


        public void wait_for_state_set() {
            foreach(var component in _components_list)
                component.wait_for_state_set();
        }


        public void allocate_ports() throws GLib.Error {
            foreach(var component in _components_list)
                component.allocate_ports();
        }


        public void allocate_buffers() throws GLib.Error {
            foreach(var component in _components_list)
                component.allocate_buffers();
        }


        public void free_ports() throws GLib.Error {
            foreach(var component in _components_list)
                component.free_ports();
        }


        public void free_handles() throws GLib.Error {
            foreach(var component in _components_list)
                component.free_handle();
        }


        public Iterator iterator() {
            return new Iterator(this);
        }


        public class Iterator: Object {
            AsyncQueue<Port> _buffers_queue;
            bool _eos_found;

            public Iterator(Engine engine) {
                _buffers_queue = engine._buffers_queue;
            }

            public bool next() {
                return !_eos_found;
            }

            public new Port get() {
                var port = _buffers_queue.pop();
                if(port.eos)
                    _eos_found = true;
                return port;
            }
        }


        public class ComponentList {
            Engine _engine;


            public ComponentList(Engine engine) {
                _engine = engine;
            }


            public Iterator iterator() {
                return new Iterator(_engine);
            }


            public uint length() {
                return _engine.get_n_components();
            }


            public new Component get(uint index) {
                return _engine.get_component(index);
            }


            public class Iterator: Object {
                weak List<Component> _components_list;

                public Iterator(Engine engine) {
                    _components_list = engine._components_list;
                }

                public bool next() {
                    return _components_list != null;
                }

                public new Component get() {
                    var component = _components_list.data;
                    _components_list = _components_list.next;
                    return component;
                }
            }
        }



        public class PortQueue {
            Engine _engine;


            public PortQueue(Engine engine) {
                _engine = engine;
            }


            public Iterator iterator() {
                return new Iterator(_engine);
            }


            public class Iterator: Object {
                AsyncQueue<Port> _buffers_queue;
                bool _eos_found;

                public Iterator(Engine engine) {
                    _buffers_queue = engine._buffers_queue;
                }

                public bool next() {
                    return !_eos_found;
                }

                public new Port get() {
                    var port = _buffers_queue.pop();
                    if(port.eos)
                        _eos_found = true;
                    return port;
                }
            }
        }
    }



    public class Component: Object {
        public PortParam port_param;
        public int id;
        Handle _handle;

        State _current_state;
        State _previous_state;
        State _pending_state;

        string _component_name;
        Index _param_init_index;
        AsyncQueue<Port> _buffers_queue;
        Semaphore _wait_for_state_sem;
        Core _core;
        Port[] _ports;
        PortList _port_list;

        public delegate void EventFunc(
            uint data1, uint data2, void *event_data);

        EventFunc _event_func_0;
        EventFunc _event_func_1;
        EventFunc _event_func_2;
        EventFunc _event_func_3;
        EventFunc _event_func_4;
        EventFunc _event_func_5;
        EventFunc _event_func_6;
        EventFunc _event_func_7;
        EventFunc _event_func_8;
        

        public string name {
            get; set;
        }


        public Handle handle {
            get {
                return _handle;
            }
        }


        public PortList ports {
            get {
                return _port_list;
            }
        }


        public AsyncQueue<Port> queue {
            get {
                return _buffers_queue;
            }
            set {
                _buffers_queue = value;
            }
        }


        public Core core {
            get {
                return _core;
            }
        }


        public uint current_state {
            get {
                return _current_state;
            }
        }


        public uint pending_state {
            get {
                return _pending_state;
            }
        }


        public uint previous_state {
            get {
                return _previous_state;
            }
        }


        construct {
            _buffers_queue = new AsyncQueue<Port>();
            _wait_for_state_sem = new Semaphore();
            _port_list = new PortList(this);
            _current_state = State.Invalid;
            _previous_state = State.Invalid;
            _pending_state = State.Invalid;
        }


        public Component(
                Core core,
                string component_name,
                Index param_init_index) {
            _core = core;
            name = _component_name = component_name;
            _param_init_index = param_init_index;
        }


        public void init() throws GLib.Error {
            _core.get_handle(
                out _handle, _component_name,
                this, callbacks);

            port_param.init();
            try_run(
                _handle.get_parameter(
                    _param_init_index, port_param));
            _pending_state = State.Loaded;
            _current_state = State.Loaded;
        }


        public void free_handle() throws GLib.Error {
            _core.free_handle(_handle);
            _handle = null;
        }


        public uint get_n_ports() {
            return port_param.ports - port_param.start_port_number;
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
                port.name = "%s_port%u".printf(name, i);
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
                if(port.definition.dir == Dir.Output) {
                    var n_buffers = port.get_n_buffers();
                    for(int i=0; i<n_buffers; i++)
                        port.push_buffer(port.pop_buffer());
                }
            }
        }


        public void empty_input_buffers() throws GLib.Error {
            foreach(var port in _ports) {
                if(port.definition.dir == Dir.Input) {
                    uint n_buffers = port.get_n_buffers();
                    for(uint i=0; i<n_buffers; i++)
                        _buffers_queue.push(port);
                }
            }
        }


        public void wait_for_state_set() {
            _wait_for_state_sem.down();
        }


        public void set_state(State state) throws GLib.Error {
            _pending_state = state;
            try_run(
                _handle.send_command(
                    Command.StateSet, state, null));
        }


        public State get_state() throws GLib.Error {
            State state;
            try_run(
                _handle.get_state(
                    out state));
            return state;
        }


        const Callback callbacks = {
            event_handler,
            empty_buffer_done,
            fill_buffer_done
        };


        public void set_event_function(Event event, EventFunc event_function) {
            switch(event) {
                case Event.CmdComplete: {
                    _event_func_0 = event_function;
                    break;
                }
                case Event.Error: {
                    _event_func_1 = event_function;
                    break;
                }
                case Event.Mark: {
                    _event_func_2 = event_function;
                    break;
                }
                case Event.PortSettingsChanged: {
                    _event_func_3 = event_function;
                    break;
                }
                case Event.BufferFlag: {
                    _event_func_4 = event_function;
                    break;
                }
                case Event.ResourcesAcquired: {
                    _event_func_5 = event_function;
                    break;
                }
                case Event.ComponentResumed: {
                    _event_func_6 = event_function;
                    break;
                }
                case Event.DynamicResourcesAvailable: {
                    _event_func_7 = event_function;
                    break;
                }
                case Event.PortFormatDetected: {
                    _event_func_8 = event_function;
                    break;
                }
                default:
                    break;
            }
        }


        Error event_handler(
                Handle component, Event event,
                uint32 data1, uint32 data2, void *event_data) {
            switch(event) {
                case Event.CmdComplete:
                    if(data1 == Command.StateSet)
                        _previous_state = _current_state;
                        _current_state = _pending_state = (State)data2;
                        if(_event_func_0 != null)
                            _event_func_0(data1, data2, event_data);
                        _wait_for_state_sem.up();
                    break;
                case Event.Error:
                    var error = (Error)data1;
                    warning("An error was detected: %s\n", error.to_string());
                    if(_event_func_1 != null)
                        _event_func_1(data1, data2, event_data);
                    break;
                case Event.Mark:
                    if(_event_func_2 != null)
                        _event_func_2(data1, data2, event_data);
                    break;
                case Event.PortSettingsChanged:
                    if(_event_func_3 != null)
                        _event_func_3(data1, data2, event_data);
                    break;
                case Event.BufferFlag:
                    if(_event_func_4 != null)
                        _event_func_4(data1, data2, event_data);
                    break;
                case Event.ResourcesAcquired:
                    if(_event_func_5 != null)
                        _event_func_5(data1, data2, event_data);
                    break;
                case Event.ComponentResumed:
                    if(_event_func_6 != null)
                        _event_func_6(data1, data2, event_data);
                    break;
                case Event.DynamicResourcesAvailable:
                    if(_event_func_7 != null)
                        _event_func_7(data1, data2, event_data);
                    break;
                case Event.PortFormatDetected:
                    if(_event_func_8 != null)
                        _event_func_8(data1, data2, event_data);
                    break;
                default:
                    break;
            }
            return Error.None;
        }


        Error empty_buffer_done(
                Handle component,
                BufferHeader buffer) {
            return buffer_done(get_port(buffer.input_port_index), buffer);
        }


        Error fill_buffer_done(
                Handle component,
                BufferHeader buffer) {
            var port = get_port(buffer.output_port_index);
            port.buffer_done(buffer);
            return buffer_done(port, buffer);
        }


        Error buffer_done(
                Port port,
                BufferHeader buffer) {
            port.queue.push(buffer);
            _buffers_queue.push(port);
            return Error.None;
        }



        public class PortList {
            Component _component;


            public PortList(Component component) {
                _component = component;
            }


            public Iterator iterator() {
                return new Iterator(_component);
            }


            public uint length() {
                return _component._ports.length;
            }


            public new Port get(uint index) {
                return _component._ports[index];
            }


            public class Iterator: Object {
                Component _component;
                uint _index;

                public Iterator(Component component) {
                    _component = component;
                }

                public bool next() {
                    return _index < _component._ports.length;
                }

                public new Port get() {
                    return _component._ports[_index++];
                }
            }
        }
    }



    public class Port: Object {
        public Param.PortDefinition definition;

        BufferHeader[] _buffers;
        AsyncQueue<BufferHeader> _buffers_queue;
        BufferList _buffer_list;
        Component _component;
        bool _eos;
        BufferDoneFunc _buffer_done_func;

        public delegate void BufferDoneFunc(BufferHeader buffer);


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


        public AsyncQueue<BufferHeader> queue {
            get {
                return _buffers_queue;
            }
        }


        public BufferList buffers {
            get {
                return _buffer_list;
            }
        }


        construct {
            _buffers_queue = new AsyncQueue<BufferHeader>();
            _buffer_list = new BufferList(this);
            definition.init();
        }

        public Port(Component parent_component, uint32 port_index) {
            _component = parent_component;
            definition.port_index = port_index;
        }


        public void init() throws GLib.Error {
            try_run(
                _component.handle.get_parameter(
                    Index.ParamPortDefinition, definition));
        }


        public void allocate_buffers() throws GLib.Error {
            uint n_buffers = get_n_buffers();
            _buffers = new BufferHeader[n_buffers];
            for(uint i=0; i<n_buffers; i++) {
                try_run(
                    _component.handle.allocate_buffer(
                        out _buffers[i], definition.port_index,
                        this, definition.buffer_size));
                _buffers_queue.push(_buffers[i]);
            }
        }


        public void use_buffers_of(Port port) throws GLib.Error {
            uint n_buffers = get_n_buffers();
            _buffers = new BufferHeader[n_buffers];
            for(uint i=0; i<n_buffers; i++) {
                var buffer_used = port.get_buffer(i);
                try_run(
                    _component.handle.use_buffer(
                        out _buffers[i], definition.port_index,
                        _component, definition.buffer_size,
                        buffer_used.buffer));
                _buffers_queue.push(_buffers[i]);
            }
        }


        public weak BufferHeader get_buffer(uint i) {
            return _buffers[i];
        }


        public uint get_n_buffers() {
            return definition.buffer_count_actual;
        }


        public void free_buffers() throws GLib.Error {
            foreach(var buffer in _buffers)
                try_run(
                    _component.handle.free_buffer(
                        definition.port_index, buffer));
            _buffers = null;
        }


        public BufferHeader pop_buffer() {
            var buffer = _buffers_queue.pop();
            if(buffer.eos)
                _eos = true;
            return buffer;
        }


        public void push_buffer(BufferHeader buffer) throws GLib.Error {
            var handle = component.handle;
            switch(definition.dir) {
                case Dir.Input:
                    handle.empty_this_buffer(buffer);
                    break;
                case Dir.Output:
                    handle.fill_this_buffer(buffer);
                    break;
                default:
                    break;
            }
        }


        public void set_buffer_done_function(BufferDoneFunc buffer_done_func) {
            _buffer_done_func = buffer_done_func;
        }


        public void buffer_done(BufferHeader buffer) {
            if(_buffer_done_func != null)
                _buffer_done_func(buffer);
        }



        public class BufferList {
            Port _port;


            public BufferList(Port port) {
                _port = port;
            }


            public Iterator iterator() {
                return new Iterator(_port);
            }


            public uint length() {
                return _port.get_n_buffers();
            }


            public new BufferHeader get(uint index) {
                return _port.get_buffer(index);
            }


            public class Iterator: Object {
                Port _port;
                uint _index;

                public Iterator(Port port) {
                    _port = port;
                }

                public bool next() {
                    return _index < _port.get_n_buffers();
                }

                public new BufferHeader get() {
                    return _port.get_buffer(_index++);
                }
            }
        }
    }



    public class Semaphore: Object {
        Cond _cond;
        Mutex _mutex;
        int counter;


        construct {
            _cond = new Cond();
            _mutex = new Mutex();
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



    public void buffer_copy(BufferHeader dest, BufferHeader source) {
        Memory.copy(dest.buffer, source.buffer, source.filled_len);
        dest.filled_len = source.filled_len;
        dest.offset = source.offset;
    }


    public void buffer_copy_len(BufferHeader dest, BufferHeader source) {
        dest.filled_len = source.filled_len;
        dest.offset = source.offset;
    }


    public void buffer_read_from_file(BufferHeader buffer, FileStream fs) {
        buffer.offset = 0;
        buffer.filled_len = fs.read(buffer.buffer);
        if(fs.eof())
            buffer.set_eos();
    }
}

