add_library(ffmpeg.avcodec.bmp.config INTERFACE)
ff_create_component(avcodec.bmp OBJECT)


list(APPEND FFMPEG_AVCODEC_CODEC_LIST
    "ff_bmp_decoder"
    "ff_bmp_encoder"
)
list(APPEND FFMPEG_AVCODEC_PARSER_LIST "ff_bmp_parser")
list(APPEND FFMPEG_AVCODEC_COMPONENTS avcodec.bmp)



set(USE_PREPEND_HACK 1)


# CONFIG_BMP_PARSER
list(APPEND FFMPEG_AVCODEC_BMP_SOURCES
    bmp_parser.c
)


# CONFIG_BMP_ENCODER
list(APPEND FFMPEG_AVCODEC_BMP_SOURCES
    bmpenc.c
)


# CONFIG_BMP_DECODER
list(APPEND FFMPEG_AVCODEC_BMP_SOURCES
    msrledec.c
)


target_compile_definitions(ffmpeg.avcodec.bmp.config INTERFACE
)

if (NOT USE_PREPEND_HACK)
list(APPEND FFMPEG_AVCODEC_BMP_SOURCES bmp.c)
else()
list(APPEND FFMPEG_AVCODEC_BMP_SOURCES_PREPENDED bmp.c "#include \"libavutil/internal.h\"")
endif()

if (USE_PREPEND_HACK)
    set(PREPEND_HACK_DIR_BMP "${PREPEND_HACK_DIR}/bmp")
    gen_prepend_hack(FFMPEG_AVCODEC_BMP_SOURCES_PREPENDED PREPEND_HACK_DIR_BMP "avcodec.bmp" FFMPEG_AVCODEC_BMP_SOURCES)
endif()

ff_component_sources(avcodec.bmp FFMPEG_AVCODEC_BMP_SOURCES)
ff_component_link_library(avcodec.bmp PRIVATE
    ffmpeg.avcodec.bmp.config
)
