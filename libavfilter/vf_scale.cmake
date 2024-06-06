list(APPEND FFMPEG_AVFILTER_FILTERS_LIST ff_vf_scale)

add_library(ffmpeg.avfilter.scale.objects OBJECT
    vf_scale.c
    scale_eval.c
)

list(APPEND FFMPEG_AVFILTER_COMPONENTS ffmpeg.avfilter.scale.objects)
