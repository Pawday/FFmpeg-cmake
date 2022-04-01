cmake_minimum_required(VERSION 3.15)

project(AVFILTER)

list(APPEND AVFILTER_ALL_HEADERS version.h)
list(APPEND AVFILTER_ALL_HEADERS version_major.h)

list(APPEND AVFILTER_ALL_HEADERS avfilter.h)
list(APPEND AVFILTER_ALL_HEADERS buffersrc.h)
list(APPEND AVFILTER_ALL_HEADERS buffersink.h)

foreach(AVFILTER_HEADER ${AVFILTER_ALL_HEADERS})
    file(COPY ${AVFILTER_HEADER} DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/include/libavfilter/)
endforeach()

list(APPEND AVFILTER_SOURCES avfilter.c)
list(APPEND AVFILTER_SOURCES buffersrc.c)
list(APPEND AVFILTER_SOURCES buffersink.c)
list(APPEND AVFILTER_SOURCES avfilter.c)
list(APPEND AVFILTER_SOURCES buffersrc.h)
list(APPEND AVFILTER_SOURCES framequeue.c)
list(APPEND AVFILTER_SOURCES framepool.c)
list(APPEND AVFILTER_SOURCES avfiltergraph.c)
list(APPEND AVFILTER_SOURCES formats.c)
list(APPEND AVFILTER_SOURCES audio.c)
list(APPEND AVFILTER_SOURCES video.c)
list(APPEND AVFILTER_SOURCES allfilters.c)
list(APPEND AVFILTER_SOURCES graphparser.c)


#set(APPEND AVFILTER_REGISTERED_FILTERS_SOURCES "") #its filled by each  <filtername>_filter cmake



#generating filter_list.c
#TODO[cmake]: register all available filters
#list(APPEND AVFILTER_REGISTERED_FILTERS_IDS filterid)


list(APPEND AVFILTER_REGISTERED_FILTERS_IDS ff_asrc_abuffer) #standard audio filter defined in buffersrc.c
list(APPEND AVFILTER_REGISTERED_FILTERS_IDS ff_vsrc_buffer) #standard video filter defined in buffersrc.c
list(APPEND AVFILTER_REGISTERED_FILTERS_IDS ff_asink_abuffer) #standard audio filter defined in buffersink.c
list(APPEND AVFILTER_REGISTERED_FILTERS_IDS ff_vsink_buffer) #standard video filter defined in buffersink.c

include(vf_null_filter.cmake)
include(vf_format_filter.cmake)
include(vf_scale.cmake)

set(FILTER_LIST_C_FILE_CONTENT)
string(APPEND FILTER_LIST_C_FILE_CONTENT "static const AVFilter * const filter_list[] = {\n")

foreach(FILTER_NAME ${AVFILTER_REGISTERED_FILTERS_IDS})
    string(APPEND FILTER_LIST_C_FILE_CONTENT "&${FILTER_NAME},\n")
endforeach()

string(APPEND FILTER_LIST_C_FILE_CONTENT "NULL\n")
string(APPEND FILTER_LIST_C_FILE_CONTENT "}\;")

file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/generated/libavfilter/filter_list.c ${FILTER_LIST_C_FILE_CONTENT})

add_library(avfilter OBJECT ${AVFILTER_SOURCES})
target_include_directories(avfilter PUBLIC ${CMAKE_CURRENT_BINARY_DIR}/include/)

if (AVFILTER_REGISTERED_FILTERS_SOURCES)
    target_sources(avfilter PRIVATE ${AVFILTER_REGISTERED_FILTERS_SOURCES})
endif ()

target_link_libraries(avfilter PRIVATE avutil)

target_include_directories(avfilter PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/generated/)

target_link_libraries(avfilter PRIVATE ffmpeg_config)
target_link_libraries(avfilter PRIVATE swscale)

add_library(avfilter_static STATIC $<TARGET_OBJECTS:avfilter>)
