list(APPEND ffmpeg.fftools.ffmpeg.sources
    ffmpeg.c
    ffmpeg_dec.c
    ffmpeg_demux.c
    ffmpeg_filter.c
    ffmpeg_hw.c
    ffmpeg_opt.c
    cmdutils.c
    opt_common.c
    sync_queue.c
    objpool.c
)

set(FFMPEG_AVCODEC_GENERATED_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/generated")
set(PREPEND_HACK_DIR "${FFMPEG_AVCODEC_GENERATED_DIRECTORY}/prepend_hack")
file(REMOVE_RECURSE ${PREPEND_HACK_DIR})

list(APPEND ffmpeg.fftools.ffmpeg.sources_prepended
    ffmpeg_enc.c "#include <pthread.h>"
    ffmpeg_mux.c "#include <pthread.h>"
    ffmpeg_mux_init.c "#include <pthread.h>"
    ffmpeg_sched.c "#include <pthread.h>"
    thread_queue.c "#include <pthread.h>"
)


gen_prepend_hack(ffmpeg.fftools.ffmpeg.sources_prepended PREPEND_HACK_DIR "avcodec" ffmpeg.fftools.ffmpeg.sources)

add_library(ffmpeg.fftools.ffmpeg.objects OBJECT ${ffmpeg.fftools.ffmpeg.sources})
target_compile_definitions(ffmpeg.fftools.ffmpeg.objects PRIVATE
    AVCONV_DATADIR="whathatdogdoing"
    FFMPEG_DATADIR="amogus"
)

if(UNIX)
    target_compile_definitions(ffmpeg.fftools.ffmpeg.objects PRIVATE HAVE_UNISTD_H=1)
endif()
