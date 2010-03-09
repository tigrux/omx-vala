/* gstgomx.c generated by valac, the Vala compiler
 * generated from gstgomx.vala, do not modify */


#include <glib.h>
#include <glib-object.h>
#include <gst/gst.h>
#include <gomx.h>
#include <stdlib.h>
#include <string.h>
#include <OMX_Core.h>
#include <OMX_Component.h>
#include <omx-utils.h>


#define GST_GOMX_TYPE_MP3_DEC (gst_gomx_mp3_dec_get_type ())
#define GST_GOMX_MP3_DEC(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), GST_GOMX_TYPE_MP3_DEC, GstGOmxMp3Dec))
#define GST_GOMX_MP3_DEC_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), GST_GOMX_TYPE_MP3_DEC, GstGOmxMp3DecClass))
#define GST_GOMX_IS_MP3_DEC(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), GST_GOMX_TYPE_MP3_DEC))
#define GST_GOMX_IS_MP3_DEC_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), GST_GOMX_TYPE_MP3_DEC))
#define GST_GOMX_MP3_DEC_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), GST_GOMX_TYPE_MP3_DEC, GstGOmxMp3DecClass))

typedef struct _GstGOmxMp3Dec GstGOmxMp3Dec;
typedef struct _GstGOmxMp3DecClass GstGOmxMp3DecClass;
typedef struct _GstGOmxMp3DecPrivate GstGOmxMp3DecPrivate;
#define _gst_object_unref0(var) ((var == NULL) ? NULL : (var = (gst_object_unref (var), NULL)))
#define _g_object_unref0(var) ((var == NULL) ? NULL : (var = (g_object_unref (var), NULL)))
#define _g_free0(var) (var = (g_free (var), NULL))
#define _g_error_free0(var) ((var == NULL) ? NULL : (var = (g_error_free (var), NULL)))
#define _gst_structure_free0(var) ((var == NULL) ? NULL : (var = (gst_structure_free (var), NULL)))
#define _gst_buffer_unref0(var) ((var == NULL) ? NULL : (var = (gst_buffer_unref (var), NULL)))
#define _gst_event_unref0(var) ((var == NULL) ? NULL : (var = (gst_event_unref (var), NULL)))
#define _gst_caps_unref0(var) ((var == NULL) ? NULL : (var = (gst_caps_unref (var), NULL)))

struct _GstGOmxMp3Dec {
	GstElement parent_instance;
	GstGOmxMp3DecPrivate * priv;
};

struct _GstGOmxMp3DecClass {
	GstElementClass parent_class;
};

struct _GstGOmxMp3DecPrivate {
	GstPad* src_pad;
	GstPad* sink_pad;
	GOmxAudioComponent* component;
	GOmxPort* input_port;
	GOmxPort* output_port;
	char* component_name;
	char* library_name;
	gint rate;
	gint channels;
	gboolean chained;
	gboolean done;
	gboolean output_configured;
};


static gpointer gst_gomx_mp3_dec_parent_class = NULL;

GType gst_gomx_mp3_dec_get_type (void);
#define GST_GOMX_MP3_DEC_GET_PRIVATE(o) (G_TYPE_INSTANCE_GET_PRIVATE ((o), GST_GOMX_TYPE_MP3_DEC, GstGOmxMp3DecPrivate))
enum  {
	GST_GOMX_MP3_DEC_DUMMY_PROPERTY
};
static void gst_gomx_mp3_dec_configure_input (GstGOmxMp3Dec* self, GError** error);
static GstStateChangeReturn gst_gomx_mp3_dec_real_change_state (GstElement* base, GstStateChange transition);
static gboolean gst_gomx_mp3_dec_sink_pad_setcaps (GstGOmxMp3Dec* self, GstPad* pad, GstCaps* caps);
void gst_gomx_mp3_dec_src_pad_task (GstGOmxMp3Dec* self);
static void _gst_gomx_mp3_dec_src_pad_task_gst_task_function (gpointer self);
static GstFlowReturn gst_gomx_mp3_dec_sink_pad_chain (GstGOmxMp3Dec* self, GstPad* pad, GstBuffer* buffer);
static gboolean gst_gomx_mp3_dec_sink_pad_event_eos (GstGOmxMp3Dec* self, GstPad* pad, GstEvent* event);
static gboolean gst_gomx_mp3_dec_sink_pad_event (GstGOmxMp3Dec* self, GstPad* pad, GstEvent* event);
static gboolean gst_gomx_mp3_dec_sink_pad_activatepush (GstGOmxMp3Dec* self, GstPad* pad, gboolean active);
static void gst_gomx_mp3_dec_configure_output (GstGOmxMp3Dec* self, GError** error);
GstBuffer* gst_gomx_mp3_dec_buffer_gst_from_omx (GstGOmxMp3Dec* self, OMX_BUFFERHEADERTYPE* omx_buffer);
static gboolean _gst_gomx_mp3_dec_sink_pad_setcaps (GstPad* pad, GstCaps* caps);
static gboolean _gst_gomx_mp3_dec_sink_pad_event (GstPad* pad, GstEvent* event);
static GstFlowReturn _gst_gomx_mp3_dec_sink_pad_chain (GstPad* pad, GstBuffer* buffer);
static gboolean _gst_gomx_mp3_dec_sink_pad_activatepush (GstPad* pad, gboolean active);
GstGOmxMp3Dec* gst_gomx_mp3_dec_new (void);
GstGOmxMp3Dec* gst_gomx_mp3_dec_construct (GType object_type);
static GstFlowReturn __gst_gomx_mp3_dec_sink_pad_chain_gst_pad_chain_function (GstPad* pad, GstBuffer* buffer);
static gboolean __gst_gomx_mp3_dec_sink_pad_setcaps_gst_pad_set_caps_function (GstPad* pad, GstCaps* caps);
static gboolean __gst_gomx_mp3_dec_sink_pad_event_gst_pad_event_function (GstPad* pad, GstEvent* event);
static gboolean __gst_gomx_mp3_dec_sink_pad_activatepush_gst_pad_activate_mode_function (GstPad* pad, gboolean active);
static GObject * gst_gomx_mp3_dec_constructor (GType type, guint n_construct_properties, GObjectConstructParam * construct_properties);
static void gst_gomx_mp3_dec_finalize (GObject* obj);
gboolean plugin_init (GstPlugin* plugin);
static gboolean _plugin_init_gst_plugin_init_func (GstPlugin* plugin);

const GstPluginDesc gst_plugin_desc = {GST_VERSION_MAJOR, GST_VERSION_MINOR, "gomx", "Elements based on omx-vala", _plugin_init_gst_plugin_init_func, "0.1.0", "LGPL", "gst-gomx", "GstGOmx", "http://github.com/tigrux/omx-vala"};


static GstStateChangeReturn gst_gomx_mp3_dec_real_change_state (GstElement* base, GstStateChange transition) {
	GstGOmxMp3Dec * self;
	GstStateChangeReturn result;
	GError * _inner_error_;
	self = (GstGOmxMp3Dec*) base;
	_inner_error_ = NULL;
	switch (transition) {
		case GST_STATE_CHANGE_NULL_TO_READY:
		{
			{
				GOmxCore* core;
				GOmxPort* _tmp0_;
				GOmxPort* _tmp1_;
				core = gomx_load_library (gomx_component_get_library_name ((GOmxComponent*) self->priv->component), &_inner_error_);
				if (_inner_error_ != NULL) {
					goto __catch0_g_error;
				}
				gomx_core_init (core, &_inner_error_);
				if (_inner_error_ != NULL) {
					_g_object_unref0 (core);
					goto __catch0_g_error;
				}
				gomx_component_init ((GOmxComponent*) self->priv->component, &_inner_error_);
				if (_inner_error_ != NULL) {
					_g_object_unref0 (core);
					goto __catch0_g_error;
				}
				self->priv->input_port = (_tmp0_ = gomx_port_array_get (gomx_component_get_ports ((GOmxComponent*) self->priv->component), (guint) 0), _g_object_unref0 (self->priv->input_port), _tmp0_);
				self->priv->output_port = (_tmp1_ = gomx_port_array_get (gomx_component_get_ports ((GOmxComponent*) self->priv->component), (guint) 1), _g_object_unref0 (self->priv->output_port), _tmp1_);
				gst_gomx_mp3_dec_configure_input (self, &_inner_error_);
				if (_inner_error_ != NULL) {
					_g_object_unref0 (core);
					goto __catch0_g_error;
				}
				_g_object_unref0 (core);
			}
			goto __finally0;
			__catch0_g_error:
			{
				GError * e;
				e = _inner_error_;
				_inner_error_ = NULL;
				{
					g_print ("%s\n", e->message);
					result = GST_STATE_CHANGE_FAILURE;
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
			break;
		}
		case GST_STATE_CHANGE_READY_TO_PAUSED:
		{
			{
				gomx_component_set_state_and_wait ((GOmxComponent*) self->priv->component, OMX_StateIdle, &_inner_error_);
				if (_inner_error_ != NULL) {
					goto __catch1_g_error;
				}
			}
			goto __finally1;
			__catch1_g_error:
			{
				GError * e;
				e = _inner_error_;
				_inner_error_ = NULL;
				{
					g_print ("%s\n", e->message);
					result = GST_STATE_CHANGE_FAILURE;
					_g_error_free0 (e);
					return result;
				}
			}
			__finally1:
			if (_inner_error_ != NULL) {
				g_critical ("file %s: line %d: uncaught error: %s (%s, %d)", __FILE__, __LINE__, _inner_error_->message, g_quark_to_string (_inner_error_->domain), _inner_error_->code);
				g_clear_error (&_inner_error_);
				return 0;
			}
			break;
		}
		default:
		{
			break;
		}
	}
	if (GST_ELEMENT_CLASS (gst_gomx_mp3_dec_parent_class)->change_state (GST_ELEMENT (self), transition) == GST_STATE_CHANGE_FAILURE) {
		result = GST_STATE_CHANGE_FAILURE;
		return result;
	}
	switch (transition) {
		case GST_STATE_CHANGE_PAUSED_TO_READY:
		{
			{
				{
					GOmxBufferArrayIterator* _buffer_it;
					_buffer_it = gomx_buffer_array_iterator (gomx_port_get_buffers (self->priv->output_port));
					while (TRUE) {
						OMX_BUFFERHEADERTYPE* buffer;
						if (!gomx_buffer_array_iterator_next (_buffer_it)) {
							break;
						}
						buffer = gomx_buffer_array_iterator_get (_buffer_it);
						if (GST_IS_BUFFER (buffer->pAppPrivate)) {
							void* _tmp2_;
							gst_buffer_unref ((_tmp2_ = buffer->pAppPrivate, GST_IS_BUFFER (_tmp2_) ? ((GstBuffer*) _tmp2_) : NULL));
						}
					}
					_g_object_unref0 (_buffer_it);
				}
				gomx_component_set_state_and_wait ((GOmxComponent*) self->priv->component, OMX_StateIdle, &_inner_error_);
				if (_inner_error_ != NULL) {
					goto __catch2_g_error;
				}
			}
			goto __finally2;
			__catch2_g_error:
			{
				GError * e;
				e = _inner_error_;
				_inner_error_ = NULL;
				{
					g_print ("%s\n", e->message);
					_g_error_free0 (e);
				}
			}
			__finally2:
			if (_inner_error_ != NULL) {
				g_critical ("file %s: line %d: uncaught error: %s (%s, %d)", __FILE__, __LINE__, _inner_error_->message, g_quark_to_string (_inner_error_->domain), _inner_error_->code);
				g_clear_error (&_inner_error_);
				return 0;
			}
			break;
		}
		case GST_STATE_CHANGE_READY_TO_NULL:
		{
			{
				GOmxAudioComponent* _tmp3_;
				gomx_component_set_state_and_wait ((GOmxComponent*) self->priv->component, OMX_StateLoaded, &_inner_error_);
				if (_inner_error_ != NULL) {
					goto __catch3_g_error;
				}
				gomx_core_deinit (gomx_component_get_core ((GOmxComponent*) self->priv->component), &_inner_error_);
				if (_inner_error_ != NULL) {
					goto __catch3_g_error;
				}
				self->priv->component = (_tmp3_ = NULL, _g_object_unref0 (self->priv->component), _tmp3_);
			}
			goto __finally3;
			__catch3_g_error:
			{
				GError * e;
				e = _inner_error_;
				_inner_error_ = NULL;
				{
					g_print ("%s\n", e->message);
					_g_error_free0 (e);
				}
			}
			__finally3:
			if (_inner_error_ != NULL) {
				g_critical ("file %s: line %d: uncaught error: %s (%s, %d)", __FILE__, __LINE__, _inner_error_->message, g_quark_to_string (_inner_error_->domain), _inner_error_->code);
				g_clear_error (&_inner_error_);
				return 0;
			}
			break;
		}
		default:
		{
			break;
		}
	}
	result = GST_STATE_CHANGE_SUCCESS;
	return result;
}


static gpointer _gst_structure_copy0 (gpointer self) {
	return self ? gst_structure_copy (self) : NULL;
}


static gboolean gst_gomx_mp3_dec_sink_pad_setcaps (GstGOmxMp3Dec* self, GstPad* pad, GstCaps* caps) {
	gboolean result;
	GstStructure* structure;
	g_return_val_if_fail (self != NULL, FALSE);
	g_return_val_if_fail (pad != NULL, FALSE);
	g_return_val_if_fail (caps != NULL, FALSE);
	structure = _gst_structure_copy0 (gst_caps_get_structure (caps, (guint) 0));
	gst_structure_get_int (structure, "rate", &self->priv->rate);
	gst_structure_get_int (structure, "channels", &self->priv->channels);
	result = gst_pad_set_caps (pad, caps);
	_gst_structure_free0 (structure);
	return result;
}


static void _gst_gomx_mp3_dec_src_pad_task_gst_task_function (gpointer self) {
	gst_gomx_mp3_dec_src_pad_task (self);
}


static GstFlowReturn gst_gomx_mp3_dec_sink_pad_chain (GstGOmxMp3Dec* self, GstPad* pad, GstBuffer* buffer) {
	GstFlowReturn result;
	GError * _inner_error_;
	g_return_val_if_fail (self != NULL, 0);
	g_return_val_if_fail (pad != NULL, 0);
	g_return_val_if_fail (buffer != NULL, 0);
	_inner_error_ = NULL;
	{
		OMX_BUFFERHEADERTYPE* omx_buffer;
		if (!self->priv->chained) {
			gomx_component_set_state_and_wait ((GOmxComponent*) self->priv->component, OMX_StateExecuting, &_inner_error_);
			if (_inner_error_ != NULL) {
				goto __catch4_g_error;
			}
			gst_pad_start_task (self->priv->src_pad, _gst_gomx_mp3_dec_src_pad_task_gst_task_function, self);
			self->priv->chained = TRUE;
		}
		omx_buffer = gomx_port_pop_buffer (self->priv->input_port);
		omx_buffer->nOffset = (guint32) 0;
		omx_buffer->nFilledLen = (guint32) buffer->size;
		memcpy (omx_buffer->pBuffer, buffer->data, (gsize) buffer->size);
		gomx_port_push_buffer (self->priv->input_port, omx_buffer, &_inner_error_);
		if (_inner_error_ != NULL) {
			goto __catch4_g_error;
		}
	}
	goto __finally4;
	__catch4_g_error:
	{
		GError * e;
		e = _inner_error_;
		_inner_error_ = NULL;
		{
			g_print ("%s\n", e->message);
			result = GST_FLOW_ERROR;
			_g_error_free0 (e);
			_gst_buffer_unref0 (buffer);
			return result;
		}
	}
	__finally4:
	if (_inner_error_ != NULL) {
		_gst_buffer_unref0 (buffer);
		g_critical ("file %s: line %d: uncaught error: %s (%s, %d)", __FILE__, __LINE__, _inner_error_->message, g_quark_to_string (_inner_error_->domain), _inner_error_->code);
		g_clear_error (&_inner_error_);
		return 0;
	}
	result = GST_FLOW_OK;
	_gst_buffer_unref0 (buffer);
	return result;
}


static gpointer _gst_event_ref0 (gpointer self) {
	return self ? gst_event_ref (self) : NULL;
}


static gboolean gst_gomx_mp3_dec_sink_pad_event (GstGOmxMp3Dec* self, GstPad* pad, GstEvent* event) {
	gboolean result;
	g_return_val_if_fail (self != NULL, FALSE);
	g_return_val_if_fail (pad != NULL, FALSE);
	g_return_val_if_fail (event != NULL, FALSE);
	switch (event->type) {
		case GST_EVENT_EOS:
		{
			result = gst_gomx_mp3_dec_sink_pad_event_eos (self, pad, _gst_event_ref0 (event));
			_gst_event_unref0 (event);
			return result;
		}
		default:
		{
			result = gst_pad_push_event (self->priv->src_pad, _gst_event_ref0 (event));
			_gst_event_unref0 (event);
			return result;
		}
	}
	_gst_event_unref0 (event);
}


static gboolean gst_gomx_mp3_dec_sink_pad_event_eos (GstGOmxMp3Dec* self, GstPad* pad, GstEvent* event) {
	gboolean result;
	GError * _inner_error_;
	g_return_val_if_fail (self != NULL, FALSE);
	g_return_val_if_fail (pad != NULL, FALSE);
	g_return_val_if_fail (event != NULL, FALSE);
	_inner_error_ = NULL;
	if (!self->priv->done) {
		{
			OMX_BUFFERHEADERTYPE* omx_buffer;
			omx_buffer = gomx_port_pop_buffer (self->priv->input_port);
			omx_buffer->nOffset = (guint32) 0;
			omx_buffer->nFilledLen = (guint32) 1;
			gomx_buffer_set_eos (omx_buffer);
			gomx_port_push_buffer (self->priv->input_port, omx_buffer, &_inner_error_);
			if (_inner_error_ != NULL) {
				goto __catch5_g_error;
			}
			result = TRUE;
			_gst_event_unref0 (event);
			return result;
		}
		goto __finally5;
		__catch5_g_error:
		{
			GError * e;
			e = _inner_error_;
			_inner_error_ = NULL;
			{
				g_print ("%s\n", e->message);
				result = FALSE;
				_g_error_free0 (e);
				_gst_event_unref0 (event);
				return result;
			}
		}
		__finally5:
		if (_inner_error_ != NULL) {
			_gst_event_unref0 (event);
			g_critical ("file %s: line %d: uncaught error: %s (%s, %d)", __FILE__, __LINE__, _inner_error_->message, g_quark_to_string (_inner_error_->domain), _inner_error_->code);
			g_clear_error (&_inner_error_);
			return FALSE;
		}
	} else {
		result = gst_pad_push_event (self->priv->src_pad, _gst_event_ref0 (event));
		_gst_event_unref0 (event);
		return result;
	}
	_gst_event_unref0 (event);
}


static gboolean gst_gomx_mp3_dec_sink_pad_activatepush (GstGOmxMp3Dec* self, GstPad* pad, gboolean active) {
	gboolean result;
	gboolean _tmp0_ = FALSE;
	g_return_val_if_fail (self != NULL, FALSE);
	g_return_val_if_fail (pad != NULL, FALSE);
	if (!active) {
		_tmp0_ = TRUE;
	} else {
		_tmp0_ = self->priv->done;
	}
	if (_tmp0_) {
		result = gst_pad_stop_task (self->priv->src_pad);
		return result;
	}
	result = TRUE;
	return result;
}


static gpointer _gst_buffer_ref0 (gpointer self) {
	return self ? gst_buffer_ref (self) : NULL;
}


void gst_gomx_mp3_dec_src_pad_task (GstGOmxMp3Dec* self) {
	GError * _inner_error_;
	gboolean _tmp0_ = FALSE;
	g_return_if_fail (self != NULL);
	_inner_error_ = NULL;
	if (!self->priv->chained) {
		_tmp0_ = TRUE;
	} else {
		_tmp0_ = self->priv->done;
	}
	if (_tmp0_) {
		return;
	}
	{
		OMX_BUFFERHEADERTYPE* omx_buffer;
		if (!self->priv->output_configured) {
			gst_gomx_mp3_dec_configure_output (self, &_inner_error_);
			if (_inner_error_ != NULL) {
				goto __catch6_g_error;
			}
		}
		omx_buffer = gomx_port_pop_buffer (self->priv->output_port);
		if (!gomx_port_get_eos (self->priv->output_port)) {
			GstBuffer* buffer;
			buffer = gst_gomx_mp3_dec_buffer_gst_from_omx (self, omx_buffer);
			gst_pad_push (self->priv->src_pad, _gst_buffer_ref0 (buffer));
			_gst_buffer_unref0 (buffer);
		} else {
			self->priv->done = TRUE;
			gst_pad_pause_task (self->priv->src_pad);
			gst_element_send_event ((GstElement*) self, gst_event_new_eos ());
		}
		gomx_port_push_buffer (self->priv->output_port, omx_buffer, &_inner_error_);
		if (_inner_error_ != NULL) {
			goto __catch6_g_error;
		}
	}
	goto __finally6;
	__catch6_g_error:
	{
		GError * e;
		e = _inner_error_;
		_inner_error_ = NULL;
		{
			g_print ("%s\n", e->message);
			_g_error_free0 (e);
		}
	}
	__finally6:
	if (_inner_error_ != NULL) {
		g_critical ("file %s: line %d: uncaught error: %s (%s, %d)", __FILE__, __LINE__, _inner_error_->message, g_quark_to_string (_inner_error_->domain), _inner_error_->code);
		g_clear_error (&_inner_error_);
		return;
	}
}


static void gst_gomx_mp3_dec_configure_input (GstGOmxMp3Dec* self, GError** error) {
	GError * _inner_error_;
	OMX_AUDIO_PARAM_MP3TYPE _tmp0_ = {0};
	OMX_AUDIO_PARAM_MP3TYPE mp3_param;
	g_return_if_fail (self != NULL);
	_inner_error_ = NULL;
	mp3_param = (memset (&_tmp0_, 0, sizeof (OMX_AUDIO_PARAM_MP3TYPE)), _tmp0_);
	omx_structure_init (&mp3_param);
	mp3_param.nPortIndex = (guint32) 0;
	gomx_try_run (OMX_GetParameter (gomx_component_get_handle ((GOmxComponent*) self->priv->component), (guint) OMX_IndexParamAudioMp3, &mp3_param), &_inner_error_);
	if (_inner_error_ != NULL) {
		g_propagate_error (error, _inner_error_);
		return;
	}
	mp3_param.nChannels = (guint32) self->priv->channels;
	mp3_param.nSampleRate = (guint32) self->priv->rate;
	gomx_try_run (OMX_SetParameter (gomx_component_get_handle ((GOmxComponent*) self->priv->component), (guint) OMX_IndexParamAudioMp3, &mp3_param), &_inner_error_);
	if (_inner_error_ != NULL) {
		g_propagate_error (error, _inner_error_);
		return;
	}
}


static void gst_gomx_mp3_dec_configure_output (GstGOmxMp3Dec* self, GError** error) {
	GError * _inner_error_;
	OMX_AUDIO_PARAM_PCMMODETYPE _tmp0_ = {0};
	OMX_AUDIO_PARAM_PCMMODETYPE pcm_param;
	GstCaps* _tmp1_;
	g_return_if_fail (self != NULL);
	_inner_error_ = NULL;
	pcm_param = (memset (&_tmp0_, 0, sizeof (OMX_AUDIO_PARAM_PCMMODETYPE)), _tmp0_);
	omx_structure_init (&pcm_param);
	pcm_param.nPortIndex = (guint32) 1;
	gomx_try_run (OMX_GetParameter (gomx_component_get_handle ((GOmxComponent*) self->priv->component), (guint) OMX_IndexParamAudioPcm, &pcm_param), &_inner_error_);
	if (_inner_error_ != NULL) {
		g_propagate_error (error, _inner_error_);
		return;
	}
	gst_pad_set_caps (self->priv->src_pad, _tmp1_ = gst_caps_new_simple ("audio/x-raw-int", "endianness", G_TYPE_INT, G_BYTE_ORDER, "width", G_TYPE_INT, 16, "depth", G_TYPE_INT, 16, "rate", G_TYPE_INT, pcm_param.nSamplingRate, "signed", G_TYPE_BOOLEAN, TRUE, "channels", G_TYPE_INT, pcm_param.nChannels, NULL, NULL));
	_gst_caps_unref0 (_tmp1_);
	self->priv->output_configured = TRUE;
}


GstBuffer* gst_gomx_mp3_dec_buffer_gst_from_omx (GstGOmxMp3Dec* self, OMX_BUFFERHEADERTYPE* omx_buffer) {
	GstBuffer* result;
	void* _tmp0_;
	GstBuffer* gst_buffer;
	g_return_val_if_fail (self != NULL, NULL);
	g_return_val_if_fail (omx_buffer != NULL, NULL);
	gst_buffer = _gst_buffer_ref0 ((_tmp0_ = omx_buffer->pAppPrivate, GST_IS_BUFFER (_tmp0_) ? ((GstBuffer*) _tmp0_) : NULL));
	if (gst_buffer == NULL) {
		GstBuffer* _tmp1_;
		guint8* _tmp2_;
		GstCaps* _tmp3_;
		gst_buffer = (_tmp1_ = gst_buffer_new (), _gst_buffer_unref0 (gst_buffer), _tmp1_);
		gst_buffer->data = (_tmp2_ = omx_buffer->pBuffer, gst_buffer->size = omx_buffer->nAllocLen, _tmp2_);
		gst_buffer_set_caps (gst_buffer, _tmp3_ = gst_pad_get_negotiated_caps (self->priv->src_pad));
		_gst_caps_unref0 (_tmp3_);
		omx_buffer->pAppPrivate = gst_buffer;
		gst_buffer_ref (gst_buffer);
	}
	gst_buffer->size = (gint) omx_buffer->nFilledLen;
	result = gst_buffer;
	return result;
}


static gboolean _gst_gomx_mp3_dec_sink_pad_setcaps (GstPad* pad, GstCaps* caps) {
	gboolean result;
	GstObject* _tmp0_;
	g_return_val_if_fail (pad != NULL, FALSE);
	g_return_val_if_fail (caps != NULL, FALSE);
	result = gst_gomx_mp3_dec_sink_pad_setcaps ((_tmp0_ = ((GstObject*) pad)->parent, GST_GOMX_IS_MP3_DEC (_tmp0_) ? ((GstGOmxMp3Dec*) _tmp0_) : NULL), pad, caps);
	return result;
}


static gboolean _gst_gomx_mp3_dec_sink_pad_event (GstPad* pad, GstEvent* event) {
	gboolean result;
	GstObject* _tmp0_;
	g_return_val_if_fail (pad != NULL, FALSE);
	g_return_val_if_fail (event != NULL, FALSE);
	result = gst_gomx_mp3_dec_sink_pad_event ((_tmp0_ = ((GstObject*) pad)->parent, GST_GOMX_IS_MP3_DEC (_tmp0_) ? ((GstGOmxMp3Dec*) _tmp0_) : NULL), pad, _gst_event_ref0 (event));
	_gst_event_unref0 (event);
	return result;
	_gst_event_unref0 (event);
}


static GstFlowReturn _gst_gomx_mp3_dec_sink_pad_chain (GstPad* pad, GstBuffer* buffer) {
	GstFlowReturn result;
	GstObject* _tmp0_;
	g_return_val_if_fail (pad != NULL, 0);
	g_return_val_if_fail (buffer != NULL, 0);
	result = gst_gomx_mp3_dec_sink_pad_chain ((_tmp0_ = ((GstObject*) pad)->parent, GST_GOMX_IS_MP3_DEC (_tmp0_) ? ((GstGOmxMp3Dec*) _tmp0_) : NULL), pad, _gst_buffer_ref0 (buffer));
	_gst_buffer_unref0 (buffer);
	return result;
	_gst_buffer_unref0 (buffer);
}


static gboolean _gst_gomx_mp3_dec_sink_pad_activatepush (GstPad* pad, gboolean active) {
	gboolean result;
	GstObject* _tmp0_;
	g_return_val_if_fail (pad != NULL, FALSE);
	result = gst_gomx_mp3_dec_sink_pad_activatepush ((_tmp0_ = ((GstObject*) pad)->parent, GST_GOMX_IS_MP3_DEC (_tmp0_) ? ((GstGOmxMp3Dec*) _tmp0_) : NULL), pad, active);
	return result;
}


GstGOmxMp3Dec* gst_gomx_mp3_dec_construct (GType object_type) {
	GstGOmxMp3Dec * self;
	self = g_object_newv (object_type, 0, NULL);
	return self;
}


GstGOmxMp3Dec* gst_gomx_mp3_dec_new (void) {
	return gst_gomx_mp3_dec_construct (GST_GOMX_TYPE_MP3_DEC);
}


static GstFlowReturn __gst_gomx_mp3_dec_sink_pad_chain_gst_pad_chain_function (GstPad* pad, GstBuffer* buffer) {
	return _gst_gomx_mp3_dec_sink_pad_chain (pad, buffer);
}


static gboolean __gst_gomx_mp3_dec_sink_pad_setcaps_gst_pad_set_caps_function (GstPad* pad, GstCaps* caps) {
	return _gst_gomx_mp3_dec_sink_pad_setcaps (pad, caps);
}


static gboolean __gst_gomx_mp3_dec_sink_pad_event_gst_pad_event_function (GstPad* pad, GstEvent* event) {
	return _gst_gomx_mp3_dec_sink_pad_event (pad, event);
}


static gpointer _gst_object_ref0 (gpointer self) {
	return self ? gst_object_ref (self) : NULL;
}


static gboolean __gst_gomx_mp3_dec_sink_pad_activatepush_gst_pad_activate_mode_function (GstPad* pad, gboolean active) {
	return _gst_gomx_mp3_dec_sink_pad_activatepush (pad, active);
}


static GObject * gst_gomx_mp3_dec_constructor (GType type, guint n_construct_properties, GObjectConstructParam * construct_properties) {
	GObject * obj;
	GObjectClass * parent_class;
	GstGOmxMp3Dec * self;
	parent_class = G_OBJECT_CLASS (gst_gomx_mp3_dec_parent_class);
	obj = parent_class->constructor (type, n_construct_properties, construct_properties);
	self = GST_GOMX_MP3_DEC (obj);
	{
		GstPad* _tmp0_;
		GstPad* _tmp1_;
		GOmxAudioComponent* _tmp2_;
		self->priv->sink_pad = (_tmp0_ = gst_pad_new_from_template (gst_element_class_get_pad_template (GST_ELEMENT_CLASS (G_OBJECT_GET_CLASS (self)), "sink"), "sink"), _gst_object_unref0 (self->priv->sink_pad), _tmp0_);
		gst_pad_set_chain_function (self->priv->sink_pad, __gst_gomx_mp3_dec_sink_pad_chain_gst_pad_chain_function);
		gst_pad_set_setcaps_function (self->priv->sink_pad, __gst_gomx_mp3_dec_sink_pad_setcaps_gst_pad_set_caps_function);
		gst_pad_set_event_function (self->priv->sink_pad, __gst_gomx_mp3_dec_sink_pad_event_gst_pad_event_function);
		gst_element_add_pad ((GstElement*) self, _gst_object_ref0 (self->priv->sink_pad));
		self->priv->src_pad = (_tmp1_ = gst_pad_new_from_template (gst_element_class_get_pad_template (GST_ELEMENT_CLASS (G_OBJECT_GET_CLASS (self)), "src"), "src"), _gst_object_unref0 (self->priv->src_pad), _tmp1_);
		gst_pad_set_activatepush_function (self->priv->src_pad, __gst_gomx_mp3_dec_sink_pad_activatepush_gst_pad_activate_mode_function);
		gst_element_add_pad ((GstElement*) self, _gst_object_ref0 (self->priv->src_pad));
		self->priv->component = (_tmp2_ = gomx_audio_component_new (self->priv->component_name), _g_object_unref0 (self->priv->component), _tmp2_);
		gomx_component_set_library_name ((GOmxComponent*) self->priv->component, self->priv->library_name);
		gomx_component_set_name ((GOmxComponent*) self->priv->component, "decoder");
	}
	return obj;
}


static void gst_gomx_mp3_dec_base_init (GstGOmxMp3DecClass * klass) {
	{
		GstPadTemplate* _tmp3_;
		GstPadTemplate* _tmp4_;
		gst_element_class_set_details_simple (GST_ELEMENT_CLASS (klass), "gomx mp3 decoder", "Codec/Decoder/Audio", "Gst GOmx Mp3 decoder", "Tigrux <tigrux@gmail.com>");
		gst_element_class_add_pad_template (GST_ELEMENT_CLASS (klass), _tmp3_ = gst_pad_template_new ("src", GST_PAD_SRC, GST_PAD_ALWAYS, gst_caps_new_simple ("audio/x-raw-int", "endianness", G_TYPE_INT, G_BYTE_ORDER, "width", G_TYPE_INT, 16, "depth", G_TYPE_INT, 16, "rate", GST_TYPE_INT_RANGE, 8000, 96000, "signed", G_TYPE_BOOLEAN, TRUE, "channels", GST_TYPE_INT_RANGE, 1, 2, NULL, NULL)));
		_gst_object_unref0 (_tmp3_);
		gst_element_class_add_pad_template (GST_ELEMENT_CLASS (klass), _tmp4_ = gst_pad_template_new ("sink", GST_PAD_SINK, GST_PAD_ALWAYS, gst_caps_new_simple ("audio/mpeg", "mpegversion", G_TYPE_INT, 1, "layer", G_TYPE_INT, 3, "rate", GST_TYPE_INT_RANGE, 8000, 48000, "channels", GST_TYPE_INT_RANGE, 1, 8, "parsed", G_TYPE_BOOLEAN, TRUE, NULL, NULL)));
		_gst_object_unref0 (_tmp4_);
	}
}


static void gst_gomx_mp3_dec_class_init (GstGOmxMp3DecClass * klass) {
	gst_gomx_mp3_dec_parent_class = g_type_class_peek_parent (klass);
	g_type_class_add_private (klass, sizeof (GstGOmxMp3DecPrivate));
	GST_ELEMENT_CLASS (klass)->change_state = gst_gomx_mp3_dec_real_change_state;
	G_OBJECT_CLASS (klass)->constructor = gst_gomx_mp3_dec_constructor;
	G_OBJECT_CLASS (klass)->finalize = gst_gomx_mp3_dec_finalize;
}


static void gst_gomx_mp3_dec_instance_init (GstGOmxMp3Dec * self) {
	self->priv = GST_GOMX_MP3_DEC_GET_PRIVATE (self);
	self->priv->component_name = g_strdup ("OMX.st.audio_decoder.mp3.mad");
	self->priv->library_name = g_strdup ("libomxil-bellagio.so.0");
	self->priv->rate = 44100;
	self->priv->channels = 2;
}


static void gst_gomx_mp3_dec_finalize (GObject* obj) {
	GstGOmxMp3Dec * self;
	self = GST_GOMX_MP3_DEC (obj);
	_gst_object_unref0 (self->priv->src_pad);
	_gst_object_unref0 (self->priv->sink_pad);
	_g_object_unref0 (self->priv->component);
	_g_object_unref0 (self->priv->input_port);
	_g_object_unref0 (self->priv->output_port);
	_g_free0 (self->priv->component_name);
	_g_free0 (self->priv->library_name);
	G_OBJECT_CLASS (gst_gomx_mp3_dec_parent_class)->finalize (obj);
}


GType gst_gomx_mp3_dec_get_type (void) {
	static volatile gsize gst_gomx_mp3_dec_type_id__volatile = 0;
	if (g_once_init_enter (&gst_gomx_mp3_dec_type_id__volatile)) {
		static const GTypeInfo g_define_type_info = { sizeof (GstGOmxMp3DecClass), (GBaseInitFunc) gst_gomx_mp3_dec_base_init, (GBaseFinalizeFunc) NULL, (GClassInitFunc) gst_gomx_mp3_dec_class_init, (GClassFinalizeFunc) NULL, NULL, sizeof (GstGOmxMp3Dec), 0, (GInstanceInitFunc) gst_gomx_mp3_dec_instance_init, NULL };
		GType gst_gomx_mp3_dec_type_id;
		gst_gomx_mp3_dec_type_id = g_type_register_static (GST_TYPE_ELEMENT, "GstGOmxMp3Dec", &g_define_type_info, 0);
		g_once_init_leave (&gst_gomx_mp3_dec_type_id__volatile, gst_gomx_mp3_dec_type_id);
	}
	return gst_gomx_mp3_dec_type_id__volatile;
}


gboolean plugin_init (GstPlugin* plugin) {
	gboolean result;
	g_return_val_if_fail (plugin != NULL, FALSE);
	result = gst_element_register (plugin, "gomxdec-mp3", (guint) GST_RANK_PRIMARY, GST_GOMX_TYPE_MP3_DEC);
	return result;
}


static gboolean _plugin_init_gst_plugin_init_func (GstPlugin* plugin) {
	return plugin_init (plugin);
}




