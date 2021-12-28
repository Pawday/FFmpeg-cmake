list(APPEND AVUTIL_ALL_HEADERS_AARCH64 cpu.h) # only swscale/utilc.c force require it


foreach(AVUTIL_HEADER_AARCH64 ${AVUTIL_ALL_HEADERS_AARCH64})
    file(COPY ${AVUTIL_HEADER_AARCH64} DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/include/libavutil/aarch64/)
endforeach()