cmake_minimum_required(VERSION 3.10)
project(avcodec)

list(APPEND AVCODEC_PUBLIC_HEADERS avcodec.h)

list(APPEND AVCODEC_SOURCES avcodec.c)


add_library(avcodec OBJECT ${AVCODEC_SOURCES})
target_include_directories(avcodec PUBLIC ${CMAKE_BINARY_DIR})

target_link_libraries(avcodec PUBLIC ffmpeg_config)

add_library(avcodec_static STATIC $<TARGET_OBJECTS:avcodec>)

