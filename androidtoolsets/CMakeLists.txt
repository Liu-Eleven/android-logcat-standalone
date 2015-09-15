FIND_PACKAGE(AndroidToolsets REQUIRED)
INCLUDE_DIRECTORIES(${AndroidToolsets_INCLUDE_DIR})

#liblog
SET(LIB_Log_SRC
    ${CMAKE_CURRENT_SOURCE_DIR}/liblog/logd_write.c
    ${CMAKE_CURRENT_SOURCE_DIR}/liblog/logprint.c
    ${CMAKE_CURRENT_SOURCE_DIR}/liblog/event_tag_map.c
    ${CMAKE_CURRENT_SOURCE_DIR}/liblog/log_time.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/liblog/log_read.c
)

#libsysutils
SET(LIB_Sysutils_SRC
    ${CMAKE_CURRENT_SOURCE_DIR}/libsysutils/src/SocketListener.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/libsysutils/src/SocketClient.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/libsysutils/src/FrameworkCommand.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/libsysutils/src/FrameworkListener.cpp
)

#libcutils
SET(LIB_Cutils_SRC
    ${CMAKE_CURRENT_SOURCE_DIR}/libcutils/socket_local_server.c
    ${CMAKE_CURRENT_SOURCE_DIR}/libcutils/socket_loopback_client.c
    ${CMAKE_CURRENT_SOURCE_DIR}/libcutils/atomic.c
)

#libutils
SET(LIB_Utils_SRC
    ${CMAKE_CURRENT_SOURCE_DIR}/libutils/String8.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/libutils/String16.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/libutils/SharedBuffer.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/libutils/Unicode.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/libutils/Static.cpp
)

ADD_LIBRARY(AndroidToolsets STATIC 
    ${LIB_Log_SRC}
    ${LIB_Sysutils_SRC}
    ${LIB_Cutils_SRC}
    ${LIB_Utils_SRC}
)


SET(EXE_Logcat_SRC
    ${CMAKE_CURRENT_SOURCE_DIR}/logcat/logcat.cpp
)
ADD_EXECUTABLE(logcat ${EXE_Logcat_SRC})
ADD_DEPENDENCIES(logcat AndroidToolsets)
TARGET_LINK_LIBRARIES(logcat AndroidToolsets ${CMAKE_SYSTEM_LINKLIBS})



INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR}/logd/)

SET(EXE_Logd_SRC
    ${CMAKE_CURRENT_SOURCE_DIR}/logd/main.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/logd/LogCommand.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/logd/CommandListener.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/logd/LogListener.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/logd/LogReader.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/logd/FlushCommand.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/logd/LogBuffer.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/logd/LogBufferElement.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/logd/LogTimes.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/logd/LogStatistics.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/logd/LogWhiteBlackList.cpp
    #${CMAKE_CURRENT_SOURCE_DIR}/logd/libaudit.c
    #${CMAKE_CURRENT_SOURCE_DIR}/logd/LogAudit.cpp
)
ADD_EXECUTABLE(logd ${EXE_Logd_SRC})
ADD_DEPENDENCIES(logd AndroidToolsets)
TARGET_LINK_LIBRARIES(logd AndroidToolsets ${CMAKE_SYSTEM_LINKLIBS})


    
    
    
    
    
    
    
    
    
    
    
    
    
