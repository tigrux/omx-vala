#ifndef __OMX_H__
#define __OMX_H__


#include <OMX_Core.h>
#include <OMX_Component.h>


#define omx_structure_init(pStructure) \
{ \
    memset((pStructure), 0, sizeof *(pStructure)); \
    (pStructure)->nSize = sizeof *(pStructure); \
    (pStructure)->nVersion.s.nVersionMajor = 1; \
    (pStructure)->nVersion.s.nVersionMinor = 1; \
}


typedef struct {
    OMX_U32 nSize;
    OMX_VERSIONTYPE nVersion;
    OMX_U32 nPortIndex;
} OmxPortStructure;


#endif
