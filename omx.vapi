[CCode (cheader_filename="OMX_Core.h,OMX_Component.h")]
namespace Omx {
    [CCode (cname="OMX_ALL")]
    const uint ALL;

    [CCode (cname="OMX_MAX_STRINGNAME_SIZE")]
    const uint MAX_STRING_SIZE;

    [CCode (cname="OMX_COMMANDTYPE", cprefix="OMX_Command")]
    public enum Command {
        StateSet,
        Flush,
        PortDisable,
        PortEnable,
        MarkBuffer;

        public weak string to_string() {
            switch(this) {
                case StateSet:
                    return "Change the component state";
                case Flush:
                    return "Flush the queue(s) of buffers on a port of a component";
                case PortDisable:
                    return "Disable a port on a component";
                case PortEnable:
                    return "Enable a port on a component";
                case MarkBuffer:
                    return "Mark a buffer and specify which other component will raise the event mark received";
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

        public weak string to_string() {
            switch(this) {
                case Invalid:
                    return "Component is corrupt or has encountered an error from which it cannot recover";
                case Loaded:
                    return "Component has been loaded but has no resources allocated";
                case Idle:
                    return "Component has all resources but has not transferred any buffers or begun processing data";
                case Executing:
                    return "Component is transferring buffers and is processing data (if data is available)";
                case Pause:
                    return "Component data processing has been paused but may be resumed from the point it was paused";
                case WaitForResources:
                    return "Component is waiting for a resource to become available";
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

        public weak string to_string() {
            switch(this) {
                case None:
                    return "The function returned successfully";
                case InsufficientResources:
                    return "There were insufficient resources to perform the requested operation";
                case Undefined:
                    return "There was an error but the cause of the error could not be determined";
                case InvalidComponentName:
                    return "The component name string was invalid";
                case ComponentNotFound:
                    return "No component with the specified name string was found";
                case InvalidComponent:
                    return "The component name string was invalid";
                case BadParameter:
                    return "One or more parameters were invalid";
                case NotImplemented:
                    return "The requested function is not implemented";
                case Underflow:
                    return "The buffer was emptied before the next buffer was ready";
                case Overflow:
                    return "The buffer was not available when it was needed";
                case Hardware:
                    return "The hardware failed to respond as expected";
                case InvalidState:
                    return "The component is in the OMX_StateInvalid state";
                case StreamCorrupt:
                    return "The stream is found to be corrupt";
                case PortsNotCompatible:
                    return "Ports being set up for tunneled communication are incompatible";
                case ResourcesLost:
                    return "Resources allocated to a component in the OMX_StateIdle state have been lost";
                case NoMore:
                    return "No more indices can be enumerated";
                case VersionMismatch:
                    return "The component detected a version mismatch";
                case NotReady:
                    return "The component is not ready to return data at this time";
                case Timeout:
                    return "A timeout occurred where the component was unable to process the call in a reasonable amount of time";
                case SameState:
                    return "The component tried to transition into the state that it is currently in";
                case ResourcesPreempted:
                    return "Resources allocated to a component in the OMX_StateExecuting or OMX_StatePause states have been pre-empted";
                case PortUnresponsiveDuringAllocation:
                    return "The non-supplier port deemed that it had waited an unusually long time for the supplier port to send it an allocated buffer via an OMX_UseBuffer call";
                case PortUnresponsiveDuringDeallocation:
                    return "The non-supplier port deemed that it had waited an unusually long time for the supplier port to request the de-allocation of a buffer header via a OMX_FreeBuffer call";
                case PortUnresponsiveDuringStop:
                    return "The supplier port deemed that it had waited an unusually long time for the non-supplier port to return a buffer via an EmptyThisBuffer or FillThisBuffer call";
                case IncorrectStateTransition:
                    return "A state transition was attempted that is not allowed";
                case IncorrectStateOperation:
                    return "A command or method was attempted that is not allowed during the present state";
                case UnsupportedSetting:
                    return "One or more values encapsulated in the parameter or configuration structure are unsupported";
                case UnsupportedIndex:
                    return "The parameter or configuration indicated by the given index is unsupported";
                case BadPortIndex:
                    return "The port index that was supplied is incorrect";
                case PortUnpopulated:
                    return "The port has lost one or more of its buffers and is thus unpopulated";
                case ComponentSuspended:
                    return "Component suspended due to temporary loss of resources";
                case DynamicResourcesUnavailable:
                    return "Component suspended due to inability to acquire dynamic resources";
                case MbErrorsInFrame:
                    return "Errors detected in frame";
                case FormatNotDetected:
                    return "Component cannot parse or determine the format of the given datastream";
                case ContentPipeOpenFailed:
                    return "Opening the Content Pipe failed";
                case ContentPipeCreationFailed:
                    return "Creating the Content Pipe failed";
                case SeperateTablesUsed:
                    return "Attempting to query for single Chroma table when separate quantization tables are used for the Chroma (Cb and Cr) coefficients";
                case TunnelingUnsupported:
                    return "Tunneling is not supported by the component";
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
        public ulong size;

        [CCode (cname="nVersion")]
        public Version version;

        [CCode (cheader_filename="omx-utils.h")]
        public void init();
    }

    public struct PortStructure: Structure {
        [CCode (cname="nPortIndex")]
        public uint32 port_index;
    }

    [Compact]
    [CCode (cname="OMX_BUFFERHEADERTYPE", ref_function = "", unref_function = "")]
    public class BufferHeader {
        [CCode (cname="nSize")]
        public ulong size;

        [CCode (cname="nVersion")]
        public Version version;

        [CCode (cname="pBuffer",array_length_cname = "nAllocLen")]
        public uint8[] buffer;

        [CCode (cname="nFilledLen")]
        public size_t length;

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

        public bool eos {
            get {
                return (flags & BufferFlag.EOS) != 0;
            }
        }

        public void set_eos() {
            flags |= Omx.BufferFlag.EOS;
        }
    }

    [CCode (cname="OMX_PORT_PARAM_TYPE")]
    public struct PortParam: Structure {
        [CCode (cname="nPorts")]
        public uint32 ports;

        [CCode (cname="nStartPortNumber")]
        public uint32 start_port_number;
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

        public weak string to_string() {
            switch(this) {
                case CmdComplete:
                    return "Component has completed the execution of a command";
                case Error:
                    return "Component has detected an error condition";
                case Mark:
                    return "A buffer mark has reached the target component, and the IL client has received this event with the private data pointer of the mark";
                case PortSettingsChanged:
                    return "Component has changed port settings. For example, the component has changed port settings resulting from bit stream parsing";
                case BufferFlag:
                    return "The event that a component sends when it detects the end of a stream";
                case ResourcesAcquired:
                    return "The component has been granted resources and is transitioning from the OMX_StateWaitForResources state to the OMX_StateIdle state";
                case ComponentResumed:
                    return "The component has been resumed (i.e. no longer suspended) due to reacquisition of resources";
                case DynamicResourcesAvailable:
                    return "The component has acquired previously unavailable dynamic resources";
                case PortFormatDetected:
                    return "Component has successfully recognized a format and determined that it can support it";
                default:
                    return "(unknown)";
            }
        }
    }

    [CCode (cname="OMX_PORTDOMAINTYPE", cprefix="OMX_PortDomain")]
    public enum PortDomain {
        Audio,
        Video,
        Image,
        Other
    }

    [CCode (cname="OMX_MARKTYPE")]
    public struct Mark {
        [CCode (cname="hMarkTargetComponent")]
        public Handle mark_target_component;

        [CCode (cname="pMarkData")]
        public void *mark_data;
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

    [Compact]
    [CCode (cname="void", type_id="G_TYPE_POINTER", set_value_function="g_value_set_pointer", param_spec_function="g_param_spec_pointer", ref_function="", unref_function="")]
    public class Handle {
        [CCode (cname="OMX_SendCommand")]
        public Error send_command(Command cmd, uint param, void *cmd_data=null);

        [CCode (cname="OMX_GetState")]
        public Error get_state(out State state);

        [CCode (cname="OMX_UseBuffer")]
        public Error use_buffer(out BufferHeader buffer, uint n_port, void *app_priv, uint n_bytes, char *pbuffer);

        [CCode (cname="OMX_AllocateBuffer")]
        public Error allocate_buffer(out BufferHeader buffer, uint n_port, void *app_priv, uint n_bytes);

        [CCode (cname="OMX_FreeBuffer")]
        public Error free_buffer(uint n_port, BufferHeader buffer);

        [CCode (cname="OMX_EmptyThisBuffer")]
        public Error empty_this_buffer(BufferHeader buffer);

        [CCode (cname="OMX_FillThisBuffer")]
        public Error fill_this_buffer(BufferHeader buffer);

        [CCode (cname="OMX_GetConfig")]
        public Error get_config(uint config_index, PortStructure config_structure);

        [CCode (cname="OMX_SetConfig")]
        public Error set_config(uint config_index, PortStructure config_structure);

        [CCode (cname="OMX_GetExtensionIndex")]
        public Error get_extension_index(string parameter_name, out uint index_type);

        [CCode (cname="OMX_GetParameter")]
        public Error get_parameter(uint param_index, Structure parameter_structure);

        [CCode (cname="OMX_SetParameter")]
        public Error set_parameter(uint param_index, Structure parameter_structure);
    }

    [CCode (cname="OMX_Init")]
    public Error init();

    [CCode (cname="OMX_Deinit")]
    public Error deinit();

    [CCode (cname="OMX_GetHandle")]
    public Error get_handle(out Handle component, string component_name, void *app_data, Callback callbacks);

    [CCode (cname="OMX_FreeHandle")]
    public Error free_handle(Handle component);

    [CCode (cname="OMX_SetupTunnel")]
    public Error setup_tunnel(Handle output, uint32 port_output, Handle input, uint32 port_input);

    [CCode (cname="OMX_DIRTYPE", cprefix="OMX_Dir")]
    public enum Dir {
        Input,
        Output;

        public weak string to_string() {
            switch(this) {
                case Input:
                    return "Omx.Dir.Input";
                case Output:
                    return "Omx.Dir.Output";
                default:
                    return "(uknnown)";
            }
        }
    }

    [CCode (cname="OMX_ENDIANTYPE", cprefix="OMX_Endian")]
    public enum Endian {
        Big,
        Little
    }

    [CCode (cname="OMX_NUMERICALDATATYPE", cprefix="OMX_NumericalData")]
    public enum NumericalData {
        Signed,
        Unsigned
    }

    [CCode (cname="OMX_BS32")]
    public struct bounded {
        [CCode (cname="nValue")]
        public int32 value;

        [CCode (cname="nMin")]
        public int32 min;

        [CCode (cname="nMax")]
        public int32 max;
    }

    [CCode (cname="OMX_BU32")]
    public struct ubounded {
        [CCode (cname="nValue")]
        public uint32 value;

        [CCode (cname="nMin")]
        public uint32 min;

        [CCode (cname="nMax")]
        public uint32 max;
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
        public struct Device {
        }

        [SimpleType]
        [CCode (cname="OMX_NATIVE_WINDOWTYPE", default_value="NULL")]
        public struct Window {
        }
    }

    namespace Param {
        [CCode (cname="OMX_PARAM_BUFFERSUPPLIERTYPE")]
        public struct BufferSupplier: PortStructure {
            [CCode (cname="eBufferSupplier")]
            public Omx.BufferSupplier buffer_supplier;
        }

        public struct FormatDetail {
            public Audio.PortDefinition audio;
            public Video.PortDefinition video;
            public Image.PortDefinition image;
            public Other.PortDefinition other;
        }

        [CCode (cname="OMX_PARAM_PORTDEFINITIONTYPE")]
        public struct PortDefinition : PortStructure {
            [CCode (cname="eDir")]
            public Dir dir;

            [CCode (cname="nBufferCountActual")]
            public uint32 buffer_count_actual;

            [CCode (cname="nBufferCountMin")]
            public uint32 buffer_count_min;

            [CCode (cname="nBufferSize")]
            public uint32 buffer_size;

            [CCode (cname="bEnabled")]
            public bool enabled;

            [CCode (cname="bPopulated")]
            public bool populated;

            [CCode (cname="eDomain")]
            public PortDomain domain;

            public FormatDetail format;

            [CCode (cname="bBuffersContiguous")]
            public bool buffers_contiguous;

            [CCode (cname="nBufferAlignment")]
            public uint32 buffer_alignment;
        }

        [CCode (cname="OMX_PARAM_SENSORMODETYPE")]
        public struct SensorMode: PortStructure {
            [CCode (cname="nFrameRate")]
            public uint32 frame_rate;

            [CCode (cname="bOneShot")]
            public bool one_shot;

            [CCode (cname="sFrameSize")]
            public FrameSize frame_size;
        }
                
        [CCode (cname="OMX_PARAM_COMPONENTROLETYPE")]
        public struct ComponentRole: PortStructure {
            [CCode (cname="cRole")]
            public weak string role;
        }
    } //ns Param

    namespace Config {
        [CCode (cname="OMX_CONFIG_BRIGHTNESSTYPE")]
        public struct Brightness: PortStructure {
            [CCode (cname="nBrightness")]
            public uint32 brightness;
        }

        [CCode (cname="OMX_CONFIG_COLORBLENDTYPE")]
        public struct ColorBlend: PortStructure {
            [CCode (cname="nRGBAlphaConstant")]
            public uint32 rgb_alpha_constant;

            [CCode (cname="eColorBlend")]
            public Omx.ColorBlend color_blend;
        }

        [CCode (cname="OMX_CONFIG_CONTRASTTYPE")]
        public struct Constrast: PortStructure {
            [CCode (cname="nContrast")]
            public uint32 constrast;
        }

        [CCode (cname="OMX_CONFIG_EXPOSURECONTROLTYPE")]
        public struct ExposureControl: PortStructure {
            [CCode (cname="eExposureControl")]
            public Omx.ExposureControl exposure_control;
        }

        [CCode (cname="OMX_CONFIG_FRAMESTABTYPE")]
        public struct FrameStab: PortStructure {
            [CCode (cname="bStab")]
            public bool stab;
        }

        [CCode (cname="OMX_CONFIG_MIRRORTYPE")]
        public struct Mirror: PortStructure {
            [CCode (cname="eMirror")]
            public Omx.Mirror mirror;
        }

        [CCode (cname="OMX_CONFIG_POINTTYPE")]
        public struct Point: PortStructure {
            [CCode (cname="nX")]
            public int32 x;

            [CCode (cname="nY")]
            public int32 y;
        }

        [CCode (cname="OMX_CONFIG_RECTTYPE")]
        public struct Rect: PortStructure {
            [CCode (cname="nLeft")]
            public uint32 left;

            [CCode (cname="nTop")]
            public uint32 top;

            [CCode (cname="nWidth")]
            public uint32 width;

            [CCode (cname="nHeight")]
            public uint32 height;
        }

        [CCode (cname="OMX_CONFIG_ROTATIONTYPE")]
        public struct Rotation: PortStructure {
            [CCode (cname="nRotation")]
            public int32 rotation;
        }

        [CCode (cname="OMX_CONFIG_SCALEFACTORTYPE")]
        public struct ScaleFactor: PortStructure {
            [CCode (cname="xWidth")]
            public int32 width;

            [CCode (cname="xHeight")]
            public int32 height;
        }

        [CCode (cname="OMX_CONFIG_WHITEBALCONTROLTYPE")]
        public struct WhiteBalControl: PortStructure {
            [CCode (cname="eWhiteBalControl")]
            public Omx.WhiteBalControl white_bal_control;
        }
    } //ns Config

    [CCode (cname="OMX_COLORBLENDTYPE", cprefix="OMX_ColorBlend")]
    public enum ColorBlend {
        None,
        AlphaConstant,
        AlphaPerPixel,
        Alternate,
        And,
        Or,
        Invert,
    }

    [CCode (cname="OMX_EXPOSURECONTROLTYPE", cprefix="OMX_ExposureControl")]
    public enum ExposureControl {
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
    public enum Mirror {
        None,
        Vertical,
        Horizontal,
        Both,
    }

    [CCode (cname="OMX_WHITEBALCONTROLTYPE", cprefix="OMX_WhiteBalControl")]
    public enum WhiteBalControl {
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

    [CCode (cname="OMX_FRAMESIZETYPE")]
    public struct FrameSize: PortStructure {
        [CCode (cname="nWidth")]
        public uint32 width;

        [CCode (cname="nHeight")]
        public uint32 height;
    }

    namespace Audio {
        [CCode (cname="OMX_AUDIO_CODINGTYPE", cprefix="OMX_AUDIO_Coding")]
        public enum Coding {
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
        public struct PortDefinition {
            [CCode (cname="cMIMEType")]
            public weak string mime_type;

            [CCode (cname="pNativeRender")]
            public Native.Device native_render;

            [CCode (cname="bFlagErrorConcealment")]
            public bool flag_error_concealment;

            [CCode (cname="eEncoding")]
            public Coding encoding;
        }

        namespace Param {
            [CCode (cname="OMX_AUDIO_PARAM_PORTFORMATTYPE")]
            public struct PortFormat: PortStructure {
                [CCode (cname="Index")]
                public uint32 index;

                [CCode (cname="eEncoding")]
                public Coding encoding;
            }

            [CCode (cname="OMX_AUDIO_PARAM_PCMMODETYPE")]
            public struct PcmMode: PortStructure {
                [CCode (cname="nChannels")]
                public uint32 channels;

                [CCode (cname="eNumData")]
                public NumericalData num_data;

                [CCode (cname="eEndian")]
                public Endian endian;

                [CCode (cname="bInterleaved")]
                public bool interleaved;

                [CCode (cname="nBitPerSample")]
                public uint32 bit_per_sample;

                [CCode (cname="nSamplingRate")]
                public uint32 sampling_rate;

                [CCode (cname="ePCMMode")]
                public Audio.PcmMode pcm_mode;

                [CCode (cname="eChannelMapping", array_length = false)]
                public weak Channel[] channel_mapping;
            }

            [CCode (cname="OMX_AUDIO_PARAM_MP3TYPE")]
            public struct Mp3: PortStructure {
                [CCode (cname="nChannels")]
                public uint32 channels;

                [CCode (cname="nBitRate")]
                public uint32 bit_rate;

                [CCode (cname="nSampleRate")]
                public uint32 sample_rate;

                [CCode (cname="nAudioBandWidth")]
                public uint32 audio_band_width;

                [CCode (cname="eChannelMode")]
                public ChannelMode channel_mode;

                [CCode (cname="eFormat")]
                public Mp3StreamFormat format;
            }

            [CCode (cname="OMX_AUDIO_PARAM_AACPROFILETYPE")]
            public struct AacProfile: PortStructure {
                [CCode (cname="nChannels")]
                public uint32 channels;

                [CCode (cname="nSampleRate")]
                public uint32 sample_rate;

                [CCode (cname="nBitRate")]
                public uint32 bit_rate;

                [CCode (cname="nAudioBandWidth")]
                public uint32 audio_band_width;

                [CCode (cname="nFrameLength")]
                public uint32 frame_length;

                [CCode (cname="nAACtools")]
                public uint32 tools;

                [CCode (cname="nAACERtools")]
                public uint32 er_tools;

                [CCode (cname="eAACProfile")]
                public Audio.AacProfile profile;

                [CCode (cname="eAACStreamFormat")]
                public AacStreamFormat stream_format;

                [CCode (cname="eChannelMode")]
                public ChannelMode channel_mode;
            }

            [CCode (cname="OMX_AUDIO_PARAM_VORBISTYPE")]
            public struct Vorbis: PortStructure {
                [CCode (cname="nChannels")]
                public uint32 channels;

                [CCode (cname="nBitRate")]
                public uint32 bit_rate;

                [CCode (cname="nMaxBitRate")]
                public uint32 max_bit_rate;

                [CCode (cname="nSampleRate")]
                public uint32 sample_rate;

                [CCode (cname="nAudioBandWidth")]
                public uint32 audio_band_width;

                [CCode (cname="nQuality")]
                public int32 quality;

                [CCode (cname="bManaged")]
                public bool managed;

                [CCode (cname="bDownmix")]
                public bool downmix;
            }

            [CCode (cname="OMX_AUDIO_PARAM_WMATYPE")]
            public struct Wma: PortStructure {
                [CCode (cname="nChannels")]
                public uint16 channels;

                [CCode (cname="nBitRate")]
                public uint32 bit_rate;

                [CCode (cname="eFormat")]
                public WmaFormat format;

                [CCode (cname="eProfile")]
                public WmaProfile profile;

                [CCode (cname="nSamplingRate")]
                public uint32 sampling_rate;

                [CCode (cname="nBlockAlign")]
                public uint16 block_align;

                [CCode (cname="nEncodeOptions")]
                public uint16 encode_options;

                [CCode (cname="nSuperBlockAlign")]
                public uint32 super_block_align;
            }

            [CCode (cname="OMX_AUDIO_PARAM_AMRTYPE")]
            public struct Amr: PortStructure {
                [CCode (cname="nChannels")]
                public uint32 channels;

                [CCode (cname="nBitRate")]
                public uint32 bit_rate;

                [CCode (cname="eAMRBandMode")]
                public AmrBandMode band_mode;

                [CCode (cname="eAMRDTXMode")]
                public AmrDtxMode  dtx_mode;

                [CCode (cname="eAMRFrameFormat")]
                public AmrFrameFormat frame_format;
            }

            [CCode (cname="OMX_AUDIO_PARAM_GSMFRTYPE")]
            public struct GsmFr: PortStructure {
                [CCode (cname="bDTX")]
                public bool dtx;

                [CCode (cname="bHiPassFilter")]
                public bool hi_pass_filter;
            }

            [CCode (cname="OMX_AUDIO_PARAM_GSMHRTYPE")]
            public struct GsmHr: PortStructure {
                [CCode (cname="bDTX")]
                public bool dtx;

                [CCode (cname="bHiPassFilter")]
                public bool hi_pass_filter;
            }

            [CCode (cname="OMX_AUDIO_PARAM_GSMEFRTYPE")]
            public struct GsmEfr: PortStructure {
                [CCode (cname="bDTX")]
                public bool dtx;

                [CCode (cname="bHiPassFilter")]
                public bool hi_pass_filter;
            }
        } //ns Param

        [CCode (cname="OMX_AUDIO_PCMMODETYPE", cprefix="OMX_AUDIO_PCMMode")]
        public enum PcmMode {
            Linear,
            ALaw,
            MULaw
        }

        [CCode (cname="OMX_AUDIO_MAXCHANNELS")]
        public const int MAX_CHANNELS;

        [CCode (cname="OMX_AUDIO_CHANNELTYPE", cprefix="OMX_AUDIO_Channel")]
        public enum Channel {
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
        public enum ChannelMode {
            Stereo,
            JointStereo,
            Dual,
            Mono
        }

        [CCode (cname="OMX_AUDIO_MP3STREAMFORMATTYPE", cprefix="OMX_AUDIO_MP3StreamFormat")]
        public enum Mp3StreamFormat {
            MP1Layer3,
            MP2Layer3,
            MP2_5Layer3
        }

        [CCode (name="OMX_AUDIO_AACSTREAMFORMATTYPE", cprefix="OMX_AUDIO_AACStreamFormat")]
        public enum AacStreamFormat {
           MP2ADTS,
           MP4ADTS,
           MP4LOAS,
           MP4LATM,
           ADIF,
           MP4FF,
           RAW
        }

        [CCode (name="OMX_AUDIO_AACPROFILETYPE", cprefix="OMX_AUDIO_AACObject")]
        public enum AacProfile {
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
        public enum WmaFormat {
          Unused,
          @7,
          @8,
          @9
        }

        [CCode (cname="OMX_AUDIO_WMAPROFILETYPE", cprefix="OMX_AUDIO_WMAProfile")]
        public enum WmaProfile {
          Unused,
          L1,
          L2,
          L3
        }

        [CCode (cname="OMX_AUDIO_AMRFRAMEFORMATTYPE", cprefix="OMX_AUDIO_AMRFrameFormat")]
        public enum AmrFrameFormat {
            Conformance,
            IF1,
            IF2,
            FSF,
            RTPPayload,
            ITU
        }

        [CCode (cname="OMX_AUDIO_AMRBANDMODETYPE", cprefix="OMX_AUDIO_AMRBandMode")]
        public enum AmrBandMode {
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
        public enum AmrDtxMode {
            Off,
            OnVAD1,
            OnVAD2,
            OnAuto,
            [CCode (cname="OMX_AUDIO_AMRDTXasEFR")]
            asEFR
        }

        namespace Config {
            [CCode (cname="OMX_AUDIO_CONFIG_VOLUMETYPE")]
            public struct Volume: PortStructure {
                [CCode (cname="bLinear")]
                public bool linear;

                [CCode (cname="sVolume")]
                public bounded volume;
            }

            [CCode (cname="OMX_AUDIO_CONFIG_CHANNELVOLUMETYPE")]
            public struct ChannelVolume: PortStructure {
                [CCode (cname="nChannel")]
                public uint32 channel;

                [CCode (cname="bLinear")]
                public bool linear;

                [CCode (cname="sVolume")]
                public bounded volume;

                [CCode (cname="bIsMIDI")]
                public bool is_midi;
            }

            [CCode (cname="OMX_AUDIO_CONFIG_BALANCETYPE")]
            public struct Balance: PortStructure {
                [CCode (cname="nBalance")]
                public int32 balance;
            }

            [CCode (cname="OMX_AUDIO_CONFIG_MUTETYPE")]
            public struct Mute: PortStructure {
                [CCode (cname="bMute")]
                public bool mute;
            }

            [CCode (cname="OMX_AUDIO_CONFIG_CHANNELMUTETYPE")]
            public struct ChannelMute: PortStructure {
                [CCode (cname="nChannel")]
                public uint32 channel;

                [CCode (cname="bMute")]
                public bool mute;

                [CCode (cname="bIsMIDI")]
                public bool is_midi;
            }
        } //ns Config
    } //ns Audio

    namespace Video {
        [CCode (cname="OMX_VIDEO_CODINGTYPE", cprefix="OMX_VIDEO_Coding")]
        public enum Coding {
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
        public struct PortDefinition {
            [CCode (cname="cMIMEType")]
            public weak string mime_type;

            [CCode (cname="pNativeRender")]
            public Native.Device native_Render;

            [CCode (cname="nFrameWidth")]
            public uint32 frame_width;

            [CCode (cname="nFrameHeight")]
            public uint32 frame_height;

            [CCode (cname="nStride")]
            public int32 stride;

            [CCode (cname="nSliceHeight")]
            public uint32 slice_height;

            [CCode (cname="nBitrate")]
            public uint32 bitrate;

            [CCode (cname="xFramerate")]
            public uint32 framerate;

            [CCode (cname="bFlagErrorConcealment")]
            public bool flag_error_concealment;

            [CCode (cname="eCompressionFormat")]
            public Video.Coding compression_format;

            [CCode (cname="eColorFormat")]
            public Color.Format color_format;

            [CCode (cname="pNativeWindow")]
            public Native.Window native_window;
        }

        [CCode (cname="OMX_VIDEO_AVCLEVELTYPE", cprefix="OMX_VIDEO_AVCLevel")]
        public enum AvcLevel {
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
        public enum AvcProfile {
            Baseline,
            Main,
            Extended,
            High,
            High10,
            High422,
            High444
        }

        [CCode (cname="OMX_VIDEO_AVCLOOPFILTERTYPE", cprefix="OMX_VIDEO_AVCLoopFilter")]
        public enum AvcLoopFilter {
            Enable,
            Disable,
            DisableSliceBoundary
        }

        [CCode (cname="OMX_VIDEO_H263LEVELTYPE", cprefix="OMX_VIDEO_H263Level")]
        public enum H263Level {
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
        public enum Mpeg4Level {
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
        public enum ControlRate {
            Disable,
            Variable,
            Constant,
            VariableSkipFrames,
            ConstantSkipFrames
        }

        [CCode (cname="OMX_VIDEO_H263PROFILETYPE", cprefix="OMX_VIDEO_H263Profile")]
        public enum H263Profile {
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
        public enum Mpeg4Profile {
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
            public struct Avc: PortStructure {
                [CCode (cname="nSliceHeaderSpacing")]
                public uint32 slice_header_spacing;

                [CCode (cname="nPFrames")]
                public uint32 p_frames;

                [CCode (cname="nBFrames")]
                public uint32 b_frames;

                [CCode (cname="bUseHadamard")]
                public bool use_hadamard;

                [CCode (cname="nRefFrames")]
                public uint32 ref_frames;

                [CCode (cname="nRefIdx10ActiveMinus1")]
                public uint32 ref_idx10_active_minus1;

                [CCode (cname="nRefIdx11ActiveMinus1")]
                public uint32 ref_idx11_active_minus1;

                [CCode (cname="bEnableUEP")]
                public bool enable_uep;

                [CCode (cname="bEnableFMO")]
                public bool enable_fmo;

                [CCode (cname="bEnableASO")]
                public bool enable_aso;

                [CCode (cname="bEnableRS")]
                public bool enable_rs;

                [CCode (cname="eProfile")]
                public AvcProfile profile;

                [CCode (cname="eLevel")]
                public AvcLevel level;

                [CCode (cname="nAllowedPictureTypes")]
                public uint32 allowed_picture_types;

                [CCode (cname="bFrameMBsOnly")]
                public bool frame_mbs_only;

                [CCode (cname="bMBAFF")]
                public bool mbaff;

                [CCode (cname="bEntropyCodingCABAC")]
                public bool entropy_coding_cabac;

                [CCode (cname="bWeightedPPrediction")]
                public bool weighted_p_prediction;

                [CCode (cname="nWeightedBipredicitonMode")]
                public uint32 weighted_biprediction_mode;

                [CCode (cname="bconstIpred")]
                public bool const_ipred;

                [CCode (cname="bDirect8x8Inference")]
                public bool direct8x8_inference;

                [CCode (cname="bDirectSpatialTemporal")]
                public bool direct_spatial_temporal;

                [CCode (cname="nCabacInitIdc")]
                public uint32 cabac_init_idc;

                [CCode (cname="eLoopFilterMode")]
                public AvcLoopFilter loop_Filter_mode;
            }

            [CCode (cname="OMX_VIDEO_PARAM_BITRATETYPE")]
            public struct Bitrate: PortStructure {
                [CCode (cname="eControlRate")]
                public ControlRate control_rate;

                [CCode (cname="nTargetBitrate")]
                public uint32 target_bitrate;
            }

            [CCode (cname="OMX_VIDEO_PARAM_H263TYPE")]
            public struct H263: PortStructure {
                [CCode (cname="nPFrames")]
                public uint32 p_frames;

                [CCode (cname="nBFrames")]
                public uint32 b_frames;

                [CCode (cname="eProfile")]
                public H263Profile profile;

                [CCode (cname="eLevel")]
                public H263Level level;

                [CCode (cname="bPLUSPTYPEAllowed")]
                public bool plus_ptype_allowed;

                [CCode (cname="nAllowedPictureTypes")]
                public uint32 allowed_picture_types;

                [CCode (cname="bForceRoundingTypeToZero")]
                public bool force_rounding_type_to_zero;

                [CCode (cname="nPictureHeaderRepetition")]
                public uint32 picture_header_repetition;

                [CCode (cname="nGOBHeaderInterval")]
                public uint32 gob_header_interval;
            }

            [CCode (cname="OMX_VIDEO_PARAM_MPEG4TYPE")]
            public struct Mpeg4: PortStructure {
                [CCode (cname="nSliceHeaderSpacing")]
                public uint32 slice_header_spacing;

                [CCode (cname="bSVH")]
                public bool svh;

                [CCode (cname="bGov")]
                public bool gov;

                [CCode (cname="nPFrames")]
                public uint32 p_frames;

                [CCode (cname="nBFrames")]
                public uint32 b_frames;

                [CCode (cname="nIDCVLCThreshold")]
                public uint32 i_dc_vlc_threshold;

                [CCode (cname="bACPred")]
                public bool ac_pred;

                [CCode (cname="nMaxPacketSize")]
                public uint32 max_packet_size;

                [CCode (cname="nTimeIncRes")]
                public uint32 time_inc_res;

                [CCode (cname="eProfile")]
                public Mpeg4Profile profile;

                [CCode (cname="eLevel")]
                public Mpeg4Level level;

                [CCode (cname="nAllowedPictureTypes")]
                public uint32 allowed_picture_types;

                [CCode (cname="nHeaderExtension")]
                public uint32 header_extension;

                [CCode (cname="bReversibleVLC")]
                public bool reversible_vlc;
            }

            [CCode (cname="OMX_VIDEO_PARAM_QUANTIZATIONTYPE")]
            public struct Quantization: PortStructure {
                [CCode (cname="nQpI")]
                public uint32 qp_i;

                [CCode (cname="nQpP")]
                public uint32 qp_p;

                [CCode (cname="nQpB")]
                public uint32 qp_b;
            }
        } //ns Param
    } //ns Video

    namespace Image {
        [CCode (cname="OMX_IMAGE_CODINGTYPE", cprefix="OMX_IMAGE_Coding")]
        public enum Coding {
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
        public struct PortDefinition {
            [CCode (cname="cMIMEType")]
            public weak string mime_type;

            [CCode (cname="pNativeRender")]
            public Native.Device native_render;

            [CCode (cname="nFrameWidth")]
            public uint32 frame_width;

            [CCode (cname="nFrameHeight")]
            public uint32 frame_height;

            [CCode (cname="nStride")]
            public int32 stride;

            [CCode (cname="nSliceHeight")]
            public uint32 slice_height;

            [CCode (cname="bFlagErrorConcealment")]
            public bool flag_error_concealment;

            [CCode (cname="eCompressionFormat")]
            public Image.Coding compression_format;

            [CCode (cname="eColorFormat")]
            public Color.Format color_format;

            [CCode (cname="pNativeWindow")]
            public Native.Window native_window;
        }

        namespace Param {
            [CCode (cname="OMX_IMAGE_PARAM_QFACTORTYPE")]
            public struct QFactor: PortStructure {
                [CCode (cname="nQFactor")]
                uint32 q_factor;
            }
        } //ns Param
    } //ns Image

    namespace Color {
        [CCode (cname="OMX_COLOR_FORMATTYPE", cprefix="OMX_COLOR_Format")]
        public enum Format {
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

    namespace Other {
        [CCode (cname="OMX_OTHER_FORMATTYPE", cprefix="OMX_OTHER_Format")]
       public  enum Format {
            Time,
            Power,
            Stats,
            Binary
        }

        [CCode (cname="OMX_OTHER_PORTDEFINITIONTYPE")]
        public struct PortDefinition {
            [CCode (cname="eFormat")]
            Format format;
        }
    }

    namespace Time {
        namespace Config {
            [CCode (cname="OMX_TIME_CONFIG_TIMESTAMPTYPE")]
            public struct TimeStamp: PortStructure {
                [CCode (cname="nTimestamp")]
                public int64 time_stamp;
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

    public void try_run(Error err) throws GLib.Error {
        if(err != Omx.Error.None) {
            var domain = GLib.Quark.from_string("OMX_ERRORTYPE-quark");
            throw new  GLib.Error(domain, err, err.to_string());
        }
    }
}

