#
# files containing dictionary of useful projection
#
set(CONFIG_FILES
  proj.ini
)

set(PROJ_DICTIONARY
  world
  other.extra
  nad27
  GL27
  nad83
  nad.lst
  CH
  ITRF2000
  ITRF2008
  ITRF2014
)

#
# gridshift file
#

file(GLOB GSB_FILES  *.gsb)
file(GLOB GTX_FILES  *.gtx)
set(GRIDSHIFT_FILES ${GSB_FILES} ${GTX_FILES})

option(GENERATE_PROJ_DB "Build proj.db file" OFF)

if(GENERATE_PROJ_DB)

    find_exthost_program(EXE_SQLITE3 sqlite3)
    if(NOT EXE_SQLITE3)
        message(FATAL_ERROR "sqlite3 binary not found!")
    endif()

    set(ALL_SQL_IN "${CMAKE_CURRENT_BINARY_DIR}/all.sql.in")
    set(PROJ_DB "${CMAKE_CURRENT_BINARY_DIR}/proj.db")
    include(sql_filelist.cmake)

    add_custom_command(
    OUTPUT ${ALL_SQL_IN}
    COMMAND ${CMAKE_COMMAND} "-DALL_SQL_IN=${ALL_SQL_IN}"
        -P "${CMAKE_CURRENT_SOURCE_DIR}/generate_all_sql_in.cmake"
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
    DEPENDS ${SQL_FILES}
    COMMENT "Generating all.sql.in"
    VERBATIM
    )

    add_custom_target(generate_all_sql_in ALL DEPENDS ${ALL_SQL_IN})

    add_custom_command(
    OUTPUT ${PROJ_DB}
    COMMAND ${CMAKE_COMMAND} -E remove -f ${PROJ_DB}
    COMMAND ${EXE_SQLITE3} -init ${ALL_SQL_IN} ${PROJ_DB} .quit
    # note: we didn't port yet the foreign_key_check done in Makefile.am
    DEPENDS generate_all_sql_in ${ALL_SQL_IN}
    COMMENT "Generating proj.db"
    VERBATIM
    )

    add_custom_target(generate_proj_db ALL DEPENDS ${PROJ_DB})

else()
    if(NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/proj.db)
        message(FATAL_ERROR "proj.db not found")
    endif()

    set(PROJ_DB ${CMAKE_CURRENT_SOURCE_DIR}/proj.db)
endif()

if(NOT "${CMAKE_CURRENT_SOURCE_DIR}" STREQUAL "${CMAKE_CURRENT_BINARY_DIR}")
  foreach(FILE ${PROJ_DICTIONARY} ${GRIDSHIFT_FILES})
    configure_file(${FILE} ${FILE} COPYONLY)
  endforeach()
endif()

#
#install
#
set(ALL_DATA_FILE
  ${CONFIG_FILES}
  ${PROJ_DICTIONARY}
  ${GRIDSHIFT_FILES}
  ${PROJ_DB}
)

if(OSX_FRAMEWORK)
    set(installdest ${INSTALL_LIB_DIR}/${PROJECT_NAME}.framework/Versions/${FRAMEWORK_VERSION}/Resources/proj/)
else()
    set(installdest ${INSTALL_DATA_DIR})
endif()

install(FILES ${ALL_DATA_FILE}
       DESTINATION ${installdest})
