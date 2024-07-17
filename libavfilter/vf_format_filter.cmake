ff_create_component(avfilter.format)
add_library(ffmpeg.avfilter.format.config INTERFACE)

target_compile_definitions(ffmpeg.avfilter.format.config INTERFACE
    CONFIG_FORMAT_FILTER=1
    CONFIG_NOFORMAT_FILTER=1
)
list(APPEND FFMPEG_AVFILTER_FILTERS_LIST 
    ff_vf_format
    ff_vf_noformat
)


list(APPEND FFMPEG_AVFILTER_COMPONENTS avfilter.format)


list(APPEND AVFILTER_FORMAT_SOURCES vf_format.c)
ff_component_sources(avfilter.format AVFILTER_FORMAT_SOURCES)


ff_component_link_library(avfilter.format PRIVATE ffmpeg.avfilter.format.config)
