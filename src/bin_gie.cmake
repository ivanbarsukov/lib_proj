set(GIE_SRC
  apps/gie.cpp
  apps/proj_strtod.cpp
  apps/proj_strtod.h
)
set(GIE_INCLUDE apps/optargpm.h)

source_group("Source Files\\Bin" FILES ${GIE_SRC})

add_executable(gie ${GIE_SRC} ${GIE_INCLUDE})
target_link_libraries(gie PRIVATE ${PROJ_LIBRARIES})
target_compile_options(gie PRIVATE ${PROJ_CXX_WARN_FLAGS})

install(TARGETS gie
  RUNTIME DESTINATION ${INSTALL_BIN_DIR})

if(MSVC AND BUILD_SHARED_LIBS)
  target_compile_definitions(gie PRIVATE PROJ_MSVC_DLL_IMPORT=1)
endif()

if(OSX_FRAMEWORK)
    set_target_properties(gie PROPERTIES INSTALL_RPATH "@executable_path/../../Library/Frameworks")
endif()