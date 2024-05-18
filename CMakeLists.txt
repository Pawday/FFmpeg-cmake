cmake_minimum_required(VERSION 3.20)

function(gen_prepend_hack SOURCE_PATCH_MAP WORKING_DIR MODULE_NAME OUTPUT_LIST)

    list(APPEND LOCAL_OUTPUT_LIST ${${OUTPUT_LIST}})

    set(SOURCE_PATCH_MAP_NAME ${SOURCE_PATCH_MAP})
    set(SOURCE_PATCH_MAP_VAL ${${SOURCE_PATCH_MAP_NAME}})
    set(WORKING_DIR_NAME ${WORKING_DIR})
    set(WORKING_DIR_VAL ${${WORKING_DIR}})

    list(LENGTH SOURCE_PATCH_MAP_VAL SOURCE_PATCH_MAP_SIZE)
    math(EXPR SHOULD_BE_ZERO "${SOURCE_PATCH_MAP_SIZE} % 2")
    if(NOT 0 EQUAL ${SHOULD_BE_ZERO})
        message(FATAL_ERROR "Broken ${SOURCE_PATCH_MAP_NAME} SOURCE_PATCH_MAP")
    endif()
    math(EXPR SOURCE_PATCH_MAP_SIZE "${SOURCE_PATCH_MAP_SIZE} / 2")

    if (0 EQUAL ${SOURCE_PATCH_MAP_SIZE})
        return()
    endif()

    foreach(PATCHED_AVCODEC_SOURCE_INDEX RANGE 1 ${SOURCE_PATCH_MAP_SIZE})
        math(EXPR PATCHED_AVCODEC_SOURCE_INDEX "${PATCHED_AVCODEC_SOURCE_INDEX} - 1")
        math(EXPR KEY_INDEX "${PATCHED_AVCODEC_SOURCE_INDEX} * 2")
        math(EXPR VAL_INDEX "${PATCHED_AVCODEC_SOURCE_INDEX} * 2 + 1")

        list(GET SOURCE_PATCH_MAP_VAL ${KEY_INDEX} SOURCE)
        list(GET SOURCE_PATCH_MAP_VAL ${VAL_INDEX} PREPEND_STRING)

        set(SOURCE_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/${SOURCE})
        set(GENERATED_SOURCE_LOCATION "${WORKING_DIR_VAL}/${SOURCE}")
        set(GENERATED_SOURCE_CONTENT "${PREPEND_STRING}\n\n#include \"${SOURCE_LOCATION}\"")

        message(STATUS "[${MODULE_NAME}] [Prepend Hack] ${GENERATED_SOURCE_LOCATION}")
        file(GENERATE OUTPUT ${GENERATED_SOURCE_LOCATION} CONTENT ${GENERATED_SOURCE_CONTENT})

        list(APPEND LOCAL_OUTPUT_LIST ${GENERATED_SOURCE_LOCATION})
    endforeach()

    set(${OUTPUT_LIST} ${LOCAL_OUTPUT_LIST} PARENT_SCOPE)
endfunction()


project(FFMPEG VERSION 6.1.1 LANGUAGES C)

add_library(ffmpeg.global_config INTERFACE)
target_compile_definitions(ffmpeg.global_config INTERFACE
    CONFIG_THIS_YEAR=2024
    CC_IDENT="${CMAKE_C_COMPILER_ID} ${CMAKE_C_COMPILER_VERSION}"
    FFMPEG_CONFIGURATION="CMake"
    FFMPEG_LICENSE="AAASD"
    FFMPEG_VERSION="${CMAKE_PROJECT_VERSION}"

    HAVE_BIGENDIAN=0
    HAVE_THREADS=0

    HAVE_ALTIVEC=0
    HAVE_LASX=0
    HAVE_MMX=0
    HAVE_NEON=0
    HAVE_MMX_INLINE=0
    HAVE_MMXEXT_INLINE=0
    HAVE_LSX=0
    HAVE_FAST_64BIT=0

    CONFIG_SMALL=0
    CONFIG_ZLIB=0

    CONFIG_AVUTIL=1
    CONFIG_AVCODEC=1
    CONFIG_AVFORMAT=1
    CONFIG_AVFILTER=1
    CONFIG_AVDEVICE=1

    CONFIG_SWSCALE=1
    CONFIG_SWRESAMPLE=0
    CONFIG_POSTPROC=0

    CONFIG_SWSCALE_ALPHA=0
)

set(FFMPEG_HAVE_UNISTD_H 1)
set(FFMPEG_HAVE_DOS_PATHS 0)

if(WIN32)
    set(FFMPEG_HAVE_DOS_PATHS 1)
    set(FFMPEG_HAVE_UNISTD_H 0)
endif()


find_library(FFMPEG_LIB_MATH m)
set(FFMPEG_LIB_MATH_FOUND FALSE)
if(NOT ${FFMPEG_LIB_MATH} STREQUAL "LIB_MATH-NOTFOUND")
    set(FFMPEG_LIB_MATH_FOUND TRUE)
endif()


target_compile_definitions(ffmpeg.global_config INTERFACE HAVE_DOS_PATHS=${FFMPEG_HAVE_DOS_PATHS})
target_compile_definitions(ffmpeg.global_config INTERFACE HAVE_UNISTD_H=${FFMPEG_HAVE_UNISTD_H})

set(ffmpeg.config_header_include_dir "${CMAKE_CURRENT_BINARY_DIR}/generated/config_include_dir")
file(GENERATE OUTPUT "${ffmpeg.config_header_include_dir}/config.h" CONTENT "")
file(GENERATE OUTPUT "${ffmpeg.config_header_include_dir}/config_components.h" CONTENT "")
target_include_directories(ffmpeg.global_config INTERFACE ${ffmpeg.config_header_include_dir})


add_subdirectory(compat)
add_subdirectory(libavutil)
add_subdirectory(libavcodec)

message(WARNING "TODO: Watch ffmpeg devs fix avcodec <=> avutil cycle in libavutil/hdr_dynamic_metadata.c")
target_link_libraries(ffmpeg.avutil.objects PRIVATE ffmpeg.avcodec.headers)

add_subdirectory(libavformat)
add_subdirectory(libavfilter)
add_subdirectory(libavdevice)
add_subdirectory(libswscale)

add_subdirectory(fftools)

add_subdirectory(doc/examples)


foreach(AVCODEC_COMPONENT_TARGET ${FFMPEG_AVCODEC_COMPONENTS})
    if (NOT TARGET ${AVCODEC_COMPONENT_TARGET})
        message(FATAL_ERROR "AVCODEC_COMPONENT_TARGET: ${AVCODEC_COMPONENT_TARGET} is not an existing target")
    endif()
endforeach()

foreach(AVFORMAT_COMPONENT_TARGET ${FFMPEG_AVFORMAT_COMPONENTS})
    if (NOT TARGET ${AVFORMAT_COMPONENT_TARGET})
        message(FATAL_ERROR "AVFORMAT_COMPONENT_TARGET: ${AVFORMAT_COMPONENT_TARGET} is not an existing target")
    endif()
endforeach()

foreach(AVDEVICE_COMPONENT_TARGET ${FFMPEG_AVDEVICE_COMPONENTS})
    if (NOT TARGET ${AVDEVICE_COMPONENT_TARGET})
        message(FATAL_ERROR "AVDEVICE_COMPONENT_TARGET: ${AVDEVICE_COMPONENT_TARGET} is not an existing target")
    endif()
endforeach()


target_link_libraries(ffmpeg.avutil.objects PRIVATE ffmpeg.global_config)
foreach(AVCODEC_COMPONENT_TARGET ${FFMPEG_AVCODEC_COMPONENTS})
    target_link_libraries(${AVCODEC_COMPONENT_TARGET} PRIVATE ffmpeg.global_config)
endforeach()
foreach(AVFORMAT_COMPONENT_TARGET ${FFMPEG_AVFORMAT_COMPONENTS})
    target_link_libraries(${AVFORMAT_COMPONENT_TARGET} PRIVATE ffmpeg.global_config)
endforeach()
foreach(AVDEVICE_COMPONENT_TARGET ${FFMPEG_AVDEVICE_COMPONENTS})
    target_link_libraries(${AVDEVICE_COMPONENT_TARGET} PRIVATE ffmpeg.global_config)
endforeach()
target_link_libraries(ffmpeg.avfilter.objects PRIVATE ffmpeg.global_config)
target_link_libraries(ffmpeg.swscale.objects PRIVATE ffmpeg.global_config)
target_link_libraries(ffmpeg.fftools.ffmpeg.objects PRIVATE ffmpeg.global_config)


# AVUTIL
add_library(ffmpeg.avutil.shared SHARED $<TARGET_OBJECTS:ffmpeg.avutil.objects>)
add_library(ffmpeg.avutil.static STATIC $<TARGET_OBJECTS:ffmpeg.avutil.objects>)

# AVCODEC
add_library(ffmpeg.avcodec.shared SHARED)
target_link_libraries(ffmpeg.avcodec.shared PRIVATE ffmpeg.avutil.shared)
add_library(ffmpeg.avcodec.static STATIC)

foreach(AVCODEC_COMPONENT_TARGET ${FFMPEG_AVCODEC_COMPONENTS})
    target_sources(ffmpeg.avcodec.shared PRIVATE $<TARGET_OBJECTS:${AVCODEC_COMPONENT_TARGET}>)
    target_sources(ffmpeg.avcodec.static PRIVATE $<TARGET_OBJECTS:${AVCODEC_COMPONENT_TARGET}>)
endforeach()

# AVFORMAT
add_library(ffmpeg.avformat.shared SHARED)
target_link_libraries(ffmpeg.avformat.shared PRIVATE
    ffmpeg.avutil.shared
    ffmpeg.avcodec.shared
)
add_library(ffmpeg.avformat.static STATIC)

foreach(AVFORMAT_COMPONENT_TARGET ${FFMPEG_AVFORMAT_COMPONENTS})
    target_sources(ffmpeg.avformat.shared PRIVATE $<TARGET_OBJECTS:${AVFORMAT_COMPONENT_TARGET}>)
    target_sources(ffmpeg.avformat.static PRIVATE $<TARGET_OBJECTS:${AVFORMAT_COMPONENT_TARGET}>)
endforeach()

# AVFILTER
add_library(ffmpeg.avfilter.shared SHARED $<TARGET_OBJECTS:ffmpeg.avfilter.objects>)
target_link_libraries(ffmpeg.avfilter.shared PRIVATE
    ffmpeg.avutil.shared
    ffmpeg.swscale.shared
)
add_library(ffmpeg.avfilter.static STATIC $<TARGET_OBJECTS:ffmpeg.avfilter.objects>)

# AVDEVICE
add_library(ffmpeg.avdevice.shared SHARED)
target_link_libraries(ffmpeg.avdevice.shared PRIVATE
    ffmpeg.avutil.shared
    ffmpeg.avcodec.shared
    ffmpeg.avformat.shared
)
add_library(ffmpeg.avdevice.static STATIC)

foreach(AVDEVICE_COMPONENT_TARGET ${FFMPEG_AVDEVICE_COMPONENTS})
    target_sources(ffmpeg.avdevice.shared PRIVATE $<TARGET_OBJECTS:${AVDEVICE_COMPONENT_TARGET}>)
    target_sources(ffmpeg.avdevice.static PRIVATE $<TARGET_OBJECTS:${AVDEVICE_COMPONENT_TARGET}>)
endforeach()



# SWSCALE
add_library(ffmpeg.swscale.shared SHARED $<TARGET_OBJECTS:ffmpeg.swscale.objects>)
target_link_libraries(ffmpeg.swscale.shared PRIVATE ffmpeg.avutil.shared)
add_library(ffmpeg.swscale.static STATIC $<TARGET_OBJECTS:ffmpeg.swscale.objects>)


# STATIC libffmpeg
add_library(ffmpeg.static STATIC)
list(APPEND FFMPEG_COMPONENTS
    ffmpeg.avutil.objects
    ${FFMPEG_AVCODEC_COMPONENTS}
    ${FFMPEG_AVFORMAT_COMPONENTS}
    ffmpeg.avfilter.objects
    ${FFMPEG_AVDEVICE_COMPONENTS}

    ffmpeg.swscale.objects
)
foreach(FFMPEG_OBJECT_COMPONENT ${FFMPEG_COMPONENTS})
    target_sources(ffmpeg.static PRIVATE $<TARGET_OBJECTS:${FFMPEG_OBJECT_COMPONENT}>)
endforeach()

# FFTOOLS
target_link_libraries(ffmpeg.fftools.ffmpeg.objects PRIVATE
    ffmpeg.compat.headers
    ffmpeg.avutil.config
    ffmpeg.avutil.headers
    ffmpeg.avcodec.config
    ffmpeg.avcodec.headers
    ffmpeg.avformat.config
    ffmpeg.avformat.headers
    ffmpeg.avdevice.config
    ffmpeg.avdevice.headers
    ffmpeg.avfilter.config
    ffmpeg.avfilter.headers
)

add_executable(ffmpeg $<TARGET_OBJECTS:ffmpeg.fftools.ffmpeg.objects>)
target_link_libraries(ffmpeg PRIVATE
    ffmpeg.avutil.shared
    ffmpeg.avcodec.shared
    ffmpeg.avformat.shared
    ffmpeg.avdevice.shared
    ffmpeg.avfilter.shared
    ffmpeg.swscale.shared
)



if(${FFMPEG_LIB_MATH_FOUND})
    target_link_libraries(ffmpeg.avutil.shared PRIVATE ${FFMPEG_LIB_MATH})
    target_link_libraries(ffmpeg.avcodec.shared PRIVATE ${FFMPEG_LIB_MATH})
    target_link_libraries(ffmpeg.avformat.shared PRIVATE ${FFMPEG_LIB_MATH})
    target_link_libraries(ffmpeg.avdevice.shared PRIVATE ${FFMPEG_LIB_MATH})
    target_link_libraries(ffmpeg.swscale.shared PRIVATE ${FFMPEG_LIB_MATH})
    target_link_libraries(ffmpeg.avfilter.shared PRIVATE ${FFMPEG_LIB_MATH})

    target_link_libraries(ffmpeg PRIVATE ${FFMPEG_LIB_MATH})

    target_link_libraries(ffmpeg.doc.decode_video PRIVATE ${FFMPEG_LIB_MATH})
endif()



set(LINKER_USE_NO_UNDEFINED TRUE)
if (MSVC)
    set(LINKER_USE_NO_UNDEFINED FALSE)
endif()

if(${LINKER_USE_NO_UNDEFINED})
    target_link_options(ffmpeg.avutil.shared PRIVATE "-Wl,--no-undefined")
    target_link_options(ffmpeg.avcodec.shared PRIVATE "-Wl,--no-undefined")
    target_link_options(ffmpeg.avformat.shared PRIVATE "-Wl,--no-undefined")
    target_link_options(ffmpeg.avdevice.shared PRIVATE "-Wl,--no-undefined")
    target_link_options(ffmpeg.avfilter.shared PRIVATE "-Wl,--no-undefined")
    target_link_options(ffmpeg.swscale.shared PRIVATE "-Wl,--no-undefined")
endif()

set_property(TARGET ffmpeg.avutil.shared PROPERTY OUTPUT_NAME "avutil")
set_property(TARGET ffmpeg.avcodec.shared PROPERTY OUTPUT_NAME "avcodec")
set_property(TARGET ffmpeg.avformat.shared PROPERTY OUTPUT_NAME "avformat")
set_property(TARGET ffmpeg.avdevice.shared PROPERTY OUTPUT_NAME "avdevice")
set_property(TARGET ffmpeg.avfilter.shared PROPERTY OUTPUT_NAME "avfilter")
set_property(TARGET ffmpeg.swscale.shared PROPERTY OUTPUT_NAME "swscale")
set(ffmpeg.avutil.static.artefact_name "avutil")
set(ffmpeg.avcodec.static.artefact_name "avcodec")
set(ffmpeg.avformat.static.artefact_name "avformat")
set(ffmpeg.avdevice.static.artefact_name "avdevice")
set(ffmpeg.avfilter.static.artefact_name "avfilter")
set(ffmpeg.swscale.static.artefact_name "swscale")
set(ffmpeg.static.artefact_name "ffmpeg")


set(APPEND_STATIC_TO_ARTEFACT_NAME FALSE)
if(WIN32)
    set(APPEND_STATIC_TO_ARTEFACT_NAME TRUE)
endif()
if(${APPEND_STATIC_TO_ARTEFACT_NAME})
    set(ffmpeg.avutil.static.artefact_name "avutil_static")
    set(ffmpeg.avcodec.static.artefact_name "avcodec_static")
    set(ffmpeg.avformat.static.artefact_name "avformat_static")
    set(ffmpeg.avdevice.static.artefact_name "avdevice_static")
    set(ffmpeg.avfilter.static.artefact_name "avfilter_static")
    set(ffmpeg.swscale.static.artefact_name "swscale_static")

    set(ffmpeg.static.artefact_name "ffmpeg_static")
endif()
set_property(TARGET ffmpeg.avutil.static PROPERTY OUTPUT_NAME ${ffmpeg.avutil.static.artefact_name})
set_property(TARGET ffmpeg.avcodec.static PROPERTY OUTPUT_NAME ${ffmpeg.avcodec.static.artefact_name})
set_property(TARGET ffmpeg.avformat.static PROPERTY OUTPUT_NAME ${ffmpeg.avformat.static.artefact_name})
set_property(TARGET ffmpeg.avdevice.static PROPERTY OUTPUT_NAME ${ffmpeg.avdevice.static.artefact_name})
set_property(TARGET ffmpeg.avfilter.static PROPERTY OUTPUT_NAME ${ffmpeg.avfilter.static.artefact_name})
set_property(TARGET ffmpeg.swscale.static PROPERTY OUTPUT_NAME ${ffmpeg.swscale.static.artefact_name})

set_property(TARGET ffmpeg.static PROPERTY OUTPUT_NAME ${ffmpeg.static.artefact_name})


set(FFMPEG_DISABLE_WARNINGS_DEFAULT 1)
message(WARNING "TODO: MSVC have option for disabling warnings - use it FFMPEG_DISABLE_WARNINGS")
if(WIN32)
    set(FFMPEG_DISABLE_WARNINGS_DEFAULT 0)
endif()
option(FFMPEG_DISABLE_WARNINGS "Disable ffmpeg compilation warnings" ${FFMPEG_DISABLE_WARNINGS_DEFAULT})


if(FFMPEG_DISABLE_WARNINGS)
    foreach(FFMPEG_OBJECT_COMPONENT ${FFMPEG_COMPONENTS})
        target_compile_options(${FFMPEG_OBJECT_COMPONENT} PRIVATE "-w")
    endforeach()

    target_compile_options(ffmpeg.fftools.ffmpeg.objects PRIVATE "-w")
endif()
