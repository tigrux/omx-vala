/* omx-glib.vapi generated by valac, do not modify. */

[CCode (cprefix = "GOmx", lower_case_cprefix = "g_omx_")]
namespace GOmx {
	[CCode (cheader_filename = "omx-glib.h")]
	public class Component : GLib.Object {
		[CCode (cheader_filename = "omx-glib.h")]
		public class PortList : GLib.Object {
			[CCode (cheader_filename = "omx-glib.h")]
			public class Iterator : GLib.Object {
				public Iterator (GOmx.Component component);
				public GOmx.Port @get ();
				public bool next ();
			}
			public PortList (GOmx.Component component);
			public GOmx.Port @get (uint index);
			public GOmx.Component.PortList.Iterator iterator ();
			public uint length { get; }
		}
		[CCode (cheader_filename = "omx-glib.h", instance_pos = -2)]
		public delegate void EventFunc (GOmx.Component component, uint data1, uint data2, void* event_data);
		public int id;
		public Omx.PortParam port_param;
		public Component (GOmx.Core core, string component_name, Omx.Index param_init_index);
		public void allocate_buffers () throws GLib.Error;
		public void allocate_ports () throws GLib.Error;
		public void empty_input_buffers () throws GLib.Error;
		public void event_set_function (Omx.Event event, GOmx.Component.EventFunc event_function);
		public void fill_output_buffers () throws GLib.Error;
		public void free_handle () throws GLib.Error;
		public void free_ports () throws GLib.Error;
		public uint get_n_ports ();
		public GOmx.Port get_port (uint i);
		public Omx.State get_state () throws GLib.Error;
		public void init () throws GLib.Error;
		public void prepare_ports () throws GLib.Error;
		public void set_state (Omx.State state) throws GLib.Error;
		public void set_state_and_wait (Omx.State state) throws GLib.Error;
		public void wait_for_state_set ();
		public GOmx.Core core { get; }
		public uint current_state { get; }
		public Omx.Handle handle { get; }
		public string name { get; set; }
		public uint pending_state { get; }
		public GOmx.Component.PortList ports { get; }
		public uint previous_state { get; }
		public GLib.AsyncQueue<GOmx.Port> queue { get; set; }
	}
	[CCode (cheader_filename = "omx-glib.h")]
	public class Core : GLib.Object {
		[CCode (cheader_filename = "omx-glib.h", instance_pos = -2)]
		public delegate Omx.Error DeinitFunc ();
		[CCode (cheader_filename = "omx-glib.h", instance_pos = -2)]
		public delegate Omx.Error FreeHandleFunc (Omx.Handle handle);
		[CCode (cheader_filename = "omx-glib.h", instance_pos = -2)]
		public delegate Omx.Error GetHandleFunc (out Omx.Handle component, string component_name, void* app_data, Omx.Callback callbacks);
		[CCode (cheader_filename = "omx-glib.h", instance_pos = -2)]
		public delegate Omx.Error InitFunc ();
		[CCode (cheader_filename = "omx-glib.h", instance_pos = -2)]
		public delegate Omx.Error SetupTunnelFunc (Omx.Handle output, uint32 port_output, Omx.Handle input, uint32 port_input);
		public Core ();
		public void deinit () throws GLib.Error;
		public void free_handle (Omx.Handle handle) throws GLib.Error;
		public void get_handle (out Omx.Handle component, string component_name, void* app_data, Omx.Callback callbacks) throws GLib.Error;
		public void init () throws GLib.Error;
		public static GOmx.Core? open (string soname);
		public void setup_tunnel (Omx.Handle output, uint32 port_output, Omx.Handle input, uint32 port_input) throws GLib.Error;
	}
	[CCode (cheader_filename = "omx-glib.h")]
	public class Engine : GLib.Object {
		[CCode (cheader_filename = "omx-glib.h")]
		public class ComponentList : GLib.Object {
			[CCode (cheader_filename = "omx-glib.h")]
			public class Iterator : GLib.Object {
				public Iterator (GOmx.Engine engine);
				public GOmx.Component @get ();
				public bool next ();
			}
			public ComponentList (GOmx.Engine engine);
			public GOmx.Component @get (uint index);
			public GOmx.Engine.ComponentList.Iterator iterator ();
			public uint length { get; }
		}
		[CCode (cheader_filename = "omx-glib.h")]
		public class Iterator : GLib.Object {
			public Iterator (GOmx.Engine engine);
			public GOmx.Port @get ();
			public bool next ();
		}
		[CCode (cheader_filename = "omx-glib.h")]
		public class PortQueue : GLib.Object {
			[CCode (cheader_filename = "omx-glib.h")]
			public class Iterator : GLib.Object {
				public Iterator (GOmx.Engine engine);
				public GOmx.Port @get ();
				public bool next ();
			}
			public PortQueue (GOmx.Engine engine);
			public GOmx.Engine.PortQueue.Iterator iterator ();
		}
		public Engine ();
		public void add_component (GOmx.Component component);
		public void allocate_buffers () throws GLib.Error;
		public void allocate_ports () throws GLib.Error;
		public void free_handles () throws GLib.Error;
		public void free_ports () throws GLib.Error;
		public GOmx.Component get_component (uint i);
		public uint get_n_components ();
		public void init () throws GLib.Error;
		public GOmx.Engine.Iterator iterator ();
		public void set_state (Omx.State state) throws GLib.Error;
		public void set_state_and_wait (Omx.State state) throws GLib.Error;
		public void start () throws GLib.Error;
		public void wait_for_state_set ();
		public GOmx.Engine.ComponentList components { get; }
		public GOmx.Engine.PortQueue ports_with_buffer_done { get; }
	}
	[CCode (cheader_filename = "omx-glib.h")]
	public class Port : GLib.Object {
		[CCode (cheader_filename = "omx-glib.h")]
		public class BufferList : GLib.Object {
			[CCode (cheader_filename = "omx-glib.h")]
			public class Iterator : GLib.Object {
				public Iterator (GOmx.Port port);
				public Omx.BufferHeader @get ();
				public bool next ();
			}
			public BufferList (GOmx.Port port);
			public Omx.BufferHeader @get (uint index);
			public GOmx.Port.BufferList.Iterator iterator ();
			public uint length { get; }
		}
		[CCode (cheader_filename = "omx-glib.h", instance_pos = -2)]
		public delegate void BufferDoneFunc (Omx.BufferHeader buffer);
		public Omx.Param.PortDefinition definition;
		public Port (GOmx.Component parent_component, uint32 port_index);
		public void allocate_buffers () throws GLib.Error;
		public void buffer_done (Omx.BufferHeader buffer);
		public void free_buffers () throws GLib.Error;
		public unowned Omx.BufferHeader get_buffer (uint i);
		public uint get_n_buffers ();
		public void init () throws GLib.Error;
		public Omx.BufferHeader pop_buffer ();
		public void push_buffer (Omx.BufferHeader buffer) throws GLib.Error;
		public void set_buffer_done_function (GOmx.Port.BufferDoneFunc buffer_done_func);
		public void use_buffers_of (GOmx.Port port) throws GLib.Error;
		public GOmx.Port.BufferList buffers { get; }
		public GOmx.Component component { get; }
		public bool eos { get; }
		public string name { get; set; }
		public GLib.AsyncQueue<Omx.BufferHeader> queue { get; }
	}
	[CCode (cheader_filename = "omx-glib.h")]
	public class Semaphore : GLib.Object {
		public Semaphore ();
		public void down ();
		public void up ();
	}
	[CCode (cheader_filename = "omx-glib.h")]
	public static void buffer_copy (Omx.BufferHeader dest, Omx.BufferHeader source);
	[CCode (cheader_filename = "omx-glib.h")]
	public static void buffer_copy_len (Omx.BufferHeader dest, Omx.BufferHeader source);
	[CCode (cheader_filename = "omx-glib.h")]
	public static void buffer_read_from_file (Omx.BufferHeader buffer, GLib.FileStream fs);
}
