cmake_minimum_required(VERSION 3.15)
project(avcodec)

add_library(avcodec_external_libraries INTERFACE) #["zlib (pngcodec)"]

list(APPEND AVCODEC_ALL_HEADERS version.h)
list(APPEND AVCODEC_ALL_HEADERS version_major.h)

list(APPEND AVCODEC_ALL_HEADERS avcodec.h)
list(APPEND AVCODEC_ALL_HEADERS codec.h)
list(APPEND AVCODEC_ALL_HEADERS codec_desc.h)
list(APPEND AVCODEC_ALL_HEADERS codec_par.h)
list(APPEND AVCODEC_ALL_HEADERS codec_id.h)
list(APPEND AVCODEC_ALL_HEADERS defs.h)
list(APPEND AVCODEC_ALL_HEADERS packet.h)
list(APPEND AVCODEC_ALL_HEADERS bsf.h)
list(APPEND AVCODEC_ALL_HEADERS bytestream.h)
list(APPEND AVCODEC_ALL_HEADERS internal.h)
list(APPEND AVCODEC_ALL_HEADERS packet_internal.h)
list(APPEND AVCODEC_ALL_HEADERS raw.h)
list(APPEND AVCODEC_ALL_HEADERS mathops.h)
list(APPEND AVCODEC_ALL_HEADERS xiph.h)
list(APPEND AVCODEC_ALL_HEADERS png.h) #its need for libavformat/id3v2.c
list(APPEND AVCODEC_ALL_HEADERS pngdsp.h) #its need for png.h
list(APPEND AVCODEC_ALL_HEADERS mpeg4audio.h)
list(APPEND AVCODEC_ALL_HEADERS get_bits.h)
list(APPEND AVCODEC_ALL_HEADERS put_bits.h)
list(APPEND AVCODEC_ALL_HEADERS vlc.h)
list(APPEND AVCODEC_ALL_HEADERS golomb.h)
list(APPEND AVCODEC_ALL_HEADERS to_upper4.h)
list(APPEND AVCODEC_ALL_HEADERS gif.h)
list(APPEND AVCODEC_ALL_HEADERS mjpeg.h)
list(APPEND AVCODEC_ALL_HEADERS xwd.h)
#list(APPEND AVCODEC_ALL_HEADERS zlib_wrapper.h)

foreach(AVCODEC_HEADER ${AVCODEC_ALL_HEADERS})
    file(COPY ${AVCODEC_HEADER} DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/include/libavcodec)
endforeach()

list(APPEND AVCODEC_SOURCES avcodec.c)
list(APPEND AVCODEC_SOURCES avpacket.c)
list(APPEND AVCODEC_SOURCES allcodecs.c)
list(APPEND AVCODEC_SOURCES parser.c)
list(APPEND AVCODEC_SOURCES options.c)
list(APPEND AVCODEC_SOURCES decode.c)
list(APPEND AVCODEC_SOURCES utils.c)
list(APPEND AVCODEC_SOURCES codec_desc.c)
list(APPEND AVCODEC_SOURCES encode.c)
list(APPEND AVCODEC_SOURCES bsf.c)
list(APPEND AVCODEC_SOURCES parsers.c)
list(APPEND AVCODEC_SOURCES codec_par.c)
list(APPEND AVCODEC_SOURCES profiles.c)
list(APPEND AVCODEC_SOURCES bitstream_filters.c)
list(APPEND AVCODEC_SOURCES golomb.c)
list(APPEND AVCODEC_SOURCES bitstream.c)
list(APPEND AVCODEC_SOURCES atsc_a53.c)
list(APPEND AVCODEC_SOURCES mathtables.c)
list(APPEND AVCODEC_SOURCES videodsp.c)
list(APPEND AVCODEC_SOURCES cabac.c)
list(APPEND AVCODEC_SOURCES startcode.c)
list(APPEND AVCODEC_SOURCES raw.c)
list(APPEND AVCODEC_SOURCES xiph.c)
list(APPEND AVCODEC_SOURCES golomb.c)
list(APPEND AVCODEC_SOURCES vlc.c)
#list(APPEND AVCODEC_SOURCES zlib_wrapper.c)



#register avcodecs
set(AVCODEC_REGISTERED_CODECS_SOURCES "")
set(AVCODEC_REGISTERED_CODECS_IDS "")

#register h264
include(h264.cmake)

#register bmp
include(bmp.cmake)

#register png
#TODO[cmake]: resolve zlib dependencies for png codec
#include(png.cmake)

set(CODEC_LIST_C_FILE_CONTENT)
string(APPEND CODEC_LIST_C_FILE_CONTENT "static const FFCodec * const codec_list[] = {\n")

foreach(AVCODEC_NAME ${AVCODEC_REGISTERED_CODECS_IDS})
    string(APPEND CODEC_LIST_C_FILE_CONTENT "&${AVCODEC_NAME},\n")
endforeach()

string(APPEND CODEC_LIST_C_FILE_CONTENT "NULL\n")
string(APPEND CODEC_LIST_C_FILE_CONTENT "}\;")

file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/generated/libavcodec/codec_list.c ${CODEC_LIST_C_FILE_CONTENT})

#creating parser_list.c

list(APPEND AVCODEC_REGISTERED_PARSERS_IDS ff_h264_parser)
list(APPEND AVCODEC_REGISTERED_PARSERS_IDS ff_bmp_parser)
#list(APPEND AVCODEC_REGISTERED_PARSERS_IDS ff_png_parser)

set(PARSER_LIST_C_FILE_CONTENT)
string(APPEND PARSER_LIST_C_FILE_CONTENT "static const AVCodecParser * const parser_list[] = {\n")

foreach(AVPARSER_NAME ${AVCODEC_REGISTERED_PARSERS_IDS})
    string(APPEND PARSER_LIST_C_FILE_CONTENT "&${AVPARSER_NAME},\n")
endforeach()

string(APPEND PARSER_LIST_C_FILE_CONTENT "NULL\n")
string(APPEND PARSER_LIST_C_FILE_CONTENT "}\;")

file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/generated/libavcodec/parser_list.c ${PARSER_LIST_C_FILE_CONTENT})

#BSF_LIST
#list(APPEND AVCODEC_REGISTERED_BIT_STREAM_FILTERS )
set(BIT_STREAM_FILTERS_LIST_C_FILE_CONTENT)

string(APPEND BIT_STREAM_FILTERS_LIST_C_FILE_CONTENT " static const AVBitStreamFilter * const bitstream_filters[] = {\n")

foreach(BIT_STREAM_FILTER ${AVCODEC_REGISTERED_BIT_STREAM_FILTERS})
    string(APPEND BIT_STREAM_FILTERS_LIST_C_FILE_CONTENT "&${BIT_STREAM_FILTER},\n")
endforeach()

string(APPEND BIT_STREAM_FILTERS_LIST_C_FILE_CONTENT "NULL\n")
string(APPEND BIT_STREAM_FILTERS_LIST_C_FILE_CONTENT "}\;")

file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/generated/libavcodec/bsf_list.c ${BIT_STREAM_FILTERS_LIST_C_FILE_CONTENT})



#!!!!!!!!!! EVIL FUNCTION REPLACEMENT HACK FOR NONOPTIMISED COMPILERS

if (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")

    set(AVCODEC_GENERATED_EMPTY_FUNCTIONS_FILE_CONTENT "")

    string(APPEND AVCODEC_GENERATED_EMPTY_FUNCTIONS_FILE_CONTENT "//THIS FILE IS PART OF EVIL HACK FOR UNOPTIMISED COMPILERS WHEN THAT FUNCTIONS ARE NOT BUILDING BECAUSE CONFIGS\n")

    #TODO[cmake]: make it config depended

    #if not CONFIG_FRAME_THREAD_ENCODER,HAVE_THREADS,
    list(APPEND AVCODEC_EMPTY_FUNCTIONS "int ff_frame_thread_encoder_init(void* avctx){return 234\;}")
    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_frame_thread_encoder_free(void* avctx){};")
    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_thread_flush(void* avctx){};")
    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_thread_free(void* s){}")
    list(APPEND AVCODEC_EMPTY_FUNCTIONS "int ff_thread_decode_frame(void* avctx, void* picture, int* got_picture_ptr, void* avpkt){return 0\;}")
    list(APPEND AVCODEC_EMPTY_FUNCTIONS "int ff_thread_video_encode_frame(void* avctx, void* pkt, void* frame, int* got_packet_ptr){return 0\;}")

    #if not ARCH_AARCH64 ARCH_ARM ARCH_PPC ARCH_X86 ARCH_MIPS ARCH_ALPHA
    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_videodsp_init_aarch64(void* ctx, int bpc){}")
    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_videodsp_init_arm(void* ctx, int bpc){}")
    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_videodsp_init_ppc(void* ctx, int bpc){}")
    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_videodsp_init_x86(void* ctx, int bpc){}")
    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_videodsp_init_mips(void* ctx, int bpc){}")
    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_videodsp_init_loongarch(void* ctx, int bpc){}")

    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_h264dsp_init_aarch64(void* c, const int bit_depth,const int chroma_format_idc){}")
    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_h264dsp_init_arm(void* c, const int bit_depth,const int chroma_format_idc){}")
    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_h264dsp_init_ppc(void* c, const int bit_depth,const int chroma_format_idc){}")
    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_h264dsp_init_x86(void* c, const int bit_depth,const int chroma_format_idc){}")
    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_h264dsp_init_mips(void* c, const int bit_depth,const int chroma_format_idc){}")
    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_h264dsp_init_loongarch(void* c, const int bit_depth, const int chroma_format_idc){}")

    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_h264chroma_init_aarch64(void* c, int bit_depth){}")
    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_h264chroma_init_arm(void* c, int bit_depth){}")
    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_h264chroma_init_ppc(void* c, int bit_depth){}")
    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_h264chroma_init_x86(void* c, int bit_depth){}")
    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_h264chroma_init_mips(void* c, int bit_depth){}")
    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_h264chroma_init_loongarch(void* c, int bit_depth){}")

    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_h264qpel_init_aarch64(void* c, int bit_depth){}")
    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_h264qpel_init_arm(void* c, int bit_depth){}")
    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_h264qpel_init_ppc(void* c, int bit_depth){}")
    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_h264qpel_init_x86(void* c, int bit_depth){}")
    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_h264qpel_init_mips(void* c, int bit_depth){}")
    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_h264qpel_init_loongarch(void* c, int bit_depth){}")

    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_h264_pred_init_aarch64(void* h, int codec_id,const int bit_depth,const int chroma_format_idc){}")
    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_h264_pred_init_arm(void* h, int codec_id,const int bit_depth, const int chroma_format_idc){}")
    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_h264_pred_init_x86(void* h, int codec_id,const int bit_depth, const int chroma_format_idc){}")
    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_h264_pred_init_mips(void* h, int codec_id,const int bit_depth, const int chroma_format_idc){}")
    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_h264_pred_init_loongarch(void* h, int codec_id, const int bit_depth, const int chroma_format_idc){}")

    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_me_cmp_init_alpha(void* c, void* avctx){}")
    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_me_cmp_init_arm(void* c, void* avctx){}")
    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_me_cmp_init_ppc(void* c, void* avctx){}")
    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_me_cmp_init_x86(void* c, void* avctx){}")
    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_me_cmp_init_mips(void* c, void* avctx){}")

    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_llvidencdsp_init_x86(void* c){}")

    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_pngdsp_init_x86(void* dsp);{}")


    #if not CONFIG_MPEGVIDEO
    list(APPEND AVCODEC_EMPTY_FUNCTIONS "void ff_print_debug_info2(void* avctx, void* pict, void* mbskip_table, int* mbtype_table, int* qscale_table, int (*motion_val[2])[2], int* low_delay, int mb_width, int mb_height, int mb_stride, int quarter_sample){}")


    foreach(CONTENT ${AVCODEC_EMPTY_FUNCTIONS})
        string(APPEND AVCODEC_GENERATED_EMPTY_FUNCTIONS_FILE_CONTENT "${CONTENT}\n")
    endforeach()

    file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/hack/empty_functions.c "${AVCODEC_GENERATED_EMPTY_FUNCTIONS_FILE_CONTENT}")

endif()





add_library(avcodec OBJECT ${AVCODEC_SOURCES} ${AVCODEC_REGISTERED_CODECS_SOURCES})
target_include_directories(avcodec PUBLIC ${CMAKE_CURRENT_BINARY_DIR}/include/)
target_include_directories(avcodec PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/generated/)

target_link_libraries(avcodec PRIVATE avcodec_external_libraries)

if(MSVC)
    message(WARNING "AVCODEC: adding empty_functions.c hack for unoptimised MSVC")
    target_sources(avcodec PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/hack/empty_functions.c)
endif()


#TODO[cmake]: avcodec.c attribute_align_arg
#only avcodec_open2 function in avcodec.c require this deco, it is located in libavutils/internal.h but avcodec.c does not include it
#ffmpeg is madness inside OMG
target_compile_definitions(avcodec PRIVATE attribute_align_arg=)

target_link_libraries(avcodec PRIVATE ffmpeg_config)
target_link_libraries(avcodec PUBLIC avutil_static)

add_library(avcodec_static STATIC $<TARGET_OBJECTS:avcodec>)

