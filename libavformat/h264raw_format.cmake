#list(APPEND ffmpeg.avformat.core.sources h264dec.c)
list(APPEND ffmpeg.avformat.core.sources_prepended
    h264dec.c "#include \"libavutil/internal.h\""
)

list(APPEND FFMPEG_AVFORMAT_DEMUXERS "ff_h264_demuxer")
