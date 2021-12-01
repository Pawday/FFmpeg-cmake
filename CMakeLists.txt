cmake_minimum_required(VERSION 3.15)

project(FFMPEG)

add_library(ffmpeg_config INTERFACE)

#TODO: config all that properly
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
target_compile_definitions(ffmpeg_config INTERFACE ARCH_X86_32=0)
target_compile_definitions(ffmpeg_config INTERFACE ARCH_X86_64=0)

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
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_MPEGVIDEO=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_SMALL=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_H264_D3D11VA_HWACCEL=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_H264_DXVA2_HWACCEL=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_H264_NVDEC_HWACCEL=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_H264_VAAPI_HWACCEL=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_H264_VIDEOTOOLBOX_HWACCEL=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_H264_VDPAU_HWACCEL=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_NETWORK=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_XVMC=0)

target_compile_definitions(ffmpeg_config INTERFACE CONFIG_AVUTIL=1)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_AVCODEC=1)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_AVFORMAT=1)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_AVDEVICE=1)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_SWSCALE=1)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_SWRESAMPLE=1)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_POSTPROC=1)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_AVFILTER=1)

target_compile_definitions(ffmpeg_config INTERFACE CONFIG_ZLIB=0)
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_SWSCALE_ALPHA=0)

target_compile_definitions(ffmpeg_config INTERFACE ARCH_AARCH64=0)
target_compile_definitions(ffmpeg_config INTERFACE ARCH_ARM=0)
target_compile_definitions(ffmpeg_config INTERFACE ARCH_PPC=0)
target_compile_definitions(ffmpeg_config INTERFACE ARCH_X86=0)
target_compile_definitions(ffmpeg_config INTERFACE ARCH_MIPS=0)
target_compile_definitions(ffmpeg_config INTERFACE ARCH_ALPHA=0)

target_compile_definitions(ffmpeg_config INTERFACE SWS_MAX_FILTER_SIZE=256)

if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    add_compile_options("-w") #TODO set it for all targets individually or remove for WARNING HELL
endif()

if (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    cmake_policy(SET CMP0092 NEW) #cmake disable std MSVC warnings in CMAKE_C_FLAGS
    #CMAKE_DEPFILE_FLAGS_C var in windows contains only /showIncludes and produce include tree
    set(CMAKE_DEPFILE_FLAGS_C "") #erase it
    add_compile_options("/w") #TODO set it for all targets individually or remove for WARNING HELL
endif()

file(WRITE ${CMAKE_BINARY_DIR}/include/config.h "//cmake config will define all that")

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