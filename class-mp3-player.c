/* class-mp3-player.c generated by valac, the Vala compiler
 * generated from class-mp3-player.vala, do not modify */


#include <glib.h>
#include <glib-object.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <OMX_Core.h>
#include <OMX_Component.h>

#define _g_error_free0(var) ((var == NULL) ? NULL : (var = (g_error_free (var), NULL)))
#define _fclose0(var) ((var == NULL) ? NULL : (var = (fclose (var), NULL)))

#define OMX_TYPE_CORE (omx_core_get_type ())
#define OMX_CORE(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), OMX_TYPE_CORE, OmxCore))
#define OMX_CORE_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), OMX_TYPE_CORE, OmxCoreClass))
#define OMX_IS_CORE(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), OMX_TYPE_CORE))
#define OMX_IS_CORE_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), OMX_TYPE_CORE))
#define OMX_CORE_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), OMX_TYPE_CORE, OmxCoreClass))

typedef struct _OmxCore OmxCore;
typedef struct _OmxCoreClass OmxCoreClass;
#define _g_object_unref0(var) ((var == NULL) ? NULL : (var = (g_object_unref (var), NULL)))

#define OMX_TYPE_COMPONENT (omx_component_get_type ())
#define OMX_COMPONENT(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), OMX_TYPE_COMPONENT, OmxComponent))
#define OMX_COMPONENT_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), OMX_TYPE_COMPONENT, OmxComponentClass))
#define OMX_IS_COMPONENT(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), OMX_TYPE_COMPONENT))
#define OMX_IS_COMPONENT_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), OMX_TYPE_COMPONENT))
#define OMX_COMPONENT_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), OMX_TYPE_COMPONENT, OmxComponentClass))

typedef struct _OmxComponent OmxComponent;
typedef struct _OmxComponentClass OmxComponentClass;
typedef struct _OmxComponentPrivate OmxComponentPrivate;

#define OMX_TYPE_ENGINE (omx_engine_get_type ())
#define OMX_ENGINE(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), OMX_TYPE_ENGINE, OmxEngine))
#define OMX_ENGINE_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), OMX_TYPE_ENGINE, OmxEngineClass))
#define OMX_IS_ENGINE(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), OMX_TYPE_ENGINE))
#define OMX_IS_ENGINE_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), OMX_TYPE_ENGINE))
#define OMX_ENGINE_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), OMX_TYPE_ENGINE, OmxEngineClass))

typedef struct _OmxEngine OmxEngine;
typedef struct _OmxEngineClass OmxEngineClass;

#define OMX_ENGINE_TYPE_COMPONENT_LIST (omx_engine_component_list_get_type ())
#define OMX_ENGINE_COMPONENT_LIST(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), OMX_ENGINE_TYPE_COMPONENT_LIST, OmxEngineComponentList))
#define OMX_ENGINE_COMPONENT_LIST_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), OMX_ENGINE_TYPE_COMPONENT_LIST, OmxEngineComponentListClass))
#define OMX_ENGINE_IS_COMPONENT_LIST(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), OMX_ENGINE_TYPE_COMPONENT_LIST))
#define OMX_ENGINE_IS_COMPONENT_LIST_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), OMX_ENGINE_TYPE_COMPONENT_LIST))
#define OMX_ENGINE_COMPONENT_LIST_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), OMX_ENGINE_TYPE_COMPONENT_LIST, OmxEngineComponentListClass))

typedef struct _OmxEngineComponentList OmxEngineComponentList;
typedef struct _OmxEngineComponentListClass OmxEngineComponentListClass;

#define OMX_ENGINE_COMPONENT_LIST_TYPE_ITERATOR (omx_engine_component_list_iterator_get_type ())
#define OMX_ENGINE_COMPONENT_LIST_ITERATOR(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), OMX_ENGINE_COMPONENT_LIST_TYPE_ITERATOR, OmxEngineComponentListIterator))
#define OMX_ENGINE_COMPONENT_LIST_ITERATOR_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), OMX_ENGINE_COMPONENT_LIST_TYPE_ITERATOR, OmxEngineComponentListIteratorClass))
#define OMX_ENGINE_COMPONENT_LIST_IS_ITERATOR(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), OMX_ENGINE_COMPONENT_LIST_TYPE_ITERATOR))
#define OMX_ENGINE_COMPONENT_LIST_IS_ITERATOR_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), OMX_ENGINE_COMPONENT_LIST_TYPE_ITERATOR))
#define OMX_ENGINE_COMPONENT_LIST_ITERATOR_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), OMX_ENGINE_COMPONENT_LIST_TYPE_ITERATOR, OmxEngineComponentListIteratorClass))

typedef struct _OmxEngineComponentListIterator OmxEngineComponentListIterator;
typedef struct _OmxEngineComponentListIteratorClass OmxEngineComponentListIteratorClass;

#define OMX_COMPONENT_TYPE_PORT_LIST (omx_component_port_list_get_type ())
#define OMX_COMPONENT_PORT_LIST(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), OMX_COMPONENT_TYPE_PORT_LIST, OmxComponentPortList))
#define OMX_COMPONENT_PORT_LIST_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), OMX_COMPONENT_TYPE_PORT_LIST, OmxComponentPortListClass))
#define OMX_COMPONENT_IS_PORT_LIST(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), OMX_COMPONENT_TYPE_PORT_LIST))
#define OMX_COMPONENT_IS_PORT_LIST_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), OMX_COMPONENT_TYPE_PORT_LIST))
#define OMX_COMPONENT_PORT_LIST_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), OMX_COMPONENT_TYPE_PORT_LIST, OmxComponentPortListClass))

typedef struct _OmxComponentPortList OmxComponentPortList;
typedef struct _OmxComponentPortListClass OmxComponentPortListClass;

#define OMX_COMPONENT_PORT_LIST_TYPE_ITERATOR (omx_component_port_list_iterator_get_type ())
#define OMX_COMPONENT_PORT_LIST_ITERATOR(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), OMX_COMPONENT_PORT_LIST_TYPE_ITERATOR, OmxComponentPortListIterator))
#define OMX_COMPONENT_PORT_LIST_ITERATOR_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), OMX_COMPONENT_PORT_LIST_TYPE_ITERATOR, OmxComponentPortListIteratorClass))
#define OMX_COMPONENT_PORT_LIST_IS_ITERATOR(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), OMX_COMPONENT_PORT_LIST_TYPE_ITERATOR))
#define OMX_COMPONENT_PORT_LIST_IS_ITERATOR_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), OMX_COMPONENT_PORT_LIST_TYPE_ITERATOR))
#define OMX_COMPONENT_PORT_LIST_ITERATOR_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), OMX_COMPONENT_PORT_LIST_TYPE_ITERATOR, OmxComponentPortListIteratorClass))

typedef struct _OmxComponentPortListIterator OmxComponentPortListIterator;
typedef struct _OmxComponentPortListIteratorClass OmxComponentPortListIteratorClass;

#define OMX_TYPE_PORT (omx_port_get_type ())
#define OMX_PORT(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), OMX_TYPE_PORT, OmxPort))
#define OMX_PORT_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), OMX_TYPE_PORT, OmxPortClass))
#define OMX_IS_PORT(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), OMX_TYPE_PORT))
#define OMX_IS_PORT_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), OMX_TYPE_PORT))
#define OMX_PORT_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), OMX_TYPE_PORT, OmxPortClass))

typedef struct _OmxPort OmxPort;
typedef struct _OmxPortClass OmxPortClass;

#define OMX_PORT_TYPE_BUFFER_LIST (omx_port_buffer_list_get_type ())
#define OMX_PORT_BUFFER_LIST(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), OMX_PORT_TYPE_BUFFER_LIST, OmxPortBufferList))
#define OMX_PORT_BUFFER_LIST_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), OMX_PORT_TYPE_BUFFER_LIST, OmxPortBufferListClass))
#define OMX_PORT_IS_BUFFER_LIST(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), OMX_PORT_TYPE_BUFFER_LIST))
#define OMX_PORT_IS_BUFFER_LIST_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), OMX_PORT_TYPE_BUFFER_LIST))
#define OMX_PORT_BUFFER_LIST_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), OMX_PORT_TYPE_BUFFER_LIST, OmxPortBufferListClass))

typedef struct _OmxPortBufferList OmxPortBufferList;
typedef struct _OmxPortBufferListClass OmxPortBufferListClass;

#define OMX_PORT_BUFFER_LIST_TYPE_ITERATOR (omx_port_buffer_list_iterator_get_type ())
#define OMX_PORT_BUFFER_LIST_ITERATOR(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), OMX_PORT_BUFFER_LIST_TYPE_ITERATOR, OmxPortBufferListIterator))
#define OMX_PORT_BUFFER_LIST_ITERATOR_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), OMX_PORT_BUFFER_LIST_TYPE_ITERATOR, OmxPortBufferListIteratorClass))
#define OMX_PORT_BUFFER_LIST_IS_ITERATOR(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), OMX_PORT_BUFFER_LIST_TYPE_ITERATOR))
#define OMX_PORT_BUFFER_LIST_IS_ITERATOR_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), OMX_PORT_BUFFER_LIST_TYPE_ITERATOR))
#define OMX_PORT_BUFFER_LIST_ITERATOR_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), OMX_PORT_BUFFER_LIST_TYPE_ITERATOR, OmxPortBufferListIteratorClass))

typedef struct _OmxPortBufferListIterator OmxPortBufferListIterator;
typedef struct _OmxPortBufferListIteratorClass OmxPortBufferListIteratorClass;

#define OMX_ENGINE_TYPE_PORT_QUEUE (omx_engine_port_queue_get_type ())
#define OMX_ENGINE_PORT_QUEUE(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), OMX_ENGINE_TYPE_PORT_QUEUE, OmxEnginePortQueue))
#define OMX_ENGINE_PORT_QUEUE_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), OMX_ENGINE_TYPE_PORT_QUEUE, OmxEnginePortQueueClass))
#define OMX_ENGINE_IS_PORT_QUEUE(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), OMX_ENGINE_TYPE_PORT_QUEUE))
#define OMX_ENGINE_IS_PORT_QUEUE_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), OMX_ENGINE_TYPE_PORT_QUEUE))
#define OMX_ENGINE_PORT_QUEUE_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), OMX_ENGINE_TYPE_PORT_QUEUE, OmxEnginePortQueueClass))

typedef struct _OmxEnginePortQueue OmxEnginePortQueue;
typedef struct _OmxEnginePortQueueClass OmxEnginePortQueueClass;

#define OMX_ENGINE_PORT_QUEUE_TYPE_ITERATOR (omx_engine_port_queue_iterator_get_type ())
#define OMX_ENGINE_PORT_QUEUE_ITERATOR(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), OMX_ENGINE_PORT_QUEUE_TYPE_ITERATOR, OmxEnginePortQueueIterator))
#define OMX_ENGINE_PORT_QUEUE_ITERATOR_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), OMX_ENGINE_PORT_QUEUE_TYPE_ITERATOR, OmxEnginePortQueueIteratorClass))
#define OMX_ENGINE_PORT_QUEUE_IS_ITERATOR(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), OMX_ENGINE_PORT_QUEUE_TYPE_ITERATOR))
#define OMX_ENGINE_PORT_QUEUE_IS_ITERATOR_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), OMX_ENGINE_PORT_QUEUE_TYPE_ITERATOR))
#define OMX_ENGINE_PORT_QUEUE_ITERATOR_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), OMX_ENGINE_PORT_QUEUE_TYPE_ITERATOR, OmxEnginePortQueueIteratorClass))

typedef struct _OmxEnginePortQueueIterator OmxEnginePortQueueIterator;
typedef struct _OmxEnginePortQueueIteratorClass OmxEnginePortQueueIteratorClass;
typedef struct _OmxPortPrivate OmxPortPrivate;

struct _OmxComponent {
	GObject parent_instance;
	OmxComponentPrivate * priv;
	OMX_PORT_PARAM_TYPE port_param;
	gint id;
};

struct _OmxComponentClass {
	GObjectClass parent_class;
};

struct _OmxPort {
	GObject parent_instance;
	OmxPortPrivate * priv;
	OMX_PARAM_PORTDEFINITIONTYPE definition;
};

struct _OmxPortClass {
	GObjectClass parent_class;
};



void play (const char* filename, GError** error);
gint _main (char** args, int args_length1);
#define AUDIODEC_ID 0
#define AUDIOSINK_ID 1
#define AUDIODEC_COMPONENT "OMX.st.audio_decoder.mp3.mad"
#define AUDIOSINK_COMPONENT "OMX.st.alsa.alsasink"
GType omx_core_get_type (void);
OmxCore* omx_core_open (const char* soname);
void omx_core_init (OmxCore* self, GError** error);
OmxComponent* omx_component_new (OmxCore* core, const char* component_name, OMX_INDEXTYPE param_init_index);
OmxComponent* omx_component_construct (GType object_type, OmxCore* core, const char* component_name, OMX_INDEXTYPE param_init_index);
GType omx_component_get_type (void);
void omx_component_set_name (OmxComponent* self, const char* value);
OmxEngine* omx_engine_new (void);
OmxEngine* omx_engine_construct (GType object_type);
GType omx_engine_get_type (void);
void omx_engine_add_component (OmxEngine* self, OmxComponent* component);
void omx_engine_init (OmxEngine* self, GError** error);
void omx_engine_set_state_and_wait (OmxEngine* self, OMX_STATETYPE state, GError** error);
gpointer omx_engine_component_list_ref (gpointer instance);
void omx_engine_component_list_unref (gpointer instance);
GParamSpec* omx_engine_param_spec_component_list (const gchar* name, const gchar* nick, const gchar* blurb, GType object_type, GParamFlags flags);
void omx_engine_value_set_component_list (GValue* value, gpointer v_object);
gpointer omx_engine_value_get_component_list (const GValue* value);
GType omx_engine_component_list_get_type (void);
OmxEngineComponentList* omx_engine_get_components (OmxEngine* self);
GType omx_engine_component_list_iterator_get_type (void);
OmxEngineComponentListIterator* omx_engine_component_list_iterator (OmxEngineComponentList* self);
gboolean omx_engine_component_list_iterator_next (OmxEngineComponentListIterator* self);
OmxComponent* omx_engine_component_list_iterator_get (OmxEngineComponentListIterator* self);
const char* omx_component_get_name (OmxComponent* self);
gpointer omx_component_port_list_ref (gpointer instance);
void omx_component_port_list_unref (gpointer instance);
GParamSpec* omx_component_param_spec_port_list (const gchar* name, const gchar* nick, const gchar* blurb, GType object_type, GParamFlags flags);
void omx_component_value_set_port_list (GValue* value, gpointer v_object);
gpointer omx_component_value_get_port_list (const GValue* value);
GType omx_component_port_list_get_type (void);
OmxComponentPortList* omx_component_get_ports (OmxComponent* self);
GType omx_component_port_list_iterator_get_type (void);
OmxComponentPortListIterator* omx_component_port_list_iterator (OmxComponentPortList* self);
gboolean omx_component_port_list_iterator_next (OmxComponentPortListIterator* self);
GType omx_port_get_type (void);
OmxPort* omx_component_port_list_iterator_get (OmxComponentPortListIterator* self);
const char* omx_port_get_name (OmxPort* self);
gpointer omx_port_buffer_list_ref (gpointer instance);
void omx_port_buffer_list_unref (gpointer instance);
GParamSpec* omx_port_param_spec_buffer_list (const gchar* name, const gchar* nick, const gchar* blurb, GType object_type, GParamFlags flags);
void omx_port_value_set_buffer_list (GValue* value, gpointer v_object);
gpointer omx_port_value_get_buffer_list (const GValue* value);
GType omx_port_buffer_list_get_type (void);
OmxPortBufferList* omx_port_get_buffers (OmxPort* self);
GType omx_port_buffer_list_iterator_get_type (void);
OmxPortBufferListIterator* omx_port_buffer_list_iterator (OmxPortBufferList* self);
gboolean omx_port_buffer_list_iterator_next (OmxPortBufferListIterator* self);
OMX_BUFFERHEADERTYPE* omx_port_buffer_list_iterator_get (OmxPortBufferListIterator* self);
void omx_engine_start (OmxEngine* self, GError** error);
gpointer omx_engine_port_queue_ref (gpointer instance);
void omx_engine_port_queue_unref (gpointer instance);
GParamSpec* omx_engine_param_spec_port_queue (const gchar* name, const gchar* nick, const gchar* blurb, GType object_type, GParamFlags flags);
void omx_engine_value_set_port_queue (GValue* value, gpointer v_object);
gpointer omx_engine_value_get_port_queue (const GValue* value);
GType omx_engine_port_queue_get_type (void);
OmxEnginePortQueue* omx_engine_get_ports (OmxEngine* self);
GType omx_engine_port_queue_iterator_get_type (void);
OmxEnginePortQueueIterator* omx_engine_port_queue_iterator (OmxEnginePortQueue* self);
gboolean omx_engine_port_queue_iterator_next (OmxEnginePortQueueIterator* self);
OmxPort* omx_engine_port_queue_iterator_get (OmxEnginePortQueueIterator* self);
OmxComponent* omx_port_get_component (OmxPort* self);
OMX_BUFFERHEADERTYPE* omx_port_pop_buffer (OmxPort* self);
void omx_buffer_read_from_file (OMX_BUFFERHEADERTYPE* buffer, FILE* fs);
void omx_port_push_buffer (OmxPort* self, OMX_BUFFERHEADERTYPE* buffer, GError** error);
OmxPort* omx_component_get_port (OmxComponent* self, guint i);
void omx_buffer_copy (OMX_BUFFERHEADERTYPE* dest, OMX_BUFFERHEADERTYPE* source);
void omx_engine_free_handles (OmxEngine* self, GError** error);
void omx_core_deinit (OmxCore* self, GError** error);



gint _main (char** args, int args_length1) {
	gint result;
	GError * _inner_error_;
	_inner_error_ = NULL;
	if (args_length1 != 2) {
		g_print ("%s <file.mp3>\n", args[0]);
		result = 1;
		return result;
	}
	{
		play (args[1], &_inner_error_);
		if (_inner_error_ != NULL) {
			goto __catch0_g_error;
		}
		result = 0;
		return result;
	}
	goto __finally0;
	__catch0_g_error:
	{
		GError * e;
		e = _inner_error_;
		_inner_error_ = NULL;
		{
			g_print ("%s\n", e->message);
			result = 1;
			_g_error_free0 (e);
			return result;
		}
	}
	__finally0:
	if (_inner_error_ != NULL) {
		g_critical ("file %s: line %d: uncaught error: %s (%s, %d)", __FILE__, __LINE__, _inner_error_->message, g_quark_to_string (_inner_error_->domain), _inner_error_->code);
		g_clear_error (&_inner_error_);
		return 0;
	}
}


int main (int argc, char ** argv) {
	g_thread_init (NULL);
	g_type_init ();
	return _main (argv, argc);
}


void play (const char* filename, GError** error) {
	GError * _inner_error_;
	FILE* fd;
	OmxCore* core;
	OmxComponent* audiodec;
	OmxComponent* audiosink;
	OmxEngine* engine;
	g_return_if_fail (filename != NULL);
	_inner_error_ = NULL;
	fd = fopen (filename, "rb");
	if (fd == NULL) {
		_inner_error_ = g_error_new (G_FILE_ERROR, G_FILE_ERROR_FAILED, "Error opening %s", filename);
		{
			g_propagate_error (error, _inner_error_);
			_fclose0 (fd);
			return;
		}
	}
	core = omx_core_open ("libomxil-bellagio.so.0");
	omx_core_init (core, &_inner_error_);
	if (_inner_error_ != NULL) {
		g_propagate_error (error, _inner_error_);
		_fclose0 (fd);
		_g_object_unref0 (core);
		return;
	}
	audiodec = omx_component_new (core, AUDIODEC_COMPONENT, OMX_IndexParamAudioInit);
	omx_component_set_name (audiodec, "audiodec");
	audiodec->id = AUDIODEC_ID;
	audiosink = omx_component_new (core, AUDIOSINK_COMPONENT, OMX_IndexParamAudioInit);
	omx_component_set_name (audiosink, "audiosink");
	audiosink->id = AUDIOSINK_ID;
	engine = omx_engine_new ();
	omx_engine_add_component (engine, audiodec);
	omx_engine_add_component (engine, audiosink);
	omx_engine_init (engine, &_inner_error_);
	if (_inner_error_ != NULL) {
		g_propagate_error (error, _inner_error_);
		_fclose0 (fd);
		_g_object_unref0 (core);
		_g_object_unref0 (audiodec);
		_g_object_unref0 (audiosink);
		_g_object_unref0 (engine);
		return;
	}
	omx_engine_set_state_and_wait (engine, OMX_StateIdle, &_inner_error_);
	if (_inner_error_ != NULL) {
		g_propagate_error (error, _inner_error_);
		_fclose0 (fd);
		_g_object_unref0 (core);
		_g_object_unref0 (audiodec);
		_g_object_unref0 (audiosink);
		_g_object_unref0 (engine);
		return;
	}
	omx_engine_set_state_and_wait (engine, OMX_StateExecuting, &_inner_error_);
	if (_inner_error_ != NULL) {
		g_propagate_error (error, _inner_error_);
		_fclose0 (fd);
		_g_object_unref0 (core);
		_g_object_unref0 (audiodec);
		_g_object_unref0 (audiosink);
		_g_object_unref0 (engine);
		return;
	}
	{
		OmxEngineComponentListIterator* _component_it;
		_component_it = omx_engine_component_list_iterator (omx_engine_get_components (engine));
		while (TRUE) {
			OmxComponent* component;
			if (!omx_engine_component_list_iterator_next (_component_it)) {
				break;
			}
			component = omx_engine_component_list_iterator_get (_component_it);
			g_print ("Component %s\n", omx_component_get_name (component));
			{
				OmxComponentPortListIterator* _port_it;
				_port_it = omx_component_port_list_iterator (omx_component_get_ports (component));
				while (TRUE) {
					OmxPort* port;
					if (!omx_component_port_list_iterator_next (_port_it)) {
						break;
					}
					port = omx_component_port_list_iterator_get (_port_it);
					g_print ("\tPort %s\n", omx_port_get_name (port));
					{
						OmxPortBufferListIterator* _buffer_it;
						_buffer_it = omx_port_buffer_list_iterator (omx_port_get_buffers (port));
						while (TRUE) {
							OMX_BUFFERHEADERTYPE* buffer;
							if (!omx_port_buffer_list_iterator_next (_buffer_it)) {
								break;
							}
							buffer = omx_port_buffer_list_iterator_get (_buffer_it);
							g_print ("\t\tBuffer %p\n", buffer);
						}
						_g_object_unref0 (_buffer_it);
					}
					_g_object_unref0 (port);
				}
				_g_object_unref0 (_port_it);
			}
			_g_object_unref0 (component);
		}
		_g_object_unref0 (_component_it);
	}
	omx_engine_start (engine, &_inner_error_);
	if (_inner_error_ != NULL) {
		g_propagate_error (error, _inner_error_);
		_fclose0 (fd);
		_g_object_unref0 (core);
		_g_object_unref0 (audiodec);
		_g_object_unref0 (audiosink);
		_g_object_unref0 (engine);
		return;
	}
	{
		OmxEnginePortQueueIterator* _port_it;
		_port_it = omx_engine_port_queue_iterator (omx_engine_get_ports (engine));
		while (TRUE) {
			OmxPort* port;
			if (!omx_engine_port_queue_iterator_next (_port_it)) {
				break;
			}
			port = omx_engine_port_queue_iterator_get (_port_it);
			switch (omx_port_get_component (port)->id) {
				case AUDIODEC_ID:
				{
					switch (port->definition.eDir) {
						case OMX_DirInput:
						{
							{
								OMX_BUFFERHEADERTYPE* buffer;
								buffer = omx_port_pop_buffer (port);
								omx_buffer_read_from_file (buffer, fd);
								omx_port_push_buffer (port, buffer, &_inner_error_);
								if (_inner_error_ != NULL) {
									g_propagate_error (error, _inner_error_);
									_g_object_unref0 (port);
									_g_object_unref0 (_port_it);
									_fclose0 (fd);
									_g_object_unref0 (core);
									_g_object_unref0 (audiodec);
									_g_object_unref0 (audiosink);
									_g_object_unref0 (engine);
									return;
								}
								break;
							}
						}
						case OMX_DirOutput:
						{
							{
								OMX_BUFFERHEADERTYPE* buffer;
								OmxPort* audiosink_inport;
								OMX_BUFFERHEADERTYPE* alsa_buffer;
								buffer = omx_port_pop_buffer (port);
								audiosink_inport = omx_component_get_port (audiosink, (guint) 0);
								alsa_buffer = omx_port_pop_buffer (audiosink_inport);
								omx_buffer_copy (alsa_buffer, buffer);
								omx_port_push_buffer (audiosink_inport, alsa_buffer, &_inner_error_);
								if (_inner_error_ != NULL) {
									g_propagate_error (error, _inner_error_);
									_g_object_unref0 (audiosink_inport);
									_g_object_unref0 (port);
									_g_object_unref0 (_port_it);
									_fclose0 (fd);
									_g_object_unref0 (core);
									_g_object_unref0 (audiodec);
									_g_object_unref0 (audiosink);
									_g_object_unref0 (engine);
									return;
								}
								omx_port_push_buffer (port, buffer, &_inner_error_);
								if (_inner_error_ != NULL) {
									g_propagate_error (error, _inner_error_);
									_g_object_unref0 (audiosink_inport);
									_g_object_unref0 (port);
									_g_object_unref0 (_port_it);
									_fclose0 (fd);
									_g_object_unref0 (core);
									_g_object_unref0 (audiodec);
									_g_object_unref0 (audiosink);
									_g_object_unref0 (engine);
									return;
								}
								_g_object_unref0 (audiosink_inport);
								break;
							}
						}
						default:
						{
							break;
						}
					}
					break;
				}
				case AUDIOSINK_ID:
				{
					switch (port->definition.eDir) {
						case OMX_DirInput:
						{
							break;
						}
						default:
						{
							break;
						}
					}
					break;
				}
			}
			_g_object_unref0 (port);
		}
		_g_object_unref0 (_port_it);
	}
	omx_engine_set_state_and_wait (engine, OMX_StateIdle, &_inner_error_);
	if (_inner_error_ != NULL) {
		g_propagate_error (error, _inner_error_);
		_fclose0 (fd);
		_g_object_unref0 (core);
		_g_object_unref0 (audiodec);
		_g_object_unref0 (audiosink);
		_g_object_unref0 (engine);
		return;
	}
	omx_engine_set_state_and_wait (engine, OMX_StateLoaded, &_inner_error_);
	if (_inner_error_ != NULL) {
		g_propagate_error (error, _inner_error_);
		_fclose0 (fd);
		_g_object_unref0 (core);
		_g_object_unref0 (audiodec);
		_g_object_unref0 (audiosink);
		_g_object_unref0 (engine);
		return;
	}
	omx_engine_free_handles (engine, &_inner_error_);
	if (_inner_error_ != NULL) {
		g_propagate_error (error, _inner_error_);
		_fclose0 (fd);
		_g_object_unref0 (core);
		_g_object_unref0 (audiodec);
		_g_object_unref0 (audiosink);
		_g_object_unref0 (engine);
		return;
	}
	omx_core_deinit (core, &_inner_error_);
	if (_inner_error_ != NULL) {
		g_propagate_error (error, _inner_error_);
		_fclose0 (fd);
		_g_object_unref0 (core);
		_g_object_unref0 (audiodec);
		_g_object_unref0 (audiosink);
		_g_object_unref0 (engine);
		return;
	}
	_fclose0 (fd);
	_g_object_unref0 (core);
	_g_object_unref0 (audiodec);
	_g_object_unref0 (audiosink);
	_g_object_unref0 (engine);
}




