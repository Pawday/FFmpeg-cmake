#   At commit ea7ee4b4e381e0fa731458de0cbf740430eeb013
#   Diego Biurrun does include libavutil/ppc/util_altivec.h file into swscale_internal.h
#   without #ifdef HAVE_ALTIVEC ... #endif
#   now you have include platform specific file
#   THANK YOU Diego
list(APPEND AVUTIL_ALL_HEADERS_PPC util_altivec.h) # only swscale_internal.h force require it


list(APPEND AVUTIL_ALL_HEADERS_PPC cpu.h) # only swscale/utilc.c force require it


foreach(AVUTIL_HEADER_PPC ${AVUTIL_ALL_HEADERS_PPC})
    file(COPY ${AVUTIL_HEADER_PPC} DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/include/libavutil/ppc/)
endforeach()