#list(APPEND ffmpeg.avformat.core.sources h264dec.c)
list(APPEND ffmpeg.avformat.core.sources_prepended
    h264dec.c "#include \"libavutil/internal.h\""
)

list(APPEND ffmpeg.avformat.demuxer_list "ff_h264_demuxer")
