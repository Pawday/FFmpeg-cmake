cmake_minimum_required(VERSION 3.10)

project(Examples)

add_executable(decode_video decode_video.c)

target_link_libraries(decode_video PRIVATE avutils)
target_link_libraries(decode_video PRIVATE avcodec)