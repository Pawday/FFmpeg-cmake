list(APPEND FFMPEG_AVFORMAT_CORE_SOURCES file.c)


list(APPEND FFMPEG_AVFORMAT_PROTOCOLS
    ff_pipe_protocol
    ff_file_protocol
)


target_compile_definitions(ffmpeg.avformat.config INTERFACE
    CONFIG_PIPE_PROTOCOL=1
    CONFIG_FILE_PROTOCOL=1
)


