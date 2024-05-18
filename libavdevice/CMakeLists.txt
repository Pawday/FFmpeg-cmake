add_library(ffmpeg.avdevice.config INTERFACE)
add_library(ffmpeg.avdevice.headers INTERFACE)
add_library(ffmpeg.avdevice.core.objects OBJECT)


list(APPEND FFMPEG_AVDEVICE_INPUT_DEVICES)
list(APPEND FFMPEG_AVDEVICE_OUTPUT_DEVICES)
list(APPEND FFMPEG_AVDEVICE_COMPONENTS ffmpeg.avdevice.core.objects)


list(APPEND ffmpeg.avdevice.core.sources
    alldevices.c
    avdevice.c
    utils.c
    version.c
)


list(APPEND ffmpeg.avdevice.header_names
    avdevice.h
    version.h
    version_major.h
)


set(FFMPEG_AVDEVICE_GENERATED_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/generated")
#set(PREPEND_HACK_DIR "${FFMPEG_AVDEVICE_GENERATED_DIRECTORY}/prepend_hack")
#file(REMOVE_RECURSE ${PREPEND_HACK_DIR})


set(AVDEVICE_GENERATED_INCLUDE_DIRECTORY "${FFMPEG_AVDEVICE_GENERATED_DIRECTORY}/include")

foreach(AVDEVICE_HEADER ${ffmpeg.avdevice.header_names})
    set(HEADER_CONTENT "// IWYU pragma: begin_exports\n#include \"${CMAKE_CURRENT_SOURCE_DIR}/${AVDEVICE_HEADER}\"\n// IWYU pragma: end_exports\n")
    file(GENERATE OUTPUT "${AVDEVICE_GENERATED_INCLUDE_DIRECTORY}/libavdevice/${AVDEVICE_HEADER}" CONTENT ${HEADER_CONTENT})
endforeach()


#generating indev_list.c
message(WARNING "TODO: generate libavdevice/indev_list.c more properly")
file(GENERATE OUTPUT "${AVDEVICE_GENERATED_INCLUDE_DIRECTORY}/libavdevice/indev_list.c" CONTENT "static const FFInputFormat * const indev_list[] = {NULL};")

#generating outdev_list.c
message(WARNING "TODO: generate libavdevice/outdev_list.c more properly")
file(GENERATE OUTPUT "${AVDEVICE_GENERATED_INCLUDE_DIRECTORY}/libavdevice/outdev_list.c" CONTENT "static const FFOutputFormat * const outdev_list[] = {NULL};")

target_include_directories(ffmpeg.avdevice.headers INTERFACE
    ${AVDEVICE_GENERATED_INCLUDE_DIRECTORY}
)

target_compile_definitions(ffmpeg.avdevice.config INTERFACE
)


target_sources(ffmpeg.avdevice.core.objects PRIVATE ${ffmpeg.avdevice.core.sources})

foreach(FFMPEG_AVDEVICE_COMPONENT ${FFMPEG_AVDEVICE_COMPONENTS})
    set_property(TARGET ${FFMPEG_AVDEVICE_COMPONENT} PROPERTY POSITION_INDEPENDENT_CODE TRUE)
    target_link_libraries(${FFMPEG_AVDEVICE_COMPONENT} PRIVATE
        ffmpeg.avutil.config
        ffmpeg.avutil.headers
        ffmpeg.avcodec.config
        ffmpeg.avcodec.headers
        ffmpeg.avformat.config
        ffmpeg.avformat.headers
        ffmpeg.avdevice.config
        ffmpeg.avdevice.headers
    )
endforeach()


set(FFMPEG_AVDEVICE_COMPONENTS ${FFMPEG_AVDEVICE_COMPONENTS} PARENT_SCOPE)
