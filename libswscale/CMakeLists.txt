cmake_minimum_required(VERSION 3.15)

project(SWSCALE)

list(APPEND SWSCALE_ALL_HEADERS version.h)
list(APPEND SWSCALE_ALL_HEADERS version_major.h)

list(APPEND SWSCALE_ALL_HEADERS swscale.h)

foreach(SWSCALE_HEADER ${SWSCALE_ALL_HEADERS})
    file(COPY ${SWSCALE_HEADER} DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/include/libswscale/)
endforeach()

list(APPEND SWSCALE_SOURCES swscale.c)
list(APPEND SWSCALE_SOURCES output.c)
list(APPEND SWSCALE_SOURCES input.c)
list(APPEND SWSCALE_SOURCES hscale_fast_bilinear.c)
list(APPEND SWSCALE_SOURCES slice.c)
list(APPEND SWSCALE_SOURCES vscale.c)
list(APPEND SWSCALE_SOURCES gamma.c)
list(APPEND SWSCALE_SOURCES hscale.c)
list(APPEND SWSCALE_SOURCES options.c)
list(APPEND SWSCALE_SOURCES utils.c)
list(APPEND SWSCALE_SOURCES yuv2rgb.c)
list(APPEND SWSCALE_SOURCES rgb2rgb.c)
list(APPEND SWSCALE_SOURCES alphablend.c)
list(APPEND SWSCALE_SOURCES swscale_unscaled.c)


#!!!!!!!!!! EVIL FUNCTION REPLACEMENT HACK FOR NONOPTIMISED COMPILERS
if (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")

    set(SWSCALE_GENERATED_EMPTY_FUNCTIONS_FILE_CONTENT "")

    string(APPEND SWSCALE_GENERATED_EMPTY_FUNCTIONS_FILE_CONTENT "//THIS FILE IS PART OF EVIL HACK FOR UNOPTIMISED COMPILERS WHEN THAT FUNCTIONS ARE NOT BUILDING BECAUSE CONFIGS\n")

    #TODO[cmake]: make it config depended

    #if not ARCH_AARCH64 ARCH_ARM ARCH_PPC ARCH_X86 ARCH_MIPS ARCH_ALPHA

    list(APPEND SWSCALE_EMPTY_FUNCTIONS "void ff_sws_init_swscale_ppc(void* c){}")
    list(APPEND SWSCALE_EMPTY_FUNCTIONS "void ff_sws_init_swscale_x86(void* c){}")
    list(APPEND SWSCALE_EMPTY_FUNCTIONS "void ff_sws_init_swscale_aarch64(void* c){}")
    list(APPEND SWSCALE_EMPTY_FUNCTIONS "void ff_sws_init_swscale_arm(void* c){}")

    list(APPEND SWSCALE_EMPTY_FUNCTIONS "void* ff_yuv2rgb_init_x86(void* c){return (void*)0\;}")
    list(APPEND SWSCALE_EMPTY_FUNCTIONS "void* ff_yuv2rgb_init_ppc(void* c){return (void*)0\;}")

    list(APPEND SWSCALE_EMPTY_FUNCTIONS "void ff_yuv2rgb_init_tables_ppc(void* c, const int inv_table[4], int brightness, int contrast, int saturation){}")

    list(APPEND SWSCALE_EMPTY_FUNCTIONS "void rgb2rgb_init_aarch64(void){}")
    list(APPEND SWSCALE_EMPTY_FUNCTIONS "void rgb2rgb_init_x86(void){}")

    list(APPEND SWSCALE_EMPTY_FUNCTIONS "void ff_get_unscaled_swscale_ppc(void* c){}")
    list(APPEND SWSCALE_EMPTY_FUNCTIONS "void ff_get_unscaled_swscale_arm(void* c){}")
    list(APPEND SWSCALE_EMPTY_FUNCTIONS "void ff_get_unscaled_swscale_aarch64(void* c){}")


    foreach(CONTENT ${SWSCALE_EMPTY_FUNCTIONS})
        string(APPEND SWSCALE_GENERATED_EMPTY_FUNCTIONS_FILE_CONTENT "${CONTENT}\n")
    endforeach()

    file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/hack/empty_functions.c "${SWSCALE_GENERATED_EMPTY_FUNCTIONS_FILE_CONTENT}")

endif()


add_library(swscale OBJECT ${SWSCALE_SOURCES})
target_include_directories(swscale PUBLIC ${CMAKE_CURRENT_BINARY_DIR}/include)

add_library(swscale_static STATIC $<TARGET_OBJECTS:swscale>)

target_link_libraries(swscale PRIVATE ffmpeg_config)
target_link_libraries(swscale PRIVATE avutil)

if(MSVC)
    message(WARNING "SWSCALE: adding empty_functions.c hack for unoptimised MSVC")
    target_sources(swscale PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/hack/empty_functions.c)
endif()
