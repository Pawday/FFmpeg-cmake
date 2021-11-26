cmake_minimum_required(VERSION 3.10)

project(SWRESAMPLE)


list(APPEND SWRESAMLE_ALL_HEADERS swresample.h)
list(APPEND SWRESAMLE_ALL_HEADERS version.h)

foreach(SWRESAMLE_HEADER ${SWRESAMLE_ALL_HEADERS})
    file(COPY ${SWRESAMLE_HEADER} DESTINATION ${CMAKE_BINARY_DIR}/include/libswresample/)
endforeach()

list(APPEND SWRESAMLE_SOURCES swresample.c)
list(APPEND SWRESAMLE_SOURCES options.c)
list(APPEND SWRESAMLE_SOURCES audioconvert.c)
list(APPEND SWRESAMLE_SOURCES rematrix.c)
list(APPEND SWRESAMLE_SOURCES resample.c)
list(APPEND SWRESAMLE_SOURCES dither.c)
list(APPEND SWRESAMLE_SOURCES resample_dsp.c)

add_library(swresample OBJECT ${SWRESAMLE_SOURCES})

target_link_libraries(swresample PRIVATE ffmpeg_config)
target_link_libraries(swresample PRIVATE avutil)