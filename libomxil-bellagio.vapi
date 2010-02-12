[CCode (cheader_filename="OMX_Core.h")]
namespace Omx {

    [CCode (cname="OMX_COMMANDTYPE", cprefix="OMX_Command")]
    public enum Command {
        StateSet,
        Flush,
        PortDisable,
        PortEnable,
        MarkBuffer,
        KhronosExtensions,
        VendorStartUnused,
        Max;
        
        public string to_string() {
            switch(this) {
                case StateSet:
                    return "OMX.Command.StateSet";
                case Flush:
                    return "OMX.Command.Flush";
                case PortDisable:
                    return "OMX.Command.PortDisable";
                case PortEnable:
                    return "OMX.Command.PortEnable";
                case MarkBuffer:
                    return "OMX.Command.MarkBuffer";
                case KhronosExtensions:
                    return "OMX.Command.KhronosExtensions";
                case VendorStartUnused:
                    return "OMX.Command.VendorStartUnused";
                case Max:
                    return "OMX.Command.Max";
                default:
                    return "(unknown)";
            }
        }
    }

    [CCode (cname="OMX_STATETYPE", cprefix="OMX_State")]
    public enum State {
        Invalid,
        Loaded,
        Idle,
        Executing,
        Pause,
        WaitForResources,
        KhronosExtensions,
        VendorStartUnused,
        Max;

        public string to_string() {
            switch(this) {
                case Invalid:
                    return "OMX.State.Invalid";
                case Loaded:
                    return "OMX.State.Loaded";
                case Idle:
                    return "OMX.State.Idle";
                case Executing:
                    return "OMX.State.Invalid";
                case Pause:
                    return "OMX.State.Pause";
                case WaitForResources:
                    return "OMX.State.WaitForResources";
                case KhronosExtensions:
                    return "OMX.State.KhronosExtensions";
                case VendorStartUnused:
                    return "OMX.State.VendorStartUnused";
                case Max:
                    return "OMX.State.Max";
                default:
                    return "(unknown)";
            }
        }
    }

    [CCode (cname="OMX_ERRORTYPE", cprefix="OMX_Error")]
    public enum Error {
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
        TunnelingUnsupported,
        KhronosExtensions,
        VendorStartUnused,
        Max;
        
        public string to_string() {
            switch(this) {
                case None:
                    return "OMX.Error.None";
                case InsufficientResources:
                    return "OMX.Error.InsufficientResources";
                case Undefined:
                    return "OMX.Error.Undefined";
                case InvalidComponentName:
                    return "OMX.Error.InvalidComponentName";
                case ComponentNotFound:
                    return "OMX.Error.ComponentNotFound";
                case InvalidComponent:
                    return "OMX.Error.InvalidComponent";
                case BadParameter:
                    return "OMX.Error.BadParameter";
                case NotImplemented:
                    return "OMX.Error.NotImplemented";
                case Underflow:
                    return "OMX.Error.Underflow";
                case Overflow:
                    return "OMX.Error.Overflow";
                case Hardware:
                    return "OMX.Error.Hardware";
                case InvalidState:
                    return "OMX.Error.InvalidState";
                case StreamCorrupt:
                    return "OMX.Error.StreamCorrupt";
                case PortsNotCompatible:
                    return "OMX.Error.PortsNotCompatible";
                case ResourcesLost:
                    return "OMX.Error.ResourcesLost";
                case NoMore:
                    return "OMX.Error.NoMore";
                case VersionMismatch:
                    return "OMX.Error.VersionMismatch";
                case NotReady:
                    return "OMX.Error.NotReady";
                case Timeout:
                    return "OMX.Error.Timeout";
                case SameState:
                    return "OMX.Error.SameState";
                case ResourcesPreempted:
                    return "OMX.Error.ResourcesPreempted";
                case PortUnresponsiveDuringAllocation:
                    return "OMX.Error.PortUnresponsiveDuringAllocation";
                case PortUnresponsiveDuringDeallocation:
                    return "OMX.Error.PortUnresponsiveDuringDeallocation";
                case PortUnresponsiveDuringStop:
                    return "OMX.Error.PortUnresponsiveDuringStop";
                case IncorrectStateTransition:
                    return "OMX.Error.IncorrectStateTransition";
                case IncorrectStateOperation:
                    return "OMX.Error.IncorrectStateOperation";
                case UnsupportedSetting:
                    return "OMX.Error.UnsupportedSetting";
                case UnsupportedIndex:
                    return "OMX.Error.UnsupportedIndex";
                case BadPortIndex:
                    return "OMX.Error.BadPortIndex";
                case PortUnpopulated:
                    return "OMX.Error.PortUnpopulated";
                case ComponentSuspended:
                    return "OMX.Error.ComponentSuspended";
                case DynamicResourcesUnavailable:
                    return "OMX.Error.DynamicResourcesUnavailable";
                case MbErrorsInFrame:
                    return "OMX.Error.MbErrorsInFrame";
                case FormatNotDetected:
                    return "OMX.Error.FormatNotDetected";
                case ContentPipeOpenFailed:
                    return "OMX.Error.ContentPipeOpenFailed";
                case ContentPipeCreationFailed:
                    return "OMX.Error.ContentPipeCreationFailed";
                case SeperateTablesUsed:
                    return "OMX.Error.SeperateTablesUsed";
                case TunnelingUnsupported:
                    return "OMX.Error.TunnelingUnsupported";
                case KhronosExtensions:
                    return "OMX.Error.KhronosExtensions";
                case VendorStartUnused:
                    return "OMX.Error.VendorStartUnused";
                case Max:
                    return "OMX.Error.Max";
                default:
                    return "(unknown)";
            }
        }
    }

    [Flags]
    [CCode (cprefix="OMX_BUFFERFLAG_")]
    public enum BufferFlag {
        EOS,
        STARTTIME,
        DECODEONLY,
        DATACORRUPT,
        ENDOFFRAME,
        SYNCFRAME,
        EXTRADATA,
        CODECCONFIG
    }

    [CCode (cname="OMX_BUFFERHEADERTYPE", default_value="NULL", ref_function = "", unref_function = "")]
    public class BufferHeader {
        [CCode (cname="nSize")]
        public uint32 size;

        [CCode (cname="nVersion")]
        public Version version;

        [CCode (cname="pBuffer",array_length_cname = "nAllocLen")]
        public char[] buffer;

        [CCode (cname="nAllocLen")]
        public uint32 alloc_len;

        [CCode (cname="nFilledLen")]
        public uint32 filled_len;

        [CCode (cname="nOffset")]
        public uint32 offset;

        [CCode (cname="pAppPrivate")]
        public void *app_private;

        [CCode (cname="pPlatformPrivate")]
        public void *platform_private;

        [CCode (cname="pInputPortPrivate")]
        public void *input_port_private;

        [CCode (cname="pOutputPortPrivate")]
        public void *output_port_private;

        [CCode (cname="hMarkTargetComponent")]
        public Handle mark_target_component;

        [CCode (cname="pMarkData")]
        public void *mark_data;

        [CCode (cname="nTickCount")]
        public uint32 tick_count;

        [CCode (cname="nTimeStamp")]
        public int64 timestamp;

        [CCode (cname="nFlags")]
        public uint32 flags;

        [CCode (cname="nOutputPortIndex")]
        public uint32 output_port_index;

        [CCode (cname="nInputPortIndex")]
        public uint32 input_port_index;
    }

    [CCode (cname="OMX_PORT_PARAM_TYPE")]
    public struct Param {
        [CCode (cname="nSize")]
        uint32 size;

        [CCode (cname="nVersion")]
        Version version;

        [CCode (cname="nPorts")]
        uint32 ports;

        [CCode (cname="nStartPortNumber")]
        uint32 start_port_number;
    }

    [CCode (cname="OMX_EVENTTYPE", cprefix="OMX_Event")]
    public enum Event {
        CmdComplete,
        Error,
        Mark,
        PortSettingsChanged,
        BufferFlag,
        ResourcesAcquired,
        ComponentResumed,
        DynamicResourcesAvailable,
        PortFormatDetected,
        KhronosExtensions,
        VendorStartUnused,
        Max;

        public string to_string() {
            switch(this) {
                case CmdComplete:
                    return "OMX.Event.CmdComplete";
                case Error:
                    return "OMX.Event.Error";
                case Mark:
                    return "OMX.Event.Mark";
                case PortSettingsChanged:
                    return "OMX.Event.PortSettingsChanged";
                case BufferFlag:
                    return "OMX.Event.BufferFlag";
                case ResourcesAcquired:
                    return "OMX.Event.ResourcesAcquired";
                case ComponentResumed:
                    return "OMX.Event.ComponentResumed";
                case DynamicResourcesAvailable:
                    return "OMX.Event.DynamicResourcesAvailable";
                case PortFormatDetected:
                    return "OMX.Event.PortFormatDetected";
                case KhronosExtensions:
                    return "OMX.Event.KhronosExtensions";
                case VendorStartUnused:
                    return "OMX.Event.VendorStartUnused";
                case Max:
                    return "OMX.Event.Max";
                default:
                    return "(unknown)";
            }
        }
    }

    [CCode (instance_pos=1.1)]
    public delegate Error EventHandlerFunc(
        Handle component,
        Event event,
        uint32 data1,
        uint32 data2,
        void *event_data);

    [CCode (instance_pos=1.1)]
    public delegate Error EmptyBufferDoneFunc(
        Handle component,
        BufferHeader buffer);

    [CCode (instance_pos=1.1)]
    public delegate Error FillBufferDoneFunc(
        Handle component,
        BufferHeader buffer);

    [CCode (cname="OMX_CALLBACKTYPE")]
    public struct Callback {
        [CCode (cname="EventHandler")]
        public EventHandlerFunc event_handler;

        [CCode (cname="EmptyBufferDone")]
        public EmptyBufferDoneFunc empty_buffer_done;

        [CCode (cname="FillBufferDone")]
        public FillBufferDoneFunc fill_buffer_done;
    }

    [CCode (cname="OMX_BUFFERSUPPLIERTYPE", cprefix="OMX_BufferSupply")]
    public enum BufferSupplier {
        Unspecified,
        Input,
        Output,
        KhronosExtensions,
        VendorStartUnused,
        Max
    }

    [Flags]
    [CCode (cprefix="OMX_PORTTUNNELFLAG_")]
    public enum PortTunnelFlag {
        READONLY
    }

    [SimpleType]
    [CCode (cname="OMX_HANDLETYPE", cheader_filename="OMX_Component.h", default_value="NULL")]
    public struct Handle {
        [CCode (cname="OMX_SendCommand")]
        public Error send_command(Command cmd, int param, void *cmd_data);

        [CCode (cname="OMX_UseBuffer")]
        public Error use_buffer(out BufferHeader buffer, int n_port, void *app_priv, uint n_bytes, char *pbuffer);

        [CCode (cname="OMX_AllocateBuffer")]
        public Error allocate_buffer(out BufferHeader buffer, int n_port, void *app_priv, uint n_bytes);

        [CCode (cname="OMX_FreeBuffer")]
        public Error free_buffer(int n_port, BufferHeader buffer);

        [CCode (cname="OMX_EmptyThisBuffer")]
        public Error empty_this_buffer(BufferHeader buffer);

        [CCode (cname="OMX_FillThisBuffer")]
        public Error fill_this_buffer(BufferHeader buffer);

        [CCode (cname="OMX_FreeHandle")]
        public Error free_handle();

        [CCode (cname="OMX_GetConfig")]
        public Error get_config(Handle component, int config_index, void *component_config_structure);
        
        [CCode (cname="OMX_SetConfig")]
        public Error set_config(Handle component, int config_index, void *component_config_structure);

        [CCode (cname="OMX_GetExtensionIndex")]
        public Error get_extension_index(Handle component, string parameter_name, out int index_type);

        [CCode (cname="OMX_GetState")]
        public Error get_state(Handle component, out State state);

        [CCode (cname="OMX_GetParameter")]
        public Error get_parameter(Handle component, int param_index, void *component_parameter_structure);

        [CCode (cname="OMX_SetParameter")]
        public Error set_parameter(Handle component, int param_index, void *component_parameter_structure);
    }

    [CCode (cname="OMX_Init")]
    public Error init();

    [CCode (cname="OMX_Deinit")]
    public Error deinit();

    [CCode (cname="OMX_GetHandle", cheader_filename="OMX_Component.h")]
    public Error get_handle(out Handle component, string component_name, void *app_data, Callback callbacks);

    [CCode (cname="OMX_SetupTunnel")]
    public Error setup_tunnel(Handle output, uint32 port_output, Handle input, uint32 port_input);

    [CCode (cname="OMX_DIRTYPE", cprefix="OMX_Dir")]
    public enum Dir {
        Input,
        Output,
        Max
    }

    [CCode (cname="OMX_INDEXTYPE", cprefix="OMX_Index")]
    public enum Index {
        ComponentStartUnused,
        ParamPriorityMgmt,
        ParamAudioInit,
        ParamImageInit,
        ParamVideoInit,
        ParamOtherInit,
        ParamNumAvailableStreams,
        ParamActiveStream,
        ParamSuspensionPolicy,
        ParamComponentSuspended,
        ConfigCapturing,
        ConfigCaptureMode,
        AutoPauseAfterCapture,
        ParamContentURI,
        ParamCustomContentPipe,
        ParamDisableResourceConcealment,
        ConfigMetadataItemCount,
        ConfigContainerNodeCount,
        ConfigMetadataItem,
        ConfigCounterNodeID,
        ParamMetadataFilterType,
        ParamMetadataKeyFilter,
        ConfigPriorityMgmt,
        ParamStandardComponentRole,

        PortStartUnused,
        ParamPortDefinition,
        ParamCompBufferSupplier,
        ReservedStartUnused,

        AudioStartUnused,
        ParamAudioPortFormat,
        ParamAudioPcm,
        ParamAudioAac,
        ParamAudioRa,
        ParamAudioMp3,
        ParamAudioAdpcm,
        ParamAudioG723,
        ParamAudioG729,
        ParamAudioAmr,
        ParamAudioWma,
        ParamAudioSbc,
        ParamAudioMidi,
        ParamAudioGsm_FR,
        ParamAudioMidiLoadUserSound,
        ParamAudioG726,
        ParamAudioGsm_EFR,
        ParamAudioGsm_HR,
        ParamAudioPdc_FR,
        ParamAudioPdc_EFR,
        ParamAudioPdc_HR,
        ParamAudioTdma_FR,
        ParamAudioTdma_EFR,
        ParamAudioQcelp8,
        ParamAudioQcelp13,
        ParamAudioEvrc,
        ParamAudioSmv,
        ParamAudioVorbis,

        ConfigAudioMidiImmediateEvent,
        ConfigAudioMidiControl,
        ConfigAudioMidiSoundBankProgram,
        ConfigAudioMidiStatus,
        ConfigAudioMidiMetaEvent,
        ConfigAudioMidiMetaEventData,
        ConfigAudioVolume,
        ConfigAudioBalance,
        ConfigAudioChannelMute,
        ConfigAudioMute,
        ConfigAudioLoudness,
        ConfigAudioEchoCancelation,
        ConfigAudioNoiseReduction,
        ConfigAudioBass,
        ConfigAudioTreble,
        ConfigAudioStereoWidening,
        ConfigAudioChorus,
        ConfigAudioEqualizer,
        ConfigAudioReverberation,
        ConfigAudioChannelVolume,

        ImageStartUnused,
        ParamImagePortFormat,
        ParamFlashControl,
        ConfigFocusControl,
        ParamQFactor,
        ParamQuantizationTable,
        ParamHuffmanTable,
        ConfigFlashControl,

        VideoStartUnused,
        ParamVideoPortFormat,
        ParamVideoQuantization,
        ParamVideoFastUpdate,
        ParamVideoBitrate,
        ParamVideoMotionVector,
        ParamVideoIntraRefresh,
        ParamVideoErrorCorrection,
        ParamVideoVBSMC,
        ParamVideoMpeg2,
        ParamVideoMpeg4,
        ParamVideoWmv,
        ParamVideoRv,
        ParamVideoAvc,
        ParamVideoH263,
        ParamVideoProfileLevelQuerySupported,
        ParamVideoProfileLevelCurrent,
        ConfigVideoBitrate,
        ConfigVideoFramerate,
        ConfigVideoIntraVOPRefresh,
        ConfigVideoIntraMBRefresh,
        ConfigVideoMBErrorReporting,
        ParamVideoMacroblocksPerFrame,
        ConfigVideoMacroBlockErrorMap,
        ParamVideoSliceFMO,
        ConfigVideoAVCIntraPeriod,
        ConfigVideoNalSize,

        CommonStartUnused,
        ParamCommonDeblocking,
        ParamCommonSensorMode,
        ParamCommonInterleave,
        ConfigCommonColorFormatConversion,
        ConfigCommonScale,
        ConfigCommonImageFilter,
        ConfigCommonColorEnhancement,
        ConfigCommonColorKey,
        ConfigCommonColorBlend,
        ConfigCommonFrameStabilisation,
        ConfigCommonRotate,
        ConfigCommonMirror,
        ConfigCommonOutputPosition,
        ConfigCommonInputCrop,
        ConfigCommonOutputCrop,
        ConfigCommonDigitalZoom,
        ConfigCommonOpticalZoom,
        ConfigCommonWhiteBalance,
        ConfigCommonExposure,
        ConfigCommonContrast,
        ConfigCommonBrightness,
        ConfigCommonBacklight,
        ConfigCommonGamma,
        ConfigCommonSaturation,
        ConfigCommonLightness,
        ConfigCommonExclusionRect,
        ConfigCommonDithering,
        ConfigCommonPlaneBlend,
        ConfigCommonExposureValue,
        ConfigCommonOutputSize,
        ParamCommonExtraQuantData,
        ConfigCommonFocusRegion,
        ConfigCommonFocusStatus,
        ConfigCommonTransitionEffect,

        OtherStartUnused,
        ParamOtherPortFormat,
        ConfigOtherPower,
        ConfigOtherStats,

        TimeStartUnused,
        ConfigTimeScale,
        ConfigTimeClockState,
        ConfigTimeActiveRefClock,
        ConfigTimeCurrentMediaTime,
        ConfigTimeCurrentWallTime,
        ConfigTimeCurrentAudioReference,
        ConfigTimeCurrentVideoReference,
        ConfigTimeMediaTimeRequest,
        ConfigTimeClientStartTime,
        ConfigTimePosition,
        ConfigTimeSeekMode,

        KhronosExtensions,
        VendorStartUnused,
        Max
    }

    namespace Audio {
        [CCode (cname="OMX_AUDIO_CODINGTYPE", cprefix="OMX_AUDIO_Coding")]
        enum Coding {
            Unused,
            AutoDetect,
            PCM,
            ADPCM,
            AMR,
            GSMFR,
            GSMEFR,
            GSMHR,
            PDCFR,
            PDCEFR,
            PDCHR,
            TDMAFR,
            TDMAEFR,
            QCELP8,
            QCELP13,
            EVRC,
            SMV,
            G711,
            G723,
            G726,
            G729,
            AAC,
            MP3,
            SBC,
            VORBIS,
            WMA,
            RA,
            MIDI,
            KhronosExtensions,
            VendorStartUnused,
            Max
        }
    }

    namespace Video {
    }

    namespace Image {
    }

    public struct VersionDetail {
        [CCode (cname="nVersionMajor")]
        public uint8 version_major;

        [CCode (cname="nVersionMinor")]
        public uint8 version_minor;

        [CCode (cname="nRevision")]
        public uint8 revision;

        [CCode (cname="nStep")]
        public uint8 step;
    }

    [CCode (cname="OMX_VERSIONTYPE")]
    public struct Version {
        public VersionDetail s;

        [CCode (cname="nVersion")]
        public uint32 version;
    }

    [CCode (cname="__LINE__")]
    uint __LINE__;

    [CCode (cname="__FILE__")]
    uint __FILE__;

    GLib.Quark error_domain() {
        return GLib.Quark.from_string("OMX.Error");
    }

    void try_run(Error err, string file=__FILE__, int line=__LINE__) throws GLib.Error {
        if(err != Omx.Error.None) {
            var e = new GLib.Error(
                       error_domain(), err,
                       "%s:%d %s\n", file, line, err.to_string());
            throw (GLib.Error)e;
            }
    }

}

namespace Bellagio {
    
    [CCode (cname="tsem_t", cheader_filename="bellagio/tsemaphore.h", cprefix="tsem_")]
    public struct Semaphore {
        public int init(uint val);
        public Semaphore(uint val);
        public void up();
        public void down();
    }

}
