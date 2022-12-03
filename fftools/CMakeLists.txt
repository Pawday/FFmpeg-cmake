cmake_minimum_required(VERSION 3.15)

project(FFMPEG_TOOLS)

list(APPEND FFMPEG_SOURCES ffmpeg.c)
list(APPEND FFMPEG_SOURCES cmdutils.c)
list(APPEND FFMPEG_SOURCES ffmpeg_opt.c)
list(APPEND FFMPEG_SOURCES ffmpeg_hw.c)
list(APPEND FFMPEG_SOURCES ffmpeg_filter.c)
list(APPEND FFMPEG_SOURCES opt_common.c)
list(APPEND FFMPEG_SOURCES ffmpeg_mux.c)
list(APPEND FFMPEG_SOURCES ffmpeg_demux.c)
list(APPEND FFMPEG_SOURCES sync_queue.c)
list(APPEND FFMPEG_SOURCES objpool.c)
list(APPEND FFMPEG_SOURCES thread_queue.c)
list(APPEND FFMPEG_SOURCES ffmpeg_mux_init.c)


add_executable(ffmpeg ${FFMPEG_SOURCES})

target_include_directories(ffmpeg PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})

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
    #on unix we need manually link with math library
    #TODO[cmake]: deal with unix math dynlib
    #if ffmpeg would link dynamically or statically do not link with libm because dynlib libm will cascade on linux from top
    find_library(MATH_LIBRARY NAMES m)
    target_link_libraries(ffmpeg PRIVATE ${MATH_LIBRARY})
endif()
