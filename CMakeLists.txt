cmake_minimum_required(VERSION 3.10)

project(FFMPEG)

#TODO: configure config.h
add_library(ffmpeg_config INTERFACE)

target_compile_definitions(ffmpeg_config INTERFACE HAVE_PTHREADS=0)
target_compile_definitions(ffmpeg_config INTERFACE FFMPEG_CONFIGURATION="wia cmake")
target_compile_definitions(ffmpeg_config INTERFACE HAVE_W32THREADS=0)
target_compile_definitions(ffmpeg_config INTERFACE HAVE_OS2THREADS=0)
target_compile_definitions(ffmpeg_config INTERFACE HAVE_ISNAN=0)
target_compile_definitions(ffmpeg_config INTERFACE HAVE_MMX2=HAVE_MMXEXT)
target_compile_definitions(ffmpeg_config INTERFACE HAVE_MMX2=HAVE_MMXEXT)
target_compile_definitions(ffmpeg_config INTERFACE HAVE_MMXEXT=0)
target_compile_definitions(ffmpeg_config INTERFACE FFMPEG_LICENSE="I am from russia, what sourcecode license is?")
target_compile_definitions(ffmpeg_config INTERFACE CONFIG_MEMORY_POISONING=0)

file(WRITE ${CMAKE_BINARY_DIR}/config.h "//cmake config will define all that")



#add_subdirectory(compat)
add_subdirectory(libavutil)
add_subdirectory(libavcodec)