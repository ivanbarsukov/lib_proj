# first include proj library
# always need
include(lib_proj.cmake)

# configure executable build
option(BUILD_CCT
  "Build cct (coordinate conversion and transformation tool)" ON)
option(BUILD_CS2CS
  "Build cs2cs (coordinate systems to coordinate systems translation tool)" ON)
option(BUILD_GEOD
  "Build geod (computation of geodesic lines)" ON)
option(BUILD_GIE
  "Build gie (geospatial integrity investigation environment)" ON)
option(BUILD_PROJ
  "Build proj (cartographic projection tool)" ON)
option(BUILD_PROJINFO
  "Build projinfo (SRS and coordinate operation metadata/query tool)" ON)

if(MSVC)

    # Linking to setargv.obj enables wildcard globbing for the
    # command line utilities, when compiling with MSVC
    # https://docs.microsoft.com/cpp/c-language/expanding-wildcard-arguments
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} setargv.obj")

endif()

if(BUILD_CCT)
  include(bin_cct.cmake)
  set(BIN_TARGETS ${BIN_TARGETS} cct)
endif()

if(BUILD_CS2CS)
  include(bin_cs2cs.cmake)
  set(BIN_TARGETS ${BIN_TARGETS} cs2cs)
endif()

if(BUILD_GEOD)
  include(bin_geod.cmake)
  include(bin_geodtest.cmake)
  set(BIN_TARGETS ${BIN_TARGETS} geod)
endif()

if(BUILD_PROJ)
  include(bin_proj.cmake)
  set(BIN_TARGETS ${BIN_TARGETS} binproj)
endif()

if(BUILD_PROJINFO)
  include(bin_projinfo.cmake)
  set(BIN_TARGETS ${BIN_TARGETS} binprojinfo)
endif()

if(BUILD_GIE)
  include(bin_gie.cmake)
  set(BIN_TARGETS ${BIN_TARGETS} gie)
endif()

if(MSVC OR CMAKE_CONFIGURATION_TYPES)
  if(BIN_TARGETS)
    # Add _d suffix for your debug versions of the tools
    set_target_properties(${BIN_TARGETS} PROPERTIES
      DEBUG_POSTFIX ${CMAKE_DEBUG_POSTFIX})
  endif()
endif()
