add_library(ffmpeg.avfilter.config INTERFACE)
add_library(ffmpeg.avfilter.headers INTERFACE)
add_library(ffmpeg.avfilter.core.objects OBJECT)

list(APPEND FFMPEG_AVFILTER_COMPONENTS ffmpeg.avfilter.core.objects)
list(APPEND FFMPEG_AVFILTER_FILTERS_LIST)


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

gen_headers(ffmpeg.avfilter.header_names CMAKE_CURRENT_SOURCE_DIR "${AVFILTER_GENERATED_INCLUDE_DIRECTORY}/libavfilter")

list(APPEND FFMPEG_AVFILTER_FILTERS_LIST
    ff_asrc_abuffer #standard audio filter defined in buffersrc.c
    ff_vsrc_buffer #standard video filter defined in buffersrc.c
    ff_asink_abuffer #standard audio filter defined in buffersink.c
    ff_vsink_buffer #standard video filter defined in buffersink.c
)


include(vf_null_filter.cmake)
include(vf_format_filter.cmake)
include(vf_scale.cmake)

string(APPEND FFMPEG_AVFILTER_FILTERS_LIST_CONTENT "static const AVFilter * const filter_list[] = {\n")
foreach(AVFILTER_NAME ${FFMPEG_AVFILTER_FILTERS_LIST})
    string(APPEND FFMPEG_AVFILTER_FILTERS_LIST_CONTENT "&${AVFILTER_NAME}\,\n")
endforeach()
string(APPEND FFMPEG_AVFILTER_FILTERS_LIST_CONTENT "NULL\n")
string(APPEND FFMPEG_AVFILTER_FILTERS_LIST_CONTENT "}\;\n")
file(GENERATE OUTPUT "${AVFILTER_GENERATED_INCLUDE_DIRECTORY}/libavfilter/filter_list.c" CONTENT ${FFMPEG_AVFILTER_FILTERS_LIST_CONTENT})


target_include_directories(ffmpeg.avfilter.headers INTERFACE
    ${AVFILTER_GENERATED_INCLUDE_DIRECTORY}
)


target_sources(ffmpeg.avfilter.core.objects PRIVATE ${ffmpeg.avfilter.sources})


foreach(FFMPEG_AVFILTER_COMPONENT ${FFMPEG_AVFILTER_COMPONENTS})
    set_property(TARGET ${FFMPEG_AVFILTER_COMPONENT} PROPERTY POSITION_INDEPENDENT_CODE TRUE)
    target_link_libraries(${FFMPEG_AVFILTER_COMPONENT} PRIVATE
        ffmpeg.avfilter.headers
        ffmpeg.avfilter.config
        ffmpeg.avutil.config
        ffmpeg.avutil.headers
        ffmpeg.swscale.config
        ffmpeg.swscale.headers
    )
endforeach()

set(FFMPEG_AVFILTER_COMPONENTS ${FFMPEG_AVFILTER_COMPONENTS} PARENT_SCOPE)


foreach(FFMPEG_AVFILTER_COMPONENT ${FFMPEG_AVFILTER_COMPONENTS})
    message(STATUS "[avfilter] Built component ${FFMPEG_AVFILTER_COMPONENT}")
endforeach()
