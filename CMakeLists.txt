cmake_minimum_required(VERSION 2.8)

SET(CMAKE_CONFIG_ROOT ${PROJECT_SOURCE_DIR}/build/configs/)
INCLUDE(${CMAKE_CONFIG_ROOT}/config_$ENV{CMAKE_PLATFORM_NAME}.txt)

#put output to out folder
SET(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/out/$ENV{CMAKE_PLATFORM_NAME}/bin)
SET(LIBRARY_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/out/$ENV{CMAKE_PLATFORM_NAME}/lib)

#set module search path
set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/build/cmakes/)

#add moduels to compile

ADD_SUBDIRECTORY(androidtoolsets) 
#ADD_SUBDIRECTORY(test) 