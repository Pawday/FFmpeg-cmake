list(APPEND FFMPEG_AVFILTER_FILTERS_LIST ff_vf_scale)

ff_create_component(avfilter.scale)

list(APPEND AVFILTER_SCALE_SOURCES
    vf_scale.c
    scale_eval.c
)

ff_component_sources(avfilter.scale AVFILTER_SCALE_SOURCES)

list(APPEND FFMPEG_AVFILTER_COMPONENTS avfilter.scale)
