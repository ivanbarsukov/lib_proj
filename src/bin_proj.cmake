set(PROJ_SRC
  apps/proj.cpp
  apps/emess.cpp
  apps/utils.cpp
)

source_group("Source Files\\Bin" FILES ${PROJ_SRC})

add_executable(binproj ${PROJ_SRC})
set_target_properties(binproj
  PROPERTIES
  OUTPUT_NAME proj)
target_link_libraries(binproj PRIVATE ${PROJ_LIBRARIES})
target_compile_options(binproj PRIVATE ${PROJ_CXX_WARN_FLAGS})

install(TARGETS binproj
  RUNTIME DESTINATION ${INSTALL_BIN_DIR})

# if(MSVC AND BUILD_SHARED_LIBS)
#   target_compile_definitions(binproj PRIVATE PROJ_MSVC_DLL_IMPORT=1)
# endif()

if(UNIX)

    set(link_target "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/invproj${CMAKE_EXECUTABLE_SUFFIX}")
    set(link_source "proj${CMAKE_EXECUTABLE_SUFFIX}")

    add_custom_command(
      OUTPUT ${link_target}
      COMMAND ${CMAKE_COMMAND} -E create_symlink ${link_source} ${link_target}
      WORKING_DIRECTORY "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}"
      DEPENDS binproj
      COMMENT "Generating invproj"
      VERBATIM
    )

    add_custom_target(invproj ALL DEPENDS ${link_target})

    install(FILES ${link_target} RUNTIME DESTINATION ${INSTALL_BIN_DIR})

else()

    add_executable(invproj ${PROJ_SRC})
    target_link_libraries(invproj PRIVATE ${PROJ_LIBRARIES})
    target_compile_options(invproj PRIVATE ${PROJ_CXX_WARN_FLAGS})

    install(TARGETS invproj
        RUNTIME DESTINATION ${INSTALL_BIN_DIR})

endif()

if(OSX_FRAMEWORK)
    set_target_properties(binproj PROPERTIES INSTALL_RPATH "@executable_path/../../Library/Frameworks")
endif()