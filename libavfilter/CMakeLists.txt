add_library(ffmpeg.avfilter.config INTERFACE)
add_library(ffmpeg.avfilter.headers INTERFACE)
ff_create_component(avfilter.core)

list(APPEND FFMPEG_AVFILTER_COMPONENTS avfilter.core)
list(APPEND FFMPEG_AVFILTER_FILTERS_LIST)


list(APPEND FFMPEG_AVFILTER_SOURCES
    buffersrc.c
    buffersink.c
)

list(APPEND FFMPEG_AVFILTER_SOURCES
    allfilters.c
    audio.c
    avfilter.c
    avfilter.c
    avfiltergraph.c
    formats.c
    framepool.c
    framequeue.c
    framesync.c
    graphparser.c
    version.c
    video.c
)


set(FFMPEG_AVFILTER_GENERATED_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/generated")
set(AVFILTER_GENERATED_INCLUDE_DIRECTORY "${FFMPEG_AVFILTER_GENERATED_DIRECTORY}/include")

include(avfilter_headers.cmake)

gen_headers(FFMPEG_AVFILTER_HEADER_NAMES CMAKE_CURRENT_SOURCE_DIR "${AVFILTER_GENERATED_INCLUDE_DIRECTORY}/libavfilter")

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


ff_component_sources(avfilter.core FFMPEG_AVFILTER_SOURCES)


foreach(FFMPEG_AVFILTER_COMPONENT ${FFMPEG_AVFILTER_COMPONENTS})
    ff_component_link_library(${FFMPEG_AVFILTER_COMPONENT} PRIVATE ffmpeg.avfilter.headers)
    ff_component_link_library(${FFMPEG_AVFILTER_COMPONENT} PRIVATE ffmpeg.avfilter.config)
    ff_component_link_library(${FFMPEG_AVFILTER_COMPONENT} PRIVATE ffmpeg.avutil.config)
    ff_component_link_library(${FFMPEG_AVFILTER_COMPONENT} PRIVATE ffmpeg.avutil.headers)
    ff_component_link_library(${FFMPEG_AVFILTER_COMPONENT} PRIVATE ffmpeg.swscale.config)
    ff_component_link_library(${FFMPEG_AVFILTER_COMPONENT} PRIVATE ffmpeg.swscale.headers)
endforeach()

set(FFMPEG_AVFILTER_COMPONENTS ${FFMPEG_AVFILTER_COMPONENTS} PARENT_SCOPE)


foreach(FFMPEG_AVFILTER_COMPONENT ${FFMPEG_AVFILTER_COMPONENTS})
    ffmpeg_message(STATUS "avfilter" "Built component ${FFMPEG_AVFILTER_COMPONENT}")
endforeach()
