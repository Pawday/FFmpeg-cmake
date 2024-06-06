list(APPEND FFMPEG_AVFILTER_FILTERS_LIST ff_vf_format)

add_library(ffmpeg.avfilter.format.objects OBJECT vf_format.c)
target_compile_definitions(ffmpeg.avfilter.format.objects PRIVATE
    CONFIG_FORMAT_FILTER=1
    CONFIG_NOFORMAT_FILTER=0
)

list(APPEND FFMPEG_AVFILTER_COMPONENTS ffmpeg.avfilter.format.objects)
