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

////////////////////////////////////////////////////////////////////////////////

    public class Engine: Object {
        ComponentList _components;
        PortDoneQueue _port_queue;
        uint _n_components;


        public ComponentList components {
            get {
                return _components;
            }
        }


        public PortDoneQueue ports_with_buffer_done {
            get {
                return _port_queue;
            }
        }


        public uint get_n_components() {
            return _n_components;
        }


        construct {
            _components = new ComponentList();
            _port_queue = new PortDoneQueue();
        }


        public void add_component(uint id, Component component) {
            component.id = id;
            component.queue = _port_queue.queue;
            _components.append(component);
            _n_components++;
        }


        public virtual void buffers_begin_transfer()
        throws Error {
            foreach(var component in _components) {
                component.buffers_begin_transfer();
                break;
            }
        }


        public virtual void init()
        throws Error {
            foreach(var component in _components)
                component.init();
        }


        public virtual void set_state(Omx.State state)
        throws Error {
            foreach(var component in _components)
                component.set_state(state);
        }


        public virtual void set_state_and_wait(Omx.State state)
        throws Error {
            foreach(var component in _components)
                component.set_state_and_wait(state);
        }


        public virtual void wait_for_state_set() {
            foreach(var component in _components)
                component.wait_for_state();
        }


        public virtual void free_handles()
        throws Error {
            foreach(var component in _components)
                component.free_handle();
        }
    }

////////////////////////////////////////////////////////////////////////////////

    public class ComponentList: Object {
        List<Component> _components_list;
        uint _length;


        construct {
            _components_list = new List<Component>();
        }


        public void append(Component component) {
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


        public new Component get(uint index)
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


        public AsyncQueue<Port> queue {
            get {
                return _queue;
            }
        }

        construct {
            _queue = new AsyncQueue<Port>();
        }


        public Iterator iterator() {
            return new Iterator(this);
        }


        public class Iterator: Object {
            AsyncQueue<Port> _ports_queue;
            bool _eos_found;

            public Iterator(PortDoneQueue queue) {
                _ports_queue = queue._queue;
            }

            public bool next() {
                return !_eos_found;
            }

            public new Port get() {
                var port = _ports_queue.pop();
                if(port.eos) {
                    _eos_found = true;
                }
                return port;
            }
        }
    }

////////////////////////////////////////////////////////////////////////////////

    public class AudioComponent: Component {
        public AudioComponent(Core core, string comp_name) {
            Object(
                core: core,
                component_name: comp_name,
                init_index: Omx.Index.ParamAudioInit,
                name: comp_name);
        }
    }


    public class ImageComponent: Component {
        public ImageComponent(Core core, string comp_name) {
            Object(
                core: core,
                component_name: comp_name,
                init_index: Omx.Index.ParamImageInit,
                name: comp_name);
        }
    }


    public class VideoComponent: Component {
        public VideoComponent(Core core, string comp_name) {
            Object(
                core: core,
                component_name: comp_name,
                init_index: Omx.Index.ParamVideoInit,
                name: comp_name);
        }
    }


    public class OtherComponent: Component {
        public OtherComponent(Core core, string comp_name) {
            Object(
                core: core,
                component_name: comp_name,
                init_index: Omx.Index.ParamOtherInit,
                name: comp_name);
        }
    }

////////////////////////////////////////////////////////////////////////////////

    public class Component: Object {
        public Omx.PortParam ports_param;
        public uint id;
        Omx.Handle _handle;

        Omx.State _current_state;
        Omx.State _previous_state;
        Omx.State _pending_state;

        Semaphore _wait_for_state_sem;
        Semaphore _wait_for_port_sem;
        Semaphore _wait_for_flush_sem;

        weak AsyncQueue<Port> _ports_queue;
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


        public string name {
            get; set;
        }


        public Omx.Handle handle {
            get {
                return _handle;
            }
        }


        public PortArray ports {
            get {
                return _ports;
            }
        }


        public AsyncQueue<Port>? queue {
            get {
                return _ports_queue;
            }
            set {
                _ports_queue = value;
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
            _wait_for_state_sem = new Semaphore();
            _wait_for_port_sem = new Semaphore();
            _wait_for_flush_sem = new Semaphore();
            _current_state = Omx.State.Invalid;
            _previous_state = Omx.State.Invalid;
            _pending_state = Omx.State.Invalid;
        }


        public Component(Core core, string comp_name, Omx.Index index) {
            Object(
                core: core,
                component_name: comp_name,
                init_index: index,
                name: comp_name);
        }


        public uint get_n_ports() {
            return ports_param.ports;
        }


        public virtual void init()
        throws Error requires(_handle == null) {
            _core.get_handle(
                out _handle, _component_name,
                this, callbacks);

            ports_param.init();
            try_run(
                _handle.get_parameter(
                    _init_index, ports_param));
            _pending_state = Omx.State.Loaded;
            _current_state = Omx.State.Loaded;
        }


        public void send_command(
            Omx.Command cmd, uint param, void *cmd_data=null)
        throws Error requires(_handle != null) {
            _handle.send_command(cmd, param, cmd_data);
        }


        public virtual void free_handle()
        throws Error requires(_handle != null) {
            _core.free_handle(_handle);
            _handle = null;
        }


        protected virtual void allocate_ports()
        throws Error requires(_ports == null) {
            var start_port = ports_param.start_port_number;
            var last_port = start_port +  ports_param.ports;

            _ports = new PortArray(ports_param.ports, start_port);
            uint i = start_port;
            while(i < last_port) {
                var port = new Port(this, i);
                port.init();
                port.name = "%s_port%u".printf(name, i);
                if(!_no_allocate_buffers)
                    port.allocate_buffers();
                _ports[i] = port;
                i++;
            }
        }


        protected virtual void free_ports()
        throws Error requires(_ports != null) {
            foreach(var port in _ports)
                port.free_buffers();
            _ports = null;
        }


        public virtual void buffers_begin_transfer()
        throws Error requires(_ports != null) {
            foreach(var port in _ports)
                port.buffers_begin_transfer();
        }


        public void wait_for_state() {
            _wait_for_state_sem.down();
        }


        public void wait_for_port()
        throws Error requires(_ports != null) {
            _wait_for_port_sem.down();
        }


        public void wait_for_flush() {
            _wait_for_flush_sem.down();
        }


        public virtual void set_state(Omx.State state)
        throws Error requires(_handle != null) {
            try_run(can_set_state(state));
            _pending_state = state;
            send_command(Omx.Command.StateSet, state);
            if(_current_state == Omx.State.Loaded &&
               _pending_state == Omx.State.Idle)
                allocate_ports();
            else
            if(_current_state == Omx.State.Idle &&
               _pending_state == Omx.State.Loaded)
                free_ports();
        }


        public Omx.Error can_set_state(Omx.State next_state) {
            if(_current_state == next_state)
                return Omx.Error.SameState;
            Omx.State[,] transitions = {
                {Omx.State.Loaded, Omx.State.WaitForResources},
                {Omx.State.Loaded, Omx.State.Idle},
                {Omx.State.Loaded, Omx.State.Invalid},
                {Omx.State.WaitForResources, Omx.State.Loaded},
                {Omx.State.WaitForResources, Omx.State.Invalid},
                {Omx.State.WaitForResources, Omx.State.Idle},
                {Omx.State.Idle, Omx.State.Loaded},
                {Omx.State.Idle, Omx.State.Invalid},
                {Omx.State.Idle, Omx.State.Pause},
                {Omx.State.Idle, Omx.State.Executing},
                {Omx.State.Pause, Omx.State.Invalid},
                {Omx.State.Pause, Omx.State.Idle},
                {Omx.State.Pause, Omx.State.Executing},
                {Omx.State.Executing, Omx.State.Idle},
                {Omx.State.Executing, Omx.State.Pause},
                {Omx.State.Executing, Omx.State.Invalid}
            };
            uint length = transitions.length[0];
            uint i = 0;
            while(i < length) {
                if(transitions[i,0] == _current_state)
                   if(transitions[i,1] == next_state)
                       return Omx.Error.None;
                i++;
            }
            return Omx.Error.IncorrectStateTransition;
        }


        public void set_state_and_wait(Omx.State state)
        throws Error {
            set_state(state);
            wait_for_state();
        }


        public Omx.State get_state()
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
            construct set {
                _start = value;
            }
        }


        public uint length {
            get {
                return _length;
            }
            construct set {
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


        public new void set(uint index, Port port) {
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
        public Omx.Param.PortDefinition definition;

        Omx.BufferHeader[] _buffers;
        AsyncQueue<Omx.BufferHeader> _buffers_queue;
        bool _eos;
        BufferDoneFunc _buffer_done_func;
        Port _peer;

        public delegate void BufferDoneFunc(Omx.BufferHeader buffer);


        public string name {
            get; set;
        }


        public Component component {
            get; construct set;
        }


        public Port? peer {
            get {
                return _peer;
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


        public bool eos {
            get {
                return _eos;
            }
        }


        public weak AsyncQueue<Omx.BufferHeader> queue {
            get {
                return _buffers_queue;
            }
        }


        construct {
            definition.init();
        }


        public Port(Component component, uint32 index) {
            Object(component: component, index: index);
        }


        public void init()
        throws Error {
            get_parameter();
        }


        public void get_parameter()
        throws Error {
            try_run(
                _component.handle.get_parameter(
                    Omx.Index.ParamPortDefinition, definition));
        }


        public void set_parameter()
        throws Error {
            try_run(
                _component.handle.set_parameter(
                    Omx.Index.ParamPortDefinition, definition));
        }


        public void allocate_buffers()
        throws Error requires(_buffers == null) {
            uint n_buffers = definition.buffer_count_actual;
            _buffers = new Omx.BufferHeader[n_buffers];
            _buffers_queue = new AsyncQueue<Omx.BufferHeader>();
            uint i = 0;
            while(i < n_buffers) {
                try_run(
                    _component.handle.allocate_buffer(
                        out _buffers[i], definition.port_index,
                        this, definition.buffer_size));
                _buffers_queue.push(_buffers[i]);
                i++;
            }
        }


        public void setup_tunnel_with(Port port)
        throws Error requires(_component != null) {
            _component.core.setup_tunnel(
                _component.handle, index,
                port._component.handle, port.index);
            _peer = port;
        }


        public void use_buffers_of_port(Port port)
        throws Error requires(_component != null) {
            uint n_buffers = definition.buffer_count_actual;
            _buffers = new Omx.BufferHeader[n_buffers];
            uint i = 0;
            while(i < n_buffers) {
                var buffer_used = port._buffers[i];
                try_run(
                    _component.handle.use_buffer(
                        out _buffers[i], definition.port_index,
                        _component, definition.buffer_size,
                        buffer_used.buffer));
                _buffers_queue.push(_buffers[i]);
                i++;
            }
        }


        public void use_buffers_of_array(uint8[][] array)
        throws Error requires(_component != null) {
            uint n_buffers = definition.buffer_count_actual;
            if(array.length != n_buffers)
                throw new GOmx.Error.InsufficientResources(
                    "The given array does not have enough items");

            _buffers = new Omx.BufferHeader[n_buffers];
            uint i = 0;
            while(i < n_buffers) {
                try_run(
                    _component.handle.use_buffer(
                        out _buffers[i], definition.port_index,
                        _component, definition.buffer_size,
                        array[i]));
                _buffers_queue.push(_buffers[i]);
                i++;
            }
        }


        public void enable()
        throws Error requires(_component != null) {
            definition.enabled = true;
            set_parameter();
            _component.send_command(Omx.Command.PortEnable, index);
            allocate_buffers();
            if(_component.current_state != Omx.State.Loaded)
                buffers_begin_transfer();
            _component.wait_for_port();
            get_parameter();
        }


        public void disable()
        throws Error requires(_component != null) {
            definition.enabled = false;
            set_parameter();
            _component.send_command(Omx.Command.PortDisable, index);
            flush();
            free_buffers();
            _component.wait_for_port();    
            get_parameter();        
        }


        public void flush()
        throws Error requires(_component != null) {
            _component.send_command(Omx.Command.Flush, index);
            _component.wait_for_flush();
        }


        public uint get_n_buffers() {
            return definition.buffer_count_actual;
        }


        public uint get_buffer_size() {
            return definition.buffer_size;
        }


        public void free_buffers()
        throws Error requires(_buffers != null) {
            foreach(var buffer in _buffers)
                try_run(
                    _component.handle.free_buffer(
                        definition.port_index, buffer));
            _buffers = null;
            _buffers_queue = null;
        }


        public Omx.BufferHeader pop_buffer() {
            var buffer = _buffers_queue.pop();
            if(buffer_is_eos(buffer))
                _eos = true;
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


        public void buffer_done(Omx.BufferHeader buffer) {
            if(_buffer_done_func != null)
                _buffer_done_func(buffer);
        }


        public void buffers_begin_transfer()
        throws Error {
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

////////////////////////////////////////////////////////////////////////////////

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
            buffer_set_eos(buffer);
    }


////////////////////////////////////////////////////////////////////////////////
    
    public weak string command_to_string(Omx.Command command) {
        return command.to_string();
    }


    public weak string state_to_string(Omx.State state) {
        return state.to_string();
    }


    public weak string event_to_string(Omx.Event event) {
        return event.to_string();
    }


    public weak string error_to_string(Omx.Error error) {
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
        SeperateTablesUsed,
        TunnelingUnsupported
    }

    extern Quark error_quark();

    public void try_run(Omx.Error e) throws Error {
        if(e != Omx.Error.None) {
            var error = new GLib.Error(error_quark(), e, error_to_string(e));
            throw (Error)error;
        }
    }
}

