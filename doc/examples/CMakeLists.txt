cmake_minimum_required(VERSION 3.15)

project(Examples)

add_executable(decode_video decode_video.c)

target_link_libraries(decode_video PRIVATE avutil)
target_link_libraries(decode_video PRIVATE avcodec)

if (UNIX)
    #un unix we need manually link with math library
    #TODO: if decode_video would link dynamically or statically do not link with libm because dynlib libm will cascade on linux from top
    find_library(MATH_LIBRARY NAMES m)
    target_link_libraries(decode_video PRIVATE ${MATH_LIBRARY})
endif()