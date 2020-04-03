set(GEOD_SRC
  apps/geod.cpp
  apps/geod_set.cpp
  apps/geod_interface.cpp
  apps/emess.cpp
)
set(GEOD_INCLUDE apps/geod_interface.h)

source_group("Source Files\\Bin" FILES ${GEOD_SRC} ${GEOD_INCLUDE})

add_executable(geod ${GEOD_SRC} ${GEOD_INCLUDE})
target_link_libraries(geod PRIVATE ${PROJ_LIBRARIES})
target_compile_options(geod PRIVATE ${PROJ_CXX_WARN_FLAGS})

install(TARGETS geod
  RUNTIME DESTINATION ${INSTALL_BIN_DIR})

if(MSVC AND BUILD_SHARED_LIBS)
  target_compile_definitions(geod PRIVATE PROJ_MSVC_DLL_IMPORT=1)
endif()

if(OSX_FRAMEWORK)
    set_target_properties(geod PROPERTIES INSTALL_RPATH "@executable_path/../../Library/Frameworks")
endif()