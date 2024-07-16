add_library(ffmpeg.avcodec.h264.config INTERFACE)
ff_create_component(avcodec.h264 OBJECT)

list(APPEND FFMPEG_AVCODEC_CODEC_LIST "ff_h264_decoder")
list(APPEND FFMPEG_AVCODEC_PARSER_LIST "ff_h264_parser")
list(APPEND FFMPEG_AVCODEC_COMPONENTS avcodec.h264)

set(USE_PREPEND_HACK 1)


# CONFIG_H264DSP
list(APPEND FFMPEG_AVCODEC_H264_SOURCES h264dsp.c)

if (NOT USE_PREPEND_HACK)
list(APPEND FFMPEG_AVCODEC_H264_SOURCES h264idct.c)
else()
list(APPEND FFMPEG_AVCODEC_H264_SOURCES_PREPENDED h264idct.c "#include \"libavutil/internal.h\"")
endif()

# CONFIG_H264CHROMA
list(APPEND FFMPEG_AVCODEC_H264_SOURCES h264chroma.c)

# CONFIG_H264_PARSER
if (NOT USE_PREPEND_HACK)
list(APPEND FFMPEG_AVCODEC_H264_SOURCES h264_parser.c)
else()
list(APPEND FFMPEG_AVCODEC_H264_SOURCES_PREPENDED h264_parser.c "#include \"libavutil/internal.h\"")
endif()

# CONFIG_H264QPEL
list(APPEND FFMPEG_AVCODEC_H264_SOURCES h264qpel.c)

# CONFIG_H264PRED
list(APPEND FFMPEG_AVCODEC_H264_SOURCES h264pred.c)

# CONFIG_H264PARSE
list(APPEND FFMPEG_AVCODEC_H264_SOURCES
    h2645_parse.c
    h2645data.c
)
if (NOT USE_PREPEND_HACK)
list(APPEND FFMPEG_AVCODEC_H264_SOURCES
    h264_parse.c
    h264_ps.c
    h2645_vui.c
)
else()
list(APPEND FFMPEG_AVCODEC_H264_SOURCES_PREPENDED
    h264_parse.c "#include \"libavutil/internal.h\""
    h264_ps.c "#include \"libavutil/internal.h\""
    h2645_vui.c "#include \"libavutil/internal.h\""
)
endif()


# CONFIG_H264_SEI
if (NOT USE_PREPEND_HACK)
list(APPEND FFMPEG_AVCODEC_H264_SOURCES
    h264_sei.c
    h2645_sei.c
)
else()
list(APPEND FFMPEG_AVCODEC_H264_SOURCES_PREPENDED
    h264_sei.c "#include \"libavutil/internal.h\""
    h2645_sei.c "#include \"libavutil/internal.h\""
)
endif()

# CONFIG_H264_DECODER
list(APPEND FFMPEG_AVCODEC_H264_SOURCES
    h264_loopfilter.c
    h264_mb.c
    h264_picture.c
    h264data.c
    h274.c
)
if (NOT USE_PREPEND_HACK)
list(APPEND FFMPEG_AVCODEC_H264_SOURCES
    h264dec.c
    h264_cabac.c
    h264_cavlc.c
    h264_direct.c
    h264_refs.c
    h264_slice.c
)
else()
list(APPEND FFMPEG_AVCODEC_H264_SOURCES_PREPENDED
    h264dec.c "#include \"libavutil/internal.h\""
    h264_cabac.c "#include \"libavutil/internal.h\""
    h264_cavlc.c "#include \"libavutil/internal.h\""
    h264_direct.c "#include \"libavutil/internal.h\""
    h264_refs.c "#include \"libavutil/internal.h\""
    h264_slice.c "#include \"libavutil/internal.h\""
)
endif()

# CONFIG_GOLOMB
list(APPEND FFMPEG_AVCODEC_H264_SOURCES golomb.c)

# CONFIG_STARTCODE
list(APPEND FFMPEG_AVCODEC_H264_SOURCES startcode.c)

# CONFIG_VIDEODSP
list(APPEND FFMPEG_AVCODEC_H264_SOURCES videodsp.c)

# CONFIG_CABAC
list(APPEND FFMPEG_AVCODEC_H264_SOURCES cabac.c)

# CONFIG_ATSC_A53
list(APPEND FFMPEG_AVCODEC_H264_SOURCES atsc_a53.c)



target_compile_definitions(ffmpeg.avcodec.h264.config INTERFACE
    CONFIG_ERROR_RESILIENCE=0

    CONFIG_H264_SEI=0
    CONFIG_HEVC_SEI=0

    CONFIG_H264_D3D11VA_HWACCEL=0
    CONFIG_H264_D3D12VA_HWACCEL=0
    CONFIG_H264_DXVA2_HWACCEL=0
    CONFIG_H264_NVDEC_HWACCEL=0
    CONFIG_H264_VAAPI_HWACCEL=0
    CONFIG_H264_VDPAU_HWACCEL=0
    CONFIG_H264_VIDEOTOOLBOX_HWACCEL=0
    CONFIG_H264_VULKAN_HWACCEL=0
)


if (USE_PREPEND_HACK)
    set(PREPEND_HACK_DIR_H264 "${PREPEND_HACK_DIR}/h264")
    gen_prepend_hack(FFMPEG_AVCODEC_H264_SOURCES_PREPENDED PREPEND_HACK_DIR_H264 "avcodec.h264" FFMPEG_AVCODEC_H264_SOURCES)
endif()

ff_component_sources(avcodec.h264 FFMPEG_AVCODEC_H264_SOURCES)
ff_component_link_library(avcodec.h264 PRIVATE
    ffmpeg.avcodec.h264.config
)
