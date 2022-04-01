cmake_minimum_required(VERSION 3.15)

project(FFMPEG_TOOLS)

list(APPEND FFMPEG_SOURCES ffmpeg.c)
list(APPEND FFMPEG_SOURCES cmdutils.c)
list(APPEND FFMPEG_SOURCES ffmpeg_opt.c)
list(APPEND FFMPEG_SOURCES ffmpeg_hw.c)
list(APPEND FFMPEG_SOURCES ffmpeg_filter.c)

#TODO[cmake]: WAIT FIX - disaster with opt_common.c ...
# at commit a545cb2b9dc689ae19e75be27a3550d97cb9cf72
# Anton Khirnov introduced opt_common.c file
# in print_all_libs_info function macro expansion with AVFILTER parameter
# generates LIBAVFILTER_VERSION_MINOR macro...
# LIBAVFILTER_VERSION_MINOR macro defined in libavfilter/version.h
# but Anton Khirnov DOES NOT INCLUDE libavfilter/version.h into opt_common.c or opt_common.h
# because all of than we need to include it manually here

file(READ ${CMAKE_CURRENT_SOURCE_DIR}/opt_common.c OPT_COMMON_C_FILE_CONTENT)



string(APPEND OPT_COMMON_C_FILE_CONTENT_MODIFIED "//---------------PREPROCESSED VIA CMAKE---------------\n")
string(APPEND OPT_COMMON_C_FILE_CONTENT_MODIFIED "#include \"libavfilter/version.h\"\n")
string(APPEND OPT_COMMON_C_FILE_CONTENT_MODIFIED "//------------END CMAKE PREPROCESS---------------\n\n")
string(APPEND OPT_COMMON_C_FILE_CONTENT_MODIFIED "${OPT_COMMON_C_FILE_CONTENT}")

file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/hack/opt_common_PREPROC.c "${OPT_COMMON_C_FILE_CONTENT_MODIFIED}")
list(APPEND FFMPEG_SOURCES ${CMAKE_CURRENT_BINARY_DIR}/hack/opt_common_PREPROC.c)


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