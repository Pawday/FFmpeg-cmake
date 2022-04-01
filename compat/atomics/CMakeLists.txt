project(FFMPEG_COMPAT_ATOMIC)

#TODO[cmake]: replace dummy header on each platform

target_include_directories(ffmpeg_compat INTERFACE dummy)