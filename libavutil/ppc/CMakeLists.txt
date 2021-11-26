list(APPEND AVUTIL_ALL_HEADERS_PPC util_altivec.h) # only swscale_internal.h force require it
list(APPEND AVUTIL_ALL_HEADERS_PPC cpu.h) # only swscale/utilc.c force require it


foreach(AVUTIL_HEADER_PPC ${AVUTIL_ALL_HEADERS_PPC})
    file(COPY ${AVUTIL_HEADER_PPC} DESTINATION ${CMAKE_BINARY_DIR}/include/libavutil/ppc/)
endforeach()