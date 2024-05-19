add_library(ffmpeg.avcodec.config INTERFACE)
add_library(ffmpeg.avcodec.headers INTERFACE)
add_library(ffmpeg.avcodec.core.objects OBJECT)


list(APPEND FFMPEG_AVCODEC_CODEC_LIST)
list(APPEND FFMPEG_AVCODEC_PARSER_LIST)
list(APPEND FFMPEG_AVCODEC_COMPONENTS ffmpeg.avcodec.core.objects)


list(APPEND ffmpeg.avcodec.core.sources
    ac3_parser.c
    adts_parser.c
    allcodecs.c
    avdct.c
    avfft.c
    bitstream.c
    bitstream_filters.c
    bsf.c
    codec_desc.c
    codec_par.c
    decode.c
    dv_profile.c
    encode.c
    get_buffer.c
    imgconvert.c
    mathtables.c
    mediacodec.c
    options.c
    packet.c
    parsers.c
    profiles.c
    qsv_api.c
    raw.c
    refstruct.c
    version.c
    vlc.c
    xiph.c
)

set(FFMPEG_AVCODEC_GENERATED_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/generated")
set(AVCODEC_GENERATED_INCLUDE_DIRECTORY "${FFMPEG_AVCODEC_GENERATED_DIRECTORY}/include")
set(PREPEND_HACK_DIR "${FFMPEG_AVCODEC_GENERATED_DIRECTORY}/prepend_hack")
file(REMOVE_RECURSE ${PREPEND_HACK_DIR})

list(APPEND ffmpeg.avcodec.core.sources_prepended
    utils.c "#include \"libavutil/internal.h\""
    avcodec.c "#include \"libavutil/internal.h\""
    parser.c "#include \"libavutil/internal.h\""
)

gen_prepend_hack(ffmpeg.avcodec.core.sources_prepended PREPEND_HACK_DIR "avcodec" ffmpeg.avcodec.core.sources)

include(avcodec_headers.cmake)


include(h264.cmake)
include(bmp.cmake)


foreach(AVCODEC_HEADER ${ffmpeg.avcodec.header_names})
    set(HEADER_CONTENT "// IWYU pragma: begin_exports\n#include \"${CMAKE_CURRENT_SOURCE_DIR}/${AVCODEC_HEADER}\"\n// IWYU pragma: end_exports\n")
    file(GENERATE OUTPUT "${AVCODEC_GENERATED_INCLUDE_DIRECTORY}/libavcodec/${AVCODEC_HEADER}" CONTENT ${HEADER_CONTENT})
endforeach()


#generating bsf_list.c
message(WARNING "TODO: generate libavcodec/bsf_list.c more properly")
file(GENERATE OUTPUT "${AVCODEC_GENERATED_INCLUDE_DIRECTORY}/libavcodec/bsf_list.c" CONTENT "const FFBitStreamFilter *bitstream_filters[] = {NULL};")


#generating parser_list.c
string(APPEND FFMPEG_AVCODEC_PARSER_LIST_CONTENT "const AVCodecParser *parser_list[] = {\n")
foreach(AVPARSER_NAME ${FFMPEG_AVCODEC_PARSER_LIST})
    string(APPEND FFMPEG_AVCODEC_PARSER_LIST_CONTENT "&${AVPARSER_NAME}\,\n")
endforeach()
string(APPEND FFMPEG_AVCODEC_PARSER_LIST_CONTENT "NULL\n")
string(APPEND FFMPEG_AVCODEC_PARSER_LIST_CONTENT "}\;\n")
file(GENERATE OUTPUT "${AVCODEC_GENERATED_INCLUDE_DIRECTORY}/libavcodec/parser_list.c" CONTENT ${FFMPEG_AVCODEC_PARSER_LIST_CONTENT})


#generating codec_list.c
string(APPEND FFMPEG_AVCODEC_CODEC_LIST_CONTENT "const FFCodec *codec_list[] = {\n")
foreach(AVCODEC_NAME ${FFMPEG_AVCODEC_CODEC_LIST})
    string(APPEND FFMPEG_AVCODEC_CODEC_LIST_CONTENT "&${AVCODEC_NAME}\,\n")
endforeach()
string(APPEND FFMPEG_AVCODEC_CODEC_LIST_CONTENT "NULL\n")
string(APPEND FFMPEG_AVCODEC_CODEC_LIST_CONTENT "}\;\n")
file(GENERATE OUTPUT "${AVCODEC_GENERATED_INCLUDE_DIRECTORY}/libavcodec/codec_list.c" CONTENT ${FFMPEG_AVCODEC_CODEC_LIST_CONTENT})




target_compile_definitions(ffmpeg.avcodec.config INTERFACE
    HAVE_FAST_64BIT=0
    CONFIG_FRAME_THREAD_ENCODER=0
    CONFIG_MPEGVIDEODEC=0
    CONFIG_GRAY=0
)

target_include_directories(ffmpeg.avcodec.headers INTERFACE
    ${AVCODEC_GENERATED_INCLUDE_DIRECTORY}
)

target_sources(ffmpeg.avcodec.core.objects PRIVATE ${ffmpeg.avcodec.core.sources})

foreach(FFMPEG_AVCODEC_COMPONENT ${FFMPEG_AVCODEC_COMPONENTS})
    set_property(TARGET ${FFMPEG_AVCODEC_COMPONENT} PROPERTY POSITION_INDEPENDENT_CODE TRUE)
    target_link_libraries(${FFMPEG_AVCODEC_COMPONENT} PRIVATE
        ffmpeg.avutil.config
        ffmpeg.avutil.headers
        ffmpeg.avcodec.config
        ffmpeg.avcodec.headers
    )
endforeach()

set(FFMPEG_AVCODEC_COMPONENTS ${FFMPEG_AVCODEC_COMPONENTS} PARENT_SCOPE)


foreach(FFMPEG_AVCODEC_COMPONENT ${FFMPEG_AVCODEC_COMPONENTS})
    message(STATUS "[avcodec] Built component ${FFMPEG_AVCODEC_COMPONENT}")
endforeach()
