list(APPEND AVFILTER_REGISTERED_FILTERS_IDS ff_vf_scale)

list(APPEND AVFILTER_REGISTERED_FILTERS_SOURCES vf_scale.c)
list(APPEND AVFILTER_REGISTERED_FILTERS_SOURCES scale_eval.c)