project(FFMPEG_COMPAT)


list(APPEND FFMPEG_COMPAT_ALL_HEADERS va_copy.h)
list(APPEND FFMPEG_COMPAT_ALL_HEADERS w32pthreads.h)

add_library(ffmpeg_compat INTERFACE)

add_subdirectory(atomics)

foreach(FFMPEG_COMPAT_HEADER ${FFMPEG_COMPAT_ALL_HEADERS})
    file(COPY ${FFMPEG_COMPAT_HEADER} DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/include/compat)
endforeach()

target_include_directories(ffmpeg_compat INTERFACE ${CMAKE_CURRENT_BINARY_DIR}/include)