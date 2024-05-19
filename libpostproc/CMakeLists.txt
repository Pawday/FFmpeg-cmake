add_library(ffmpeg.postproc.config INTERFACE)
add_library(ffmpeg.postproc.headers INTERFACE)
add_library(ffmpeg.postproc.objects OBJECT)


list(APPEND ffmpeg.postproc.sources
    postprocess.c
    version.c
)

list(APPEND ffmpeg.postproc.header_names
    postprocess.h
    version.h
    version_major.h
)


set(FFMPEG_POSTPROC_GENERATED_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/generated")
set(POSTPROC_GENERATED_INCLUDE_DIRECTORY "${FFMPEG_POSTPROC_GENERATED_DIRECTORY}/include")

foreach(POSTPROC_HEADER ${ffmpeg.postproc.header_names})
    set(HEADER_CONTENT "// IWYU pragma: begin_exports\n#include \"${CMAKE_CURRENT_SOURCE_DIR}/${POSTPROC_HEADER}\"\n// IWYU pragma: end_exports\n")
    file(GENERATE OUTPUT "${POSTPROC_GENERATED_INCLUDE_DIRECTORY}/libpostproc/${POSTPROC_HEADER}" CONTENT ${HEADER_CONTENT})
endforeach()

target_compile_definitions(ffmpeg.postproc.config INTERFACE
)

target_include_directories(ffmpeg.postproc.headers INTERFACE
    ${POSTPROC_GENERATED_INCLUDE_DIRECTORY}
)


target_sources(ffmpeg.postproc.objects PRIVATE ${ffmpeg.postproc.sources})

set_property(TARGET ffmpeg.postproc.objects PROPERTY POSITION_INDEPENDENT_CODE TRUE)

target_link_libraries(ffmpeg.postproc.objects PRIVATE
    ffmpeg.postproc.config
    ffmpeg.postproc.headers
    ffmpeg.avutil.config
    ffmpeg.avutil.headers
)
