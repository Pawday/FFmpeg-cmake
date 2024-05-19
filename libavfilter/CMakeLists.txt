add_library(ffmpeg.avfilter.config INTERFACE)

list(APPEND ffmpeg.avfilter.filter_list)


list(APPEND ffmpeg.avfilter.sources
    buffersrc.c
    buffersink.c
)

list(APPEND ffmpeg.avfilter.sources
    avfilter.c
    version.c
    avfilter.c
    buffersrc.h
    framequeue.c
    framepool.c
    avfiltergraph.c
    formats.c
    audio.c
    video.c
    allfilters.c
    graphparser.c
)


set(FFMPEG_AVFILTER_GENERATED_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/generated")
set(AVFILTER_GENERATED_INCLUDE_DIRECTORY "${FFMPEG_AVFILTER_GENERATED_DIRECTORY}/include")

include(avfilter_headers.cmake)

foreach(AVFILTER_HEADER ${ffmpeg.avfilter.header_names})
    set(HEADER_CONTENT "// IWYU pragma: begin_exports\n#include \"${CMAKE_CURRENT_SOURCE_DIR}/${AVFILTER_HEADER}\"\n// IWYU pragma: end_exports\n")
    file(GENERATE OUTPUT "${AVFILTER_GENERATED_INCLUDE_DIRECTORY}/libavfilter/${AVFILTER_HEADER}" CONTENT ${HEADER_CONTENT})
endforeach()


list(APPEND ffmpeg.avfilter.filter_list
    ff_asrc_abuffer #standard audio filter defined in buffersrc.c
    ff_vsrc_buffer #standard video filter defined in buffersrc.c
    ff_asink_abuffer #standard audio filter defined in buffersink.c
    ff_vsink_buffer #standard video filter defined in buffersink.c
)


include(vf_null_filter.cmake)
include(vf_format_filter.cmake)
include(vf_scale.cmake)

string(APPEND ffmpeg.avfilter.filter_list_content "static const AVFilter * const filter_list[] = {\n")
foreach(AVFILTER_NAME ${ffmpeg.avfilter.filter_list})
    string(APPEND ffmpeg.avfilter.filter_list_content "&${AVFILTER_NAME}\,\n")
endforeach()
string(APPEND ffmpeg.avfilter.filter_list_content "NULL\n")
string(APPEND ffmpeg.avfilter.filter_list_content "}\;\n")
file(GENERATE OUTPUT "${AVFILTER_GENERATED_INCLUDE_DIRECTORY}/libavfilter/filter_list.c" CONTENT ${ffmpeg.avfilter.filter_list_content})


add_library(ffmpeg.avfilter.headers INTERFACE)
target_include_directories(ffmpeg.avfilter.headers INTERFACE
    ${AVFILTER_GENERATED_INCLUDE_DIRECTORY}
)


add_library(ffmpeg.avfilter.objects OBJECT ${ffmpeg.avfilter.sources})
set_property(TARGET ffmpeg.avfilter.objects PROPERTY POSITION_INDEPENDENT_CODE TRUE)
target_link_libraries(ffmpeg.avfilter.objects PRIVATE
    ffmpeg.avfilter.headers
    ffmpeg.avfilter.config
    ffmpeg.avutil.config
    ffmpeg.avutil.headers
    ffmpeg.swscale.config
    ffmpeg.swscale.headers
)
