set(AndroidToolsets_INCLUDE_DIR 
    ${PROJECT_SOURCE_DIR}/androidtoolsets/include/
)

IF (AndroidToolsets_INCLUDE_DIR)
    SET(AndroidToolsets_FOUND TRUE)
ENDIF (AndroidToolsets_INCLUDE_DIR)

IF (AndroidToolsets_FOUND)
    IF (NOT AndroidToolsets_FIND_QUIETLY)
        MESSAGE(STATUS "Found AndroidToolsets: ${AndroidToolsets_INCLUDE_DIR}") 
    ENDIF (NOT AndroidToolsets_FIND_QUIETLY)
ELSE (AndroidToolsets_FOUND)
    IF (AndroidToolsets_FIND_REQUIRED)
        MESSAGE(FATAL_ERROR "Could not find AndroidToolsets")
    ENDIF (AndroidToolsets_FIND_REQUIRED)
ENDIF (AndroidToolsets_FOUND)
