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
                    return "OMX.Command.StateSet";
                case Flush:
                    return "OMX.Command.Flush";
                case PortDisable:
                    return "OMX.Command.PortDisable";
                case PortEnable:
                    return "OMX.Command.PortEnable";
                case MarkBuffer:
                    return "OMX.Command.MarkBuffer";
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
        public ulong size;

        [CCode (cname="nVersion")]
        public Version version;

        [CCode (cname="pBuffer",array_length_cname = "nAllocLen")]
        public char[] buffer;

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
        public int64 timestamp;

        [CCode (cname="nFlags")]
        public uint32 flags;

        [CCode (cname="nOutputPortIndex")]
        public uint32 output_port_index;

        [CCode (cname="nInputPortIndex")]
        public uint32 input_port_index;
    }

    namespace Port {
        [CCode (cname="OMX_PORT_PARAM_TYPE")]
        public struct Param {
            [CCode (cname="nSize")]
            ulong size;

            [CCode (cname="nVersion")]
            Version version;

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
        Output;
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
    struct BS32 {
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
        struct BufferSupplier {
            [CCode (cname="nSize")]
            ulong size;
            
            [CCode (cname="nVersion")]
            Version version;
            
            [CCode (cname="nPortIndex")]
            uint32 port_Index;
            
            [CCode (cname="eBufferSupplier")]
            Omx.BufferSupplier buffer_supplier;
        }
    } //ns Param

    struct FormatDetail {
        Audio.PortDefinition audio;
        Video.PortDefinition video;
        Image.PortDefinition image;
        Other.PortDefinition other;
    }

    [CCode (cname="OMX_PARAM_PortDefinition")]
     struct PortDefinition {
        [CCode (cname="nSize")]
        ulong size;
        
        [CCode (cname="nVersion")]
        Version version;
        
        [CCode (cname="nPortIndex")]
        uint32 port_index;
        
        [CCode (cname="eDir")]
        Dir dir;
        
        [CCode (cname="nBufferCountActual")]
        uint32 buffer_count_actual;
        
        [CCode (cname="nBufferCountMin")]
        uint32 Buffer_count_min;
        
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
        bool bBuffersContiguous;
        
        [CCode (cname="nBufferAlignment")]
        uint32 nBufferAlignment;
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
            struct PortFormat {
                [CCode (cname="nSize")]
                ulong size;
                
                [CCode (cname="nVersion")]
                Version version;
                
                [CCode (cname="PortIndex")]
                uint32 port_index;
                
                [CCode (cname="Index")]
                uint32 index;
                
                [CCode (cname="eEncoding")]
                Coding encoding;
            }
            
            [CCode (cname="OMX_AUDIO_PARAM_PCMMODETYPE")]
            struct PcmMode {
                [CCode (cname="nSize")]
                ulong size;
                
                [CCode (cname="nVersion")]
                Version version;
                
                [CCode (cname="nPortIndex")]
                uint32 port_index;
                
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
                
                [CCode (cname="eChannelMapping")]
                Channel[] channel_mapping;
            }

            [CCode (cname="OMX_AUDIO_PARAM_MP3TYPE")]
            struct Mp3 {
                [CCode (cname="nSize")]
                ulong size;
                
                [CCode (cname="nVersion")]
                Version version;
                
                [CCode (cname="nPortIndex")]
                uint32 port_index;
                
                [CCode (cname="nChannels")]
                uint32 channels;
                
                [CCode (cname="nBitRate")]
                uint32 bit_Rate;
                
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
            struct AacProfile {
                [CCode (cname="nSize")]
                ulong size;
                
                [CCode (cname="nVersion")]
                Version version;
                
                [CCode (cname="nPortIndex")]
                uint32 port_index;
                
                [CCode (cname="nChannels")]
                uint32 channels;
                
                [CCode (cname="nSampleRate")]
                uint32 sample_rate;
                
                [CCode (cname="nBitRate")]
                uint32 bit_Rate;
                
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
            struct Vorbis {
                [CCode (cname="nSize")]
                ulong size;
                
                [CCode (cname="nVersion")]
                Version version;
                
                [CCode (cname="nPortIndex")]
                uint32 port_index;
                
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
            struct Wma {
                [CCode (cname="nSize")]
                ulong nSize;
                
                [CCode (cname="nVersion")]
                Version version;
                
                [CCode (cname="nPortIndex")]
                uint32 port_index;
                
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
            struct Amr {
                [CCode (cname="nSize")]
                ulong size;
                
                [CCode (cname="nVersion")]
                Version version;
                
                [CCode (cname="nPortIndex")]
                uint32 port_index;
                
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

        [CCode (cname="OMX_AUDIO_WMAFORMATTYPE")]
        enum WmaFormat {
          [CCode (cname="OMX_AUDIO_WMAFormatUnused")]
          Unused,
          [CCode (cname="OMX_AUDIO_WMAFormat7")]
          V7,
          [CCode (cname="OMX_AUDIO_WMAFormat8")]
          V8,
          [CCode (cname="OMX_AUDIO_WMAFormat9")]
          V9
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
            struct Volume {
                [CCode (cname="nSize")]
                ulong size;
                
                [CCode (cname="nVersion")]
                Version version;
                
                [CCode (cname="nPortIndex")]
                uint32 port_index;
                
                [CCode (cname="bLinear")]
                bool linear;
                
                [CCode (cname="sVolume")]
                BS32 volume;
            }

            [CCode (cname="OMX_AUDIO_CONFIG_CHANNELVOLUMETYPE")]
            struct ChannelVolume {
                [CCode (cname="nSize")]
                ulong size;
                
                [CCode (cname="nVersion")]
                Version Version;
                
                [CCode (cname="nPortIndex")]
                uint32 port_index;
                
                [CCode (cname="nChannel")]
                uint32 channel;
                
                [CCode (cname="bLinear")]
                bool linear;
                
                [CCode (cname="sVolume")]
                BS32 volume;
                
                [CCode (cname="bIsMIDI")]
                bool is_midi;
            }
            
            [CCode (cname="OMX_AUDIO_CONFIG_BALANCETYPE")]
            struct Balance {
                [CCode (cname="nSize")]
                ulong size;
                
                [CCode (cname="nVersion")]
                Version version;
                
                [CCode (cname="nPortIndex")]
                uint32 port_index;
                
                [CCode (cname="nBalance")]
                int32 balance;
            }
            

            [CCode (cname="OMX_AUDIO_CONFIG_MUTETYPE")]
            struct Mute {
                [CCode (cname="nSize")]
                ulong size;
                
                [CCode (cname="nVersion")]
                Version version;
                
                [CCode (cname="nPortIndex")]
                uint32 port_index;
                
                [CCode (cname="bMute")]
                bool mute;
            }
            
            [CCode (cname="OMX_AUDIO_CONFIG_CHANNELMUTETYPE")]
            struct ChannelMute {
                [CCode (cname="nSize")]
                ulong size;
                
                [CCode (cname="nVersion")]
                Version nVersion;
                
                [CCode (cname="nPortIndex")]
                uint32 port_index;
                
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
            BMP,
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
    } //ns Image

    [CCode (cheader_filename="OMX_Component.h")]
    namespace Color {

        [CCode (cname="OMX_COLOR_FORMATTYPE", cprefix="OMX_COLOR_Format")]
        enum Format {
            Unused,
            Monochrome,
            8bitRGB332,
            12bitRGB444,
            16bitARGB4444,
            16bitARGB1555,
            16bitRGB565,
            16bitBGR565,
            18bitRGB666,
            18bitARGB1665,
            19bitARGB1666, 
            24bitRGB888,
            24bitBGR888,
            24bitARGB1887,
            25bitARGB1888,
            32bitBGRA8888,
            32bitARGB8888,
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
            18BitBGR666,
            24BitARGB6666,
            24BitABGR6666,
        }
    }

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
        return GLib.Quark.from_string("OMX.Error");
    }

    void try_run(
            Error err,
            string file=__FILE__,
            string function=__FUNCTION__,
            int line=__LINE__) throws GLib.Error {
        if(err != Omx.Error.None) {
            var e = new GLib.Error(
                       error_domain(), err,
                       "%s from function %s at %s:%d\n",
                       err.to_string(), function, file, line);
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
