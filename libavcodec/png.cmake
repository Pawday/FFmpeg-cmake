option(ZLIB_SOURCE_DIR "ZLIB source directory" OFF)

if (NOT ZLIB_SOURCE_DIR)
    #this file is including to libavcodec/CMakeLists.txt when png is registered
    message(FATAL_ERROR "For png codec you MUST specify ZLIB_SOURCE_DIR option")
endif ()

add_subdirectory(${ZLIB_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR}/zlib EXCLUDE_FROM_ALL)

target_include_directories(zlibstatic PUBLIC ${ZLIB_SOURCE_DIR})
target_include_directories(zlibstatic PUBLIC ${CMAKE_CURRENT_BINARY_DIR}/zlib)

target_link_libraries(avcodec_external_libraries INTERFACE zlibstatic)

list(APPEND AVCODEC_REGISTERED_CODECS_IDS ff_png_encoder)
list(APPEND AVCODEC_REGISTERED_CODECS_IDS ff_png_decoder)

list(APPEND AVCODEC_REGISTERED_CODECS_SOURCES png.c)
list(APPEND AVCODEC_REGISTERED_CODECS_SOURCES pngenc.c)
list(APPEND AVCODEC_REGISTERED_CODECS_SOURCES pngdec.c)
list(APPEND AVCODEC_REGISTERED_CODECS_SOURCES pngdsp.c)

list(APPEND AVCODEC_REGISTERED_CODECS_SOURCES png_parser.c)

list(APPEND AVCODEC_REGISTERED_CODECS_SOURCES lossless_videoencdsp.c)
