namespace GstGOmx {

    class Mp3Dec: Gst.Element {
        Gst.Pad src_pad;
        Gst.Pad sink_pad;


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
        }


        override Gst.StateChangeReturn change_state(
                Gst.StateChange transition) {
            Gst.StateChangeReturn result = Gst.StateChangeReturn.SUCCESS;

            switch (transition) {
                case Gst.StateChange.NULL_TO_READY:
                    print("*** Passing from null to ready\n");
                    break;
                case Gst.StateChange.READY_TO_PAUSED:
                    print("*** Passing from ready to paused\n");
                    break;
                case Gst.StateChange.PAUSED_TO_PLAYING:
                    print("*** Passing from paused to playing\n");
                    break;
                default:
                    break;
            }

            result = base.change_state(transition);
            if(result == Gst.StateChangeReturn.FAILURE)
                return result;

            switch (transition) {
                case Gst.StateChange.PLAYING_TO_PAUSED:
                    print("*** Passing from playing to paused\n");
                    break;
                case Gst.StateChange.PAUSED_TO_READY:
                    print("*** Passing from paused to ready\n");
                    break;
                case Gst.StateChange.READY_TO_NULL:
                    print("*** Passing from ready to null\n");
                    break;
                default:
                    break;
            }

            return result;
        }


        bool sink_pad_setcaps(Gst.Pad pad, Gst.Caps caps) {
            var structure = caps.get_structure(0);
            int rate = 0;
            int channels = 0;

            structure.get_int("rate", out rate);
            structure.get_int("channels", out channels);

            print("*** Sink Caps: rate = %d, channels=%d\n", rate, channels);
            
            return pad.set_caps(caps);
        }


        bool sink_pad_event(Gst.Pad pad, owned Gst.Event event) {
            bool result;

            switch(event.type) {
                case Gst.EventType.EOS:
                    print("*** Got eos\n");
                    result = src_pad.push_event(event);
                    break;
                case Gst.EventType.FLUSH_START:
                    print("*** Starting flush\n");
                    result = src_pad.push_event(event);
                    break;
                case Gst.EventType.FLUSH_STOP:
                    print("*** Stopping flush\n");
                    result = src_pad.push_event(event);
                    break;
                case Gst.EventType.NEWSEGMENT:
                    print("*** Got new segment\n");
                    result = src_pad.push_event(event);
                    break;
                default:
                    result = src_pad.push_event(event);
                    break;
            }

            return result;
        }


        bool sink_pad_activatepush(Gst.Pad pad, bool active) {
            bool result;
            if(active) {
                print("*** Starting task\n");
                result = src_pad.start_task(src_pad_task);
            }
            else {
                print("*** Stopping task\n");
                result = src_pad.stop_task();
            }

            return result;
        }


        Gst.FlowReturn sink_pad_chain(Gst.Pad pad, owned Gst.Buffer buffer) {
            print("** Chaining: %d\n", buffer.data.length);
            
            return Gst.FlowReturn.OK;
        }


        public void src_pad_task() {
            print("*** Pad tasking\n");
            src_pad.pause_task();
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
    "http://github.com/tigrux/omx-vala",
    {null}
};
