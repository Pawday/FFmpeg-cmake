add_library(ffmpeg.avutil.config INTERFACE)
add_library(ffmpeg.avutil.headers INTERFACE)
add_library(ffmpeg.avutil.objects OBJECT)

list(APPEND ffmpeg.avutil.sources
    adler32.c
    aes.c
    aes_ctr.c
    ambient_viewing_environment.c
    audio_fifo.c
    avsscanf.c
    avstring.c
    base64.c
    blowfish.c
    bprint.c
    buffer.c
    camellia.c
    cast5.c
    channel_layout.c
    cpu.c
    crc.c
    csp.c
    des.c
    detection_bbox.c
    dict.c
    display.c
    dovi_meta.c
    downmix_info.c
    encryption_info.c
    error.c
    eval.c
    executor.c
    fifo.c
    file.c
    file_open.c
    film_grain_params.c
    fixed_dsp.c
    float_dsp.c
    hash.c
    hdr_dynamic_metadata.c
    hdr_dynamic_vivid_metadata.c
    hmac.c
    hwcontext.c
    iamf.c
    imgutils.c
    integer.c
    intmath.c
    lfg.c
    lls.c
    log.c
    log2_tab.c
    lzo.c
    mastering_display_metadata.c
    mathematics.c
    md5.c
    mem.c
    murmur3.c
    opt.c
    parseutils.c
    pixdesc.c
    pixelutils.c
    random_seed.c
    rational.c
    rc4.c
    reverse.c
    ripemd.c
    samplefmt.c
    sha.c
    sha512.c
    slicethread.c
    spherical.c
    stereo3d.c
    tea.c
    threadmessage.c
    time.c
    timecode.c
    timestamp.c
    tree.c
    twofish.c
    utils.c
    uuid.c
    version.c
    video_enc_params.c
    video_hint.c
    xga_font_data.c
    xtea.c
)

list(APPEND ffmpeg.avutil.sources_prepended
     tx.c "#include \"libavutil/internal.h\""
     frame.c "#include \"libavutil/internal.h\"\n#include \"libavutil/intmath.h\""
     tx_double.c "#include \"libavutil/internal.h\"\n#include \"libavutil/intmath.h\""
     tx_float.c "#include \"libavutil/internal.h\"\n#include \"libavutil/intmath.h\""
     tx_int32.c "#include \"libavutil/internal.h\"\n#include \"libavutil/intmath.h\""
)

list(APPEND ffmpeg.avutil.header_names
    adler32.h
    aes.h
    aes_ctr.h
    aes_internal.h
    ambient_viewing_environment.h
    attributes.h
    attributes_internal.h
    audio_fifo.h
    avassert.h
    avstring.h
    avutil.h
    base64.h
    blowfish.h
    bprint.h
    bswap.h
    buffer.h
    buffer_internal.h
    camellia.h
    cast5.h
    channel_layout.h
    colorspace.h
    common.h
    cpu.h
    cpu_internal.h
    crc.h
    csp.h
    cuda_check.h
    des.h
    detection_bbox.h
    dict.h
    dict_internal.h
    display.h
    dovi_meta.h
    downmix_info.h
    dynarray.h
    emms.h
    encryption_info.h
    error.h
    eval.h
    executor.h
    ffmath.h
    fifo.h
    file.h
    file_open.h
    film_grain_params.h
    fixed_dsp.h
    float2half.h
    float_dsp.h
    frame.h
    getenv_utf8.h
    half2float.h
    hash.h
    hdr_dynamic_metadata.h
    hdr_dynamic_vivid_metadata.h
    hmac.h
    hwcontext.h
    hwcontext_cuda.h
    hwcontext_cuda_internal.h
    hwcontext_d3d11va.h
    hwcontext_d3d12va.h
    hwcontext_d3d12va_internal.h
    hwcontext_drm.h
    hwcontext_dxva2.h
    hwcontext_internal.h
    hwcontext_mediacodec.h
    hwcontext_opencl.h
    hwcontext_qsv.h
    hwcontext_vaapi.h
    hwcontext_vdpau.h
    hwcontext_videotoolbox.h
    hwcontext_vulkan.h
    iamf.h
    imgutils.h
    imgutils_internal.h
    integer.h
    internal.h
    intfloat.h
    intmath.h
    intreadwrite.h
    lfg.h
    libm.h
    lls.h
    log.h
    lzo.h
    macos_kperf.h
    macros.h
    mastering_display_metadata.h
    mathematics.h
    md5.h
    mem.h
    mem_internal.h
    motion_vector.h
    murmur3.h
    objc.h
    opt.h
    parseutils.h
    pca.h
    pixdesc.h
    pixelutils.h
    pixfmt.h
    qsort.h
    random_seed.h
    rational.h
    rc4.h
    replaygain.h
    reverse.h
    ripemd.h
    samplefmt.h
    sfc64.h
    sha.h
    sha512.h
    slicethread.h
    softfloat.h
    softfloat_ieee754.h
    softfloat_tables.h
    spherical.h
    stereo3d.h
    tablegen.h
    tea.h
    thread.h
    threadmessage.h
    time.h
    time_internal.h
    timecode.h
    timer.h
    timestamp.h
    tree.h
    twofish.h
    tx.h
    tx_priv.h
    uuid.h
    version.h
    version_major.h
    video_enc_params.h
    video_hint.h
    vulkan.h
    vulkan_functions.h
    vulkan_loader.h
    wchar_filename.h
    xga_font_data.h
    xtea.h
)

# used in libswscale/utils.c directly and unconditionally
list(APPEND ffmpeg.avutil.header_names
    aarch64/cpu.h
    ppc/cpu.h
    x86/asm.h
    x86/cpu.h
    loongarch/cpu.h # also used when x86?
)

# YES! its not a template and just included into another libraries IDK why
list(APPEND ffmpeg.avutil.header_names
    half2float.c # avcodec swscale
)



set(ffmpeg.avutil.generated_directory "${CMAKE_CURRENT_BINARY_DIR}/generated")
set(ffmpeg.avutil.generated_include_directory "${ffmpeg.avutil.generated_directory}/include")

target_compile_definitions(ffmpeg.avutil.config INTERFACE
    ARCH_X86=0
    HAVE_FAST_UNALIGNED=0
    CONFIG_MEMORY_POISONING=0
    HAVE_PRAGMA_DEPRECATED=1
)

set(PREPEND_HACK_DIR "${ffmpeg.avutil.generated_directory}/prepend_hack")
file(REMOVE_RECURSE ${PREPEND_HACK_DIR})
gen_prepend_hack(ffmpeg.avutil.sources_prepended PREPEND_HACK_DIR "avutil" ffmpeg.avutil.sources)


gen_headers(ffmpeg.avutil.header_names CMAKE_CURRENT_SOURCE_DIR "${ffmpeg.avutil.generated_include_directory}/libavutil")

set(FFMPEG_AVUTIL_GENERATED_HEADERS
    "avconfig.h"
    "ffversion.h"
)
foreach(HEADER ${FFMPEG_AVUTIL_GENERATED_HEADERS})
    file(GENERATE OUTPUT "${ffmpeg.avutil.generated_include_directory}/libavutil/${HEADER}" CONTENT "")
endforeach()


list(APPEND ffmpeg.avutil.math.subst_map
    atanf HAVE_ATANF
    atan2f HAVE_ATAN2F
    powf HAVE_POWF
    cbrt HAVE_CBRT
    cbrtf HAVE_CBRTF
    copysign HAVE_COPYSIGN
    cosf HAVE_COSF
    erf HAVE_ERF
    expf HAVE_EXPF
    exp2 HAVE_EXP2
    exp2f HAVE_EXP2F
    isinf HAVE_ISINF
    isnan HAVE_ISNAN
    isfinite HAVE_ISFINITE
    hypot HAVE_HYPOT
    ldexpf HAVE_LDEXPF
    llrint HAVE_LLRINT
    llrintf HAVE_LLRINTF
    log2 HAVE_LOG2
    log2f HAVE_LOG2F
    log10f HAVE_LOG10F
    sinf HAVE_SINF
    rint HAVE_RINT
    lrint HAVE_LRINT
    lrintf HAVE_LRINTF
    round HAVE_ROUND
    roundf HAVE_ROUNDF
    trunc HAVE_TRUNC
    truncf HAVE_TRUNCF
    atanf HAVE_ATANF
    atan2f HAVE_ATAN2F
    powf HAVE_POWF
    cbrt HAVE_CBRT
    cbrtf HAVE_CBRTF
)

list(LENGTH ffmpeg.avutil.math.subst_map ffmpeg.avutil.math.subst_map_size)

math(EXPR ffmpeg.avutil.math.subst_map_size2_remainder "${ffmpeg.avutil.math.subst_map_size} % 2")
if(NOT 0 EQUAL ${ffmpeg.avutil.math.subst_map_size2_remainder})
    message(FATAL_ERROR "ffmpeg.avutil.math.subst_map (sym <=> HAVE_<sym>) is broken")
endif()
math(EXPR ffmpeg.avutil.math.subst_map_size "${ffmpeg.avutil.math.subst_map_size} / 2")

include(CheckSymbolExists)

foreach(MATH_F_IDX RANGE 1 ${ffmpeg.avutil.math.subst_map_size})
    math(EXPR REAL_INDEX "${MATH_F_IDX} - 1")
    math(EXPR KEY_INDEX "${REAL_INDEX} * 2")
    math(EXPR VAL_INDEX "${REAL_INDEX} * 2 + 1")
    list(GET ffmpeg.avutil.math.subst_map ${KEY_INDEX} KEY)
    list(GET ffmpeg.avutil.math.subst_map ${VAL_INDEX} VAL)

    set(CMAKE_REQUIRED_QUIET ON)
    set(CMAKE_REQUIRED_LIBRARIES "m")
    check_symbol_exists(${KEY} "math.h" FFMPEG_AVUTIL_MATH_${VAL})

    if(FFMPEG_AVUTIL_MATH_${VAL})
        set(FFMPEG_AVUTIL_MATH_${VAL}_CONF 1)
        message(STATUS "[avutil] ${KEY} <=> ${VAL} ${FFMPEG_AVUTIL_MATH_${VAL}_CONF}")
    else()
        set(FFMPEG_AVUTIL_MATH_${VAL}_CONF 0)
        message(STATUS "[avutil] ${KEY} [NOT FOUND] <=> ${VAL} ${FFMPEG_AVUTIL_MATH_${VAL}_CONF}")
    endif()
    target_compile_definitions(ffmpeg.avutil.config INTERFACE "${VAL}=${FFMPEG_AVUTIL_MATH_${VAL}_CONF}")
endforeach()


target_include_directories(ffmpeg.avutil.headers INTERFACE ${ffmpeg.avutil.generated_include_directory})

target_sources(ffmpeg.avutil.objects PRIVATE ${ffmpeg.avutil.sources})
set_property(TARGET ffmpeg.avutil.objects PROPERTY POSITION_INDEPENDENT_CODE TRUE)
target_link_libraries(ffmpeg.avutil.objects PRIVATE
    ffmpeg.avutil.config
    ffmpeg.avutil.headers
)

target_link_libraries(ffmpeg.avutil.objects PRIVATE
    ffmpeg.compat.headers
)
