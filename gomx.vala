namespace GOmx {

////////////////////////////////////////////////////////////////////////////////

    public Core load_library(string library_name)
    throws GLib.FileError, Error {
        return LibraryLoader.load_library(library_name);
    }


////////////////////////////////////////////////////////////////////////////////

    internal class LibraryLoader: Object {
        GLib.HashTable<string,Core> _core_table;
        static LibraryLoader _common_table;


        construct {
            _core_table = new GLib.HashTable<string,Core>(str_hash, str_equal);
        }


        public static Core load_library(string library_name)
        throws GLib.FileError, Error {
            lock(_common_table)
                if(_common_table == null)
                    _common_table = new LibraryLoader();
            var core = _common_table[library_name];
            if(core == null) {
                core = Core.open(library_name);
                _common_table[library_name] = core;
            }
            return core;
        }


        public static Core? get_library(string library_name) {
            return _common_table[library_name];
        }


        new unowned Core? get(string library_name) {
            return _core_table.lookup(library_name);
        }


        new void set(string library_name, Core core) {
            _core_table.insert(library_name, core);
        }
    }

////////////////////////////////////////////////////////////////////////////////

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


        public weak Module module {
            get {
                return _module;
            }
        }


        public void init()
        throws Error {
            try_run(_init_func());
        }


        public void deinit()
        throws Error {
            try_run(_deinit_func());
        }


        public void get_handle(
                out Omx.Handle component, string component_name,
                void *app_data, Omx.Callback callbacks)
        throws Error {
            try_run(
                _get_handle_func(
                    out component, component_name, app_data, callbacks));
        }


        public void free_handle(Omx.Handle handle)
        throws Error {
            try_run(_free_handle_func(handle));
        }


        public void setup_tunnel(
                Omx.Handle output, uint32 port_output,
                Omx.Handle input, uint32 port_input)
        throws Error {
            try_run(
                _setup_tunnel_func(output, port_output, input, port_input));
        }


        public static Core open (string soname)
        throws GLib.FileError {
            var core = new Core();

            var module = Module.open(soname, ModuleFlags.BIND_LAZY);
            if(module == null)
                throw new FileError.FAILED(
                    "Could not open library '%s'", soname);

            string name;
            void *symbol;

            name = "OMX_Init";
            module.symbol(name, out symbol);
            core._init_func = (InitFunc)symbol;

            if(symbol != null) {
                name = "OMX_Deinit";
                module.symbol(name, out symbol);
                core._deinit_func = (DeinitFunc)symbol;
            }

            if(symbol != null) {
                name = "OMX_GetHandle";
                module.symbol(name, out symbol);
                core._get_handle_func = (GetHandleFunc)symbol;
            }

            if(symbol != null) {
                name = "OMX_FreeHandle";
                module.symbol(name, out symbol);
                core._free_handle_func = (FreeHandleFunc)symbol;
            }

            if(symbol != null) {
                name = "OMX_SetupTunnel";
                module.symbol(name, out symbol);
                core._setup_tunnel_func = (SetupTunnelFunc)symbol;
            }

            if(symbol == null)
                throw new GLib.FileError.INVAL(
                    "Could not find symbol '%s' in library '%s'", name, soname);

            core._module = (owned)module;
            return core;
        }
    }

////////////////////////////////////////////////////////////////////////////////

    public class Engine: Object {
        ComponentList _components;
        HashTable<string, Component> _components_table;
        PortDoneQueue _port_queue;


        construct {
            _components = new ComponentList();
            _components_table =
                new HashTable<string, Component>(str_hash, str_equal);
            _port_queue = new PortDoneQueue();
        }


        public weak ComponentList components {
            get {
                return _components;
            }
        }


        public weak PortDoneQueue ports_with_buffer_done {
            get {
                return _port_queue;
            }
        }


        public virtual void add_component(Component component) {
            component.queue = _port_queue;
            if(component.name == "" || component.name == null)
                component.name =
                    "%s%u".printf(component.component_name, component.id);
            if(component.name in this)
                component.name =
                    "%s%02u".printf(component.component_name, component.id);
            _components.add(component);
            _components_table.insert(component.name, component);
        }


        public new unowned Component get(string name) {
            return _components_table.lookup(name);
        }


        public bool contains(string name) {
            return _components_table.lookup(name) != null;
        }
    }

////////////////////////////////////////////////////////////////////////////////

    public class ComponentList: Object {
        List<Component> _components_list;
        uint _length;


        construct {
            _components_list = new List<Component>();
        }


        public void add(Component component) {
            _components_list.append(component);
            _length++;
        }


        public Iterator iterator() {
            return new Iterator(this);
        }


        public uint length {
            get {
                return _length;
            }
        }


        public void init()
        throws Error {
            foreach(var component in _components_list)
                component.init();
        }


        public void set_state(Omx.State state)
        throws Error {
            foreach(var component in _components_list)
                component.set_state(state);
        }


        public void set_state_and_wait(Omx.State state)
        throws Error {
            foreach(var component in _components_list)
                component.set_state(state);
            foreach(var component in _components_list)
                component.wait_for_state();                
        }


        public void wait_for_state() {
            foreach(var component in _components_list)
                component.wait_for_state();
        }


        public void begin_transfer()
        throws Error {
            foreach(var component in _components_list) {
                component.begin_transfer();
                break;
            }
        }


        public void flush()
        throws Error {
            foreach(var component in _components_list)
                component.flush();
        }


        public void free_handles()
        throws Error {
            foreach(var component in _components_list)
                component.free_handle();
        }


        public new unowned Component get(uint index)
        requires(index < _length) {
            return _components_list.nth_data(index);
        }


        public class Iterator: Object {
            weak List<Component> _components_list;

            public Iterator(ComponentList list) {
                _components_list = list._components_list;
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

////////////////////////////////////////////////////////////////////////////////

    public class PortDoneQueue: Object {
        AsyncQueue<Port> _queue;
        bool _eos;


        construct {
            _queue = new AsyncQueue<Port>();
        }


        public weak AsyncQueue<Port> queue {
            get {
                return _queue;
            }
        }


        internal void set_eos(bool eos) {
            _eos = eos;
        }


        public void push(Port port) {
            _queue.push(port);
        }


        public Port pop() {
            return _queue.pop();
        }


        public Iterator iterator() {
            return new Iterator(this);
        }


        public class Iterator: Object {
            PortDoneQueue _ports_queue;

            public Iterator(PortDoneQueue queue) {
                _ports_queue = queue;
            }

            public bool next() {
                return !_ports_queue._eos;
            }

            public new Port get() {
                var port = _ports_queue.pop();
                if(port.eos) {
                    _ports_queue._eos = true;
                }
                return port;
            }
        }
    }

////////////////////////////////////////////////////////////////////////////////

    public class AudioComponent: Component {
        public AudioComponent(string name) {
            Object(
                component_name: name,
                init_index: Omx.Index.ParamAudioInit,
                name: name);
        }
    }


    public class ImageComponent: Component {
        public ImageComponent(string name) {
            Object(
                component_name: name,
                init_index: Omx.Index.ParamImageInit,
                name: name);
        }
    }


    public class VideoComponent: Component {
        public VideoComponent(string name) {
            Object(
                component_name: name,
                init_index: Omx.Index.ParamVideoInit,
                name: name);
        }
    }


    public class OtherComponent: Component {
        public OtherComponent(string name) {
            Object(
                component_name: name,
                init_index: Omx.Index.ParamOtherInit,
                name: name);
        }
    }

////////////////////////////////////////////////////////////////////////////////

    public class Component: Object {
        public uint id;
        Omx.PortParam ports_param;
        Omx.Handle _handle;
        Core _core;

        Omx.State _current_state;
        Omx.State _previous_state;
        Omx.State _pending_state;

        Semaphore _wait_for_state_sem;
        Semaphore _wait_for_port_sem;
        Semaphore _wait_for_flush_sem;

        PortDoneQueue _ports_queue;
        PortArray _ports;


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


        construct {
            _wait_for_state_sem = new Semaphore();
            _wait_for_port_sem = new Semaphore();
            _wait_for_flush_sem = new Semaphore();
            _current_state = Omx.State.Invalid;
            _previous_state = Omx.State.Invalid;
            _pending_state = Omx.State.Invalid;
            _name = "";
            _library_name = "";
            _component_name = "";
        }


        public string name {
            get; set;
        }


        public weak Omx.Handle handle {
            get {
                return _handle;
            }
        }


        public weak PortArray ports {
            get {
                return _ports;
            }
        }


        public weak PortDoneQueue? queue {
            get {
                return _ports_queue;
            }
            set {
                _ports_queue = value;
            }
        }


        public weak Core core {
            get {
                return _core;
            }
        }


        public uint init_index {
            get; set;
        }


        public string library_name {
            get; set;
        }


        public string component_name {
            get; set;
        }


        public string? component_role {
            get; set;
        }

        public Omx.State current_state {
            get {
                return _current_state;
            }
        }


        public Omx.State pending_state {
            get {
                return _pending_state;
            }
        }


        public Omx.State previous_state {
            get {
                return _previous_state;
            }
        }


        public Component(string name, Omx.Index index) {
            Object(
                component_name: name,
                init_index: index,
                name: name);
        }


        public uint n_ports {
            get {
                return ports_param.ports;
            }
        }


        public virtual void init()
        throws Error requires(_handle == null) {
            if(_library_name == null || _library_name == "")
                throw new Error.BadParameter(
                    "No library has been defined for component '%s'", _name);

            _core = LibraryLoader.get_library(_library_name);
            if(_core == null)
                throw new Error.BadParameter(
                    "There is no core for library '%s'", _library_name);

            _core.get_handle(
                out _handle, _component_name,
                this, callbacks);

            ports_param.init();
            try_run(
                _handle.get_parameter(_init_index, ports_param));

            allocate_ports();

            if(_component_role != "" && component_role != null)
                set_role(_component_role);

            _pending_state = Omx.State.Loaded;
            _current_state = Omx.State.Loaded;
        }


        protected virtual void allocate_ports()
        throws Error {
            var start_port = ports_param.start_port_number;
            var n_ports = ports_param.ports;
            var last_port = start_port +  n_ports;

            _ports = new PortArray(n_ports, start_port);

            uint i = start_port;
            while(i < last_port) {
                var port = new Port(this, i);
                port.init();
                port.name = "%s_port%u".printf(name, i);
                _ports[i] = port;
                i++;
            }
        }


        protected virtual void set_role(string component_role)
        requires(_handle != null) {
            var role_param = Omx.Param.ComponentRole();
            role_param.init();

            var role_index = Omx.Index.ParamStandardComponentRole;
            string role;

            var error = _handle.get_parameter(role_index, role_param);
            if(error == Omx.Error.None)
                role = (string)role_param.role;
            else {
                _component_role = null;
                return;
            }

            if(_component_role == null) {
                _component_role = role;
                return;
            }

            var max_size = Omx.MAX_STRING_SIZE;
            Posix.strncpy((string)role_param.role, component_role, max_size);
            error = _handle.set_parameter(role_index, role_param);
            if(error != Omx.Error.None)
                _component_role = role;
            else
                _component_role = component_role;
        }


        public virtual void free_handle()
        throws Error requires(_handle != null) {
            _core.free_handle(_handle);
            _handle = null;
        }


        protected virtual void allocate_buffers()
        throws Error requires(_ports != null) {
            foreach(var p in _ports) {
                if(!p.no_allocate_buffers)
                    p.allocate_buffers();
            }
        }


        protected virtual void free_buffers()
        throws Error requires(_ports != null) {
            foreach(var p in _ports)
                if(p.buffers != null) {
                    p.get_definition();
                    if(p.populated && p.enabled)
                        p.free_buffers();
                }
        }


        public virtual void begin_transfer()
        throws Error requires(_ports != null) {
            if(_ports_queue != null)
                _ports_queue.set_eos(false);
            foreach(var p in _ports)
                if(p.buffers != null) {
                    p.get_definition();
                    if(p.populated && p.enabled)
                        p.begin_transfer();
                }
        }


        public virtual void flush()
        throws Error requires(_ports != null) {
            foreach(var p in _ports)
                if(p.buffers != null) {
                    p.get_definition();
                    if(p.populated && p.enabled)
                        p.flush();
                }
        }


        public void wait_for_state() {
            _wait_for_state_sem.down();
        }


        public void wait_for_port()
        requires(_ports != null) {
            _wait_for_port_sem.down();
        }


        public void wait_for_flush() {
            _wait_for_flush_sem.down();
        }


        public virtual void set_state(Omx.State state)
        throws Error requires(_handle != null) {
            try_run(can_set_state(state));
            _pending_state = state;
            
            var safe_current_state = _current_state;
            var safe_pending_state = _pending_state;
            
            try_run(
                _handle.send_command(Omx.Command.StateSet, state));

            if(safe_current_state == Omx.State.Loaded &&
               safe_pending_state == Omx.State.Idle)
                allocate_buffers();
            else
            if(safe_current_state == Omx.State.Executing &&
               safe_pending_state == Omx.State.Idle)
                flush();
            else
            if(safe_current_state == Omx.State.Idle) {
                if(safe_pending_state == Omx.State.Executing)
                    begin_transfer();
                else
                if(safe_pending_state == Omx.State.Loaded)
                    free_buffers();
            }
        }


        const Omx.State[] TRANSITIONS = {
            Omx.State.Loaded, Omx.State.WaitForResources,
            Omx.State.Loaded, Omx.State.Idle,
            Omx.State.Loaded, Omx.State.Invalid,
            Omx.State.WaitForResources, Omx.State.Loaded,
            Omx.State.WaitForResources, Omx.State.Invalid,
            Omx.State.WaitForResources, Omx.State.Idle,
            Omx.State.Idle, Omx.State.Loaded,
            Omx.State.Idle, Omx.State.Invalid,
            Omx.State.Idle, Omx.State.Pause,
            Omx.State.Idle, Omx.State.Executing,
            Omx.State.Pause, Omx.State.Invalid,
            Omx.State.Pause, Omx.State.Idle,
            Omx.State.Pause, Omx.State.Executing,
            Omx.State.Executing, Omx.State.Idle,
            Omx.State.Executing, Omx.State.Pause,
            Omx.State.Executing, Omx.State.Invalid
        };


        public Omx.Error can_set_state(Omx.State next_state) {
            if(_current_state == next_state)
                return Omx.Error.SameState;
            uint i = 0;
            while(i < TRANSITIONS.length) {
                if(TRANSITIONS[i] == _current_state)
                   if(TRANSITIONS[i+1] == next_state)
                       return Omx.Error.None;
                i+=2;
            }
            return Omx.Error.IncorrectStateTransition;
        }


        public void set_state_and_wait(Omx.State state)
        throws Error {
            set_state(state);
            wait_for_state();
        }


        public virtual Omx.State get_state()
        throws Error requires(_handle != null) {
            Omx.State state;
            try_run(
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
                case Omx.Event.CmdComplete:
                    _event_func_0 = event_function;
                    break;

                case Omx.Event.Error:
                    _event_func_1 = event_function;
                    break;

                case Omx.Event.Mark:
                    _event_func_2 = event_function;
                    break;

                case Omx.Event.PortSettingsChanged:
                    _event_func_3 = event_function;
                    break;

                case Omx.Event.BufferFlag:
                    _event_func_4 = event_function;
                    break;

                case Omx.Event.ResourcesAcquired:
                    _event_func_5 = event_function;
                    break;

                case Omx.Event.ComponentResumed:
                    _event_func_6 = event_function;
                    break;

                case Omx.Event.DynamicResourcesAvailable:
                    _event_func_7 = event_function;
                    break;

                case Omx.Event.PortFormatDetected:
                    _event_func_8 = event_function;
                    break;

                default:
                    break;
            }
        }


        Omx.Error event_handler(
                Omx.Handle component, Omx.Event event,
                uint32 data1, uint32 data2, void *event_data) {
            switch(event) {
                case Omx.Event.CmdComplete:
                    switch(data1) {
                        case Omx.Command.StateSet:
                            _previous_state = _current_state;
                            _current_state = _pending_state = (Omx.State)data2;
                            _wait_for_state_sem.up();
                            break;
                        case Omx.Command.PortDisable:
                        case Omx.Command.PortEnable:
                            _wait_for_port_sem.up();
                            break;
                        case Omx.Command.Flush:
                            _wait_for_flush_sem.up();
                            break;
                    }
                    if(_event_func_0 != null)
                        _event_func_0(this, data1, data2, event_data);
                    break;

                case Omx.Event.Error:
                    var error = (Omx.Error)data1;
                    critical(error.to_string());
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
                    if((data2 & Omx.BufferFlag.EOS) != 0) {
                        ports[data1].set_eos(true);
                        if(_ports_queue != null)
                            _ports_queue.set_eos(true);
                    }
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
            var port = _ports[buffer.input_port_index];
            return buffer_done(port, buffer);
        }


        Omx.Error fill_buffer_done(
                Omx.Handle component,
                Omx.BufferHeader buffer) {
            var port = _ports[buffer.output_port_index];
            return buffer_done(port, buffer);
        }


        Omx.Error buffer_done(
                Port port,
                Omx.BufferHeader buffer) {
            port.queue.push(buffer);
            if(_ports_queue != null)
                _ports_queue.push(port);
            port.buffer_done(buffer);
            return Omx.Error.None;
        }
    }

////////////////////////////////////////////////////////////////////////////////

    public class PortArray: Object {
        Port[] _ports;
        uint _start;
        uint _length;


        public uint start {
            get {
                return _start;
            }
            set {
                _start = value;
            }
        }


        public uint length {
            get {
                return _length;
            }
            set {
                _ports = new Port[value];
                _length = value;
            }
        }


        public PortArray(uint length, uint start=0) {
            Object(length: length, start: start);
        }


        public Iterator iterator() {
            return new Iterator(this);
        }


        public new Port get(uint index)
        requires(index-_start < _ports.length && index-_start >=0) {
            return _ports[index-_start];
        }


        public new void set(uint index, Port port)
        requires(index-_start < _ports.length && index-_start >=0) {
            _ports[index-_start] = port;
        }


        public class Iterator: Object {
            PortArray _array;
            uint _index;

            public Iterator(PortArray array) {
                _array = array;
                _index = array.start;
            }

            public bool next() {
                return _index < _array.length + _array._start;
            }

            public new Port get() {
                return _array[_index++];
            }
        }
    }

////////////////////////////////////////////////////////////////////////////////

    public class Port: Object {
        Omx.Param.PortDefinition definition;
        BufferArray _buffers;
        AsyncQueue<Omx.BufferHeader> _buffers_queue;
        bool _eos;
        BufferDoneFunc _buffer_done_func;
        weak Port _supplier;
        weak Port _peer;
        bool _tunneled;

        public delegate void BufferDoneFunc(Port port, Omx.BufferHeader buffer);


        construct {
            _name = "";
            definition.init();
            _buffers_queue = new AsyncQueue<Omx.BufferHeader>();
        }


        public string name {
            get; set;
        }


        public weak Component component {
            get; set;
        }


        public weak Port? supplier {
            get {
                return _supplier;
            }
        }


        public weak Port? peer {
            get {
                return _peer;
            }
        }


        public bool tunneled {
            get {
                return _tunneled;
            }
        }


        public BufferArray buffers {
            get {
                return _buffers;
            }
        }


        public uint index {
            get {
                return definition.port_index;
            }
            set {
                definition.port_index = value;
            }
        }


        public bool is_input {
            get {
                return definition.dir == Omx.Dir.Input;
            }
        }


        public bool is_output {
            get {
                return definition.dir == Omx.Dir.Output;
            }
        }


        public bool enabled {
            get {
                return definition.enabled;
            }
        }


        public bool populated {
            get {
                return definition.populated;
            }
        }


        public Omx.PortDomain domain {
            get {
                return definition.domain;
            }
        }


        public bool eos {
            get {
                return _eos;
            }
        }


        public bool no_allocate_buffers {
            get; set;
        }


        public bool buffers_allocated {
            get {
                return _buffers != null;
            }
        }

        public weak AsyncQueue<Omx.BufferHeader> queue {
            get {
                return _buffers_queue;
            }
        }


        public uint n_buffers {
            get {
                return definition.buffer_count_actual;
            }
            set {
                definition.buffer_count_actual = value;
            }
        }


        public uint n_min_buffers {
            get {
                return definition.buffer_count_min;
            }
        }


        public uint buffer_size {
            get {
                return definition.buffer_size;
            }
            set {
                definition.buffer_size = value;
            }
        }


        public Port(Component component, uint index) {
            Object(component: component, index: index);
        }


        public void init()
        throws Error {
            get_definition();
        }


        public Omx.Param.PortDefinition* get_definition()
        throws Error {
            try_run(
                _component.handle.get_parameter(
                    Omx.Index.ParamPortDefinition, definition));
            return &definition;
        }


        public void set_definition()
        throws Error {
            try_run(
                _component.handle.set_parameter(
                    Omx.Index.ParamPortDefinition, definition));
        }


        public void allocate_buffers()
        throws Error requires(_buffers == null) {
            _buffers = new BufferArray(n_buffers);
            _buffers_queue = new AsyncQueue<Omx.BufferHeader>();
            uint i = 0;
            while(i < n_buffers) {
                try_run(
                    _component.handle.allocate_buffer(
                        out _buffers.array[i], index,
                        this, buffer_size));
                _buffers_queue.push(_buffers[i]);
                i++;
            }
        }


        public void use_buffers_of_port(Port port)
        throws Error requires(_component != null) {
            _buffers = new BufferArray(n_buffers);
            _buffers_queue = new AsyncQueue<Omx.BufferHeader>();
            uint i = 0;
            while(i < n_buffers) {
                var buffer_used = port._buffers[i];
                try_run(
                    _component.handle.use_buffer(
                        out _buffers.array[i], index,
                        _component, buffer_size,
                        buffer_used.buffer));
                _buffers_queue.push(_buffers[i]);
                i++;
            }
            _supplier = port;
        }


        public void use_null_buffers()
        throws Error requires(_component != null) {
            _buffers = new BufferArray(n_buffers);
            _buffers_queue = new AsyncQueue<Omx.BufferHeader>();
            uint i = 0;
            while(i < n_buffers) {
                try_run(
                    _component.handle.use_buffer(
                        out _buffers.array[i], index,
                        _component, buffer_size,
                        null));
                _buffers_queue.push(_buffers[i]);
                i++;
            }
        }


        public void free_buffers()
        throws Error requires(_buffers != null && _component !=null) {
            foreach(var buffer in _buffers)
                try_run(
                    _component.handle.free_buffer(index, buffer));
            _buffers = null;
            _buffers_queue = null;
        }


        public void tunnel(Port input_port)
        throws Error requires(_component != null) {
            _component.core.setup_tunnel(
                _component.handle, index,
                input_port._component.handle, input_port.index);
            _peer = input_port;
            input_port._no_allocate_buffers = _no_allocate_buffers = true;
            input_port._tunneled = _tunneled = true;
        }


        public void enable()
        throws Error requires(_component != null) {
            definition.enabled = true;
            set_definition();
            try_run(
                _component.handle.send_command(Omx.Command.PortEnable, index));
            allocate_buffers();
            if(_component.current_state != Omx.State.Loaded)
                begin_transfer();
            _component.wait_for_port();
            get_definition();
        }


        public void disable()
        throws Error requires(_component != null) {
            definition.enabled = false;
            set_definition();
            try_run(
                _component.handle.send_command(Omx.Command.PortDisable, index));
            flush();
            free_buffers();
            _component.wait_for_port();
            get_definition();
        }


        public void flush()
        throws Error requires(_component != null) {
            try_run(
                _component.handle.send_command(Omx.Command.Flush, index));
            _component.wait_for_flush();
        }


        internal void set_eos(bool eos) {
            _eos = eos;
        }


        public Omx.BufferHeader pop_buffer() {
            var buffer = _buffers_queue.pop();
            if(buffer_is_eos(buffer))
                set_eos(true);
            return buffer;
        }


        public void push_buffer(Omx.BufferHeader buffer)
        throws Error requires(_component != null) {
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


        internal void buffer_done(Omx.BufferHeader buffer) {
            if(_buffer_done_func != null)
                _buffer_done_func(this, buffer);
        }


        public void begin_transfer()
        throws Error {
            set_eos(false);
            switch(definition.dir) {
                case Omx.Dir.Output:
                    push_buffer(pop_buffer());
                    break;
                case Omx.Dir.Input:
                    if(_component.queue != null)
                        _component.queue.push(this);
                    break;
                default:
                    break;
            }
        }
    }

////////////////////////////////////////////////////////////////////////////////

    public class BufferArray: Object {
        internal Omx.BufferHeader[] array;


        public uint length {
            get {
                return array.length;
            }
            set {
                array = new Omx.BufferHeader[value];
            }
        }


        public BufferArray(uint length) {
            Object(length: length);
        }


        public Iterator iterator() {
            return new Iterator(this);
        }


        public new Omx.BufferHeader get(uint index)
        requires(index < array.length && index >= 0) {
            return array[index];
        }


        public class Iterator: Object {
            BufferArray _array;
            uint _index;

            public Iterator(BufferArray array) {
                _array = array;
                _index = 0;
            }

            public bool next() {
                return _index < _array.length;
            }

            public new Omx.BufferHeader get() {
                return _array[_index++];
            }
        }
    }

////////////////////////////////////////////////////////////////////////////////

    internal class Semaphore: Object {
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

////////////////////////////////////////////////////////////////////////////////

    public bool buffer_is_eos(Omx.BufferHeader buffer) {
        return (buffer.flags & Omx.BufferFlag.EOS) != 0;
    }


    public void buffer_set_eos(Omx.BufferHeader buffer) {
        buffer.flags |= Omx.BufferFlag.EOS;
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
        buffer.length = (uint32)fs.read(buffer.buffer);
        if(fs.eof())
            buffer_set_eos(buffer);
    }


////////////////////////////////////////////////////////////////////////////////

    public unowned string command_to_string(Omx.Command command) {
        return command.to_string();
    }


    public unowned string state_to_string(Omx.State state) {
        return state.to_string();
    }


    public unowned string event_to_string(Omx.Event event) {
        return event.to_string();
    }


    public unowned string error_to_string(Omx.Error error) {
        return error.to_string();
    }

////////////////////////////////////////////////////////////////////////////////

    public errordomain Error {
        None,
        InsufficientResources,
        Undefined,
        InvalidComponentName,
        ComponentNotFound,
        InvalidComponent,
        BadParameter,
        NotImplemented,
        Underflow,
        Overflow,
        Hardware,
        InvalidState,
        StreamCorrupt,
        PortsNotCompatible,
        ResourcesLost,
        NoMore,
        VersionMismatch,
        NotReady,
        Timeout,
        SameState,
        ResourcesPreempted,
        PortUnresponsiveDuringAllocation,
        PortUnresponsiveDuringDeallocation,
        PortUnresponsiveDuringStop,
        IncorrectStateTransition,
        IncorrectStateOperation,
        UnsupportedSetting,
        UnsupportedIndex,
        BadPortIndex,
        PortUnpopulated,
        ComponentSuspended,
        DynamicResourcesUnavailable,
        MbErrorsInFrame,
        FormatNotDetected,
        ContentPipeOpenFailed,
        ContentPipeCreationFailed,
        SeparateTablesUsed,
        TunnelingUnsupported
    }

    extern Quark error_quark();

    public void try_run(Omx.Error e) throws Error {
        if(e != Omx.Error.None) {
            var error = new GLib.Error(error_quark(), e, error_to_string(e));
            throw (Error)error;
        }
    }

////////////////////////////////////////////////////////////////////////////////

}

