cmake_minimum_required(VERSION 3.15)

project(POSTPROC)

list(APPEND POSTPROC_ALL_HEADERS version.h)
list(APPEND POSTPROC_ALL_HEADERS version_major.h)

list(APPEND POSTPROC_ALL_HEADERS postprocess.h)

foreach(POSTPROC_HEADER ${POSTPROC_ALL_HEADERS})
    file(COPY ${POSTPROC_HEADER} DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/include/libpostproc/)
endforeach()

list(APPEND POSTPROC_SOURCES postprocess.c)

add_library(postproc OBJECT ${POSTPROC_SOURCES})
add_library(postproc_static STATIC $<TARGET_OBJECTS:postproc>)

target_link_libraries(postproc PRIVATE ffmpeg_config)
target_link_libraries(postproc PRIVATE avutil)

target_include_directories(postproc PUBLIC ${CMAKE_CURRENT_BINARY_DIR}/include/)