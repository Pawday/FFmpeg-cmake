cmake_minimum_required(VERSION 3.15)

project(avformat)

list(APPEND AVFORMAT_ALL_HEADERS version.h)
list(APPEND AVFORMAT_ALL_HEADERS version_major.h)

list(APPEND AVFORMAT_ALL_HEADERS avformat.h)
list(APPEND AVFORMAT_ALL_HEADERS avio.h)
list(APPEND AVFORMAT_ALL_HEADERS internal.h)
list(APPEND AVFORMAT_ALL_HEADERS id3v2.h)
list(APPEND AVFORMAT_ALL_HEADERS id3v1.h)
list(APPEND AVFORMAT_ALL_HEADERS os_support.h)


foreach(AVFORMAT_HEADER ${AVFORMAT_ALL_HEADERS})
    file(COPY ${AVFORMAT_HEADER} DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/include/libavformat)
endforeach()

list(APPEND AVFORMAT_SOURCES utils.c)
list(APPEND AVFORMAT_SOURCES mux.c)
list(APPEND AVFORMAT_SOURCES demux.c)
list(APPEND AVFORMAT_SOURCES allformats.c)
list(APPEND AVFORMAT_SOURCES aviobuf.c)
list(APPEND AVFORMAT_SOURCES avio.c)
list(APPEND AVFORMAT_SOURCES options.c)
list(APPEND AVFORMAT_SOURCES format.c)
list(APPEND AVFORMAT_SOURCES id3v2.c)
list(APPEND AVFORMAT_SOURCES id3v1.c)
list(APPEND AVFORMAT_SOURCES protocols.c)
list(APPEND AVFORMAT_SOURCES metadata.c)
list(APPEND AVFORMAT_SOURCES dump.c)
list(APPEND AVFORMAT_SOURCES sdp.c)
list(APPEND AVFORMAT_SOURCES seek.c)
list(APPEND AVFORMAT_SOURCES rawdec.c)
list(APPEND AVFORMAT_SOURCES to_upper4.c)
list(APPEND AVFORMAT_SOURCES rawenc.c)

#set(APPEND AVFORMAT_REGISTERED_PROTOCOLS_SOURCES "") #its filled by each <protoname>_proto cmake script

#set(APPEND AVFORMAT_REGISTERED_FORMATS_SOURCES "") #its filled by each  <formatname>_format cmake


#TODO[cmake]: register all muxers and demuxers

include(h264raw_format.cmake)
include(img2_format.cmake)

#generating muxer_list.c
#list(APPEND AVFORMAT_REGISTERED_MUXER_LIST_IDS muxer_id)

set(MUXER_LIST_C_FILE_CONTENT)
string(APPEND MUXER_LIST_C_FILE_CONTENT "static const AVOutputFormat * const muxer_list[] = {\n")

foreach(MUXER_NAME ${AVFORMAT_REGISTERED_MUXER_LIST_IDS})
    string(APPEND MUXER_LIST_C_FILE_CONTENT "&${MUXER_NAME},\n")
endforeach()

string(APPEND MUXER_LIST_C_FILE_CONTENT "NULL\n")
string(APPEND MUXER_LIST_C_FILE_CONTENT "}\;")

file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/generated/libavformat/muxer_list.c ${MUXER_LIST_C_FILE_CONTENT})

#generating demuxer_list.c

#list(APPEND AVFORMAT_REGISTERED_DEMUXER_LIST_IDS muxer_id)

set(DEMUXER_LIST_C_FILE_CONTENT)
string(APPEND DEMUXER_LIST_C_FILE_CONTENT "static const AVInputFormat * const demuxer_list[] = {\n")

foreach(DEMUXER_NAME ${AVFORMAT_REGISTERED_DEMUXER_LIST_IDS})
    string(APPEND DEMUXER_LIST_C_FILE_CONTENT "&${DEMUXER_NAME},\n")
endforeach()

string(APPEND DEMUXER_LIST_C_FILE_CONTENT "NULL\n")
string(APPEND DEMUXER_LIST_C_FILE_CONTENT "}\;")

file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/generated/libavformat/demuxer_list.c ${DEMUXER_LIST_C_FILE_CONTENT})


#generating protocol_list.c
#TODO: [avformat] register protocols
#list(APPEND AVFORMAT_REGISTERED_PROTOCOLS_LIST_IDS protocol_id)


include(file_proto.cmake)


set(PROTOCOL_LIST_C_FILE_CONTENT)
string(APPEND PROTOCOL_LIST_C_FILE_CONTENT "static const URLProtocol * const url_protocols[] = {\n")

foreach(PROTOCOL_NAME ${AVFORMAT_REGISTERED_PROTOCOLS_LIST_IDS})
    string(APPEND PROTOCOL_LIST_C_FILE_CONTENT "&${PROTOCOL_NAME},\n")
endforeach()

string(APPEND PROTOCOL_LIST_C_FILE_CONTENT "NULL\n")
string(APPEND PROTOCOL_LIST_C_FILE_CONTENT "}\;")

file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/generated/libavformat/protocol_list.c ${PROTOCOL_LIST_C_FILE_CONTENT})


add_library(avformat OBJECT ${AVFORMAT_SOURCES})
target_include_directories(avformat PUBLIC ${CMAKE_CURRENT_BINARY_DIR}/include/)
target_include_directories(avformat PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/generated/)

if (AVFORMAT_REGISTERED_PROTOCOLS_SOURCES)
    target_sources(avformat PRIVATE ${AVFORMAT_REGISTERED_PROTOCOLS_SOURCES})
endif ()

if (AVFORMAT_REGISTERED_FORMATS_SOURCES)
    target_sources(avformat PRIVATE ${AVFORMAT_REGISTERED_FORMATS_SOURCES})
endif ()

add_library(avformat_static STATIC $<TARGET_OBJECTS:avformat>)



target_link_libraries(avformat PRIVATE ffmpeg_config)
target_link_libraries(avformat PRIVATE avutil)
target_link_libraries(avformat PRIVATE avcodec)
