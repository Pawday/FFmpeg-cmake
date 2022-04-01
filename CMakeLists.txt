cmake_minimum_required(VERSION 3.15)

project(FFMPEG)

add_library(ffmpeg_config INTERFACE)

#TODO:[cmake] COMMON DEFINES (config.h)
# create list with all that and then pick required from that list in each target
target_compile_definitions(ffmpeg_config INTERFACE FFMPEG_CONFIGURATION="")
target_compile_definitions(ffmpeg_config INTERFACE FFMPEG_DATADIR="")
target_compile_definitions(ffmpeg_config INTERFACE AVCONV_DATADIR="")
target_compile_definitions(ffmpeg_config INTERFACE FFMPEG_LICENSE="")

target_compile_definitions(ffmpeg_config INTERFACE CC_IDENT="")

target_compile_definitions(ffmpeg_config INTERFACE HAVE_THREADS=0)
target_compile_definitions(ffmpeg_config INTERFACE HAVE_PTHREADS=0)
target_compile_definitions(ffmpeg_config INTERFACE HAVE_W32THREADS=0)
target_compile_definitions(ffmpeg_config INTERFACE HAVE_OS2THREADS=0)
target_compile_definitions(ffmpeg_config INTERFACE HAVE_ISNAN=0)
target_compile_definitions(ffmpeg_config INTERFACE HAVE_MMXEXT=0)
target_compile_definitions(ffmpeg_config INTERFACE HAVE_MMX2=HAVE_MMXEXT)
target_compile_definitions(ffmpeg_config INTERFACE HAVE_MMX2=HAVE_MMXEXT)
target_compile_definitions(ffmpeg_config INTERFACE HAVE_MMX_INLINE=0)
target_compile_definitions(ffmpeg_config INTERFACE HAVE_MMX=0)
target_compile_definitions(ffmpeg_config INTERFACE HAVE_AV_CONFIG_H=1)
target_compile_definitions(ffmpeg_config INTERFACE HAVE_ALTIVEC=0)
target_compile_definitions(ffmpeg_config INTERFACE HAVE_MMXEXT_INLINE=0)
target_compile_definitions(ffmpeg_config INTERFACE HAVE_NEON=0)
target_compile_definitions(ffmpeg_config INTERFACE HAVE_AMD3DNOW_INLINE=0)
target_compile_definitions(ffmpeg_config INTERFACE HAVE_X86ASM=0)
if(WIN32)
    target_compile_definitions(ffmpeg_config INTERFACE HAVE_MKSTEMP=0)
else()
    target_compile_definitions(ffmpeg_config INTERFACE HAVE_MKSTEMP=1)
endif()


#TODO:[cmake] detect each function and set to 0 if missing (they are in math.h)
target_compile_definitions(ffmpeg_config INTERFACE HAVE_CBRT=1)
target_compile_definitions(ffmpeg_config INTERFACE HAVE_CBRTF=1)
target_compile_definitions(ffmpeg_config INTERFACE HAVE_COPYSIGN=1)
target_compile_definitions(ffmpeg_config INTERFACE HAVE_ERF=1)
target_compile_definitions(ffmpeg_config INTERFACE HAVE_HYPOT=1)
target_compile_definitions(ffmpeg_config INTERFACE HAVE_RINT=1)
target_compile_definitions(ffmpeg_config INTERFACE HAVE_LRINT=1)
target_compile_definitions(ffmpeg_config INTERFACE HAVE_LRINTF=1)
target_compile_definitions(ffmpeg_config INTERFACE HAVE_ROUND=1)
target_compile_definitions(ffmpeg_config INTERFACE HAVE_ROUNDF=1)
target_compile_definitions(ffmpeg_config INTERFACE HAVE_TRUNC=1)
target_compile_definitions(ffmpeg_config INTERFACE HAVE_TRUNCF=1)



target_link_libraries(ffmpeg_config INTERFACE ffmpeg_compat)

include (TestBigEndian)
TEST_BIG_ENDIAN(IS_BIG_ENDIAN)
if(IS_BIG_ENDIAN)
    target_compile_definitions(ffmpeg_config INTERFACE HAVE_BIGENDIAN=1)
else()
    target_compile_definitions(ffmpeg_config INTERFACE HAVE_BIGENDIAN=0)
endif()

target_compile_definitions(ffmpeg_config INTERFACE av_restrict=)

target_compile_definitions(ffmpeg_config INTERFACE CONFIG_THIS_YEAR=2021)

target_compile_definitions(ffmpeg_config INTERFACE CONFIG_MEMORY_POISONING=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_FRAME_THREAD_ENCODER=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_MEMORY_POISONING=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_GRAY=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_ERROR_RESILIENCE=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_MPEGVIDEODEC=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_SMALL=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_H264_D3D11VA_HWACCEL=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_H264_DXVA2_HWACCEL=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_H264_NVDEC_HWACCEL=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_H264_VAAPI_HWACCEL=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_H264_VIDEOTOOLBOX_HWACCEL=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_H264_VDPAU_HWACCEL=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_NETWORK=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_XVMC=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_FORMAT_FILTER=1)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_PNG_DECODER=1)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_APNG_DECODER=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_INFLATE_WRAPPER=1)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_DEFLATE_WRAPPER=1)

target_compile_definitions(ffmpeg_config INTERFACE CONFIG_AVUTIL=1)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_AVCODEC=1)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_AVFORMAT=1)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_AVDEVICE=1)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_SWSCALE=1)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_SWRESAMPLE=1)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_POSTPROC=1)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_AVFILTER=1)



#CONFIG MUXERS
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_H264_MUXER=1)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_IMAGE2_MUXER=1)

#CONFIG DEMUXERS
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_IMAGE2_DEMUXER=1)

# look at the end of libavformat/img2dec.c file
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_IMAGE_BMP_PIPE_DEMUXER=1)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_IMAGE_CRI_PIPE_DEMUXER=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_IMAGE_DDS_PIPE_DEMUXER=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_IMAGE_DPX_PIPE_DEMUXER=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_IMAGE_EXR_PIPE_DEMUXER=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_IMAGE_GEM_PIPE_DEMUXER=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_IMAGE_GIF_PIPE_DEMUXER=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_IMAGE_J2K_PIPE_DEMUXER=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_IMAGE_JPEG_PIPE_DEMUXER=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_IMAGE_JPEGLS_PIPE_DEMUXER=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_IMAGE_PAM_PIPE_DEMUXER=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_IMAGE_PBM_PIPE_DEMUXER=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_IMAGE_PCX_PIPE_DEMUXER=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_IMAGE_PGM_PIPE_DEMUXER=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_IMAGE_PGMYUV_PIPE_DEMUXER=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_IMAGE_PGX_PIPE_DEMUXER=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_IMAGE_PHOTOCD_PIPE_DEMUXER=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_IMAGE_PICTOR_PIPE_DEMUXER=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_IMAGE_PNG_PIPE_DEMUXER=1)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_IMAGE_PPM_PIPE_DEMUXER=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_IMAGE_PSD_PIPE_DEMUXER=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_IMAGE_QDRAW_PIPE_DEMUXER=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_IMAGE_SGI_PIPE_DEMUXER=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_IMAGE_SUNRAST_PIPE_DEMUXER=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_IMAGE_SVG_PIPE_DEMUXER=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_IMAGE_TIFF_PIPE_DEMUXER=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_IMAGE_WEBP_PIPE_DEMUXER=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_IMAGE_XBM_PIPE_DEMUXER=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_IMAGE_XPM_PIPE_DEMUXER=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_IMAGE_XWD_PIPE_DEMUXER=0)


#CONFIG PROTOCOLS
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_FILE_PROTOCOL=1)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_PIPE_PROTOCOL=1)

target_compile_definitions(ffmpeg_config INTERFACE CONFIG_ZLIB=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_SWSCALE_ALPHA=0)

target_compile_definitions(ffmpeg_config INTERFACE ARCH_X86_32=0)
target_compile_definitions(ffmpeg_config INTERFACE ARCH_X86_64=0)
target_compile_definitions(ffmpeg_config INTERFACE ARCH_AARCH64=0)
target_compile_definitions(ffmpeg_config INTERFACE ARCH_ARM=0)
target_compile_definitions(ffmpeg_config INTERFACE ARCH_PPC=0)
target_compile_definitions(ffmpeg_config INTERFACE ARCH_X86=0)
target_compile_definitions(ffmpeg_config INTERFACE ARCH_MIPS=0)
target_compile_definitions(ffmpeg_config INTERFACE ARCH_ALPHA=0)
target_compile_definitions(ffmpeg_config INTERFACE ARCH_LOONGARCH=0)
target_compile_definitions(ffmpeg_config INTERFACE ARCH_LOONGARCH64=0)

target_compile_definitions(ffmpeg_config INTERFACE SWS_MAX_FILTER_SIZE=256)

#_________________________WARNINGS__________________________________________
#TODO[cmake]: set it for all targets individually or remove for WARNING HELL
if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    add_compile_options("-w")
endif()

if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    add_compile_options("-w")
endif()

if (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    cmake_policy(SET CMP0092 NEW) #cmake disable std MSVC warnings in CMAKE_C_FLAGS
    #CMAKE_DEPFILE_FLAGS_C var in windows contains only /showIncludes and produce include tree
    set(CMAKE_DEPFILE_FLAGS_C "") #erase it
    add_compile_options("/w")
endif()

file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/include/config.h "//cmake config will define all that")
target_include_directories(ffmpeg_config INTERFACE ${CMAKE_CURRENT_BINARY_DIR}/include)

#TODO[cmake]: resolve config_components.h
file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/include/config_components.h "//")
target_include_directories(ffmpeg_config INTERFACE ${CMAKE_CURRENT_BINARY_DIR}/include)

add_subdirectory(compat)
add_subdirectory(libavutil)
add_subdirectory(libavcodec)
add_subdirectory(libavformat)
add_subdirectory(libavdevice)
add_subdirectory(libavfilter)
add_subdirectory(libswresample)
add_subdirectory(libswscale)
add_subdirectory(libpostproc)

add_subdirectory(fftools)

add_subdirectory(doc/examples)