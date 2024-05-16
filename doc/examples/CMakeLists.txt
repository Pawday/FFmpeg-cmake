add_executable(ffmpeg.doc.decode_video decode_video.c)

target_link_libraries(ffmpeg.doc.decode_video PRIVATE ffmpeg.avutil.static ffmpeg.avcodec.static m)
