add_library(ffmpeg.avcodec.bmp.config INTERFACE)
add_library(ffmpeg.avcodec.bmp.objects OBJECT)


list(APPEND FFMPEG_AVCODEC_CODEC_LIST
    "ff_bmp_decoder"
    "ff_bmp_encoder"
)
list(APPEND FFMPEG_AVCODEC_PARSER_LIST "ff_bmp_parser")
list(APPEND FFMPEG_AVCODEC_COMPONENTS ffmpeg.avcodec.bmp.objects)



set(USE_PREPEND_HACK 1)


# CONFIG_BMP_PARSER
list(APPEND ffmpeg.avcodec.bmp.sources
    bmp_parser.c
)


# CONFIG_BMP_ENCODER
list(APPEND ffmpeg.avcodec.bmp.sources
    bmpenc.c
)


# CONFIG_BMP_DECODER
list(APPEND ffmpeg.avcodec.bmp.sources
    msrledec.c
)


target_compile_definitions(ffmpeg.avcodec.bmp.config INTERFACE
)

if (NOT USE_PREPEND_HACK)
list(APPEND ffmpeg.avcodec.bmp.sources bmp.c)
else()
list(APPEND ffmpeg.avcodec.bmp.sources_prepended bmp.c "#include \"libavutil/internal.h\"")
endif()

if (USE_PREPEND_HACK)
    set(PREPEND_HACK_DIR_BMP "${PREPEND_HACK_DIR}/bmp")
    gen_prepend_hack(ffmpeg.avcodec.bmp.sources_prepended PREPEND_HACK_DIR_BMP "avcodec.bmp" ffmpeg.avcodec.bmp.sources)
endif()

target_sources(ffmpeg.avcodec.bmp.objects PRIVATE ${ffmpeg.avcodec.bmp.sources})
target_link_libraries(ffmpeg.avcodec.bmp.objects PRIVATE
    ffmpeg.avcodec.bmp.config
)
