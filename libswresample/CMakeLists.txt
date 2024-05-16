cmake_minimum_required(VERSION 3.15)

project(SWRESAMPLE)


list(APPEND SWRESAMLE_ALL_HEADERS version.h)
list(APPEND SWRESAMLE_ALL_HEADERS version_major.h)

list(APPEND SWRESAMLE_ALL_HEADERS swresample.h)

foreach(SWRESAMLE_HEADER ${SWRESAMLE_ALL_HEADERS})
    file(COPY ${SWRESAMLE_HEADER} DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/include/libswresample/)
endforeach()

list(APPEND SWRESAMLE_SOURCES swresample.c)
list(APPEND SWRESAMLE_SOURCES version.c)
list(APPEND SWRESAMLE_SOURCES options.c)
list(APPEND SWRESAMLE_SOURCES audioconvert.c)
list(APPEND SWRESAMLE_SOURCES rematrix.c)
list(APPEND SWRESAMLE_SOURCES resample.c)
list(APPEND SWRESAMLE_SOURCES dither.c)
list(APPEND SWRESAMLE_SOURCES resample_dsp.c)


#!!!!!!!!!! EVIL FUNCTION REPLACEMENT HACK FOR NONOPTIMISED COMPILERS
if (CMAKE_C_COMPILER_ID STREQUAL "MSVC")

    set(SWRESAMPLE_GENERATED_EMPTY_FUNCTIONS_FILE_CONTENT "")

    string(APPEND SWRESAMPLE_GENERATED_EMPTY_FUNCTIONS_FILE_CONTENT "//THIS FILE IS PART OF EVIL HACK FOR UNOPTIMISED COMPILERS WHEN THAT FUNCTIONS ARE NOT BUILDING BECAUSE CONFIGS\n")


    string(APPEND SWRESAMPLE_GENERATED_EMPTY_FUNCTIONS_FILE_CONTENT "#include \"libavutil/samplefmt.h\"\n")


    #TODO[cmake]: make it config depended

    #if not HAVE_X86ASM, HAVE_MMX,
    list(APPEND SWRESAMPLE_EMPTY_FUNCTIONS "void swri_audio_convert_init_aarch64(void* ac, enum AVSampleFormat out_fmt, enum AVSampleFormat in_fmt, int channels){}")
    list(APPEND SWRESAMPLE_EMPTY_FUNCTIONS "void swri_audio_convert_init_arm(void* ac, enum AVSampleFormat out_fmt, enum AVSampleFormat in_fmt, int channels){}")
    list(APPEND SWRESAMPLE_EMPTY_FUNCTIONS "void swri_audio_convert_init_x86(void* ac, enum AVSampleFormat out_fmt, enum AVSampleFormat in_fmt, int channels){}")

    list(APPEND SWRESAMPLE_EMPTY_FUNCTIONS "int swri_rematrix_init_x86(struct SwrContext *s){return 0\;}")

    list(APPEND SWRESAMPLE_EMPTY_FUNCTIONS "void swri_resample_dsp_x86_init(void* c){}")
    list(APPEND SWRESAMPLE_EMPTY_FUNCTIONS "void swri_resample_dsp_arm_init(void* c){}")
    list(APPEND SWRESAMPLE_EMPTY_FUNCTIONS "void swri_resample_dsp_aarch64_init(void* c){}")


    foreach(CONTENT ${SWRESAMPLE_EMPTY_FUNCTIONS})
        string(APPEND SWRESAMPLE_GENERATED_EMPTY_FUNCTIONS_FILE_CONTENT "${CONTENT}\n")
    endforeach()

    file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/hack/empty_functions.c "${SWRESAMPLE_GENERATED_EMPTY_FUNCTIONS_FILE_CONTENT}")


endif()

add_library(swresample OBJECT ${SWRESAMLE_SOURCES})
target_include_directories(swresample PUBLIC ${CMAKE_CURRENT_BINARY_DIR}/include/)


add_library(swresample_static STATIC $<TARGET_OBJECTS:swresample>)

if(MSVC)
    message(WARNING "SWRESAMPLE: adding empty_functions.c hack for unoptimised MSVC")
    target_sources(swresample PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/hack/empty_functions.c)
endif()

target_link_libraries(swresample PRIVATE ffmpeg_config)
target_link_libraries(swresample PRIVATE avutil)
