namespace GstGOmx {

    class Mp3Dec: Gst.Element {
        Gst.Pad src_pad;
        Gst.Pad sink_pad;
        
        GOmx.AudioComponent component;
        GOmx.Port input_port;
        GOmx.Port output_port;
        

        class construct {
            set_details_simple(
                "gomx mp3 decoder",
                "Codec/Decoder/Audio",
                "Gst GOmx Mp3 decoder",
                "Tigrux <tigrux@gmail.com>");

            add_pad_template(
                new Gst.PadTemplate(
                    "src", Gst.PadDirection.SRC,
                    Gst.PadPresence.ALWAYS,
                    new Gst.Caps.simple(
                        "audio/x-raw-int",
                        "endianness", typeof(int), ByteOrder.HOST,
                        "width", typeof(int), 16,
                        "depth", typeof(int), 16,
                        "rate", typeof(Gst.IntRange), 8000, 96000,
                        "signed", typeof(bool), true,
                        "channels", typeof(Gst.IntRange), 1, 2,
                        null)));

            add_pad_template(
                new Gst.PadTemplate(
                    "sink", Gst.PadDirection.SINK,
                    Gst.PadPresence.ALWAYS,
                    new Gst.Caps.simple(
                        "audio/mpeg",
                        "mpegversion", typeof(int), 1,
                        "layer", typeof(int), 3,
                        "rate", typeof(Gst.IntRange), 8000, 48000,
                        "channels", typeof(Gst.IntRange), 1, 8,
                        "parsed", typeof(bool), true,
                        null)));
        }


        string component_name = "OMX.st.audio_decoder.mp3.mad";
        string library_name = "libomxil-bellagio.so.0";

        construct {
            sink_pad =
                new Gst.Pad.from_template(get_pad_template("sink"), "sink");
            sink_pad.set_chain_function(_sink_pad_chain);
            sink_pad.set_setcaps_function(_sink_pad_setcaps);
            sink_pad.set_event_function(_sink_pad_event);
            add_pad(sink_pad);

            src_pad =
                new Gst.Pad.from_template(get_pad_template("src"), "src");
            src_pad.set_activatepush_function(_sink_pad_activatepush);
            add_pad(src_pad);

            component = new GOmx.AudioComponent(component_name);
            component.library_name = library_name;
            component.name = "decoder";
        }


        override
        Gst.StateChangeReturn change_state(Gst.StateChange transition) {
            switch (transition) {
                case Gst.StateChange.NULL_TO_READY:
                    try {
                        var core = GOmx.load_library(component.library_name);
                        core.init();
                        component.init();
                        input_port = component.ports[0];
                        output_port = component.ports[1];
                        configure_input();
                    }
                    catch(Error e) {
                        print("%s\n", e.message);
                        return Gst.StateChangeReturn.FAILURE;
                    }
                    break;
                case Gst.StateChange.READY_TO_PAUSED:
                    try {
                        component.set_state_and_wait(Omx.State.Idle);
                    }
                    catch(Error e) {
                        print("%s\n", e.message);
                        return Gst.StateChangeReturn.FAILURE;
                    }
                    break;
                default:
                    break;
            }


            if(base.change_state(transition) == Gst.StateChangeReturn.FAILURE)
                return Gst.StateChangeReturn.FAILURE;

            switch (transition) {
                case Gst.StateChange.PAUSED_TO_READY:
                    try {
                        foreach(var buffer in output_port.buffers)
                            if(buffer.app_private is Gst.Buffer)
                                (buffer.app_private as Gst.Buffer).unref();
                        component.set_state_and_wait(Omx.State.Idle);
                    }
                    catch(Error e) {
                        print("%s\n", e.message);
                    }
                    break;
                case Gst.StateChange.READY_TO_NULL:
                    try {
                        component.set_state_and_wait(Omx.State.Loaded);
                        component.core.deinit();
                        component = null;
                    }
                    catch(Error e) {
                        print("%s\n", e.message);
                    }
                    break;
                default:
                    break;
            }

            return Gst.StateChangeReturn.SUCCESS;
        }


        int rate = 44100;
        int channels = 2;

        bool sink_pad_setcaps(Gst.Pad pad, Gst.Caps caps) {
            var structure = caps.get_structure(0);
            structure.get_int("rate", out rate);
            structure.get_int("channels", out channels);
            return pad.set_caps(caps);
        }


        bool chained;

        Gst.FlowReturn sink_pad_chain(Gst.Pad pad, owned Gst.Buffer buffer) {
            try {
                if(!chained) {
                    component.set_state_and_wait(Omx.State.Executing);
                    src_pad.start_task(src_pad_task);
                    chained = true;
                }

                var omx_buffer = input_port.pop_buffer();
                omx_buffer.offset = 0;
                omx_buffer.length = buffer.data.length;
                Memory.copy(omx_buffer.buffer, buffer.data, buffer.data.length);
                input_port.push_buffer(omx_buffer);
            }
            catch(Error e) {
                print("%s\n", e.message);
                return Gst.FlowReturn.ERROR;
            }
            
            return Gst.FlowReturn.OK;
        }


        bool sink_pad_event(Gst.Pad pad, owned Gst.Event event) {
            switch(event.type) {
                case Gst.EventType.EOS:
                    return sink_pad_event_eos(pad, event);
                default:
                    return src_pad.push_event(event);
            }
        }


        bool done;

        bool sink_pad_event_eos(Gst.Pad pad, owned Gst.Event event) {
            if(!done)
                try {
                    var omx_buffer = input_port.pop_buffer();
#if BELLAGIO
                    omx_buffer.length = 1;
#else
                    omx_buffer.length = 0;
#endif
                    omx_buffer.flags = Omx.BufferFlag.EOS;
                    input_port.push_buffer(omx_buffer);
                    return true;
                }
                catch(Error e) {
                    print("%s\n", e.message);
                    return false;
                }
            else
                return src_pad.push_event(event);
        }


        bool sink_pad_activatepush(Gst.Pad pad, bool active) {
            if(!active || done)
                return src_pad.stop_task();
            return true;
        }


        bool output_configured;

        public void src_pad_task() {
            if(!chained || done)
                return;

            try {
                if(!output_configured)
                    configure_output();

                var omx_buffer = output_port.pop_buffer();
                if(!output_port.eos) {
                    var buffer = buffer_gst_from_omx(omx_buffer);
                    src_pad.push(buffer);
                }
                else {
                    done = true;
                    src_pad.pause_task();
                    send_event(new Gst.Event.eos());
                }
                output_port.push_buffer(omx_buffer);
            }
            catch(Error e) {
                print("%s\n", e.message);
            }
        }


        public Gst.Buffer buffer_gst_from_omx(Omx.BufferHeader omx_buffer) {
            var gst_buffer = omx_buffer.app_private as Gst.Buffer;
            if(gst_buffer == null) {
                gst_buffer = new Gst.Buffer();
                gst_buffer.data = omx_buffer.buffer;
                gst_buffer.set_caps(src_pad.get_negotiated_caps());
                omx_buffer.app_private = gst_buffer;
                gst_buffer.ref();
            }
            gst_buffer.data.length = (int)omx_buffer.length;
            return gst_buffer;
        }


        void configure_input() throws Error {
            var mp3_param = Omx.Audio.Param.Mp3();
            mp3_param.init();
            input_port.get_parameter(Omx.Index.ParamAudioMp3, mp3_param);
            mp3_param.channels = channels;
            mp3_param.sample_rate = rate;
            input_port.set_parameter(Omx.Index.ParamAudioMp3, mp3_param);
        }


        void configure_output() throws Error {
            var pcm_param = Omx.Audio.Param.PcmMode();
            pcm_param.init();
            output_port.get_parameter(Omx.Index.ParamAudioPcm, pcm_param);

            src_pad.set_caps(
                new Gst.Caps.simple(
                    "audio/x-raw-int",
                    "endianness", typeof(int), ByteOrder.HOST,
                    "width", typeof(int), 16,
                    "depth", typeof(int), 16,
                    "rate", typeof(int), pcm_param.sampling_rate,
                    "signed", typeof(bool), true,
                    "channels", typeof(int), pcm_param.channels,
                    null));
            output_configured = true;
        }


        static bool _sink_pad_setcaps(Gst.Pad pad, Gst.Caps caps) {
            return (pad.parent as Mp3Dec).sink_pad_setcaps(pad, caps);
        }

        static bool _sink_pad_event(Gst.Pad pad, owned Gst.Event event) {
            return (pad.parent as Mp3Dec).sink_pad_event(pad, event);
        }

        static Gst.FlowReturn _sink_pad_chain(
                Gst.Pad pad, owned Gst.Buffer buffer) {
            return (pad.parent as Mp3Dec).sink_pad_chain(pad, buffer);
        }

        static bool _sink_pad_activatepush(Gst.Pad pad, bool active) {
            return (pad.parent as Mp3Dec).sink_pad_activatepush(pad, active);
        }        
    }
}



bool plugin_init(Gst.Plugin plugin) {
    return Gst.Element.register(
        plugin, "gomxdec-mp3", Gst.Rank.PRIMARY, typeof(GstGOmx.Mp3Dec));
}

public const Gst.PluginDesc gst_plugin_desc = {
    Gst.VERSION_MAJOR, Gst.VERSION_MINOR,
    "gomx",
    "Elements based on omx-vala",
    plugin_init,
    "0.1.0",
    "LGPL",
    "gst-gomx",
    "GstGOmx",
    "http://github.com/tigrux/omx-vala"
};

