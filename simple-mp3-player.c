/* simple-mp3-player.c generated by valac, the Vala compiler
 * generated from simple-mp3-player.vala, do not modify */


#include <glib.h>
#include <glib-object.h>
#include <stdlib.h>
#include <string.h>
#include <bellagio/tsemaphore.h>
#include <stdio.h>
#include <OMX_Component.h>
#include <OMX_Core.h>
#include <omx-util.h>


#define TYPE_SIMPLE_MP3_PLAYER (simple_mp3_player_get_type ())
#define SIMPLE_MP3_PLAYER(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), TYPE_SIMPLE_MP3_PLAYER, SimpleMp3Player))
#define SIMPLE_MP3_PLAYER_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), TYPE_SIMPLE_MP3_PLAYER, SimpleMp3PlayerClass))
#define IS_SIMPLE_MP3_PLAYER(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), TYPE_SIMPLE_MP3_PLAYER))
#define IS_SIMPLE_MP3_PLAYER_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), TYPE_SIMPLE_MP3_PLAYER))
#define SIMPLE_MP3_PLAYER_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), TYPE_SIMPLE_MP3_PLAYER, SimpleMp3PlayerClass))

typedef struct _SimpleMp3Player SimpleMp3Player;
typedef struct _SimpleMp3PlayerClass SimpleMp3PlayerClass;
#define _g_object_unref0(var) ((var == NULL) ? NULL : (var = (g_object_unref (var), NULL)))
#define _g_error_free0(var) ((var == NULL) ? NULL : (var = (g_error_free (var), NULL)))
typedef struct _SimpleMp3PlayerPrivate SimpleMp3PlayerPrivate;
#define _fclose0(var) ((var == NULL) ? NULL : (var = (fclose (var), NULL)))

struct _SimpleMp3Player {
	GObject parent_instance;
	SimpleMp3PlayerPrivate * priv;
};

struct _SimpleMp3PlayerClass {
	GObjectClass parent_class;
};

struct _SimpleMp3PlayerPrivate {
	tsem_t audiodec_sem;
	tsem_t audiosink_sem;
	tsem_t eos_sem;
	FILE* fd;
	OMX_HANDLETYPE audiodec_handle;
	OMX_HANDLETYPE audiosink_handle;
	OMX_BUFFERHEADERTYPE** in_buffer_audiosink;
	gint in_buffer_audiosink_length1;
	gint in_buffer_audiosink_size;
	OMX_BUFFERHEADERTYPE** in_buffer_audiodec;
	gint in_buffer_audiodec_length1;
	gint in_buffer_audiodec_size;
	OMX_BUFFERHEADERTYPE** out_buffer_audiodec;
	gint out_buffer_audiodec_length1;
	gint out_buffer_audiodec_size;
	gint eos_found;
};


static gpointer simple_mp3_player_parent_class = NULL;

SimpleMp3Player* simple_mp3_player_new (void);
SimpleMp3Player* simple_mp3_player_construct (GType object_type);
GType simple_mp3_player_get_type (void);
void simple_mp3_player_play (SimpleMp3Player* self, const char* filename, GError** error);
gint _main (char** args, int args_length1);
#define SIMPLE_MP3_PLAYER_GET_PRIVATE(o) (G_TYPE_INSTANCE_GET_PRIVATE ((o), TYPE_SIMPLE_MP3_PLAYER, SimpleMp3PlayerPrivate))
enum  {
	SIMPLE_MP3_PLAYER_DUMMY_PROPERTY
};
#define SIMPLE_MP3_PLAYER_N_BUFFERS 2
#define SIMPLE_MP3_PLAYER_BUFFER_OUT_SIZE 32768
#define SIMPLE_MP3_PLAYER_BUFFER_IN_SIZE 4096
static OMX_ERRORTYPE simple_mp3_player_audiodec_event_handler (SimpleMp3Player* self, OMX_HANDLETYPE component, OMX_EVENTTYPE event, guint32 data1, guint32 data2, void* event_data);
static OMX_ERRORTYPE _simple_mp3_player_audiodec_event_handler_omx_event_handler_func (OMX_HANDLETYPE component, gpointer self, OMX_EVENTTYPE event, guint32 data1, guint32 data2, void* event_data);
static OMX_ERRORTYPE simple_mp3_player_audiodec_empty_buffer_done (SimpleMp3Player* self, OMX_HANDLETYPE component, OMX_BUFFERHEADERTYPE* buffer);
static OMX_ERRORTYPE _simple_mp3_player_audiodec_empty_buffer_done_omx_empty_buffer_done_func (OMX_HANDLETYPE component, gpointer self, OMX_BUFFERHEADERTYPE* buffer);
static OMX_ERRORTYPE simple_mp3_player_audiodec_fill_buffer_done (SimpleMp3Player* self, OMX_HANDLETYPE component, OMX_BUFFERHEADERTYPE* buffer);
static OMX_ERRORTYPE _simple_mp3_player_audiodec_fill_buffer_done_omx_fill_buffer_done_func (OMX_HANDLETYPE component, gpointer self, OMX_BUFFERHEADERTYPE* buffer);
static OMX_ERRORTYPE simple_mp3_player_audiosink_event_handler (SimpleMp3Player* self, OMX_HANDLETYPE component, OMX_EVENTTYPE event, guint32 data1, guint32 data2, void* event_data);
static OMX_ERRORTYPE _simple_mp3_player_audiosink_event_handler_omx_event_handler_func (OMX_HANDLETYPE component, gpointer self, OMX_EVENTTYPE event, guint32 data1, guint32 data2, void* event_data);
static OMX_ERRORTYPE simple_mp3_player_audiosink_empty_buffer_done (SimpleMp3Player* self, OMX_HANDLETYPE component, OMX_BUFFERHEADERTYPE* buffer);
static OMX_ERRORTYPE _simple_mp3_player_audiosink_empty_buffer_done_omx_empty_buffer_done_func (OMX_HANDLETYPE component, gpointer self, OMX_BUFFERHEADERTYPE* buffer);
#define SIMPLE_MP3_PLAYER_AUDIODEC_COMPONENT_NAME "OMX.st.audio_decoder.mp3.mad"
#define SIMPLE_MP3_PLAYER_AUDIOSINK_COMPONENT_NAME "OMX.st.alsa.alsasink"
static void simple_mp3_player_get_handles (SimpleMp3Player* self, GError** error);
static void simple_mp3_player_handle_print_info (SimpleMp3Player* self, const char* name, OMX_HANDLETYPE handle, GError** error);
static void simple_mp3_player_pass_to_idle_and_allocate_buffers (SimpleMp3Player* self, GError** error);
static void simple_mp3_player_pass_to_executing (SimpleMp3Player* self, GError** error);
static void simple_mp3_player_move_buffers (SimpleMp3Player* self, GError** error);
static void simple_mp3_player_pass_to_idle (SimpleMp3Player* self, GError** error);
static void simple_mp3_player_pass_to_loaded_and_free_buffers (SimpleMp3Player* self, GError** error);
static void simple_mp3_player_free_handles (SimpleMp3Player* self, GError** error);
static GObject * simple_mp3_player_constructor (GType type, guint n_construct_properties, GObjectConstructParam * construct_properties);
static void simple_mp3_player_finalize (GObject* obj);

static const OMX_CALLBACKTYPE SIMPLE_MP3_PLAYER_audiodec_callbacks = {_simple_mp3_player_audiodec_event_handler_omx_event_handler_func, _simple_mp3_player_audiodec_empty_buffer_done_omx_empty_buffer_done_func, _simple_mp3_player_audiodec_fill_buffer_done_omx_fill_buffer_done_func};
static const OMX_CALLBACKTYPE SIMPLE_MP3_PLAYER_audiosink_callbacks = {_simple_mp3_player_audiosink_event_handler_omx_event_handler_func, _simple_mp3_player_audiosink_empty_buffer_done_omx_empty_buffer_done_func, NULL};


gint _main (char** args, int args_length1) {
	gint result;
	GError * _inner_error_;
	SimpleMp3Player* player;
	_inner_error_ = NULL;
	if (args_length1 != 2) {
		g_print ("%s <file.mp3>\n", args[0]);
		result = 1;
		return result;
	}
	player = simple_mp3_player_new ();
	{
		simple_mp3_player_play (player, args[1], &_inner_error_);
		if (_inner_error_ != NULL) {
			goto __catch0_g_error;
		}
		result = 0;
		_g_object_unref0 (player);
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
			_g_object_unref0 (player);
			return result;
		}
	}
	__finally0:
	if (_inner_error_ != NULL) {
		_g_object_unref0 (player);
		g_critical ("file %s: line %d: uncaught error: %s (%s, %d)", __FILE__, __LINE__, _inner_error_->message, g_quark_to_string (_inner_error_->domain), _inner_error_->code);
		g_clear_error (&_inner_error_);
		return 0;
	}
	_g_object_unref0 (player);
}


int main (int argc, char ** argv) {
	g_type_init ();
	return _main (argv, argc);
}


static OMX_ERRORTYPE _simple_mp3_player_audiodec_event_handler_omx_event_handler_func (OMX_HANDLETYPE component, gpointer self, OMX_EVENTTYPE event, guint32 data1, guint32 data2, void* event_data) {
	return simple_mp3_player_audiodec_event_handler (self, component, event, data1, data2, event_data);
}


static OMX_ERRORTYPE _simple_mp3_player_audiodec_empty_buffer_done_omx_empty_buffer_done_func (OMX_HANDLETYPE component, gpointer self, OMX_BUFFERHEADERTYPE* buffer) {
	return simple_mp3_player_audiodec_empty_buffer_done (self, component, buffer);
}


static OMX_ERRORTYPE _simple_mp3_player_audiodec_fill_buffer_done_omx_fill_buffer_done_func (OMX_HANDLETYPE component, gpointer self, OMX_BUFFERHEADERTYPE* buffer) {
	return simple_mp3_player_audiodec_fill_buffer_done (self, component, buffer);
}


static OMX_ERRORTYPE _simple_mp3_player_audiosink_event_handler_omx_event_handler_func (OMX_HANDLETYPE component, gpointer self, OMX_EVENTTYPE event, guint32 data1, guint32 data2, void* event_data) {
	return simple_mp3_player_audiosink_event_handler (self, component, event, data1, data2, event_data);
}


static OMX_ERRORTYPE _simple_mp3_player_audiosink_empty_buffer_done_omx_empty_buffer_done_func (OMX_HANDLETYPE component, gpointer self, OMX_BUFFERHEADERTYPE* buffer) {
	return simple_mp3_player_audiosink_empty_buffer_done (self, component, buffer);
}


static GQuark omx_error_domain (void) {
	GQuark result;
	result = g_quark_from_string ("Omx.Error");
	return result;
}


static const char* omx_error_to_string (OMX_ERRORTYPE self) {
	const char* result;
	switch (self) {
		case OMX_ErrorNone:
		{
			result = "Omx.Error.None";
			return result;
		}
		case OMX_ErrorInsufficientResources:
		{
			result = "Omx.Error.InsufficientResources";
			return result;
		}
		case OMX_ErrorUndefined:
		{
			result = "Omx.Error.Undefined";
			return result;
		}
		case OMX_ErrorInvalidComponentName:
		{
			result = "Omx.Error.InvalidComponentName";
			return result;
		}
		case OMX_ErrorComponentNotFound:
		{
			result = "Omx.Error.ComponentNotFound";
			return result;
		}
		case OMX_ErrorInvalidComponent:
		{
			result = "Omx.Error.InvalidComponent";
			return result;
		}
		case OMX_ErrorBadParameter:
		{
			result = "Omx.Error.BadParameter";
			return result;
		}
		case OMX_ErrorNotImplemented:
		{
			result = "Omx.Error.NotImplemented";
			return result;
		}
		case OMX_ErrorUnderflow:
		{
			result = "Omx.Error.Underflow";
			return result;
		}
		case OMX_ErrorOverflow:
		{
			result = "Omx.Error.Overflow";
			return result;
		}
		case OMX_ErrorHardware:
		{
			result = "Omx.Error.Hardware";
			return result;
		}
		case OMX_ErrorInvalidState:
		{
			result = "Omx.Error.InvalidState";
			return result;
		}
		case OMX_ErrorStreamCorrupt:
		{
			result = "Omx.Error.StreamCorrupt";
			return result;
		}
		case OMX_ErrorPortsNotCompatible:
		{
			result = "Omx.Error.PortsNotCompatible";
			return result;
		}
		case OMX_ErrorResourcesLost:
		{
			result = "Omx.Error.ResourcesLost";
			return result;
		}
		case OMX_ErrorNoMore:
		{
			result = "Omx.Error.NoMore";
			return result;
		}
		case OMX_ErrorVersionMismatch:
		{
			result = "Omx.Error.VersionMismatch";
			return result;
		}
		case OMX_ErrorNotReady:
		{
			result = "Omx.Error.NotReady";
			return result;
		}
		case OMX_ErrorTimeout:
		{
			result = "Omx.Error.Timeout";
			return result;
		}
		case OMX_ErrorSameState:
		{
			result = "Omx.Error.SameState";
			return result;
		}
		case OMX_ErrorResourcesPreempted:
		{
			result = "Omx.Error.ResourcesPreempted";
			return result;
		}
		case OMX_ErrorPortUnresponsiveDuringAllocation:
		{
			result = "Omx.Error.PortUnresponsiveDuringAllocation";
			return result;
		}
		case OMX_ErrorPortUnresponsiveDuringDeallocation:
		{
			result = "Omx.Error.PortUnresponsiveDuringDeallocation";
			return result;
		}
		case OMX_ErrorPortUnresponsiveDuringStop:
		{
			result = "Omx.Error.PortUnresponsiveDuringStop";
			return result;
		}
		case OMX_ErrorIncorrectStateTransition:
		{
			result = "Omx.Error.IncorrectStateTransition";
			return result;
		}
		case OMX_ErrorIncorrectStateOperation:
		{
			result = "Omx.Error.IncorrectStateOperation";
			return result;
		}
		case OMX_ErrorUnsupportedSetting:
		{
			result = "Omx.Error.UnsupportedSetting";
			return result;
		}
		case OMX_ErrorUnsupportedIndex:
		{
			result = "Omx.Error.UnsupportedIndex";
			return result;
		}
		case OMX_ErrorBadPortIndex:
		{
			result = "Omx.Error.BadPortIndex";
			return result;
		}
		case OMX_ErrorPortUnpopulated:
		{
			result = "Omx.Error.PortUnpopulated";
			return result;
		}
		case OMX_ErrorComponentSuspended:
		{
			result = "Omx.Error.ComponentSuspended";
			return result;
		}
		case OMX_ErrorDynamicResourcesUnavailable:
		{
			result = "Omx.Error.DynamicResourcesUnavailable";
			return result;
		}
		case OMX_ErrorMbErrorsInFrame:
		{
			result = "Omx.Error.MbErrorsInFrame";
			return result;
		}
		case OMX_ErrorFormatNotDetected:
		{
			result = "Omx.Error.FormatNotDetected";
			return result;
		}
		case OMX_ErrorContentPipeOpenFailed:
		{
			result = "Omx.Error.ContentPipeOpenFailed";
			return result;
		}
		case OMX_ErrorContentPipeCreationFailed:
		{
			result = "Omx.Error.ContentPipeCreationFailed";
			return result;
		}
		case OMX_ErrorSeperateTablesUsed:
		{
			result = "Omx.Error.SeperateTablesUsed";
			return result;
		}
		case OMX_ErrorTunnelingUnsupported:
		{
			result = "Omx.Error.TunnelingUnsupported";
			return result;
		}
		default:
		{
			result = "(unknown)";
			return result;
		}
	}
}


static gpointer _g_error_copy0 (gpointer self) {
	return self ? g_error_copy (self) : NULL;
}


static void omx_try_run (OMX_ERRORTYPE err, const char* file, const char* function, gint line, GError** error) {
	GError * _inner_error_;
	g_return_if_fail (file != NULL);
	g_return_if_fail (function != NULL);
	_inner_error_ = NULL;
	if (err != OMX_ErrorNone) {
		GError* e;
		e = g_error_new (omx_error_domain (), (gint) err, "%s (0x%x) in function %s at %s:%d", omx_error_to_string (err), err, function, file, line, NULL);
		_inner_error_ = _g_error_copy0 ((GError*) e);
		{
			g_propagate_error (error, _inner_error_);
			_g_error_free0 (e);
			return;
		}
		_g_error_free0 (e);
	}
}


void simple_mp3_player_play (SimpleMp3Player* self, const char* filename, GError** error) {
	GError * _inner_error_;
	FILE* _tmp0_;
	g_return_if_fail (self != NULL);
	g_return_if_fail (filename != NULL);
	_inner_error_ = NULL;
	self->priv->fd = (_tmp0_ = fopen (filename, "rb"), _fclose0 (self->priv->fd), _tmp0_);
	if (self->priv->fd == NULL) {
		_inner_error_ = g_error_new (G_FILE_ERROR, G_FILE_ERROR_FAILED, "Error opening %s", filename);
		{
			g_propagate_error (error, _inner_error_);
			return;
		}
	}
	omx_try_run (OMX_Init (), __FILE__, __FUNCTION__, __LINE__, &_inner_error_);
	if (_inner_error_ != NULL) {
		g_propagate_error (error, _inner_error_);
		return;
	}
	simple_mp3_player_get_handles (self, &_inner_error_);
	if (_inner_error_ != NULL) {
		g_propagate_error (error, _inner_error_);
		return;
	}
	simple_mp3_player_handle_print_info (self, "audiodec", self->priv->audiodec_handle, &_inner_error_);
	if (_inner_error_ != NULL) {
		g_propagate_error (error, _inner_error_);
		return;
	}
	simple_mp3_player_handle_print_info (self, "audiosink", self->priv->audiosink_handle, &_inner_error_);
	if (_inner_error_ != NULL) {
		g_propagate_error (error, _inner_error_);
		return;
	}
	simple_mp3_player_pass_to_idle_and_allocate_buffers (self, &_inner_error_);
	if (_inner_error_ != NULL) {
		g_propagate_error (error, _inner_error_);
		return;
	}
	simple_mp3_player_pass_to_executing (self, &_inner_error_);
	if (_inner_error_ != NULL) {
		g_propagate_error (error, _inner_error_);
		return;
	}
	simple_mp3_player_move_buffers (self, &_inner_error_);
	if (_inner_error_ != NULL) {
		g_propagate_error (error, _inner_error_);
		return;
	}
	simple_mp3_player_pass_to_idle (self, &_inner_error_);
	if (_inner_error_ != NULL) {
		g_propagate_error (error, _inner_error_);
		return;
	}
	simple_mp3_player_pass_to_loaded_and_free_buffers (self, &_inner_error_);
	if (_inner_error_ != NULL) {
		g_propagate_error (error, _inner_error_);
		return;
	}
	simple_mp3_player_free_handles (self, &_inner_error_);
	if (_inner_error_ != NULL) {
		g_propagate_error (error, _inner_error_);
		return;
	}
	omx_try_run (OMX_Deinit (), __FILE__, __FUNCTION__, __LINE__, &_inner_error_);
	if (_inner_error_ != NULL) {
		g_propagate_error (error, _inner_error_);
		return;
	}
}


static void simple_mp3_player_get_handles (SimpleMp3Player* self, GError** error) {
	GError * _inner_error_;
	g_return_if_fail (self != NULL);
	_inner_error_ = NULL;
	omx_try_run (OMX_GetHandle (&self->priv->audiodec_handle, SIMPLE_MP3_PLAYER_AUDIODEC_COMPONENT_NAME, self, &SIMPLE_MP3_PLAYER_audiodec_callbacks), __FILE__, __FUNCTION__, __LINE__, &_inner_error_);
	if (_inner_error_ != NULL) {
		g_propagate_error (error, _inner_error_);
		return;
	}
	omx_try_run (OMX_GetHandle (&self->priv->audiosink_handle, SIMPLE_MP3_PLAYER_AUDIOSINK_COMPONENT_NAME, self, &SIMPLE_MP3_PLAYER_audiosink_callbacks), __FILE__, __FUNCTION__, __LINE__, &_inner_error_);
	if (_inner_error_ != NULL) {
		g_propagate_error (error, _inner_error_);
		return;
	}
}


static const char* omx_dir_to_string (OMX_DIRTYPE self) {
	const char* result;
	switch (self) {
		case OMX_DirInput:
		{
			result = "Omx.Dir.Input";
			return result;
		}
		case OMX_DirOutput:
		{
			result = "Omx.Dir.Output";
			return result;
		}
		default:
		{
			result = "(uknnown)";
			return result;
		}
	}
}


static void simple_mp3_player_handle_print_info (SimpleMp3Player* self, const char* name, OMX_HANDLETYPE handle, GError** error) {
	GError * _inner_error_;
	OMX_PORT_PARAM_TYPE _tmp0_ = {0};
	OMX_PORT_PARAM_TYPE param;
	OMX_PARAM_PORTDEFINITIONTYPE _tmp1_ = {0};
	OMX_PARAM_PORTDEFINITIONTYPE port_def;
	g_return_if_fail (self != NULL);
	g_return_if_fail (name != NULL);
	_inner_error_ = NULL;
	param = (memset (&_tmp0_, 0, sizeof (OMX_PORT_PARAM_TYPE)), _tmp0_);
	omx_structure_init (&param);
	omx_try_run (OMX_GetParameter (handle, (gint) OMX_IndexParamAudioInit, &param), __FILE__, __FUNCTION__, __LINE__, &_inner_error_);
	if (_inner_error_ != NULL) {
		g_propagate_error (error, _inner_error_);
		return;
	}
	port_def = (memset (&_tmp1_, 0, sizeof (OMX_PARAM_PORTDEFINITIONTYPE)), _tmp1_);
	omx_structure_init (&port_def);
	g_print ("%s (%p)\n", name, (void*) handle);
	{
		guint i;
		i = (guint) param.nStartPortNumber;
		{
			gboolean _tmp2_;
			_tmp2_ = TRUE;
			while (TRUE) {
				if (!_tmp2_) {
					i++;
				}
				_tmp2_ = FALSE;
				if (!(i < param.nPorts)) {
					break;
				}
				g_print ("\tPort %u:\n", i);
				port_def.nPortIndex = (guint32) i;
				omx_try_run (OMX_GetParameter (handle, (gint) OMX_IndexParamPortDefinition, &port_def), __FILE__, __FUNCTION__, __LINE__, &_inner_error_);
				if (_inner_error_ != NULL) {
					g_propagate_error (error, _inner_error_);
					return;
				}
				g_print ("\t\thas direction %s\n", omx_dir_to_string (port_def.eDir));
				g_print ("\t\thas %u buffers of size %u\n", (guint) port_def.nBufferCountActual, (guint) port_def.nBufferSize);
			}
		}
	}
}


static void simple_mp3_player_pass_to_idle_and_allocate_buffers (SimpleMp3Player* self, GError** error) {
	GError * _inner_error_;
	OMX_BUFFERHEADERTYPE** _tmp0_;
	OMX_BUFFERHEADERTYPE** _tmp1_;
	OMX_BUFFERHEADERTYPE** _tmp2_;
	g_return_if_fail (self != NULL);
	_inner_error_ = NULL;
	omx_try_run (OMX_SendCommand (self->priv->audiodec_handle, OMX_CommandStateSet, (gint) OMX_StateIdle, NULL), __FILE__, __FUNCTION__, __LINE__, &_inner_error_);
	if (_inner_error_ != NULL) {
		g_propagate_error (error, _inner_error_);
		return;
	}
	omx_try_run (OMX_SendCommand (self->priv->audiosink_handle, OMX_CommandStateSet, (gint) OMX_StateIdle, NULL), __FILE__, __FUNCTION__, __LINE__, &_inner_error_);
	if (_inner_error_ != NULL) {
		g_propagate_error (error, _inner_error_);
		return;
	}
	self->priv->in_buffer_audiodec = (_tmp0_ = g_new0 (OMX_BUFFERHEADERTYPE*, SIMPLE_MP3_PLAYER_N_BUFFERS + 1), self->priv->in_buffer_audiodec = (g_free (self->priv->in_buffer_audiodec), NULL), self->priv->in_buffer_audiodec_length1 = SIMPLE_MP3_PLAYER_N_BUFFERS, self->priv->in_buffer_audiodec_size = self->priv->in_buffer_audiodec_length1, _tmp0_);
	self->priv->out_buffer_audiodec = (_tmp1_ = g_new0 (OMX_BUFFERHEADERTYPE*, SIMPLE_MP3_PLAYER_N_BUFFERS + 1), self->priv->out_buffer_audiodec = (g_free (self->priv->out_buffer_audiodec), NULL), self->priv->out_buffer_audiodec_length1 = SIMPLE_MP3_PLAYER_N_BUFFERS, self->priv->out_buffer_audiodec_size = self->priv->out_buffer_audiodec_length1, _tmp1_);
	self->priv->in_buffer_audiosink = (_tmp2_ = g_new0 (OMX_BUFFERHEADERTYPE*, SIMPLE_MP3_PLAYER_N_BUFFERS + 1), self->priv->in_buffer_audiosink = (g_free (self->priv->in_buffer_audiosink), NULL), self->priv->in_buffer_audiosink_length1 = SIMPLE_MP3_PLAYER_N_BUFFERS, self->priv->in_buffer_audiosink_size = self->priv->in_buffer_audiosink_length1, _tmp2_);
	{
		gint i;
		i = 0;
		{
			gboolean _tmp3_;
			_tmp3_ = TRUE;
			while (TRUE) {
				if (!_tmp3_) {
					i++;
				}
				_tmp3_ = FALSE;
				if (!(i < SIMPLE_MP3_PLAYER_N_BUFFERS)) {
					break;
				}
				omx_try_run (OMX_AllocateBuffer (self->priv->audiodec_handle, &self->priv->in_buffer_audiodec[i], 0, NULL, (guint) SIMPLE_MP3_PLAYER_BUFFER_IN_SIZE), __FILE__, __FUNCTION__, __LINE__, &_inner_error_);
				if (_inner_error_ != NULL) {
					g_propagate_error (error, _inner_error_);
					return;
				}
				omx_try_run (OMX_AllocateBuffer (self->priv->audiodec_handle, &self->priv->out_buffer_audiodec[i], 1, NULL, (guint) SIMPLE_MP3_PLAYER_BUFFER_OUT_SIZE), __FILE__, __FUNCTION__, __LINE__, &_inner_error_);
				if (_inner_error_ != NULL) {
					g_propagate_error (error, _inner_error_);
					return;
				}
				omx_try_run (OMX_AllocateBuffer (self->priv->audiosink_handle, &self->priv->in_buffer_audiosink[i], 0, NULL, (guint) SIMPLE_MP3_PLAYER_BUFFER_OUT_SIZE), __FILE__, __FUNCTION__, __LINE__, &_inner_error_);
				if (_inner_error_ != NULL) {
					g_propagate_error (error, _inner_error_);
					return;
				}
			}
		}
	}
	tsem_down (&self->priv->audiodec_sem);
	tsem_down (&self->priv->audiosink_sem);
}


static void simple_mp3_player_pass_to_executing (SimpleMp3Player* self, GError** error) {
	GError * _inner_error_;
	g_return_if_fail (self != NULL);
	_inner_error_ = NULL;
	omx_try_run (OMX_SendCommand (self->priv->audiodec_handle, OMX_CommandStateSet, (gint) OMX_StateExecuting, NULL), __FILE__, __FUNCTION__, __LINE__, &_inner_error_);
	if (_inner_error_ != NULL) {
		g_propagate_error (error, _inner_error_);
		return;
	}
	omx_try_run (OMX_SendCommand (self->priv->audiosink_handle, OMX_CommandStateSet, (gint) OMX_StateExecuting, NULL), __FILE__, __FUNCTION__, __LINE__, &_inner_error_);
	if (_inner_error_ != NULL) {
		g_propagate_error (error, _inner_error_);
		return;
	}
	tsem_down (&self->priv->audiodec_sem);
	tsem_down (&self->priv->audiosink_sem);
}


static void simple_mp3_player_move_buffers (SimpleMp3Player* self, GError** error) {
	GError * _inner_error_;
	g_return_if_fail (self != NULL);
	_inner_error_ = NULL;
	{
		gint i;
		i = 0;
		{
			gboolean _tmp0_;
			_tmp0_ = TRUE;
			while (TRUE) {
				OMX_BUFFERHEADERTYPE* buffer;
				gsize data_read;
				if (!_tmp0_) {
					i++;
				}
				_tmp0_ = FALSE;
				if (!(i < SIMPLE_MP3_PLAYER_N_BUFFERS)) {
					break;
				}
				buffer = self->priv->in_buffer_audiodec[i];
				data_read = fread (buffer->pBuffer, 1, buffer->nAllocLen, self->priv->fd);
				self->priv->in_buffer_audiodec[i]->nFilledLen = data_read;
				self->priv->in_buffer_audiodec[i]->nOffset = (gsize) 0;
				omx_try_run (OMX_EmptyThisBuffer (self->priv->audiodec_handle, self->priv->in_buffer_audiodec[i]), __FILE__, __FUNCTION__, __LINE__, &_inner_error_);
				if (_inner_error_ != NULL) {
					g_propagate_error (error, _inner_error_);
					return;
				}
				omx_try_run (OMX_FillThisBuffer (self->priv->audiodec_handle, self->priv->out_buffer_audiodec[i]), __FILE__, __FUNCTION__, __LINE__, &_inner_error_);
				if (_inner_error_ != NULL) {
					g_propagate_error (error, _inner_error_);
					return;
				}
			}
		}
	}
	g_print ("Waiting for eos\n");
	tsem_down (&self->priv->eos_sem);
}


static void simple_mp3_player_pass_to_idle (SimpleMp3Player* self, GError** error) {
	GError * _inner_error_;
	g_return_if_fail (self != NULL);
	_inner_error_ = NULL;
	omx_try_run (OMX_SendCommand (self->priv->audiodec_handle, OMX_CommandStateSet, (gint) OMX_StateIdle, NULL), __FILE__, __FUNCTION__, __LINE__, &_inner_error_);
	if (_inner_error_ != NULL) {
		g_propagate_error (error, _inner_error_);
		return;
	}
	omx_try_run (OMX_SendCommand (self->priv->audiosink_handle, OMX_CommandStateSet, (gint) OMX_StateIdle, NULL), __FILE__, __FUNCTION__, __LINE__, &_inner_error_);
	if (_inner_error_ != NULL) {
		g_propagate_error (error, _inner_error_);
		return;
	}
	tsem_down (&self->priv->audiodec_sem);
	tsem_down (&self->priv->audiosink_sem);
}


static void simple_mp3_player_pass_to_loaded_and_free_buffers (SimpleMp3Player* self, GError** error) {
	GError * _inner_error_;
	g_return_if_fail (self != NULL);
	_inner_error_ = NULL;
	omx_try_run (OMX_SendCommand (self->priv->audiodec_handle, OMX_CommandStateSet, (gint) OMX_StateLoaded, NULL), __FILE__, __FUNCTION__, __LINE__, &_inner_error_);
	if (_inner_error_ != NULL) {
		g_propagate_error (error, _inner_error_);
		return;
	}
	omx_try_run (OMX_SendCommand (self->priv->audiosink_handle, OMX_CommandStateSet, (gint) OMX_StateLoaded, NULL), __FILE__, __FUNCTION__, __LINE__, &_inner_error_);
	if (_inner_error_ != NULL) {
		g_propagate_error (error, _inner_error_);
		return;
	}
	{
		gint i;
		i = 0;
		{
			gboolean _tmp0_;
			_tmp0_ = TRUE;
			while (TRUE) {
				if (!_tmp0_) {
					i++;
				}
				_tmp0_ = FALSE;
				if (!(i < SIMPLE_MP3_PLAYER_N_BUFFERS)) {
					break;
				}
				omx_try_run (OMX_FreeBuffer (self->priv->audiodec_handle, 0, self->priv->in_buffer_audiodec[i]), __FILE__, __FUNCTION__, __LINE__, &_inner_error_);
				if (_inner_error_ != NULL) {
					g_propagate_error (error, _inner_error_);
					return;
				}
				omx_try_run (OMX_FreeBuffer (self->priv->audiodec_handle, 1, self->priv->out_buffer_audiodec[i]), __FILE__, __FUNCTION__, __LINE__, &_inner_error_);
				if (_inner_error_ != NULL) {
					g_propagate_error (error, _inner_error_);
					return;
				}
				omx_try_run (OMX_FreeBuffer (self->priv->audiosink_handle, 0, self->priv->in_buffer_audiosink[i]), __FILE__, __FUNCTION__, __LINE__, &_inner_error_);
				if (_inner_error_ != NULL) {
					g_propagate_error (error, _inner_error_);
					return;
				}
			}
		}
	}
	tsem_down (&self->priv->audiodec_sem);
	tsem_down (&self->priv->audiosink_sem);
}


static void simple_mp3_player_free_handles (SimpleMp3Player* self, GError** error) {
	GError * _inner_error_;
	g_return_if_fail (self != NULL);
	_inner_error_ = NULL;
	omx_try_run (OMX_FreeHandle (self->priv->audiodec_handle), __FILE__, __FUNCTION__, __LINE__, &_inner_error_);
	if (_inner_error_ != NULL) {
		g_propagate_error (error, _inner_error_);
		return;
	}
	omx_try_run (OMX_FreeHandle (self->priv->audiosink_handle), __FILE__, __FUNCTION__, __LINE__, &_inner_error_);
	if (_inner_error_ != NULL) {
		g_propagate_error (error, _inner_error_);
		return;
	}
}


static OMX_ERRORTYPE simple_mp3_player_audiodec_event_handler (SimpleMp3Player* self, OMX_HANDLETYPE component, OMX_EVENTTYPE event, guint32 data1, guint32 data2, void* event_data) {
	OMX_ERRORTYPE result;
	g_return_val_if_fail (self != NULL, 0);
	switch (event) {
		case OMX_EventCmdComplete:
		{
			switch (data1) {
				case OMX_CommandStateSet:
				{
					tsem_up (&self->priv->audiodec_sem);
					break;
				}
				default:
				{
					break;
				}
			}
			break;
		}
		default:
		{
			break;
		}
	}
	result = OMX_ErrorNone;
	return result;
}


static OMX_ERRORTYPE simple_mp3_player_audiodec_empty_buffer_done (SimpleMp3Player* self, OMX_HANDLETYPE component, OMX_BUFFERHEADERTYPE* buffer) {
	OMX_ERRORTYPE result;
	g_return_val_if_fail (self != NULL, 0);
	g_return_val_if_fail (buffer != NULL, 0);
	if (self->priv->eos_found != 0) {
		g_print ("Requesting buffer after eos was found\n");
		if (self->priv->eos_found == SIMPLE_MP3_PLAYER_N_BUFFERS) {
			tsem_up (&self->priv->eos_sem);
		} else {
			self->priv->eos_found++;
		}
		result = OMX_ErrorNone;
		return result;
	}
	buffer->nOffset = (gsize) 0;
	buffer->nFilledLen = fread (buffer->pBuffer, 1, buffer->nAllocLen, self->priv->fd);
	if (feof (self->priv->fd)) {
		g_print ("Setting eos flag\n");
		buffer->nFlags = buffer->nFlags | ((guint32) OMX_BUFFERFLAG_EOS);
		self->priv->eos_found++;
	}
	result = OMX_EmptyThisBuffer (self->priv->audiodec_handle, buffer);
	return result;
}


static OMX_ERRORTYPE simple_mp3_player_audiodec_fill_buffer_done (SimpleMp3Player* self, OMX_HANDLETYPE component, OMX_BUFFERHEADERTYPE* buffer) {
	OMX_ERRORTYPE result;
	g_return_val_if_fail (self != NULL, 0);
	g_return_val_if_fail (buffer != NULL, 0);
	result = OMX_EmptyThisBuffer (self->priv->audiosink_handle, buffer);
	return result;
}


static OMX_ERRORTYPE simple_mp3_player_audiosink_event_handler (SimpleMp3Player* self, OMX_HANDLETYPE component, OMX_EVENTTYPE event, guint32 data1, guint32 data2, void* event_data) {
	OMX_ERRORTYPE result;
	g_return_val_if_fail (self != NULL, 0);
	switch (event) {
		case OMX_EventCmdComplete:
		{
			switch (data1) {
				case OMX_CommandStateSet:
				{
					tsem_up (&self->priv->audiosink_sem);
					break;
				}
				default:
				{
					break;
				}
			}
			break;
		}
		default:
		{
			break;
		}
	}
	result = OMX_ErrorNone;
	return result;
}


static OMX_ERRORTYPE simple_mp3_player_audiosink_empty_buffer_done (SimpleMp3Player* self, OMX_HANDLETYPE component, OMX_BUFFERHEADERTYPE* buffer) {
	OMX_ERRORTYPE result;
	g_return_val_if_fail (self != NULL, 0);
	g_return_val_if_fail (buffer != NULL, 0);
	result = OMX_FillThisBuffer (self->priv->audiodec_handle, buffer);
	return result;
}


SimpleMp3Player* simple_mp3_player_construct (GType object_type) {
	SimpleMp3Player * self;
	self = g_object_newv (object_type, 0, NULL);
	return self;
}


SimpleMp3Player* simple_mp3_player_new (void) {
	return simple_mp3_player_construct (TYPE_SIMPLE_MP3_PLAYER);
}


static GObject * simple_mp3_player_constructor (GType type, guint n_construct_properties, GObjectConstructParam * construct_properties) {
	GObject * obj;
	GObjectClass * parent_class;
	SimpleMp3Player * self;
	parent_class = G_OBJECT_CLASS (simple_mp3_player_parent_class);
	obj = parent_class->constructor (type, n_construct_properties, construct_properties);
	self = SIMPLE_MP3_PLAYER (obj);
	{
		tsem_init (&self->priv->audiodec_sem, (guint) 0);
		tsem_init (&self->priv->audiosink_sem, (guint) 0);
		tsem_init (&self->priv->eos_sem, (guint) 0);
	}
	return obj;
}


static void simple_mp3_player_class_init (SimpleMp3PlayerClass * klass) {
	simple_mp3_player_parent_class = g_type_class_peek_parent (klass);
	g_type_class_add_private (klass, sizeof (SimpleMp3PlayerPrivate));
	G_OBJECT_CLASS (klass)->constructor = simple_mp3_player_constructor;
	G_OBJECT_CLASS (klass)->finalize = simple_mp3_player_finalize;
}


static void simple_mp3_player_instance_init (SimpleMp3Player * self) {
	self->priv = SIMPLE_MP3_PLAYER_GET_PRIVATE (self);
}


static void simple_mp3_player_finalize (GObject* obj) {
	SimpleMp3Player * self;
	self = SIMPLE_MP3_PLAYER (obj);
	_fclose0 (self->priv->fd);
	self->priv->in_buffer_audiosink = (g_free (self->priv->in_buffer_audiosink), NULL);
	self->priv->in_buffer_audiodec = (g_free (self->priv->in_buffer_audiodec), NULL);
	self->priv->out_buffer_audiodec = (g_free (self->priv->out_buffer_audiodec), NULL);
	G_OBJECT_CLASS (simple_mp3_player_parent_class)->finalize (obj);
}


GType simple_mp3_player_get_type (void) {
	static GType simple_mp3_player_type_id = 0;
	if (simple_mp3_player_type_id == 0) {
		static const GTypeInfo g_define_type_info = { sizeof (SimpleMp3PlayerClass), (GBaseInitFunc) NULL, (GBaseFinalizeFunc) NULL, (GClassInitFunc) simple_mp3_player_class_init, (GClassFinalizeFunc) NULL, NULL, sizeof (SimpleMp3Player), 0, (GInstanceInitFunc) simple_mp3_player_instance_init, NULL };
		simple_mp3_player_type_id = g_type_register_static (G_TYPE_OBJECT, "SimpleMp3Player", &g_define_type_info, 0);
	}
	return simple_mp3_player_type_id;
}




