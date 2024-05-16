add_library(ffmpeg.swscale.config INTERFACE)


list(APPEND ffmpeg.swscale.sources
    alphablend.c
    gamma.c
    half2float.c
    hscale.c
    hscale_fast_bilinear.c
    input.c
    #log2_tab.c
    options.c
    output.c
    rgb2rgb.c
    slice.c
    swscale_unscaled.c
    version.c
    vscale.c
    yuv2rgb.c
)


set(FFMPEG_SWSCALE_GENERATED_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/generated")
set(PREPEND_HACK_DIR "${FFMPEG_SWSCALE_GENERATED_DIRECTORY}/prepend_hack")
file(REMOVE_RECURSE ${PREPEND_HACK_DIR})

list(APPEND ffmpeg.swscale.sources_prepended
    swscale.c "#include \"libavutil/internal.h\""
    utils.c "#include \"libavutil/internal.h\""
)


gen_prepend_hack(ffmpeg.swscale.sources_prepended PREPEND_HACK_DIR "swscale" ffmpeg.swscale.sources)

list(APPEND ffmpeg.swscale.header_names
    rgb2rgb.h
    swscale.h
    swscale_internal.h
    version.h
    version_major.h
)


set(ffmpeg.swscale.gen_inc "${CMAKE_CURRENT_BINARY_DIR}/generated/include")

foreach(SWSCALE_HEADER ${ffmpeg.swscale.header_names})
    set(HEADER_CONTENT "// IWYU pragma: begin_exports\n#include \"${CMAKE_CURRENT_SOURCE_DIR}/${SWSCALE_HEADER}\"\n// IWYU pragma: end_exports\n")
    file(GENERATE OUTPUT "${ffmpeg.swscale.gen_inc}/libswscale/${SWSCALE_HEADER}" CONTENT ${HEADER_CONTENT})
endforeach()


add_library(ffmpeg.swscale.headers INTERFACE)
target_include_directories(ffmpeg.swscale.headers INTERFACE
    ${ffmpeg.swscale.gen_inc}
)

target_compile_definitions(ffmpeg.swscale.config INTERFACE
    SWS_MAX_FILTER_SIZE=32
)

add_library(ffmpeg.swscale.objects OBJECT ${ffmpeg.swscale.sources})
set_property(TARGET ffmpeg.swscale.objects PROPERTY POSITION_INDEPENDENT_CODE TRUE)
target_link_libraries(ffmpeg.swscale.objects PRIVATE
    ffmpeg.swscale.config
    ffmpeg.swscale.headers
)

target_link_libraries(ffmpeg.swscale.objects PRIVATE
    ffmpeg.avutil.config
    ffmpeg.avutil.headers
)
