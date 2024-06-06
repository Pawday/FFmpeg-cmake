add_library(ffmpeg.avformat.config INTERFACE)
add_library(ffmpeg.avformat.headers INTERFACE)
add_library(ffmpeg.avformat.core.objects OBJECT)


list(APPEND FFMPEG_AVFORMAT_COMPONENTS ffmpeg.avformat.core.objects)

list(APPEND ffmpeg.avformat.core.sources
    allformats.c
    url.c
    version.c
    utils.c
    mux.c
    avio.c
    aviobuf.c
    options.c
    format.c
    id3v1.c
    protocols.c
    metadata.c
    sdp.c
    seek.c
    rawdec.c
    demux.c
    to_upper4.c
    rawenc.c
    mux_utils.c
    demux_utils.c
    avio.c
)


list(APPEND ffmpeg.avformat.core.sources_prepended
    avformat.c "#include \"libavutil/internal.h\""
    dump.c "#include \"libavutil/internal.h\""
    id3v2.c "#include \"libavutil/internal.h\""
)


list(APPEND ffmpeg.avformat.header_names
    aiff.h
    apetag.h
    argo_asf.h
    asf.h
    asfcrypt.h
    ast.h
    av1.h
    avc.h
    avformat.h
    avi.h
    avio.h
    avio_internal.h
    avlanguage.h
    caf.h
    dash.h
    demux.h
    dovi_isom.h
    dv.h
    dvdclut.h
    evc.h
    ffmeta.h
    flac_picture.h
    flacenc.h
    flv.h
    gxf.h
    hevc.h
    hls_sample_encryption.h
    hlsplaylist.h
    http.h
    httpauth.h
    iamf.h
    iamf_parse.h
    iamf_reader.h
    iamf_writer.h
    id3v1.h
    id3v2.h
    imf.h
    img2.h
    internal.h
    ip.h
    ircam.h
    isom.h
    lrc.h
    matroska.h
    metadata.h
    mms.h
    mov_chan.h
    movenc.h
    movenc_ttml.h
    movenccenc.h
    mpeg.h
    mpegts.h
    mux.h
    mxf.h
    network.h
    nut.h
    oggdec.h
    oma.h
    options_table.h
    os_support.h
    pcm.h
    qtpalette.h
    rawdec.h
    rawenc.h
    rawutils.h
    rdt.h
    replaygain.h
    riff.h
    rm.h
    rmsipr.h
    rso.h
    rtmp.h
    rtmpcrypt.h
    rtmpdh.h
    rtmppkt.h
    rtp.h
    rtpdec.h
    rtpdec_formats.h
    rtpenc.h
    rtpenc_chain.h
    rtpproto.h
    rtsp.h
    rtspcodes.h
    sauce.h
    smjpeg.h
    sox.h
    spdif.h
    srtp.h
    subtitles.h
    swf.h
    tee_common.h
    tls.h
    ttmlenc.h
    url.h
    urldecode.h
    version.h
    version_major.h
    voc.h
    vorbiscomment.h
    vpcc.h
    vvc.h
    w64.h
    wtv.h
    wv.h
    yuv4mpeg.h
)


include(file_proto.cmake)
include(h264raw_format.cmake)
include(img2_format.cmake)


set(FFMPEG_AVFORMAT_GENERATED_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/generated")
set(AVFORMAT_GENERATED_INCLUDE_DIRECTORY "${FFMPEG_AVFORMAT_GENERATED_DIRECTORY}/include")
set(PREPEND_HACK_DIR "${FFMPEG_AVFORMAT_GENERATED_DIRECTORY}/prepend_hack")
file(REMOVE_RECURSE ${PREPEND_HACK_DIR})


gen_prepend_hack(ffmpeg.avformat.core.sources_prepended PREPEND_HACK_DIR "avformat" ffmpeg.avformat.core.sources)


list(APPEND ffmpeg.avformat.muxer_list)
list(APPEND ffmpeg.avformat.demuxer_list)
list(APPEND ffmpeg.avformat.protocol_list)



gen_headers(ffmpeg.avformat.header_names CMAKE_CURRENT_SOURCE_DIR "${AVFORMAT_GENERATED_INCLUDE_DIRECTORY}/libavformat")




#generating muxer_list.c
string(APPEND ffmpeg.avformat.muxer_list_content "const FFOutputFormat * const muxer_list[] = {\n")
foreach(MUXER_NAME ${ffmpeg.avformat.muxer_list})
    string(APPEND ffmpeg.avformat.muxer_list_content "&${MUXER_NAME}\,\n")
endforeach()
string(APPEND ffmpeg.avformat.muxer_list_content "NULL\n")
string(APPEND ffmpeg.avformat.muxer_list_content "}\;\n")
file(GENERATE OUTPUT "${AVFORMAT_GENERATED_INCLUDE_DIRECTORY}/libavformat/muxer_list.c" CONTENT ${ffmpeg.avformat.muxer_list_content})


#generating demuxer_list.c
string(APPEND ffmpeg.avformat.demuxer_list_content "const FFInputFormat * const demuxer_list[] = {\n")
foreach(DEMUXER_NAME ${ffmpeg.avformat.demuxer_list})
    string(APPEND ffmpeg.avformat.demuxer_list_content "&${DEMUXER_NAME}\,\n")
endforeach()
string(APPEND ffmpeg.avformat.demuxer_list_content "NULL\n")
string(APPEND ffmpeg.avformat.demuxer_list_content "}\;\n")
file(GENERATE OUTPUT "${AVFORMAT_GENERATED_INCLUDE_DIRECTORY}/libavformat/demuxer_list.c" CONTENT ${ffmpeg.avformat.demuxer_list_content})


#generating protocol_list.c
string(APPEND ffmpeg.avformat.protocol_list_content "const URLProtocol * const url_protocols[] = {\n")
foreach(PROTO_NAME ${ffmpeg.avformat.protocol_list})
    string(APPEND ffmpeg.avformat.protocol_list_content "&${PROTO_NAME}\,\n")
endforeach()
string(APPEND ffmpeg.avformat.protocol_list_content "NULL\n")
string(APPEND ffmpeg.avformat.protocol_list_content "}\;\n")
file(GENERATE OUTPUT "${AVFORMAT_GENERATED_INCLUDE_DIRECTORY}/libavformat/protocol_list.c" CONTENT ${ffmpeg.avformat.protocol_list_content})

target_include_directories(ffmpeg.avformat.headers INTERFACE
    ${AVFORMAT_GENERATED_INCLUDE_DIRECTORY}
)


target_sources(ffmpeg.avformat.core.objects PRIVATE ${ffmpeg.avformat.core.sources})

foreach(FFMPEG_AVFORMAT_COMPONENT ${FFMPEG_AVFORMAT_COMPONENTS})
    set_property(TARGET ${FFMPEG_AVFORMAT_COMPONENT} PROPERTY POSITION_INDEPENDENT_CODE TRUE)
    target_link_libraries(${FFMPEG_AVFORMAT_COMPONENT} PRIVATE
        ffmpeg.avformat.config
        ffmpeg.avformat.headers
        ffmpeg.avutil.config
        ffmpeg.avutil.headers
        ffmpeg.avcodec.config
        ffmpeg.avcodec.headers
    )
endforeach()

set(FFMPEG_AVFORMAT_COMPONENTS ${FFMPEG_AVFORMAT_COMPONENTS} PARENT_SCOPE)


foreach(FFMPEG_AVFORMAT_COMPONENT ${FFMPEG_AVFORMAT_COMPONENTS})
    message(STATUS "[avformat] Built component ${FFMPEG_AVFORMAT_COMPONENT}")
endforeach()
