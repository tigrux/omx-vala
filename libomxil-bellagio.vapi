[CCode (cheader_filename="OMX_Core.h")]
namespace Omx {
    [CCode (cname="OMX_COMMANDTYPE", cprefix="OMX_Command")]
    public enum Command {
        StateSet,
        Flush,
        PortDisable,
        PortEnable,
        MarkBuffer;

        public string to_string() {
            switch(this) {
                case StateSet:
                    return "Omx.Command.StateSet";
                case Flush:
                    return "Omx.Command.Flush";
                case PortDisable:
                    return "Omx.Command.PortDisable";
                case PortEnable:
                    return "Omx.Command.PortEnable";
                case MarkBuffer:
                    return "Omx.Command.MarkBuffer";
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
        WaitForResources;

        public string to_string() {
            switch(this) {
                case Invalid:
                    return "Omx.State.Invalid";
                case Loaded:
                    return "Omx.State.Loaded";
                case Idle:
                    return "Omx.State.Idle";
                case Executing:
                    return "Omx.State.Executing";
                case Pause:
                    return "Omx.State.Pause";
                case WaitForResources:
                    return "Omx.State.WaitForResources";
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
        TunnelingUnsupported;

        public string to_string() {
            switch(this) {
                case None:
                    return "Omx.Error.None";
                case InsufficientResources:
                    return "Omx.Error.InsufficientResources";
                case Undefined:
                    return "Omx.Error.Undefined";
                case InvalidComponentName:
                    return "Omx.Error.InvalidComponentName";
                case ComponentNotFound:
                    return "Omx.Error.ComponentNotFound";
                case InvalidComponent:
                    return "Omx.Error.InvalidComponent";
                case BadParameter:
                    return "Omx.Error.BadParameter";
                case NotImplemented:
                    return "Omx.Error.NotImplemented";
                case Underflow:
                    return "Omx.Error.Underflow";
                case Overflow:
                    return "Omx.Error.Overflow";
                case Hardware:
                    return "Omx.Error.Hardware";
                case InvalidState:
                    return "Omx.Error.InvalidState";
                case StreamCorrupt:
                    return "Omx.Error.StreamCorrupt";
                case PortsNotCompatible:
                    return "Omx.Error.PortsNotCompatible";
                case ResourcesLost:
                    return "Omx.Error.ResourcesLost";
                case NoMore:
                    return "Omx.Error.NoMore";
                case VersionMismatch:
                    return "Omx.Error.VersionMismatch";
                case NotReady:
                    return "Omx.Error.NotReady";
                case Timeout:
                    return "Omx.Error.Timeout";
                case SameState:
                    return "Omx.Error.SameState";
                case ResourcesPreempted:
                    return "Omx.Error.ResourcesPreempted";
                case PortUnresponsiveDuringAllocation:
                    return "Omx.Error.PortUnresponsiveDuringAllocation";
                case PortUnresponsiveDuringDeallocation:
                    return "Omx.Error.PortUnresponsiveDuringDeallocation";
                case PortUnresponsiveDuringStop:
                    return "Omx.Error.PortUnresponsiveDuringStop";
                case IncorrectStateTransition:
                    return "Omx.Error.IncorrectStateTransition";
                case IncorrectStateOperation:
                    return "Omx.Error.IncorrectStateOperation";
                case UnsupportedSetting:
                    return "Omx.Error.UnsupportedSetting";
                case UnsupportedIndex:
                    return "Omx.Error.UnsupportedIndex";
                case BadPortIndex:
                    return "Omx.Error.BadPortIndex";
                case PortUnpopulated:
                    return "Omx.Error.PortUnpopulated";
                case ComponentSuspended:
                    return "Omx.Error.ComponentSuspended";
                case DynamicResourcesUnavailable:
                    return "Omx.Error.DynamicResourcesUnavailable";
                case MbErrorsInFrame:
                    return "Omx.Error.MbErrorsInFrame";
                case FormatNotDetected:
                    return "Omx.Error.FormatNotDetected";
                case ContentPipeOpenFailed:
                    return "Omx.Error.ContentPipeOpenFailed";
                case ContentPipeCreationFailed:
                    return "Omx.Error.ContentPipeCreationFailed";
                case SeperateTablesUsed:
                    return "Omx.Error.SeperateTablesUsed";
                case TunnelingUnsupported:
                    return "Omx.Error.TunnelingUnsupported";
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

    public struct Structure {
        [CCode (cname="nSize")]
        ulong size;

        [CCode (cname="nVersion")]
        Version version;
    }

    public struct PortStructure: Structure {
        [CCode (cname="nPortIndex")]
        uint32 port_index;
    }

    [CCode (cname="OMX_BUFFERHEADERTYPE", default_value="NULL", ref_function = "", unref_function = "")]
    public class BufferHeader {
        [CCode (cname="nSize")]
        ulong size;

        [CCode (cname="nVersion")]
        Version version;

        [CCode (cname="pBuffer",array_length_cname = "nAllocLen")]
        public uint8[] buffer;

        [CCode (cname="nAllocLen")]
        public size_t alloc_len;

        [CCode (cname="nFilledLen")]
        public size_t filled_len;

        [CCode (cname="nOffset")]
        public size_t offset;

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
        public int64 time_stamp;

        [CCode (cname="nFlags")]
        public uint32 flags;

        [CCode (cname="nOutputPortIndex")]
        public uint32 output_port_index;

        [CCode (cname="nInputPortIndex")]
        public uint32 input_port_index;
    }

    namespace Port {
        [CCode (cname="OMX_PORT_PARAM_TYPE")]
        public struct Param: Structure {
            [CCode (cname="nPorts")]
            uint32 ports;

            [CCode (cname="nStartPortNumber")]
            uint32 start_port_number;
        }
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
        PortFormatDetected;

        public string to_string() {
            switch(this) {
                case CmdComplete:
                    return "Omx.Event.CmdComplete";
                case Error:
                    return "Omx.Event.Error";
                case Mark:
                    return "Omx.Event.Mark";
                case PortSettingsChanged:
                    return "Omx.Event.PortSettingsChanged";
                case BufferFlag:
                    return "Omx.Event.BufferFlag";
                case ResourcesAcquired:
                    return "Omx.Event.ResourcesAcquired";
                case ComponentResumed:
                    return "Omx.Event.ComponentResumed";
                case DynamicResourcesAvailable:
                    return "Omx.Event.DynamicResourcesAvailable";
                case PortFormatDetected:
                    return "Omx.Event.PortFormatDetected";
                default:
                    return "(unknown)";
            }
        }
    }

    [CCode (cname="OMX_PORTDOMAINTYPE", cprefix="OMX_PortDomain")]
    enum PortDomain {
        Audio,
        Video,
        Image,
        Other
    }

    [CCode (cname="OMX_MARKTYPE")]
    struct Mark {
        [CCode (cname="hMarkTargetComponent")]
        Handle mark_target_component;

        [CCode (cname="pMarkData")]
        void *mark_data;
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
        Output
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
        public Error get_config(int config_index, ref PortStructure config_structure);

        [CCode (cname="OMX_SetConfig")]
        public Error set_config(int config_index, ref PortStructure config_structure);

        [CCode (cname="OMX_GetExtensionIndex")]
        public Error get_extension_index(string parameter_name, out int index_type);

        [CCode (cname="OMX_GetState")]
        public Error get_state(out State state);

        [CCode (cname="OMX_GetParameter")]
        public Error get_parameter(int param_index, ref PortStructure parameter_structure);

        [CCode (cname="OMX_SetParameter")]
        public Error set_parameter(int param_index, ref PortStructure parameter_structure);
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
        Output
    }

    [CCode (cname="OMX_ENDIANTYPE", cprefix="OMX_Endian")]
    enum Endian {
        Big,
        Little
    }

    [CCode (cname="OMX_NUMERICALDATATYPE", cprefix="OMX_NumericalData")]
    enum NumericalData {
        Signed,
        Unsigned
    }

    [CCode (cname="OMX_BS32")]
    struct bounded {
        [CCode (cname="nValue")]
        int32 value;

        [CCode (cname="nMin")]
        int32 min;

        [CCode (cname="nMax")]
        int32 max;
    }

    [CCode (cname="OMX_BU32")]
    struct ubounded {
        [CCode (cname="nValue")]
        uint32 value;

        [CCode (cname="nMin")]
        uint32 min;

        [CCode (cname="nMax")]
        uint32 max;
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
        ConfigTimeSeekMode
    }

    namespace Native {
        [SimpleType]
        [CCode (cname="OMX_NATIVE_DEVICETYPE", default_value="NULL")]
        struct Device {
        }

        [SimpleType]
        [CCode (cname="OMX_NATIVE_WINDOWTYPE", default_value="NULL")]
        struct Window {
        }
    }

    namespace Param {
        [CCode (cname="OMX_PARAM_BUFFERSUPPLIERTYPE")]
        struct BufferSupplier: PortStructure {
            [CCode (cname="eBufferSupplier")]
            Omx.BufferSupplier buffer_supplier;
        }

        struct FormatDetail {
            Audio.PortDefinition audio;
            Video.PortDefinition video;
            Image.PortDefinition image;
            Other.PortDefinition other;
        }

        [CCode (cname="OMX_PARAM_PORTDEFINITIONTYPE")]
         struct PortDefinition : PortStructure {
            [CCode (cname="eDir")]
            Dir dir;

            [CCode (cname="nBufferCountActual")]
            uint32 buffer_count_actual;

            [CCode (cname="nBufferCountMin")]
            uint32 buffer_count_min;

            [CCode (cname="nBufferSize")]
            uint32 buffer_size;

            [CCode (cname="bEnabled")]
            bool enabled;

            [CCode (cname="bPopulated")]
            bool populated;

            [CCode (cname="eDomain")]
            PortDomain domain;

            FormatDetail format;

            [CCode (cname="bBuffersContiguous")]
            bool buffers_contiguous;

            [CCode (cname="nBufferAlignment")]
            uint32 buffer_alignment;
        }

        [CCode (cname="OMX_PARAM_SENSORMODETYPE")]
        struct SensorMode: PortStructure {
            [CCode (cname="nFrameRate")]
            uint32 frame_rate;

            [CCode (cname="bOneShot")]
            bool one_shot;

            [CCode (cname="sFrameSize")]
            FrameSize frame_size;
        }
    } //ns Param

    namespace Config {
        [CCode (cname="OMX_CONFIG_BRIGHTNESSTYPE")]
        struct Brightness: PortStructure {
            [CCode (cname="nBrightness")]
            uint32 brightness;
        }

        [CCode (cname="OMX_CONFIG_COLORBLENDTYPE")]
        struct ColorBlend: PortStructure {
            [CCode (cname="nRGBAlphaConstant")]
            uint32 rgb_alpha_constant;

            [CCode (cname="eColorBlend")]
            Omx.ColorBlend color_blend;
        }

        [CCode (cname="OMX_CONFIG_CONTRASTTYPE")]
        struct Constrast: PortStructure {
            [CCode (cname="nContrast")]
            uint32 constrast;
        }

        [CCode (cname="OMX_CONFIG_EXPOSURECONTROLTYPE")]
        struct ExposureControl: PortStructure {
            [CCode (cname="eExposureControl")]
            Omx.ExposureControl exposure_control;
        }

        [CCode (cname="OMX_CONFIG_FRAMESTABTYPE")]
        struct FrameStab: PortStructure {
            [CCode (cname="bStab")]
            bool stab;
        }

        [CCode (cname="OMX_CONFIG_MIRRORTYPE")]
        struct Mirror: PortStructure {
            [CCode (cname="eMirror")]
            Omx.Mirror mirror;
        }

        [CCode (cname="OMX_CONFIG_POINTTYPE")]
        struct Point: PortStructure {
            [CCode (cname="nX")]
            int32 x;

            [CCode (cname="nY")]
            int32 y;
        }

        [CCode (cname="OMX_CONFIG_RECTTYPE")]
        struct Rect: PortStructure {
            [CCode (cname="nLeft")]
            uint32 left;

            [CCode (cname="nTop")]
            uint32 top;

            [CCode (cname="nWidth")]
            uint32 width;

            [CCode (cname="nHeight")]
            uint32 height;
        }

        [CCode (cname="OMX_CONFIG_ROTATIONTYPE")]
        struct Rotation: PortStructure {
            [CCode (cname="nRotation")]
            int32 rotation;
        }

        [CCode (cname="OMX_CONFIG_SCALEFACTORTYPE")]
        struct ScaleFactor: PortStructure {
            [CCode (cname="xWidth")]
            int32 width;

            [CCode (cname="xHeight")]
            int32 height;
        }

        [CCode (cname="OMX_CONFIG_WHITEBALCONTROLTYPE")]
        struct WhiteBalControl: PortStructure {
            [CCode (cname="eWhiteBalControl")]
            Omx.WhiteBalControl white_bal_control;
        }
    } //ns Config

    [CCode (cname="OMX_COLORBLENDTYPE", cprefix="OMX_ColorBlend")]
    enum ColorBlend {
        None,
        AlphaConstant,
        AlphaPerPixel,
        Alternate,
        And,
        Or,
        Invert,
    }

    [CCode (cname="OMX_EXPOSURECONTROLTYPE", cprefix="OMX_ExposureControl")]
    enum ExposureControl {
        Off,
        Auto,
        Night,
        BackLight,
        SpotLight,
        Sports,
        Snow,
        Beach,
        LargeAperture,
        SmallApperture
    }

    [CCode (cname="OMX_MIRRORTYPE", cprefix="OMX_Mirror")]
    enum Mirror {
        None,
        Vertical,
        Horizontal,
        Both,
    }

    [CCode (cname="OMX_WHITEBALCONTROLTYPE", cprefix="OMX_WhiteBalControl")]
    enum WhiteBalControl {
        Off,
        Auto,
        SunLight,
        Cloudy,
        Shade,
        Tungsten,
        Fluorescent,
        Incandescent,
        Flash,
        Horizon
    }

    struct FrameSize: PortStructure {
        [CCode (cname="nWidth")]
        uint32 width;

        [CCode (cname="nHeight")]
        uint32 height;
    }

    [CCode (cheader_filename="OMX_Component.h")]
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
            MIDI
        }

        [CCode (cname="OMX_AUDIO_PORTDEFINITIONTYPE")]
        struct PortDefinition {
            [CCode (cname="cMIMEType")]
            string mime_type;

            [CCode (cname="pNativeRender")]
            Native.Device native_render;

            [CCode (cname="bFlagErrorConcealment")]
            bool flag_error_concealment;

            [CCode (cname="eEncoding")]
            Coding encoding;
        }

        namespace Param {
            [CCode (cname="OMX_AUDIO_PARAM_PORTFORMATTYPE")]
            struct PortFormat: PortStructure {
                [CCode (cname="Index")]
                uint32 index;

                [CCode (cname="eEncoding")]
                Coding encoding;
            }

            [CCode (cname="OMX_AUDIO_PARAM_PCMMODETYPE")]
            struct PcmMode: PortStructure {
                [CCode (cname="nChannels")]
                uint32 channels;

                [CCode (cname="eNumData")]
                NumericalData num_data;

                [CCode (cname="eEndian")]
                Endian endian;

                [CCode (cname="bInterleaved")]
                bool interleaved;

                [CCode (cname="nBitPerSample")]
                uint32 bit_per_sample;

                [CCode (cname="nSamplingRate")]
                uint32 sampling_rate;

                [CCode (cname="ePCMMode")]
                Audio.PcmMode pcm_mode;

                [CCode (cname="eChannelMapping", array_length = false)]
                weak Channel[] channel_mapping;
            }

            [CCode (cname="OMX_AUDIO_PARAM_MP3TYPE")]
            struct Mp3: PortStructure {
                [CCode (cname="nChannels")]
                uint32 channels;

                [CCode (cname="nBitRate")]
                uint32 bit_rate;

                [CCode (cname="nSampleRate")]
                uint32 sample_rate;

                [CCode (cname="nAudioBandWidth")]
                uint32 audio_band_width;

                [CCode (cname="eChannelMode")]
                ChannelMode channel_mode;

                [CCode (cname="eFormat")]
                Mp3StreamFormat format;
            }

            [CCode (cname="OMX_AUDIO_PARAM_AACPROFILETYPE")]
            struct AacProfile: PortStructure {
                [CCode (cname="nChannels")]
                uint32 channels;

                [CCode (cname="nSampleRate")]
                uint32 sample_rate;

                [CCode (cname="nBitRate")]
                uint32 bit_rate;

                [CCode (cname="nAudioBandWidth")]
                uint32 audio_band_width;

                [CCode (cname="nFrameLength")]
                uint32 frame_length;

                [CCode (cname="nAACtools")]
                uint32 tools;

                [CCode (cname="nAACERtools")]
                uint32 er_tools;

                [CCode (cname="eAACProfile")]
                Audio.AacProfile profile;

                [CCode (cname="eAACStreamFormat")]
                AacStreamFormat stream_format;

                [CCode (cname="eChannelMode")]
                ChannelMode channel_mode;
            }

            [CCode (cname="OMX_AUDIO_PARAM_VORBISTYPE")]
            struct Vorbis: PortStructure {
                [CCode (cname="nChannels")]
                uint32 channels;

                [CCode (cname="nBitRate")]
                uint32 bit_rate;

                [CCode (cname="nMaxBitRate")]
                uint32 max_bit_rate;

                [CCode (cname="nSampleRate")]
                uint32 sample_rate;

                [CCode (cname="nAudioBandWidth")]
                uint32 audio_band_width;

                [CCode (cname="nQuality")]
                int32 quality;

                [CCode (cname="bManaged")]
                bool managed;

                [CCode (cname="bDownmix")]
                bool downmix;
            }

            [CCode (cname="OMX_AUDIO_PARAM_WMATYPE")]
            struct Wma: PortStructure {
                [CCode (cname="nChannels")]
                uint16 channels;

                [CCode (cname="nBitRate")]
                uint32 bit_rate;

                [CCode (cname="eFormat")]
                WmaFormat format;

                [CCode (cname="eProfile")]
                WmaProfile profile;

                [CCode (cname="nSamplingRate")]
                uint32 sampling_rate;

                [CCode (cname="nBlockAlign")]
                uint16 block_align;

                [CCode (cname="nEncodeOptions")]
                uint16 encode_options;

                [CCode (cname="nSuperBlockAlign")]
                uint32 super_block_align;
            }

            [CCode (cname="OMX_AUDIO_PARAM_AMRTYPE")]
            struct Amr: PortStructure {
                [CCode (cname="nChannels")]
                uint32 channels;

                [CCode (cname="nBitRate")]
                uint32 bit_rate;

                [CCode (cname="eAMRBandMode")]
                AmrBandMode band_mode;

                [CCode (cname="eAMRDTXMode")]
                AmrDtxMode  dtx_mode;

                [CCode (cname="eAMRFrameFormat")]
                AmrFrameFormat frame_format;
            }

            [CCode (cname="OMX_AUDIO_PARAM_GSMFRTYPE")]
            struct GsmFr: PortStructure {
                [CCode (cname="bDTX")]
                bool dtx;

                [CCode (cname="bHiPassFilter")]
                bool hi_pass_filter;
            }

            [CCode (cname="OMX_AUDIO_PARAM_GSMHRTYPE")]
            struct GsmHr: PortStructure {
                [CCode (cname="bDTX")]
                bool dtx;

                [CCode (cname="bHiPassFilter")]
                bool hi_pass_filter;
            }

            [CCode (cname="OMX_AUDIO_PARAM_GSMEFRTYPE")]
            struct GsmEfr: PortStructure {
                [CCode (cname="bDTX")]
                bool dtx;

                [CCode (cname="bHiPassFilter")]
                bool hi_pass_filter;
            }
        } //ns Param

        [CCode (cname="OMX_AUDIO_PCMMODETYPE", cprefix="OMX_AUDIO_PCMMode")]
        enum PcmMode {
            Linear,
            ALaw,
            MULaw
        }

        [CCode (cname="OMX_AUDIO_MAXCHANNELS")]
        const int MAX_CHANNELS;

        [CCode (cname="OMX_AUDIO_CHANNELTYPE", cprefix="OMX_AUDIO_Channel")]
        enum Channel {
            None,
            LF,
            RF,
            CF,
            LS,
            RS,
            LFE,
            CS,
            LR,
            RR
        }

        [CCode (cname="OMX_AUDIO_CHANNELMODETYPE", cprefix="OMX_AUDIO_ChannelMode")]
        enum ChannelMode {
            Stereo,
            JointStereo,
            Dual,
            Mono
        }

        [CCode (cname="OMX_AUDIO_MP3STREAMFORMATTYPE", cprefix="OMX_AUDIO_MP3StreamFormat")]
        enum Mp3StreamFormat {
            MP1Layer3,
            MP2Layer3,
            MP2_5Layer3
        }

        [CCode (name="OMX_AUDIO_AACSTREAMFORMATTYPE", cprefix="OMX_AUDIO_AACStreamFormat")]
        enum AacStreamFormat {
           MP2ADTS,
           MP4ADTS,
           MP4LOAS,
           MP4LATM,
           ADIF,
           MP4FF,
           RAW
        }

        [CCode (name="OMX_AUDIO_AACPROFILETYPE", cprefix="OMX_AUDIO_AACObject")]
        enum AacProfile {
          Null,
          Main,
          LC,
          SSR,
          LTP,
          HE,
          Scalable,
          ERLC,
          LD,
          HE_PS
        }

        [Flags]
        [CCode (cprefix="OMX_AUDIO_AACTool")]
        public enum AacTool {
            None,
            MS,
            IS,
            TNS,
            PNS,
            LTP
        }

        [Flags]
        [CCode (cprefix="OMX_AUDIO_AACER")]
        public enum AacEr {
            None,
            VCB11,
            RVLC,
            HCR,
            All
        }

        [CCode (cname="OMX_AUDIO_WMAFORMATTYPE", cprefix="OMX_AUDIO_WMAFormat")]
        enum WmaFormat {
          Unused,
          @7,
          @8,
          @9
        }

        [CCode (cname="OMX_AUDIO_WMAPROFILETYPE", cprefix="OMX_AUDIO_WMAProfile")]
        enum WmaProfile {
          Unused,
          L1,
          L2,
          L3
        }

        [CCode (cname="OMX_AUDIO_AMRFRAMEFORMATTYPE", cprefix="OMX_AUDIO_AMRFrameFormat")]
        enum AmrFrameFormat {
            Conformance,
            IF1,
            IF2,
            FSF,
            RTPPayload,
            ITU
        }

        [CCode (cname="OMX_AUDIO_AMRBANDMODETYPE", cprefix="OMX_AUDIO_AMRBandMode")]
        enum AmrBandMode {
            Unused,
            NB0,
            NB1,
            NB2,
            NB3,
            NB4,
            NB5,
            NB6,
            NB7,
            WB0,
            WB1,
            WB2,
            WB3,
            WB4,
            WB5,
            WB6,
            WB7,
            WB8
        }

        [CCode (cname="OMX_AUDIO_AMRDTXMODETYPE", cprefix="OMX_AUDIO_AMRDTXMode")]
        enum AmrDtxMode {
            Off,
            OnVAD1,
            OnVAD2,
            OnAuto,
            [CCode (cname="OMX_AUDIO_AMRDTXasEFR")]
            asEFR
        }

        namespace Config {
            [CCode (cname="OMX_AUDIO_CONFIG_VOLUMETYPE")]
            struct Volume: PortStructure {
                [CCode (cname="bLinear")]
                bool linear;

                [CCode (cname="sVolume")]
                bounded volume;
            }

            [CCode (cname="OMX_AUDIO_CONFIG_CHANNELVOLUMETYPE")]
            struct ChannelVolume: PortStructure {
                [CCode (cname="nChannel")]
                uint32 channel;

                [CCode (cname="bLinear")]
                bool linear;

                [CCode (cname="sVolume")]
                bounded volume;

                [CCode (cname="bIsMIDI")]
                bool is_midi;
            }

            [CCode (cname="OMX_AUDIO_CONFIG_BALANCETYPE")]
            struct Balance: PortStructure {
                [CCode (cname="nBalance")]
                int32 balance;
            }

            [CCode (cname="OMX_AUDIO_CONFIG_MUTETYPE")]
            struct Mute: PortStructure {
                [CCode (cname="bMute")]
                bool mute;
            }

            [CCode (cname="OMX_AUDIO_CONFIG_CHANNELMUTETYPE")]
            struct ChannelMute: PortStructure {
                [CCode (cname="nChannel")]
                uint32 channel;

                [CCode (cname="bMute")]
                bool mute;

                [CCode (cname="bIsMIDI")]
                bool is_midi;
            }
        } //ns Config
    } //ns Audio

    [CCode (cheader_filename="OMX_Component.h")]
    namespace Video {
        [CCode (cname="OMX_VIDEO_CODINGTYPE", cprefix="OMX_VIDEO_Coding")]
        enum Coding {
            Unused,
            AutoDetect,
            MPEG2,
            H263,
            MPEG4,
            WMV,
            RV,
            AVC,
            MJPEG
        }

        [CCode (cname="OMX_VIDEO_PORTDEFINITIONTYPE")]
        struct PortDefinition {
            [CCode (cname="cMIMEType")]
            string mime_type;

            [CCode (cname="pNativeRender")]
            Native.Device native_Render;

            [CCode (cname="nFrameWidth")]
            uint32 frame_width;

            [CCode (cname="nFrameHeight")]
            uint32 frame_height;

            [CCode (cname="nStride")]
            int32 stride;

            [CCode (cname="nSliceHeight")]
            uint32 slice_height;

            [CCode (cname="nBitrate")]
            uint32 bitrate;

            [CCode (cname="xFramerate")]
            uint32 framerate;

            [CCode (cname="bFlagErrorConcealment")]
            bool flag_error_concealment;

            [CCode (cname="eCompressionFormat")]
            Video.Coding compression_format;

            [CCode (cname="eColorFormat")]
            Color.Format color_format;

            [CCode (cname="pNativeWindow")]
            Native.Window native_window;
        }

        [CCode (cname="OMX_VIDEO_AVCLEVELTYPE", cprefix="OMX_VIDEO_AVCLevel")]
        enum AvcLevel {
            @1,
            @1b,
            @11,
            @12,
            @13,
            @2,
            @21,
            @22,
            @3,
            @31,
            @32,
            @4,
            @41,
            @42,
            @5,
            @51
        }

        [CCode (cname="OMX_VIDEO_AVCPROFILETYPE", cprefix="OMX_VIDEO_AVCProfile")]
        enum AvcProfile {
            Baseline,
            Main,
            Extended,
            High,
            High10,
            High422,
            High444
        }

        [CCode (cname="OMX_VIDEO_AVCLOOPFILTERTYPE", cprefix="OMX_VIDEO_AVCLoopFilter")]
        enum AvcLoopFilter {
            Enable,
            Disable,
            DisableSliceBoundary
        }

        [CCode (cname="OMX_VIDEO_H263LEVELTYPE", cprefix="OMX_VIDEO_H263Level")]
        enum H263Level {
            @10,
            @20,
            @30,
            @40,
            @45,
            @50,
            @60,
            @70
        }

        [CCode (cname="OMX_VIDEO_MPEG4LEVELTYPE", cprefix="OMX_VIDEO_MPEG4Level")]
        enum Mpeg4Level {
            @0,
            @0b,
            @1,
            @2,
            @3,
            @4,
            @4a,
            @5
        }

        [CCode (cname="OMX_VIDEO_CONTROLRATETYPE", cprefix="OMX_Video_ControlRate")]
        enum ControlRate {
            Disable,
            Variable,
            Constant,
            VariableSkipFrames,
            ConstantSkipFrames
        }

        [CCode (cname="OMX_VIDEO_H263PROFILETYPE", cprefix="OMX_VIDEO_H263Profile")]
        enum H263Profile {
            Baseline,
            H320Coding,
            BackwardCompatible,
            ISWV2,
            ISWV3,
            HighCompression,
            Internet,
            Interlace,
            HighLatency
        }

        [CCode (cname="OMX_VIDEO_MPEG4PROFILETYPE", cprefix="OMX_VIDEO_MPEG4Profile")]
        enum Mpeg4Profile {
            Simple,
            SimpleScalable,
            Core,
            Main,
            Nbit,
            ScalableTexture,
            SimpleFace,
            SimpleFBA,
            BasicAnimated,
            Hybrid,
            AdvancedRealTime,
            CoreScalable,
            AdvancedCoding,
            AdvancedCore,
            AdvancedScalable,
            AdvancedSimple
        }

        namespace Param {
            [CCode (cname="OMX_VIDEO_PARAM_AVCTYPE")]
            struct Avc: PortStructure {
                [CCode (cname="nSliceHeaderSpacing")]
                uint32 slice_header_spacing;

                [CCode (cname="nPFrames")]
                uint32 p_frames;

                [CCode (cname="nBFrames")]
                uint32 b_frames;

                [CCode (cname="bUseHadamard")]
                bool use_hadamard;

                [CCode (cname="nRefFrames")]
                uint32 ref_frames;

                [CCode (cname="nRefIdx10ActiveMinus1")]
                uint32 ref_idx10_active_minus1;

                [CCode (cname="nRefIdx11ActiveMinus1")]
                uint32 ref_idx11_active_minus1;

                [CCode (cname="bEnableUEP")]
                bool enable_uep;

                [CCode (cname="bEnableFMO")]
                bool enable_fmo;

                [CCode (cname="bEnableASO")]
                bool enable_aso;

                [CCode (cname="bEnableRS")]
                bool enable_rs;

                [CCode (cname="eProfile")]
                AvcProfile profile;

                [CCode (cname="eLevel")]
                AvcLevel level;

                [CCode (cname="nAllowedPictureTypes")]
                uint32 allowed_picture_types;

                [CCode (cname="bFrameMBsOnly")]
                bool frame_mbs_only;

                [CCode (cname="bMBAFF")]
                bool mbaff;

                [CCode (cname="bEntropyCodingCABAC")]
                bool entropy_coding_cabac;

                [CCode (cname="bWeightedPPrediction")]
                bool weighted_p_prediction;

                [CCode (cname="nWeightedBipredicitonMode")]
                uint32 weighted_biprediction_mode;

                [CCode (cname="bconstIpred")]
                bool const_ipred;

                [CCode (cname="bDirect8x8Inference")]
                bool direct8x8_inference;

                [CCode (cname="bDirectSpatialTemporal")]
                bool direct_spatial_temporal;

                [CCode (cname="nCabacInitIdc")]
                uint32 cabac_init_idc;

                [CCode (cname="eLoopFilterMode")]
                AvcLoopFilter loop_Filter_mode;
            }

            [CCode (cname="OMX_VIDEO_PARAM_BITRATETYPE")]
            struct Bitrate: PortStructure {
                [CCode (cname="eControlRate")]
                ControlRate control_rate;

                [CCode (cname="nTargetBitrate")]
                uint32 target_bitrate;
            }

            [CCode (cname="OMX_VIDEO_PARAM_H263TYPE")]
            struct H263: PortStructure {
                [CCode (cname="nPFrames")]
                uint32 p_frames;

                [CCode (cname="nBFrames")]
                uint32 b_frames;

                [CCode (cname="eProfile")]
                H263Profile profile;

                [CCode (cname="eLevel")]
                H263Level level;

                [CCode (cname="bPLUSPTYPEAllowed")]
                bool plus_ptype_allowed;

                [CCode (cname="nAllowedPictureTypes")]
                uint32 allowed_picture_types;

                [CCode (cname="bForceRoundingTypeToZero")]
                bool force_rounding_type_to_zero;

                [CCode (cname="nPictureHeaderRepetition")]
                uint32 picture_header_repetition;

                [CCode (cname="nGOBHeaderInterval")]
                uint32 gob_header_interval;
            }

            [CCode (cname="OMX_VIDEO_PARAM_MPEG4TYPE")]
            struct Mpeg4: PortStructure {
                [CCode (cname="nSliceHeaderSpacing")]
                uint32 slice_header_spacing;

                [CCode (cname="bSVH")]
                bool svh;

                [CCode (cname="bGov")]
                bool gov;

                [CCode (cname="nPFrames")]
                uint32 p_frames;

                [CCode (cname="nBFrames")]
                uint32 b_frames;

                [CCode (cname="nIDCVLCThreshold")]
                uint32 i_dc_vlc_threshold;

                [CCode (cname="bACPred")]
                bool ac_pred;

                [CCode (cname="nMaxPacketSize")]
                uint32 max_packet_size;

                [CCode (cname="nTimeIncRes")]
                uint32 time_inc_res;

                [CCode (cname="eProfile")]
                Mpeg4Profile profile;

                [CCode (cname="eLevel")]
                Mpeg4Level level;

                [CCode (cname="nAllowedPictureTypes")]
                uint32 allowed_picture_types;

                [CCode (cname="nHeaderExtension")]
                uint32 header_extension;

                [CCode (cname="bReversibleVLC")]
                bool reversible_vlc;
            }

            [CCode (cname="OMX_VIDEO_PARAM_QUANTIZATIONTYPE")]
            struct Quantization: PortStructure {
                [CCode (cname="nQpI")]
                uint32 qp_i;

                [CCode (cname="nQpP")]
                uint32 qp_p;

                [CCode (cname="nQpB")]
                uint32 qp_b;
            }
        } //ns Param
    } //ns Video

    [CCode (cheader_filename="OMX_Component.h")]
    namespace Image {
        [CCode (cname="OMX_IMAGE_CODINGTYPE", cprefix="OMX_IMAGE_Coding")]
        enum Coding {
            Unused,
            AutoDetect,
            JPEG,
            JPEG2K,
            EXIF,
            TIFF,
            GIF,
            PNG,
            LZW,
            BMP
        }

        [CCode (cname="OMX_IMAGE_PORTDEFINITIONTYPE")]
        struct PortDefinition {
            [CCode (cname="cMIMEType")]
            string mime_type;

            [CCode (cname="pNativeRender")]
            Native.Device native_render;

            [CCode (cname="nFrameWidth")]
            uint32 frame_width;

            [CCode (cname="nFrameHeight")]
            uint32 frame_height;

            [CCode (cname="nStride")]
            int32 stride;

            [CCode (cname="nSliceHeight")]
            uint32 slice_height;

            [CCode (cname="bFlagErrorConcealment")]
            bool flag_error_concealment;

            [CCode (cname="eCompressionFormat")]
            Image.Coding compression_format;

            [CCode (cname="eColorFormat")]
            Color.Format color_format;

            [CCode (cname="pNativeWindow")]
            Native.Window native_window;
        }

        namespace Param {
            [CCode (cname="OMX_IMAGE_PARAM_QFACTORTYPE")]
            struct QFactor: PortStructure {
                [CCode (cname="nQFactor")]
                uint32 q_factor;
            }
        } //ns Param
    } //ns Image

    [CCode (cheader_filename="OMX_Component.h")]
    namespace Color {
        [CCode (cname="OMX_COLOR_FORMATTYPE", cprefix="OMX_COLOR_Format")]
        enum Format {
            Unused,
            Monochrome,
            @8bitRGB332,
            @12bitRGB444,
            @16bitARGB4444,
            @16bitARGB1555,
            @16bitRGB565,
            @16bitBGR565,
            @18bitRGB666,
            @18bitARGB1665,
            @19bitARGB1666,
            @24bitRGB888,
            @24bitBGR888,
            @24bitARGB1887,
            @25bitARGB1888,
            @32bitBGRA8888,
            @32bitARGB8888,
            YUV411Planar,
            YUV411PackedPlanar,
            YUV420Planar,
            YUV420PackedPlanar,
            YUV420SemiPlanar,
            YUV422Planar,
            YUV422PackedPlanar,
            YUV422SemiPlanar,
            YCbYCr,
            YCrYCb,
            CbYCrY,
            CrYCbY,
            YUV444Interleaved,
            RawBayer8bit,
            RawBayer10bit,
            RawBayer8bitcompressed,
            L2,
            L4,
            L8,
            L16,
            L24,
            L32,
            YUV420PackedSemiPlanar,
            YUV422PackedSemiPlanar,
            @18BitBGR666,
            @24BitARGB6666,
            @24BitABGR6666
        }
    }

    [CCode (cheader_filename="OMX_Component.h")]
    namespace Other {
        [CCode (cname="OMX_OTHER_FORMATTYPE", cprefix="OMX_OTHER_Format")]
        enum Format {
            Time,
            Power,
            Stats,
            Binary
        }

        [CCode (cname="OMX_OTHER_PORTDEFINITIONTYPE")]
        struct PortDefinition {
            [CCode (cname="eFormat")]
            Format format;
        }
    }

    namespace Time {
        namespace Config {
            [CCode (cname="OMX_TIME_CONFIG_TIMESTAMPTYPE")]
            struct TimeStamp: PortStructure {
                [CCode (cname="nTimestamp")]
                int64 time_stamp;
            }
        } //ns Config
    } //ns Time

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
    string __FILE__;

    [CCode (cname="__FUNCTION__")]
    string __FUNCTION__;

    GLib.Quark error_domain() {
        return GLib.Quark.from_string("Omx.Error");
    }

    void try_run(
            Error err,
            string file=__FILE__,
            string function=__FUNCTION__,
            int line=__LINE__) throws GLib.Error {
        if(err != Omx.Error.None) {
            var e = new GLib.Error(
                       error_domain(), err,
                       "%s (0x%x) in function %s at %s:%d\n",
                       err.to_string(), err, function, file, line);
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
