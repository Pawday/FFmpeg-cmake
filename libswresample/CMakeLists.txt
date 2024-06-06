add_library(ffmpeg.swresample.config INTERFACE)
add_library(ffmpeg.swresample.headers INTERFACE)
add_library(ffmpeg.swresample.objects OBJECT)


list(APPEND ffmpeg.swresample.sources
    audioconvert.c
    dither.c
    options.c
    rematrix.c
    resample.c
    resample_dsp.c
    swresample.c
    swresample_frame.c
    version.c
)

list(APPEND ffmpeg.swresample.header_names
    swresample.h
    version.h
    version_major.h
)


set(FFMPEG_SWRESAMPLE_GENERATED_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/generated")
set(SWRESAMPLE_GENERATED_INCLUDE_DIRECTORY "${FFMPEG_SWRESAMPLE_GENERATED_DIRECTORY}/include")

gen_headers(ffmpeg.swresample.header_names CMAKE_CURRENT_SOURCE_DIR "${SWRESAMPLE_GENERATED_INCLUDE_DIRECTORY}/libswresample")

target_compile_definitions(ffmpeg.swresample.config INTERFACE
)

target_include_directories(ffmpeg.swresample.headers INTERFACE
    ${SWRESAMPLE_GENERATED_INCLUDE_DIRECTORY}
)


target_sources(ffmpeg.swresample.objects PRIVATE ${ffmpeg.swresample.sources})

set_property(TARGET ffmpeg.swresample.objects PROPERTY POSITION_INDEPENDENT_CODE TRUE)

target_link_libraries(ffmpeg.swresample.objects PRIVATE
    ffmpeg.swresample.config
    ffmpeg.swresample.headers
    ffmpeg.avutil.config
    ffmpeg.avutil.headers
)
