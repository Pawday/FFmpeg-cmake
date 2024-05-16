list(APPEND ffmpeg.avfilter.sources vf_format.c)

list(APPEND ffmpeg.avfilter.filter_list ff_vf_format)


target_compile_definitions(ffmpeg.avfilter.config INTERFACE
    CONFIG_FORMAT_FILTER=1
    CONFIG_NOFORMAT_FILTER=0
)
