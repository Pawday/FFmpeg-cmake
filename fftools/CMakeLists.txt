cmake_minimum_required(VERSION 3.15)

project(FFMPEG_TOOLS)

list(APPEND FFMPEG_SOURCES ffmpeg.c)
list(APPEND FFMPEG_SOURCES cmdutils.c)
list(APPEND FFMPEG_SOURCES ffmpeg_opt.c)
list(APPEND FFMPEG_SOURCES ffmpeg_hw.c)
list(APPEND FFMPEG_SOURCES ffmpeg_filter.c)

add_executable(ffmpeg ${FFMPEG_SOURCES})

target_link_libraries(ffmpeg PRIVATE ffmpeg_config)
target_link_libraries(ffmpeg PRIVATE avcodec)
target_link_libraries(ffmpeg PRIVATE postproc)
target_link_libraries(ffmpeg PRIVATE avutil)
target_link_libraries(ffmpeg PRIVATE swscale)
target_link_libraries(ffmpeg PRIVATE swresample)
target_link_libraries(ffmpeg PRIVATE avfilter)
target_link_libraries(ffmpeg PRIVATE avformat)
target_link_libraries(ffmpeg PRIVATE avdevice)

if (UNIX)
    #un unix we need manually link with math library
    #TODO: if ffmpeg would link dynamically or statically do not link with libm because dynlib libm will cascade on linux from top
    find_library(MATH_LIBRARY NAMES m)
    target_link_libraries(ffmpeg PRIVATE ${MATH_LIBRARY})
endif()