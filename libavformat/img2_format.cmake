list(APPEND ffmpeg.avformat.core.sources
    img2.c
)

list(APPEND ffmpeg.avformat.core.sources_prepended
    img2dec.c "#include \"libavutil/internal.h\""
    img2enc.c "#include \"libavutil/internal.h\""
)

target_compile_definitions(ffmpeg.avformat.config INTERFACE CONFIG_IMAGE2_DEMUXER=1)
list(APPEND FFMPEG_AVFORMAT_MUXERS
    ff_image2_muxer
    ff_image2pipe_muxer
)

target_compile_definitions(ffmpeg.avformat.config INTERFACE  CONFIG_IMAGE2_MUXER=1)
list(APPEND FFMPEG_AVFORMAT_DEMUXERS
    ff_image2_demuxer
)


target_compile_definitions(ffmpeg.avformat.config INTERFACE CONFIG_IMAGE2PIPE_MUXER=1)
list(APPEND FFMPEG_AVFORMAT_DEMUXERS
    ff_image_bmp_pipe_demuxer
    #ff_image_png_pipe_demuxer
)



list(APPEND ffmpeg.avformat.imagepipe_demuxers
    BMP 1
    CRI 0
    DDS 0
    DPX 0
    EXR 0
    GEM 0
    GIF 0
    HDR 0
    J2K 0
    JPEG 0
    JPEGLS 0
    JPEGXL 0
    PAM 0
    PBM 0
    PCX 0
    PFM 0
    PGM 0
    PGMYUV 0
    PGX 0
    PHM 0
    PHOTOCD 0
    PICTOR 0
    PNG 0
    PPM 0
    PSD 0
    QDRAW 0
    QOI 0
    SGI 0
    SUNRAST 0
    SVG 0
    TIFF 0
    VBN 0
    WEBP 0
    XBM 0
    XPM 0
    XWD 0
)

list(LENGTH ffmpeg.avformat.imagepipe_demuxers ffmpeg.avformat.imagepipe_demuxers_size)
math(EXPR SHOULD_BE_ZERO "${ffmpeg.avformat.imagepipe_demuxers_size} % 2")
if(NOT 0 EQUAL ${SHOULD_BE_ZERO})
    ffmpeg_message(FATAL_ERROR "avformat" "Broken ffmpeg.avformat.imagepipe_demuxers map")
endif()
math(EXPR ffmpeg.avformat.imagepipe_demuxers_size "${ffmpeg.avformat.imagepipe_demuxers_size} / 2")

foreach(IMG_DEMUXER_INDEX RANGE 1 ${ffmpeg.avformat.imagepipe_demuxers_size})
    math(EXPR IMG_DEMUXER_INDEX "${IMG_DEMUXER_INDEX}-1")
    math(EXPR IMG_DEMUXER_KEY_INDEX "${IMG_DEMUXER_INDEX} * 2")
    math(EXPR IMG_DEMUXER_VAL_INDEX "${IMG_DEMUXER_INDEX} * 2 + 1")

    list(GET ffmpeg.avformat.imagepipe_demuxers ${IMG_DEMUXER_KEY_INDEX} DEMUXER_NAME)
    list(GET ffmpeg.avformat.imagepipe_demuxers ${IMG_DEMUXER_VAL_INDEX} DEMUXER_ENABLED)

    set(DEMUXER_CONFIG_NAME "CONFIG_IMAGE_${DEMUXER_NAME}_PIPE_DEMUXER")
    ffmpeg_message(STATUS "avformat" "${DEMUXER_CONFIG_NAME} ${DEMUXER_ENABLED}")

    target_compile_definitions(ffmpeg.avformat.config INTERFACE ${DEMUXER_CONFIG_NAME}=${DEMUXER_ENABLED})
endforeach()


