add_executable(ffmpeg.doc.decode_video decode_video.c)

target_link_libraries(ffmpeg.doc.decode_video PRIVATE
    ffmpeg.static
    ffmpeg.avutil.headers
    ffmpeg.avutil.config
    ffmpeg.avcodec.headers
    ffmpeg.avcodec.config
)
