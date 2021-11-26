cmake_minimum_required(VERSION 3.10)

project(SWSCALE)

list(APPEND SWSCALE_ALL_HEADERS version.h)
list(APPEND SWSCALE_ALL_HEADERS swscale.h)

foreach(SWSCALE_HEADER ${SWSCALE_ALL_HEADERS})
    file(COPY ${SWSCALE_HEADER} DESTINATION ${CMAKE_BINARY_DIR}/include/libswscale/)
endforeach()

list(APPEND SWSCALE_SOURCES swscale.c)
list(APPEND SWSCALE_SOURCES output.c)
list(APPEND SWSCALE_SOURCES input.c)
list(APPEND SWSCALE_SOURCES hscale_fast_bilinear.c)
list(APPEND SWSCALE_SOURCES slice.c)
list(APPEND SWSCALE_SOURCES vscale.c)
list(APPEND SWSCALE_SOURCES gamma.c)
list(APPEND SWSCALE_SOURCES hscale.c)
list(APPEND SWSCALE_SOURCES options.c)
list(APPEND SWSCALE_SOURCES utils.c)
list(APPEND SWSCALE_SOURCES yuv2rgb.c)
list(APPEND SWSCALE_SOURCES rgb2rgb.c)
list(APPEND SWSCALE_SOURCES alphablend.c)
list(APPEND SWSCALE_SOURCES swscale_unscaled.c)


add_library(swscale OBJECT ${SWSCALE_SOURCES})

target_link_libraries(swscale PUBLIC ffmpeg_config)
target_link_libraries(swscale PUBLIC avutil)