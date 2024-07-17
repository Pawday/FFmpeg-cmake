list(APPEND FFMPEG_AVFILTER_FILTERS_LIST ff_vf_null)
list(APPEND FFMPEG_AVFILTER_COMPONENTS avfilter.null)

ff_create_component(avfilter.null)

list(APPEND SOURCES vf_null.c)

ff_component_sources(avfilter.null SOURCES)
