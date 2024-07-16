cmake_minimum_required(VERSION 3.23)

option(FFMPEG_DISABLE_CMAKE_WARNINGS "Disable cmake warnings for ffmpeg" ON)
mark_as_advanced(FFMPEG_DISABLE_CMAKE_WARNINGS)

function(ffmpeg_message MODE MODULE_NAME MESSAGE)

    list(APPEND VALID_MODE_LIST
        "TRACE"
        "DEBUG"
        "VERBOSE"
        "STATUS"
        "NOTICE"
        "DEPRECATION"
        "AUTHOR_WARNING"
        "WARNING"
        "SEND_ERROR"
        "FATAL_ERROR"
    )

    list(FIND VALID_MODE_LIST ${MODE} SHOULD_BE_NOT_NEGATIVE_ONE)

    if (-1 EQUAL ${SHOULD_BE_NOT_NEGATIVE_ONE})
        message(FATAL_ERROR "[ffmpeg] Unknown mode \"${MODE}\" for message \"${MESSAGE}\"")
    endif()

    if ("FATAL_ERROR" STREQUAL ${MODE})
        message(FATAL_ERROR "[ffmpeg] [${MODULE_NAME}] ${MESSAGE}")
        return()
    endif()

    if ("SEND_ERROR" STREQUAL ${MODE})
        message(SEND_ERROR "[ffmpeg] [${MODULE_NAME}] ${MESSAGE}")
        return()
    endif()

    if ("WARNING" STREQUAL ${MODE})
        if (FFMPEG_DISABLE_CMAKE_WARNINGS)
            return()
        endif()
        message(WARNING "[ffmpeg] [${MODULE_NAME}] ${MESSAGE}")
        return()
    endif()

    message(STATUS "[ffmpeg] (${MODE}) [${MODULE_NAME}] ${MESSAGE}")
endfunction()

macro(ff_create_component COMPONENT_NAME)
    list(APPEND FFMPEG_COMPONENTS ${COMPONENT_NAME})
    set(FFMPEG_COMPONENTS ${FFMPEG_COMPONENTS} PARENT_SCOPE)
    add_library(ffmpeg.${COMPONENT_NAME}.PIC_obj OBJECT)
    set_property(TARGET ffmpeg.${COMPONENT_NAME}.PIC_obj PROPERTY POSITION_INDEPENDENT_CODE TRUE)
    add_library(ffmpeg.${COMPONENT_NAME}.obj OBJECT)
endmacro()


macro(ff_component_sources COMPONENT_NAME SOURCES_LIST)
    target_sources(ffmpeg.${COMPONENT_NAME}.PIC_obj PUBLIC ${${SOURCES_LIST}})
    target_sources(ffmpeg.${COMPONENT_NAME}.obj PUBLIC ${${SOURCES_LIST}})
endmacro()


macro(ff_component_link_library COMPONENT_NAME MODE LIBRARY_TARGET)
    target_link_libraries(ffmpeg.${COMPONENT_NAME}.PIC_obj ${MODE} ${LIBRARY_TARGET})
    target_link_libraries(ffmpeg.${COMPONENT_NAME}.obj ${MODE} ${LIBRARY_TARGET})
endmacro()


function(gen_prepend_hack SOURCE_PATCH_MAP WORKING_DIR MODULE_NAME OUTPUT_LIST)

    list(APPEND LOCAL_OUTPUT_LIST ${${OUTPUT_LIST}})

    set(SOURCE_PATCH_MAP_NAME ${SOURCE_PATCH_MAP})
    set(SOURCE_PATCH_MAP_VAL ${${SOURCE_PATCH_MAP_NAME}})
    set(WORKING_DIR_NAME ${WORKING_DIR})
    set(WORKING_DIR_VAL ${${WORKING_DIR}})

    list(LENGTH SOURCE_PATCH_MAP_VAL SOURCE_PATCH_MAP_SIZE)
    math(EXPR SHOULD_BE_ZERO "${SOURCE_PATCH_MAP_SIZE} % 2")
    if(NOT 0 EQUAL ${SHOULD_BE_ZERO})
        ffmpeg_message(FATAL_ERROR ${MODULE_NAME} "Broken ${SOURCE_PATCH_MAP_NAME} SOURCE_PATCH_MAP")
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

        ffmpeg_message(STATUS ${MODULE_NAME} "[Prepend Hack] ${GENERATED_SOURCE_LOCATION}")
        file(GENERATE OUTPUT ${GENERATED_SOURCE_LOCATION} CONTENT ${GENERATED_SOURCE_CONTENT})

        list(APPEND LOCAL_OUTPUT_LIST ${GENERATED_SOURCE_LOCATION})
    endforeach()

    set(${OUTPUT_LIST} ${LOCAL_OUTPUT_LIST} PARENT_SCOPE)
endfunction()


function(gen_headers_include_source HEADER_NAMES WORKING_DIR OUTPUT_DIR)
    set(HEADER_NAMES ${${HEADER_NAMES}})
    set(WORKING_DIR ${${WORKING_DIR}})
    foreach(HEADER ${HEADER_NAMES})
        set(HEADER_CONTENT "// IWYU pragma: begin_exports\n#include \"${WORKING_DIR}/${HEADER}\"\n// IWYU pragma: end_exports\n")
        file(GENERATE OUTPUT "${OUTPUT_DIR}/${HEADER}" CONTENT ${HEADER_CONTENT})
    endforeach()
endfunction()

function(gen_headers_symlink HEADER_NAMES WORKING_DIR OUTPUT_DIR)
    set(HEADER_NAMES ${${HEADER_NAMES}})
    set(WORKING_DIR ${${WORKING_DIR}})
    foreach(HEADER ${HEADER_NAMES})
        set(OUTPUT_FILE "${OUTPUT_DIR}/${HEADER}")
        cmake_path(REMOVE_FILENAME OUTPUT_FILE OUTPUT_VARIABLE OUTPUT_FILE_DIR)
        file(MAKE_DIRECTORY ${OUTPUT_FILE_DIR})
        file(CREATE_LINK "${WORKING_DIR}/${HEADER}" ${OUTPUT_FILE} SYMBOLIC)
    endforeach()
endfunction()

function(gen_headers HEADER_NAMES WORKING_DIR OUTPUT_DIR)
    gen_headers_symlink(${HEADER_NAMES} ${WORKING_DIR} ${OUTPUT_DIR})
endfunction()

project(FFMPEG VERSION 7.0.0 LANGUAGES C)

set(CMAKE_LINK_LIBRARIES_ONLY_TARGETS ON)

string(TIMESTAMP FFMPEG_CONFIG_THIS_YEAR_DEFAULT "%Y")
set(FFMPEG_CONFIG_THIS_YEAR ${FFMPEG_CONFIG_THIS_YEAR_DEFAULT} CACHE STRING "FFmpeg CONFIG_THIS_YEAR string define")
mark_as_advanced(FFMPEG_CONFIG_THIS_YEAR)

set(FFMPEG_CC_IDENT "${CMAKE_C_COMPILER_ID} ${CMAKE_C_COMPILER_VERSION}" CACHE STRING "FFmpeg CC_IDENT string define")
mark_as_advanced(FFMPEG_CC_IDENT)

set(FFMPEG_CONFIGURATION "CMake" CACHE STRING "FFmpeg FFMPEG_CONFIGURATION string define")
mark_as_advanced(FFMPEG_CONFIGURATION)

list(APPEND FFMPEG_LICENSE_VALUES
    GPL
    GPLV3
    LGPLV2_1
    LGPLV3
    NONFREE
)
list(APPEND FFMPEG_LICENSE_STRINGS
    "GPL version 2 or later"
    "GPL version 3 or later"
    "LGPL version 2.1 or later"
    "LGPL version 3 or later"
    "nonfree and unredistributable"
)

set(FFMPEG_LICENSE "GPL" CACHE STRING "FFmpeg LICENSE")
set_property(CACHE FFMPEG_LICENSE PROPERTY STRINGS ${FFMPEG_LICENSE_VALUES})
list(FIND FFMPEG_LICENSE_VALUES ${FFMPEG_LICENSE} FFMPEG_LICENSE_INDEX)
if(-1 EQUAL ${FFMPEG_LICENSE_INDEX})
    ffmpeg_message(FATAL_ERROR "config" "Unknown FFMPEG_LICENSE: ${FFMPEG_LICENSE}")
endif()


list(GET FFMPEG_LICENSE_STRINGS ${FFMPEG_LICENSE_INDEX} FFMPEG_LICENSE_STRING)
set(FFMPEG_LICENSE_STRING ${FFMPEG_LICENSE_STRING} CACHE STRING "FFmpeg FFMPEG_LICENSE string define" FORCE)
mark_as_advanced(FFMPEG_LICENSE_STRING)


set(FFMPEG_HAVE_BIGENDIAN 0 CACHE STRING "FFmpeg HAVE_BIGENDIAN define" FORCE)
if(CMAKE_C_BYTE_ORDER STREQUAL BIG_ENDIAN)
    set(FFMPEG_HAVE_BIGENDIAN 1 CACHE STRING "FFmpeg HAVE_BIGENDIAN define" FORCE)
endif()
mark_as_advanced(FFMPEG_HAVE_BIGENDIAN)

add_library(ffmpeg.global_config INTERFACE)
target_compile_definitions(ffmpeg.global_config INTERFACE
    CONFIG_THIS_YEAR=${FFMPEG_CONFIG_THIS_YEAR}
    CC_IDENT="${FFMPEG_CC_IDENT}"
    FFMPEG_CONFIGURATION="${FFMPEG_CONFIGURATION}"
    FFMPEG_LICENSE="${FFMPEG_LICENSE_STRING}"
    FFMPEG_VERSION="${CMAKE_PROJECT_VERSION}"

    HAVE_BIGENDIAN=${FFMPEG_HAVE_BIGENDIAN}
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
    CONFIG_SWRESAMPLE=1
    CONFIG_POSTPROC=1

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
if(NOT ${FFMPEG_LIB_MATH} STREQUAL "FFMPEG_LIB_MATH-NOTFOUND")
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

ffmpeg_message(WARNING "config" "TODO: Watch ffmpeg devs fix avcodec <=> avutil cycle in libavutil/hdr_dynamic_metadata.c")
target_link_libraries(ffmpeg.avutil.obj PRIVATE ffmpeg.avcodec.headers)
target_link_libraries(ffmpeg.avutil.PIC_obj PRIVATE ffmpeg.avcodec.headers)

add_subdirectory(libavformat)
add_subdirectory(libavdevice)

add_subdirectory(libswscale)
add_subdirectory(libavfilter)

add_subdirectory(libswresample)
add_subdirectory(libpostproc)

add_subdirectory(fftools)

add_subdirectory(doc/examples)


foreach(AVDEVICE_COMPONENT_TARGET ${FFMPEG_AVDEVICE_COMPONENTS})
    if (NOT TARGET ${AVDEVICE_COMPONENT_TARGET})
        ffmpeg_message(FATAL_ERROR "config" "AVDEVICE_COMPONENT_TARGET: ${AVDEVICE_COMPONENT_TARGET} is not an existing target")
    endif()
endforeach()


target_link_libraries(ffmpeg.avutil.obj PRIVATE ffmpeg.global_config)

foreach(AVDEVICE_COMPONENT_TARGET ${FFMPEG_AVDEVICE_COMPONENTS})
    target_link_libraries(${AVDEVICE_COMPONENT_TARGET} PRIVATE ffmpeg.global_config)
endforeach()
foreach(AVFILTER_COMPONENT_TARGET ${FFMPEG_AVFILTER_COMPONENTS})
    target_link_libraries(${AVFILTER_COMPONENT_TARGET} PRIVATE ffmpeg.global_config)
endforeach()
target_link_libraries(ffmpeg.swscale.objects PRIVATE ffmpeg.global_config)
target_link_libraries(ffmpeg.fftools.ffmpeg.objects PRIVATE ffmpeg.global_config)
target_link_libraries(ffmpeg.swresample.objects PRIVATE ffmpeg.global_config)
target_link_libraries(ffmpeg.postproc.objects PRIVATE ffmpeg.global_config)


# AVUTIL
add_library(ffmpeg.avutil.shared SHARED $<TARGET_OBJECTS:ffmpeg.avutil.PIC_obj>)
add_library(ffmpeg.avutil.static_pic STATIC $<TARGET_OBJECTS:ffmpeg.avutil.PIC_obj>)
add_library(ffmpeg.avutil.static STATIC $<TARGET_OBJECTS:ffmpeg.avutil.obj>)

# AVCODEC
add_library(ffmpeg.avcodec.shared SHARED)
target_link_libraries(ffmpeg.avcodec.shared PRIVATE ffmpeg.avutil.shared)
add_library(ffmpeg.avcodec.static STATIC)
add_library(ffmpeg.avcodec.static_pic STATIC)

foreach(AVCODEC_COMPONENT_TARGET ${FFMPEG_AVCODEC_COMPONENTS})
    target_sources(ffmpeg.avcodec.shared PRIVATE $<TARGET_OBJECTS:ffmpeg.${AVCODEC_COMPONENT_TARGET}.PIC_obj>)
    target_sources(ffmpeg.avcodec.static_pic PRIVATE $<TARGET_OBJECTS:ffmpeg.${AVCODEC_COMPONENT_TARGET}.PIC_obj>)
    target_sources(ffmpeg.avcodec.static PRIVATE $<TARGET_OBJECTS:ffmpeg.${AVCODEC_COMPONENT_TARGET}.obj>)
endforeach()

# AVFORMAT
add_library(ffmpeg.avformat.shared SHARED)
target_link_libraries(ffmpeg.avformat.shared PRIVATE
    ffmpeg.avutil.shared
    ffmpeg.avcodec.shared
)
add_library(ffmpeg.avformat.static_pic STATIC)
add_library(ffmpeg.avformat.static STATIC)

foreach(AVFORMAT_COMPONENT_TARGET ${FFMPEG_AVFORMAT_COMPONENTS})
    target_sources(ffmpeg.avformat.shared PRIVATE $<TARGET_OBJECTS:ffmpeg.${AVFORMAT_COMPONENT_TARGET}.PIC_obj>)
    target_sources(ffmpeg.avformat.static_pic PRIVATE $<TARGET_OBJECTS:ffmpeg.${AVFORMAT_COMPONENT_TARGET}.PIC_obj>)
    target_sources(ffmpeg.avformat.static PRIVATE $<TARGET_OBJECTS:ffmpeg.${AVFORMAT_COMPONENT_TARGET}.obj>)
endforeach()

# AVFILTER
add_library(ffmpeg.avfilter.shared SHARED)
target_link_libraries(ffmpeg.avfilter.shared PRIVATE
    ffmpeg.avutil.shared
    ffmpeg.swscale.shared
)
add_library(ffmpeg.avfilter.static STATIC)
add_library(ffmpeg.avfilter.static_pic STATIC)

foreach(AVFILTER_COMPONENT_TARGET ${FFMPEG_AVFILTER_COMPONENTS})
    target_sources(ffmpeg.avfilter.shared PRIVATE $<TARGET_OBJECTS:${AVFILTER_COMPONENT_TARGET}>)
    target_sources(ffmpeg.avfilter.static_pic PRIVATE $<TARGET_OBJECTS:${AVFILTER_COMPONENT_TARGET}>)
    target_sources(ffmpeg.avfilter.static PRIVATE $<TARGET_OBJECTS:${AVFILTER_COMPONENT_TARGET}>)
endforeach()

# AVDEVICE
add_library(ffmpeg.avdevice.shared SHARED)
target_link_libraries(ffmpeg.avdevice.shared PRIVATE
    ffmpeg.avutil.shared
    ffmpeg.avcodec.shared
    ffmpeg.avformat.shared
)
add_library(ffmpeg.avdevice.static STATIC)
add_library(ffmpeg.avdevice.static_pic STATIC)

foreach(AVDEVICE_COMPONENT_TARGET ${FFMPEG_AVDEVICE_COMPONENTS})
    target_sources(ffmpeg.avdevice.shared PRIVATE $<TARGET_OBJECTS:${AVDEVICE_COMPONENT_TARGET}>)
    target_sources(ffmpeg.avdevice.static_pic PRIVATE $<TARGET_OBJECTS:${AVDEVICE_COMPONENT_TARGET}>)
    target_sources(ffmpeg.avdevice.static PRIVATE $<TARGET_OBJECTS:${AVDEVICE_COMPONENT_TARGET}>)
endforeach()


# SWSCALE
add_library(ffmpeg.swscale.shared SHARED $<TARGET_OBJECTS:ffmpeg.swscale.objects>)
target_link_libraries(ffmpeg.swscale.shared PRIVATE ffmpeg.avutil.shared)
add_library(ffmpeg.swscale.static STATIC $<TARGET_OBJECTS:ffmpeg.swscale.objects>)
add_library(ffmpeg.swscale.static_pic STATIC $<TARGET_OBJECTS:ffmpeg.swscale.objects>)



# SWRESAMPLE
add_library(ffmpeg.swresample.shared SHARED $<TARGET_OBJECTS:ffmpeg.swresample.objects>)
target_link_libraries(ffmpeg.swresample.shared PRIVATE ffmpeg.avutil.shared)
add_library(ffmpeg.swresample.static STATIC $<TARGET_OBJECTS:ffmpeg.swresample.objects>)
add_library(ffmpeg.swresample.static_pic STATIC $<TARGET_OBJECTS:ffmpeg.swresample.objects>)


# POSTPROC
add_library(ffmpeg.postproc.shared SHARED $<TARGET_OBJECTS:ffmpeg.postproc.objects>)
target_link_libraries(ffmpeg.postproc.shared PRIVATE ffmpeg.avutil.shared)
add_library(ffmpeg.postproc.static STATIC $<TARGET_OBJECTS:ffmpeg.postproc.objects>)
add_library(ffmpeg.postproc.static_pic STATIC $<TARGET_OBJECTS:ffmpeg.postproc.objects>)


list(APPEND FFMPEG_LIBS
    avutil
    avcodec
    avformat
    avdevice
    avfilter
    swscale
    swresample
    postproc
)


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
    ffmpeg.swscale.config
    ffmpeg.swscale.headers
    ffmpeg.swresample.config
    ffmpeg.swresample.headers
    ffmpeg.postproc.config
    ffmpeg.postproc.headers
)

add_executable(ffmpeg $<TARGET_OBJECTS:ffmpeg.fftools.ffmpeg.objects>)
target_link_libraries(ffmpeg PRIVATE
    ffmpeg.avutil.shared
    ffmpeg.avcodec.shared
    ffmpeg.avformat.shared
    ffmpeg.avdevice.shared
    ffmpeg.avfilter.shared
    ffmpeg.swresample.shared
    ffmpeg.swscale.shared
    ffmpeg.postproc.shared
)


if(${FFMPEG_LIB_MATH_FOUND})
    foreach(FFMPEG_LIB ${FFMPEG_LIBS})
        target_link_libraries(ffmpeg.${FFMPEG_LIB}.shared PRIVATE ${FFMPEG_LIB_MATH})
    endforeach()

    target_link_libraries(ffmpeg PRIVATE ${FFMPEG_LIB_MATH})

    target_link_libraries(ffmpeg.doc.decode_video PRIVATE ${FFMPEG_LIB_MATH})
endif()



set(LINKER_USE_NO_UNDEFINED TRUE)
if (MSVC)
    set(LINKER_USE_NO_UNDEFINED FALSE)
endif()

if(${LINKER_USE_NO_UNDEFINED})
    foreach(FFMPEG_LIB ${FFMPEG_LIBS})
        target_link_options(ffmpeg.${FFMPEG_LIB}.shared PRIVATE "-Wl,--no-undefined")
        set_property(TARGET ffmpeg.${FFMPEG_LIB}.shared PROPERTY OUTPUT_NAME ${FFMPEG_LIB})
    endforeach()
endif()

foreach(FFMPEG_LIB ${FFMPEG_LIBS})
    set_property(TARGET ffmpeg.${FFMPEG_LIB}.shared PROPERTY OUTPUT_NAME ${FFMPEG_LIB})
endforeach()

foreach(FFMPEG_LIB ${FFMPEG_LIBS})
    set(FFMPEG_${FFMPEG_LIB}_STATIC_ARTEFACT_NAME "${FFMPEG_LIB}")
endforeach()
set(ffmpeg.static.artefact_name "ffmpeg")


set(APPEND_STATIC_TO_ARTEFACT_NAME FALSE)
if(WIN32)
    set(APPEND_STATIC_TO_ARTEFACT_NAME TRUE)
endif()
if(${APPEND_STATIC_TO_ARTEFACT_NAME})
    foreach(FFMPEG_LIB ${FFMPEG_LIBS})
        set(FFMPEG_${FFMPEG_LIB}_STATIC_ARTEFACT_NAME "${FFMPEG_LIB}_static")
    endforeach()
    set(ffmpeg.static.artefact_name "ffmpeg_static")
endif()

foreach(FFMPEG_LIB ${FFMPEG_LIBS})
    set_property(TARGET ffmpeg.${FFMPEG_LIB}.static PROPERTY OUTPUT_NAME ${FFMPEG_${FFMPEG_LIB}_STATIC_ARTEFACT_NAME})
    set_property(TARGET ffmpeg.${FFMPEG_LIB}.static_pic PROPERTY OUTPUT_NAME "${FFMPEG_${FFMPEG_LIB}_STATIC_ARTEFACT_NAME}_pic")
endforeach()

add_library(ffmpeg.static STATIC)
list(APPEND FFMPEG_LEGACY_TARGETS
    ${FFMPEG_AVFILTER_COMPONENTS}
    ${FFMPEG_AVDEVICE_COMPONENTS}

    ffmpeg.swscale.objects
    ffmpeg.swresample.objects
    ffmpeg.postproc.objects
)

set_property(TARGET ffmpeg.static PROPERTY OUTPUT_NAME ${ffmpeg.static.artefact_name})

foreach(FFMPEG_COMPONENT ${FFMPEG_COMPONENTS})
    target_sources(ffmpeg.static PRIVATE $<TARGET_OBJECTS:ffmpeg.${FFMPEG_COMPONENT}.obj>)
endforeach()

foreach(LEGACY_TARGET ${FFMPEG_LEGACY_TARGETS})
    target_sources(ffmpeg.static PRIVATE $<TARGET_OBJECTS:${LEGACY_TARGET}>)
endforeach()

set(FFMPEG_DISABLE_WARNINGS_DEFAULT 1)
ffmpeg_message(WARNING "config" "TODO: MSVC have option for disabling warnings - use it FFMPEG_DISABLE_WARNINGS")
if(WIN32)
    set(FFMPEG_DISABLE_WARNINGS_DEFAULT 0)
endif()
option(FFMPEG_DISABLE_WARNINGS "Disable ffmpeg compilation warnings" ${FFMPEG_DISABLE_WARNINGS_DEFAULT})


if(FFMPEG_DISABLE_WARNINGS)
    foreach(FFMPEG_COMPONENT ${FFMPEG_COMPONENTS})
        target_compile_options(ffmpeg.${FFMPEG_COMPONENT}.PIC_obj PRIVATE "-w")
        target_compile_options(ffmpeg.${FFMPEG_COMPONENT}.obj PRIVATE "-w")
    endforeach()

    foreach(LEGACY_TARGET ${FFMPEG_LEGACY_TARGETS})
        target_compile_options(${LEGACY_TARGET} PRIVATE "-w")
    endforeach()

    target_compile_options(ffmpeg.fftools.ffmpeg.objects PRIVATE "-w")
endif()


foreach(FFMPEG_COMPONENT ${FFMPEG_COMPONENTS})
    target_link_libraries(ffmpeg.${FFMPEG_COMPONENT}.PIC_obj PRIVATE ffmpeg.global_config)
    target_link_libraries(ffmpeg.${FFMPEG_COMPONENT}.obj PRIVATE ffmpeg.global_config)
endforeach()
