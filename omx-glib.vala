[CCode (lower_case_cprefix = "g_omx_")]
namespace GOmx {

    public class Core: Object {
        Module _module;

        InitFunc _init_func;
        DeinitFunc _deinit_func;
        GetHandleFunc _get_handle_func;
        FreeHandleFunc _free_handle_func;
        SetupTunnelFunc _setup_tunnel_func;


        public delegate Omx.Error InitFunc();

        public delegate Omx.Error DeinitFunc();

        public delegate Omx.Error GetHandleFunc(
            out Omx.Handle component, string component_name,
            void *app_data, Omx.Callback callbacks);

        public delegate Omx.Error FreeHandleFunc(Omx.Handle handle);

        public delegate Omx.Error SetupTunnelFunc(
            Omx.Handle output, uint32 port_output,
            Omx.Handle input, uint32 port_input);


        public Module module {
            get {
                return _module;
            }
        }


        public void init()
        throws GLib.Error {
            Omx.try_run(_init_func());
        }


        public void deinit()
        throws GLib.Error {
            Omx.try_run(_deinit_func());
        }


        public void get_handle(
                out Omx.Handle component, string component_name,
                void *app_data, Omx.Callback callbacks)
        throws GLib.Error {
            Omx.try_run(
                _get_handle_func(
                    out component, component_name, app_data, callbacks));
        }


        public void free_handle(Omx.Handle handle)
        throws GLib.Error {
            Omx.try_run(_free_handle_func(handle));
        }


        public void setup_tunnel(
                Omx.Handle output, uint32 port_output,
                Omx.Handle input, uint32 port_input)
        throws GLib.Error {
            Omx.try_run(
                _setup_tunnel_func(output, port_output, input, port_input));
        }


        private Core() {
        }


        public static Core? open(string soname) {
            var core = new Core();

            var module = Module.open(soname, ModuleFlags.BIND_LAZY);
            return_val_if_fail(module != null, null);

            void *symbol;
            module.symbol ("OMX_Init", out symbol);
            return_val_if_fail(symbol != null, null);
            core._init_func = (InitFunc)symbol;

            module.symbol ("OMX_Deinit", out symbol);
            return_val_if_fail(symbol != null, null);
            core._deinit_func = (DeinitFunc)symbol;

            module.symbol ("OMX_GetHandle", out symbol);
            return_val_if_fail(symbol != null, null);
            core._get_handle_func = (GetHandleFunc)symbol;

            module.symbol ("OMX_FreeHandle", out symbol);
            return_val_if_fail(symbol != null, null);
            core._free_handle_func = (FreeHandleFunc)symbol;

            module.symbol ("OMX_SetupTunnel", out symbol);
            return_val_if_fail(symbol != null, null);
            core._setup_tunnel_func = (SetupTunnelFunc)symbol;

            core._module = (owned)module;
            return core;
        }
    }



    public class Engine: Object {
        AsyncQueue<Port> _buffers_queue;
        List<Component> _components_list;
        ComponentList _component_list;
        PortQueue _port_queue;
        bool _started;
        uint _n_components;

        public bool started {
            get {
                return _started;
            }
        }


        public ComponentList components {
            get {
                return _component_list;
            }
        }


        public PortQueue ports_with_buffer_done {
            get {
                return _port_queue;
            }
        }


        public uint get_n_components() {
            return _n_components;
        }


        construct {
            _buffers_queue = new AsyncQueue<Port>();
            _components_list = new List<Component>();
            _component_list = new ComponentList(this);
            _port_queue = new PortQueue(this);
        }


        public void add_component(Component component) {
            component.queue = _buffers_queue;
            _components_list.append(component);
            _n_components++;
        }


        public Component get_component(uint i)
        requires(i < _n_components) {
            return _components_list.nth_data(i);
        }


        public virtual void start()
        throws GLib.Error requires(!_started) {
            foreach(var component in _components_list) {
                component.prepare_ports();
                break;
            }
            _started = true;
        }


        public virtual void init()
        throws GLib.Error {
            foreach(var component in _components_list)
                component.init();
        }


        public virtual void set_state(Omx.State state)
        throws GLib.Error {
            foreach(var component in _components_list)
                component.set_state(state);
        }


        public virtual void set_state_and_wait(Omx.State state)
        throws GLib.Error {
            foreach(var component in _components_list)
                component.set_state_and_wait(state);
        }


        public virtual void wait_for_state_set() {
            foreach(var component in _components_list)
                component.wait_for_state_set();
        }


        public virtual void free_handles()
        throws GLib.Error {
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


        public class ComponentList: Object {
            public Engine engine {
                get; construct set;
            }


            public ComponentList(Engine engine) {
                Object(engine: engine);
            }


            public Iterator iterator() {
                return new Iterator(_engine);
            }


            public uint length {
                get {
                    return _engine._n_components;
                }
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



        public class PortQueue: Object {
            public Engine engine {
                get; construct set;
            }


            public PortQueue(Engine engine) {
                Object(engine: engine);
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
                    if(_eos_found)
                        _started = false;
                    return !_eos_found;
                }

                public new Port get() {
                    var port = _buffers_queue.pop();
                    if(port.eos) {
                        _eos_found = true;
                    }
                    return port;
                }
            }
        }
    }



    public class Component: Object {
        public Omx.PortParam ports_param;
        public int id;
        Omx.Handle _handle;

        Omx.State _current_state;
        Omx.State _previous_state;
        Omx.State _pending_state;

        AsyncQueue<Port> _buffers_queue;
        Semaphore _wait_for_state_sem;
        Port[] _ports;
        PortList _port_list;

        public delegate void EventFunc(
            Component component, uint data1, uint data2, void *event_data);

        EventFunc _event_func_0;
        EventFunc _event_func_1;
        EventFunc _event_func_2;
        EventFunc _event_func_3;
        EventFunc _event_func_4;
        EventFunc _event_func_5;
        EventFunc _event_func_6;
        EventFunc _event_func_7;
        EventFunc _event_func_8;

        bool _started;


        public bool started {
            get {
                return _started;
            }
        }


        public string name {
            get; set;
        }


        public Omx.Handle handle {
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
            get; construct set;
        }


        public string component_name {
            get; set construct;
        }


        public uint current_state {
            get {
                return _current_state;
            }
        }


        public uint init_index {
            get; set construct;
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


        public bool no_allocate_buffers {
            get; set;
        }


        construct {
            _buffers_queue = new AsyncQueue<Port>();
            _wait_for_state_sem = new Semaphore();
            _port_list = new PortList(this);
            _current_state = Omx.State.Invalid;
            _previous_state = Omx.State.Invalid;
            _pending_state = Omx.State.Invalid;
        }


        public Component(Core core, string comp_name, Omx.Index index) {
            Object(core: core, component_name: comp_name, init_index: index);
            name = comp_name;
        }


        public uint get_n_ports() {
            return ports_param.ports;
        }


        public Port get_port(uint i)
        requires(i < ports_param.ports) {
            return _ports[i];
        }


        public virtual void init()
        throws GLib.Error requires(_handle == null) {
            _core.get_handle(
                out _handle, _component_name,
                this, callbacks);

            ports_param.init();
            Omx.try_run(
                _handle.get_parameter(
                    _init_index, ports_param));
            _pending_state = Omx.State.Loaded;
            _current_state = Omx.State.Loaded;
        }


        public virtual void free_handle()
        throws GLib.Error requires(_handle != null) {
            _core.free_handle(_handle);
            _handle = null;
        }


        protected virtual void allocate_ports()
        throws GLib.Error requires(_ports == null) {
            uint n_ports = ports_param.ports;
            _ports = new Port[n_ports];
            for(uint i = 0; i<n_ports; i++) {
                var port = new Port(this, i+ports_param.start_port_number);
                port.init();
                port.name = "%s_port%u".printf(name, i);
                if(!_no_allocate_buffers)
                    port.allocate_buffers();
                _ports[i] = port;
            }
        }


        protected virtual void free_ports()
        throws GLib.Error requires(_ports != null) {
            foreach(var port in _ports)
                port.free_buffers();
            _ports = null;
        }


        public virtual void prepare_ports()
        throws GLib.Error requires(_ports != null) {
            foreach(var port in _ports)
                if(port.definition.dir == Omx.Dir.Output) {
                    var n_buffers = port.get_n_buffers();
                    for(uint i=0; i<n_buffers; i++)
                        port.push_buffer(port.pop_buffer());
                }
            foreach(var port in _ports)
                if(port.definition.dir == Omx.Dir.Input) {
                    uint n_buffers = port.get_n_buffers();
                    for(uint i=0; i<n_buffers; i++)
                        _buffers_queue.push(port);
                }
        }


        public void wait_for_state_set() {
            _wait_for_state_sem.down();
        }


        public void set_state(Omx.State state)
        throws GLib.Error requires(_handle != null) {
            _pending_state = state;
            Omx.try_run(
                _handle.send_command(
                    Omx.Command.StateSet, state, null));
            if(_current_state == Omx.State.Loaded &&
               _pending_state == Omx.State.Idle)
                allocate_ports();
            else
            if(_current_state == Omx.State.Idle &&
               _pending_state == Omx.State.Loaded)
                free_ports();
        }


        public void set_state_and_wait(Omx.State state)
        throws GLib.Error {
            set_state(state);
            wait_for_state_set();
        }


        public Omx.State get_state()
        throws GLib.Error requires(_handle != null) {
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


        public void event_set_function(
                Omx.Event event,
                EventFunc event_function) {
            switch(event) {
                case Omx.Event.CmdComplete: {
                    _event_func_0 = event_function;
                    break;
                }
                case Omx.Event.Error: {
                    _event_func_1 = event_function;
                    break;
                }
                case Omx.Event.Mark: {
                    _event_func_2 = event_function;
                    break;
                }
                case Omx.Event.PortSettingsChanged: {
                    _event_func_3 = event_function;
                    break;
                }
                case Omx.Event.BufferFlag: {
                    _event_func_4 = event_function;
                    break;
                }
                case Omx.Event.ResourcesAcquired: {
                    _event_func_5 = event_function;
                    break;
                }
                case Omx.Event.ComponentResumed: {
                    _event_func_6 = event_function;
                    break;
                }
                case Omx.Event.DynamicResourcesAvailable: {
                    _event_func_7 = event_function;
                    break;
                }
                case Omx.Event.PortFormatDetected: {
                    _event_func_8 = event_function;
                    break;
                }
                default:
                    break;
            }
        }


        Omx.Error event_handler(
                Omx.Handle component, Omx.Event event,
                uint32 data1, uint32 data2, void *event_data) {
            switch(event) {
                case Omx.Event.CmdComplete:
                    if(data1 == Omx.Command.StateSet) {
                        _previous_state = _current_state;
                        _current_state = _pending_state = (Omx.State)data2;

                        if(_event_func_0 != null)
                            _event_func_0(this, data1, data2, event_data);
                        _wait_for_state_sem.up();
                    }
                    break;
                case Omx.Event.Error:
                    if(_event_func_1 != null)
                        _event_func_1(this, data1, data2, event_data);
                    break;
                case Omx.Event.Mark:
                    if(_event_func_2 != null)
                        _event_func_2(this, data1, data2, event_data);
                    break;
                case Omx.Event.PortSettingsChanged:
                    if(_event_func_3 != null)
                        _event_func_3(this, data1, data2, event_data);
                    break;
                case Omx.Event.BufferFlag:
                    if(_event_func_4 != null)
                        _event_func_4(this, data1, data2, event_data);
                    break;
                case Omx.Event.ResourcesAcquired:
                    if(_event_func_5 != null)
                        _event_func_5(this, data1, data2, event_data);
                    break;
                case Omx.Event.ComponentResumed:
                    if(_event_func_6 != null)
                        _event_func_6(this, data1, data2, event_data);
                    break;
                case Omx.Event.DynamicResourcesAvailable:
                    if(_event_func_7 != null)
                        _event_func_7(this, data1, data2, event_data);
                    break;
                case Omx.Event.PortFormatDetected:
                    if(_event_func_8 != null)
                        _event_func_8(this, data1, data2, event_data);
                    break;
                default:
                    break;
            }
            return Omx.Error.None;
        }


        Omx.Error empty_buffer_done(
                Omx.Handle component,
                Omx.BufferHeader buffer) {
            var port = get_port(buffer.input_port_index);
            return buffer_done(port, buffer);
        }


        Omx.Error fill_buffer_done(
                Omx.Handle component,
                Omx.BufferHeader buffer) {
            var port = get_port(buffer.output_port_index);
            return buffer_done(port, buffer);
        }


        Omx.Error buffer_done(
                Port port,
                Omx.BufferHeader buffer) {
            port.queue.push(buffer);
            _buffers_queue.push(port);
            port.buffer_done(buffer);
            return Omx.Error.None;
        }



        public class PortList: Object {
            public Component component {
                get; construct set;
            }


            public uint length {
                get {
                    return _component._ports.length;
                }
            }


            public PortList(Component component) {
                Object(component: component);
            }


            public Iterator iterator() {
                return new Iterator(_component);
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
        public Omx.Param.PortDefinition definition;

        Omx.BufferHeader[] _buffers;
        AsyncQueue<Omx.BufferHeader> _buffers_queue;
        BufferList _buffer_list;
        bool _eos;
        BufferDoneFunc _buffer_done_func;

        public delegate void BufferDoneFunc(Omx.BufferHeader buffer);


        public string name {
            get; set;
        }


        public Component component {
            get; construct set;
        }


        public uint index {
            get {
                return definition.port_index;
            }
            
            set {
                definition.port_index = value;
            }
        }


        public bool eos {
            get {
                return _eos;
            }
        }


        public AsyncQueue<Omx.BufferHeader> queue {
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
            _buffers_queue = new AsyncQueue<Omx.BufferHeader>();
            _buffer_list = new BufferList(this);
            definition.init();
        }


        public Port(Component component, uint32 index) {
            Object(component: component, index: index);
        }


        public void init()
        throws GLib.Error {
            Omx.try_run(
                _component.handle.get_parameter(
                    Omx.Index.ParamPortDefinition, definition));
        }


        public void allocate_buffers()
        throws GLib.Error requires(_buffers == null) {
            uint n_buffers = get_n_buffers();
            _buffers = new Omx.BufferHeader[n_buffers];
            for(uint i=0; i<n_buffers; i++) {
                Omx.try_run(
                    _component.handle.allocate_buffer(
                        out _buffers[i], definition.port_index,
                        this, definition.buffer_size));
                _buffers_queue.push(_buffers[i]);
            }
        }


        public void setup_tunnel_with(Port port)
        throws GLib.Error requires(_component != null) {
            _component.core.setup_tunnel(
                _component.handle, index,
                port._component.handle, port.index);
        }


        public void use_buffers_of(Port port)
        throws GLib.Error requires(_component != null) {
            uint n_buffers = get_n_buffers();
            _buffers = new Omx.BufferHeader[n_buffers];
            for(uint i=0; i<n_buffers; i++) {
                var buffer_used = port.get_buffer(i);
                Omx.try_run(
                    _component.handle.use_buffer(
                        out _buffers[i], definition.port_index,
                        _component, definition.buffer_size,
                        buffer_used.buffer));
                _buffers_queue.push(_buffers[i]);
            }
        }


        public weak Omx.BufferHeader get_buffer(uint i)
        requires(i < definition.buffer_count_actual) {
            return _buffers[i];
        }


        public uint get_n_buffers() {
            return definition.buffer_count_actual;
        }


        public void free_buffers()
        throws GLib.Error requires(_buffers != null) {
            foreach(var buffer in _buffers)
                Omx.try_run(
                    _component.handle.free_buffer(
                        definition.port_index, buffer));
            _buffers = null;
        }


        public Omx.BufferHeader pop_buffer() {
            var buffer = _buffers_queue.pop();
            if(buffer.eos)
                _eos = true;
            return buffer;
        }


        public void push_buffer(Omx.BufferHeader buffer)
        throws GLib.Error requires(_component != null) {
            switch(definition.dir) {
                case Omx.Dir.Input:
                    _component.handle.empty_this_buffer(buffer);
                    break;
                case Omx.Dir.Output:
                    _component.handle.fill_this_buffer(buffer);
                    break;
                default:
                    break;
            }
        }


        public void set_buffer_done_function(BufferDoneFunc buffer_done_func) {
            _buffer_done_func = buffer_done_func;
        }


        public void buffer_done(Omx.BufferHeader buffer) {
            if(_buffer_done_func != null)
                _buffer_done_func(buffer);
        }



        public class BufferList: Object {
            public Port port {
                get; construct set;
            }


            public BufferList(Port port) {
                Object(port: port);
            }


            public Iterator iterator() {
                return new Iterator(_port);
            }


            public uint length {
                get {
                    return _port.get_n_buffers();
                }
            }


            public new Omx.BufferHeader get(uint index) {
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

                public new Omx.BufferHeader get() {
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



    public bool buffer_is_eos(Omx.BufferHeader buffer) {
        return buffer.eos;
    }


    public void buffer_set_eos(Omx.BufferHeader buffer) {
        buffer.set_eos();
    }


    public void buffer_copy(
            Omx.BufferHeader dest,
            Omx.BufferHeader source)
    requires(dest.buffer.length <= source.buffer.length) {
        dest.offset = source.offset;
        dest.length = source.length;
        Memory.copy(dest.buffer, source.buffer, source.length);
    }


    public void buffer_copy_len(
            Omx.BufferHeader dest,
            Omx.BufferHeader source)
    requires(dest.buffer.length <= source.buffer.length) {
        dest.offset = source.offset;
        dest.length = source.length;
    }


    public void buffer_read_from_file(
            Omx.BufferHeader buffer,
            FileStream fs) {
        buffer.offset = 0;
        buffer.length = fs.read(buffer.buffer);
        if(fs.eof())
            buffer.set_eos();
    }
}

