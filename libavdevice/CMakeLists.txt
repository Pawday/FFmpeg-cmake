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
    alsa.h
    avdevice.h
    decklink_common.h
    decklink_common_c.h
    decklink_dec.h
    decklink_enc.h
    dshow_capture.h
    fbdev_common.h
    internal.h
    opengl_enc_shaders.h
    oss.h
    pulse_audio_common.h
    sndio.h
    timefilter.h
    v4l2-common.h
    version.h
    version_major.h
)


set(FFMPEG_AVDEVICE_GENERATED_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/generated")
#set(PREPEND_HACK_DIR "${FFMPEG_AVDEVICE_GENERATED_DIRECTORY}/prepend_hack")
#file(REMOVE_RECURSE ${PREPEND_HACK_DIR})


set(AVDEVICE_GENERATED_INCLUDE_DIRECTORY "${FFMPEG_AVDEVICE_GENERATED_DIRECTORY}/include")

gen_headers(ffmpeg.avdevice.header_names CMAKE_CURRENT_SOURCE_DIR "${AVDEVICE_GENERATED_INCLUDE_DIRECTORY}/libavdevice")

#generating indev_list.c
ffmpeg_message(WARNING "avdevice" "TODO: generate libavdevice/indev_list.c more properly")
file(GENERATE OUTPUT "${AVDEVICE_GENERATED_INCLUDE_DIRECTORY}/libavdevice/indev_list.c" CONTENT "static const FFInputFormat * const indev_list[] = {NULL};")

#generating outdev_list.c
ffmpeg_message(WARNING "avdevice" "TODO: generate libavdevice/outdev_list.c more properly")
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
