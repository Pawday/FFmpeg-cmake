cmake_minimum_required(VERSION 3.15)
project(avutil)

#TODO[cmake]: when install will come, generate ffversion.h and avconfig.h only for install

#GENERATING ffversion.h
file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/include/libavutil/ffversion.h "//configured via cmake\n")
file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/include/libavutil/ffversion.h "")
file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/include/libavutil/ffversion.h "#ifndef AVUTIL_FFVERSION_H\n")
file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/include/libavutil/ffversion.h "#define AVUTIL_FFVERSION_H\n")
file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/include/libavutil/ffversion.h "#define FFMPEG_VERSION \"TODO\"\n") #TODO[cmake] set FFMPEG_VERSION
file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/include/libavutil/ffversion.h "#endif")


include (TestBigEndian)
TEST_BIG_ENDIAN(IS_BIG_ENDIAN)
if(IS_BIG_ENDIAN)
    set(AV_HAVE_BIGENDIAN_DEF 1)
else()
    set(AV_HAVE_BIGENDIAN_DEF 0)
endif()

#GENERATING avconfig.h
file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/include/libavutil/avconfig.h "//configured via cmake\n")
file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/include/libavutil/avconfig.h "#ifndef AVUTIL_AVCONFIG_H\n")
file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/include/libavutil/avconfig.h "#define AVUTIL_AVCONFIG_H\n")
file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/include/libavutil/avconfig.h "#define AV_HAVE_BIGENDIAN ${AV_HAVE_BIGENDIAN_DEF}\n")
file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/include/libavutil/avconfig.h "#define AV_HAVE_FAST_UNALIGNED 0\n")
file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/include/libavutil/avconfig.h "#endif \n")

list(APPEND AVUTIL_ALL_HEADERS version.h)
list(APPEND AVUTIL_ALL_HEADERS version_major.h)


list(APPEND AVUTIL_ALL_HEADERS samplefmt.h)
list(APPEND AVUTIL_ALL_HEADERS attributes.h)
list(APPEND AVUTIL_ALL_HEADERS avutil.h)
list(APPEND AVUTIL_ALL_HEADERS buffer.h)
list(APPEND AVUTIL_ALL_HEADERS dict.h)
list(APPEND AVUTIL_ALL_HEADERS frame.h)
list(APPEND AVUTIL_ALL_HEADERS log.h)
list(APPEND AVUTIL_ALL_HEADERS pixfmt.h)
list(APPEND AVUTIL_ALL_HEADERS rational.h)
list(APPEND AVUTIL_ALL_HEADERS avassert.h)
list(APPEND AVUTIL_ALL_HEADERS avstring.h)
list(APPEND AVUTIL_ALL_HEADERS bprint.h)
list(APPEND AVUTIL_ALL_HEADERS channel_layout.h)
list(APPEND AVUTIL_ALL_HEADERS imgutils.h)
list(APPEND AVUTIL_ALL_HEADERS mem.h)
list(APPEND AVUTIL_ALL_HEADERS opt.h)
list(APPEND AVUTIL_ALL_HEADERS thread.h)
list(APPEND AVUTIL_ALL_HEADERS common.h)
list(APPEND AVUTIL_ALL_HEADERS macros.h)
list(APPEND AVUTIL_ALL_HEADERS error.h)
list(APPEND AVUTIL_ALL_HEADERS mathematics.h)
list(APPEND AVUTIL_ALL_HEADERS intfloat.h)
list(APPEND AVUTIL_ALL_HEADERS pixdesc.h)
list(APPEND AVUTIL_ALL_HEADERS hwcontext.h)
list(APPEND AVUTIL_ALL_HEADERS fifo.h)
list(APPEND AVUTIL_ALL_HEADERS internal.h)
list(APPEND AVUTIL_ALL_HEADERS intmath.h)
list(APPEND AVUTIL_ALL_HEADERS timer.h)
list(APPEND AVUTIL_ALL_HEADERS libm.h)
list(APPEND AVUTIL_ALL_HEADERS intreadwrite.h)
list(APPEND AVUTIL_ALL_HEADERS bswap.h)
list(APPEND AVUTIL_ALL_HEADERS display.h)
list(APPEND AVUTIL_ALL_HEADERS stereo3d.h)
list(APPEND AVUTIL_ALL_HEADERS video_enc_params.h)
list(APPEND AVUTIL_ALL_HEADERS mem_internal.h)
list(APPEND AVUTIL_ALL_HEADERS reverse.h)
list(APPEND AVUTIL_ALL_HEADERS film_grain_params.h)
list(APPEND AVUTIL_ALL_HEADERS timecode.h)
list(APPEND AVUTIL_ALL_HEADERS qsort.h)
list(APPEND AVUTIL_ALL_HEADERS parseutils.h)
list(APPEND AVUTIL_ALL_HEADERS time.h)
list(APPEND AVUTIL_ALL_HEADERS timestamp.h)
list(APPEND AVUTIL_ALL_HEADERS threadmessage.h)
list(APPEND AVUTIL_ALL_HEADERS wchar_filename.h)
list(APPEND AVUTIL_ALL_HEADERS cpu.h)
list(APPEND AVUTIL_ALL_HEADERS eval.h)
list(APPEND AVUTIL_ALL_HEADERS crc.h)
list(APPEND AVUTIL_ALL_HEADERS color_utils.h)
list(APPEND AVUTIL_ALL_HEADERS mastering_display_metadata.h)
list(APPEND AVUTIL_ALL_HEADERS base64.h)
list(APPEND AVUTIL_ALL_HEADERS dovi_meta.h)
list(APPEND AVUTIL_ALL_HEADERS replaygain.h)
list(APPEND AVUTIL_ALL_HEADERS spherical.h)
list(APPEND AVUTIL_ALL_HEADERS cpu_internal.h)
list(APPEND AVUTIL_ALL_HEADERS slicethread.h)
list(APPEND AVUTIL_ALL_HEADERS time_internal.h)

foreach(AVUTIL_HEADER ${AVUTIL_ALL_HEADERS})
    file(COPY ${AVUTIL_HEADER} DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/include/libavutil/)
endforeach()


list(APPEND AVUTIL_SOURCES samplefmt.c)
list(APPEND AVUTIL_SOURCES utils.c)
list(APPEND AVUTIL_SOURCES buffer.c)
list(APPEND AVUTIL_SOURCES dict.c)
list(APPEND AVUTIL_SOURCES frame.c)
list(APPEND AVUTIL_SOURCES log.c)
list(APPEND AVUTIL_SOURCES rational.c)
list(APPEND AVUTIL_SOURCES avstring.c)
list(APPEND AVUTIL_SOURCES bprint.c)
list(APPEND AVUTIL_SOURCES channel_layout.c)
list(APPEND AVUTIL_SOURCES imgutils.c)
list(APPEND AVUTIL_SOURCES mem.c)
list(APPEND AVUTIL_SOURCES opt.c)
list(APPEND AVUTIL_SOURCES error.c)
list(APPEND AVUTIL_SOURCES mathematics.c)
list(APPEND AVUTIL_SOURCES pixdesc.c)
list(APPEND AVUTIL_SOURCES hwcontext.c)
list(APPEND AVUTIL_SOURCES fifo.c)
list(APPEND AVUTIL_SOURCES intmath.c)
list(APPEND AVUTIL_SOURCES log2_tab.c)
list(APPEND AVUTIL_SOURCES eval.c)
list(APPEND AVUTIL_SOURCES parseutils.c)
list(APPEND AVUTIL_SOURCES reverse.c)
list(APPEND AVUTIL_SOURCES time.c)
list(APPEND AVUTIL_SOURCES random_seed.c)
list(APPEND AVUTIL_SOURCES sha.c)
list(APPEND AVUTIL_SOURCES display.c)
list(APPEND AVUTIL_SOURCES stereo3d.c)
list(APPEND AVUTIL_SOURCES reverse.c)
list(APPEND AVUTIL_SOURCES video_enc_params.c)
list(APPEND AVUTIL_SOURCES film_grain_params.c)
list(APPEND AVUTIL_SOURCES timecode.c)
list(APPEND AVUTIL_SOURCES threadmessage.c)
list(APPEND AVUTIL_SOURCES cpu.c)
list(APPEND AVUTIL_SOURCES eval.c)
list(APPEND AVUTIL_SOURCES crc.c)
list(APPEND AVUTIL_SOURCES color_utils.c)
list(APPEND AVUTIL_SOURCES mastering_display_metadata.c)
list(APPEND AVUTIL_SOURCES base64.c)
list(APPEND AVUTIL_SOURCES dovi_meta.c)
list(APPEND AVUTIL_SOURCES spherical.c)
list(APPEND AVUTIL_SOURCES file_open.c)
list(APPEND AVUTIL_SOURCES slicethread.c)
list(APPEND AVUTIL_SOURCES avsscanf.c)



#!!!!!!!!!! EVIL FUNCTION REPLACEMENT HACK FOR NONOPTIMISED COMPILERS
if (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")

    set(AVUTIL_GENERATED_EMPTY_FUNCTIONS_FILE_CONTENT "")

    string(APPEND AVUTIL_GENERATED_EMPTY_FUNCTIONS_FILE_CONTENT "//THIS FILE IS PART OF EVIL HACK FOR UNOPTIMISED COMPILERS WHEN THAT FUNCTIONS ARE NOT BUILDING BECAUSE CONFIGS\n")

    #TODO[cmake]: make it config depended

    #if not ARCH_AARCH64 ARCH_ARM ARCH_PPC ARCH_X86 ARCH_MIPS ARCH_ALPHA ARCH_LOONGARCH ARCH_LOONGARCH64
    list(APPEND AVUTIL_EMPTY_FUNCTIONS "int ff_get_cpu_flags_mips(void){return 0\;}")
    list(APPEND AVUTIL_EMPTY_FUNCTIONS "int ff_get_cpu_flags_aarch64(void){return 0\;}")
    list(APPEND AVUTIL_EMPTY_FUNCTIONS "int ff_get_cpu_flags_arm(void){return 0\;}")
    list(APPEND AVUTIL_EMPTY_FUNCTIONS "int ff_get_cpu_flags_ppc(void){return 0\;}")
    list(APPEND AVUTIL_EMPTY_FUNCTIONS "int ff_get_cpu_flags_x86(void){return 0\;}")
    list(APPEND AVUTIL_EMPTY_FUNCTIONS "int ff_get_cpu_flags_loongarch(void){return 0\;}")

    list(APPEND AVUTIL_EMPTY_FUNCTIONS "size_t ff_get_cpu_max_align_mips(void){return 0\;}")
    list(APPEND AVUTIL_EMPTY_FUNCTIONS "size_t ff_get_cpu_max_align_aarch64(void){return 0\;}")
    list(APPEND AVUTIL_EMPTY_FUNCTIONS "size_t ff_get_cpu_max_align_arm(void){return 0\;}")
    list(APPEND AVUTIL_EMPTY_FUNCTIONS "size_t ff_get_cpu_max_align_ppc(void){return 0\;}")
    list(APPEND AVUTIL_EMPTY_FUNCTIONS "size_t ff_get_cpu_max_align_x86(void){return 0\;}")
    list(APPEND AVUTIL_EMPTY_FUNCTIONS "size_t ff_get_cpu_max_align_loongarch(void){return 0\;}")

    foreach(CONTENT ${AVUTIL_EMPTY_FUNCTIONS})
        string(APPEND AVUTIL_GENERATED_EMPTY_FUNCTIONS_FILE_CONTENT "${CONTENT}\n")
    endforeach()

    file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/hack/empty_functions.c "${AVUTIL_GENERATED_EMPTY_FUNCTIONS_FILE_CONTENT}")

endif()

add_library(avutil OBJECT ${AVUTIL_SOURCES})

if(MSVC)
    message(WARNING "AVUTIL: adding empty_functions.c hack for unoptimised MSVC")
    target_sources(avutil PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/hack/empty_functions.c)
endif()



target_include_directories(avutil PUBLIC ${CMAKE_CURRENT_BINARY_DIR}/include/)

#TODO[cmake]: -------------------------Diego's includes--------------------------------
#swscale library required it ""!BECAUSE!""
add_subdirectory(ppc)
add_subdirectory(x86)
add_subdirectory(aarch64)

#   At commit ea7ee4b4e381e0fa731458de0cbf740430eeb013
#   Diego Biurrun does include libavutil/ppc/util_altivec.h file into swscale_internal.h
#   without #ifdef HAVE_ALTIVEC ... #endif
#   now you have to include platform specific file
#   THANK YOU Diego
target_include_directories(avutil PUBLIC ${CMAKE_CURRENT_BINARY_DIR}/ppc/include)

#   At commit e0c6cce44729d94e2a5507a4b6d031f23e8bd7b6
#   Diego Biurrun does include libavutil/x86/asm.h and libavutil/x86/cpu.h file into libswscale/utils.c
#   without #ifdef ARCH_X86_64 ... #endif
#   now you have to include platform specific file
#   THANK YOU Diego
target_include_directories(avutil PUBLIC ${CMAKE_CURRENT_BINARY_DIR}/x86/include)

#   At commit 70ab2778be9c83dab84340af7e3ba83fa0f98576
target_include_directories(avutil PUBLIC ${CMAKE_CURRENT_BINARY_DIR}/aarch64/include)


target_link_libraries(avutil PRIVATE ffmpeg_config)

target_compile_definitions(avutil PRIVATE emms_c)

target_compile_definitions(avutil PRIVATE HAVE_AV_CONFIG_H)

add_library(avutil_static STATIC $<TARGET_OBJECTS:avutil>)
target_include_directories(avutil_static PUBLIC ${CMAKE_CURRENT_BINARY_DIR}/include/)

if (UNIX)
    #on unix we need manually link with math library
    #libm library on linux is only shared, and its cascades to others
    find_library(MATH_LIBRARY NAMES m)
    target_link_libraries(avutil_static PRIVATE ${MATH_LIBRARY})
endif()
