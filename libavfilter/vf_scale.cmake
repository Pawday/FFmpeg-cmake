list(APPEND ffmpeg.avfilter.sources
    vf_scale.c
    scale_eval.c
)

list(APPEND ffmpeg.avfilter.filter_list ff_vf_scale)
