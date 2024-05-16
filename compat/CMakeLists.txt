

set(ffmpeg.compat.gen_inc "${CMAKE_CURRENT_BINARY_DIR}/generated/include")
file(GENERATE OUTPUT "${ffmpeg.compat.gen_inc}/compat/va_copy.h" INPUT "va_copy.h")

add_library(ffmpeg.compat.headers INTERFACE)
target_include_directories(ffmpeg.compat.headers INTERFACE ${ffmpeg.compat.gen_inc})
