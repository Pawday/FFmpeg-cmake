cmake_minimum_required(VERSION 3.10)

project(AVFILTER)

list(APPEND AVFILTER_ALL_HEADERS avfilter.h)
list(APPEND AVFILTER_ALL_HEADERS buffersrc.h)
list(APPEND AVFILTER_ALL_HEADERS buffersink.h)
list(APPEND AVFILTER_ALL_HEADERS version.h)

foreach(AVFILTER_HEADER ${AVFILTER_ALL_HEADERS})
    file(COPY ${AVFILTER_HEADER} DESTINATION ${CMAKE_BINARY_DIR}/include/libavfilter/)
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



#generating filter_list.c
#TODO: register all available filters
#list(APPEND AVFILTER_REGISTERED_FILTERS_IDS filterid)

set(FILTER_LIST_C_FILE_CONTENT)
string(APPEND FILTER_LIST_C_FILE_CONTENT "static const AVFilter * const filter_list[] = {\n")

foreach(FILTER_NAME ${AVFILTER_REGISTERED_FILTERS_IDS})
    string(APPEND FILTER_LIST_C_FILE_CONTENT "&${FILTER_NAME},\n")
endforeach()

string(APPEND FILTER_LIST_C_FILE_CONTENT "NULL\n")
string(APPEND FILTER_LIST_C_FILE_CONTENT "}\;")

file(WRITE ${CMAKE_BINARY_DIR}/generated/libavfilter/filter_list.c ${FILTER_LIST_C_FILE_CONTENT})

add_library(avfilter OBJECT ${AVFILTER_SOURCES})

target_link_libraries(avfilter PRIVATE avutil)

target_include_directories(avfilter PRIVATE ${CMAKE_BINARY_DIR}/generated/)

target_link_libraries(avfilter PRIVATE ffmpeg_config)
add_library(avfilter_static STATIC $<TARGET_OBJECTS:avfilter>)
