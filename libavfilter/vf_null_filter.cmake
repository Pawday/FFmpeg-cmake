list(APPEND FFMPEG_AVFILTER_FILTERS_LIST ff_vf_null)

add_library(ffmpeg.avfilter.null.objects OBJECT vf_null.c)
list(APPEND FFMPEG_AVFILTER_COMPONENTS ffmpeg.avfilter.null.objects)
