FIND_PACKAGE(AndroidToolsets REQUIRED)
INCLUDE_DIRECTORIES(${AndroidToolsets_INCLUDE_DIR})

SET(EXE_Log_SRC
    ${CMAKE_CURRENT_SOURCE_DIR}/log.c
)
ADD_EXECUTABLE(log ${EXE_Log_SRC})
ADD_DEPENDENCIES(log AndroidToolsets)
TARGET_LINK_LIBRARIES(log AndroidToolsets ${CMAKE_SYSTEM_LINKLIBS})


    
    
    
    
    
    
    
    
    
    
    
    
    
