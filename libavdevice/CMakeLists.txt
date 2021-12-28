cmake_minimum_required(VERSION 3.15)

project(AVDEVICE)

list(APPEND AVDEVICE_ALL_HEADERS avdevice.h)
list(APPEND AVDEVICE_ALL_HEADERS version.h)

foreach(AVDEVICE_HEADER ${AVDEVICE_ALL_HEADERS})
    file(COPY ${AVDEVICE_HEADER} DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/include/libavdevice)
endforeach()

list(APPEND AVDEVICE_SOURCES avdevice.c)
list(APPEND AVDEVICE_SOURCES utils.c)
list(APPEND AVDEVICE_SOURCES alldevices.c)

#generating indev_list.c

#list(APPEND AVDEVICE_REGISTERED_INPUT_DEVICES_IDS device)

set(INPUT_DEVICE_C_FILE_CONTENT)
string(APPEND INPUT_DEVICE_C_FILE_CONTENT "static const AVInputFormat * const indev_list[] = {\n")

foreach(INPUT_DEVICE_NAME ${AVDEVICE_REGISTERED_INPUT_DEVICES_IDS})
    string(APPEND INPUT_DEVICE_C_FILE_CONTENT "&${INPUT_DEVICE_NAME},\n")
endforeach()

string(APPEND INPUT_DEVICE_C_FILE_CONTENT "NULL\n")
string(APPEND INPUT_DEVICE_C_FILE_CONTENT "}\;")

file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/generated/libavdevice/indev_list.c ${INPUT_DEVICE_C_FILE_CONTENT})

#generating outdev_list.c

#list(APPEND AVDEVICE_REGISTERED_OUTPUT_DEVICES_IDS device)

set(OUTPUT_DEVICE_C_FILE_CONTENT)
string(APPEND OUTPUT_DEVICE_C_FILE_CONTENT "static const AVOutputFormat * const outdev_list[] = {\n")

foreach(OUTPUT_DEVICE_NAME ${AVDEVICE_REGISTERED_OUTPUT_DEVICES_IDS})
    string(APPEND OUTPUT_DEVICE_C_FILE_CONTENT "&${OUTPUT_DEVICE_NAME},\n")
endforeach()

string(APPEND OUTPUT_DEVICE_C_FILE_CONTENT "NULL\n")
string(APPEND OUTPUT_DEVICE_C_FILE_CONTENT "}\;")

file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/generated/libavdevice/outdev_list.c ${OUTPUT_DEVICE_C_FILE_CONTENT})

add_library(avdevice OBJECT ${AVDEVICE_SOURCES})
target_include_directories(avdevice PUBLIC ${CMAKE_CURRENT_BINARY_DIR}/include/)

target_link_libraries(avdevice PRIVATE ffmpeg_config)
target_link_libraries(avdevice PRIVATE avutil)
target_link_libraries(avdevice PRIVATE avcodec)
target_link_libraries(avdevice PRIVATE avformat)

target_include_directories(avdevice PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/generated/)

add_library(avdevice_static STATIC $<TARGET_OBJECTS:avdevice>)
