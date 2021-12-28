list(APPEND AVUTIL_ALL_HEADERS_X86 cpu.h) # only swscale/utilc.c force require it
list(APPEND AVUTIL_ALL_HEADERS_X86 asm.h) # only swscale/utilc.c force require it


foreach(AVUTIL_HEADER_X86 ${AVUTIL_ALL_HEADERS_X86})
    file(COPY ${AVUTIL_HEADER_X86} DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/include/libavutil/x86/)
endforeach()