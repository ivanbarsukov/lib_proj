#################################################################################
#
# This file is part of CMake configuration for PROJ4 library (inspired from SOCI
# CMake,  Copyright (C) 2009-2010 Mateusz Loskot <mateusz@loskot.net> )
#
# Copyright (C) 2011 Nicolas David <nicolas.david@ign.fr>
# Distributed under the MIT license
#
# Modified by Dmitry Baryshnikov <polimax@mail.ru> for NextGIS Borsch build system
# Copyright (C) 2016-2022 NextGIS, <info@nextgis.com>
#
#################################################################################
# General settings
#################################################################################
cmake_minimum_required(VERSION 2.8.12 FATAL_ERROR)

# proj is an ANSI C project
project(proj LANGUAGES C CXX)
set(PROJECT_INTERN_NAME PROJ)

if(NOT DEFINED PACKAGE_VENDOR)
    set(PACKAGE_VENDOR NextGIS)
endif()

if(NOT DEFINED PACKAGE_BUGREPORT)
    set(PACKAGE_BUGREPORT info@nextgis.com)
endif()

cmake_policy(SET CMP0054 NEW)
cmake_policy(SET CMP0063 NEW)

# some init settings
set(CMAKE_COLOR_MAKEFILE ON)
# set path to additional CMake modules
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake ${CMAKE_MODULE_PATH})

if(OSX_FRAMEWORK AND (BUILD_SHARED_LIBS OR BUILD_STATIC_LIBS))
  message(FATAL_ERROR "Only OSX_FRAMEWORK key or any or both BUILD_SHARED_LIBS
                       and BUILD_STATIC_LIBS keys are permitted")
endif()

if(OSX_FRAMEWORK)
    set(INSTALL_BIN_DIR "bin" CACHE INTERNAL "Installation directory for executables" FORCE)
    set(INSTALL_LIB_DIR "Library/Frameworks" CACHE INTERNAL "Installation directory for libraries" FORCE)
    set(INSTALL_INC_DIR "${INSTALL_LIB_DIR}/${PROJECT_NAME}.framework/Headers" CACHE INTERNAL "Installation directory for headers" FORCE)
    set(INSTALL_CMAKECONF_DIR ${INSTALL_LIB_DIR}/${PROJECT_NAME}.framework/Resources/CMake CACHE INTERNAL "Installation directory for cmake config files" FORCE)
    set(SKIP_INSTALL_HEADERS ON)
    set(SKIP_INSTALL_EXECUTABLES ON)
    set(SKIP_INSTALL_FILES ON)
    set(SKIP_INSTALL_EXPORT ON)
    set(CMAKE_MACOSX_RPATH ON)
else()
    include(GNUInstallDirs)

    set(INSTALL_BIN_DIR ${CMAKE_INSTALL_BINDIR} CACHE INTERNAL "Installation directory for executables" FORCE)
    set(INSTALL_LIB_DIR ${CMAKE_INSTALL_LIBDIR} CACHE INTERNAL "Installation directory for libraries" FORCE)
    set(INSTALL_INC_DIR ${CMAKE_INSTALL_INCLUDEDIR} CACHE INTERNAL "Installation directory for headers" FORCE)
    set(INSTALL_SHARE_DIR ${CMAKE_INSTALL_DATADIR} CACHE INTERNAL "Shared files directory" FORCE)
    set(INSTALL_DATA_DIR "${INSTALL_SHARE_DIR}/proj" CACHE INTERNAL "Shared files directory" FORCE)
    set(INSTALL_MAN_DIR ${CMAKE_INSTALL_MANDIR} CACHE INTERNAL "Man files directory" FORCE)
    set(INSTALL_PKGCONFIG_DIR "${INSTALL_LIB_DIR}/pkgconfig" CACHE INTERNAL "Installation directory for pkgconfig (.pc) files" FORCE)
    set(INSTALL_CMAKECONF_DIR ${CMAKE_INSTALL_DATADIR}/${PROJECT_NAME}/CMake CACHE INTERNAL "Installation directory for cmake config files" FORCE)
endif()

# Set C++ version
# Make CMAKE_CXX_STANDARD available as cache option overridable by user
set(CMAKE_CXX_STANDARD 11
  CACHE STRING "C++ standard version to use (default is 11)")
message(STATUS "Requiring C++${CMAKE_CXX_STANDARD}")
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
message(STATUS "Requiring C++${CMAKE_CXX_STANDARD} - done")

# Set C99 version
# Make CMAKE_C_STANDARD available as cache option overridable by user
set(CMAKE_C_STANDARD 99
  CACHE STRING "C standard version to use (default is 99)")
message(STATUS "Requiring C${CMAKE_C_STANDARD}")
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)
message(STATUS "Requiring C${CMAKE_C_STANDARD} - done")

# Set global -fvisibility=hidden
set(CMAKE_C_VISIBILITY_PRESET hidden)
set(CMAKE_CXX_VISIBILITY_PRESET hidden)

# Set warnings as variables, then store as cache options
set(PROJ_common_WARN_FLAGS  # common only to GNU/Clang C/C++
  -Wall
  -Wextra
  -Wswitch
  -Wshadow
  -Wunused-parameter
  -Wmissing-declarations
  -Wformat
  -Wformat-security
)
if("${CMAKE_C_COMPILER_ID}" STREQUAL "GNU")
  set(PROJ_C_WARN_FLAGS ${PROJ_common_WARN_FLAGS}
    -Wmissing-prototypes
  )
  set(PROJ_CXX_WARN_FLAGS ${PROJ_common_WARN_FLAGS})
elseif("${CMAKE_C_COMPILER_ID}" MATCHES "Clang")
  set(PROJ_C_WARN_FLAGS ${PROJ_common_WARN_FLAGS}
    -Wmissing-prototypes
    -Wfloat-conversion
    -Wc99-extensions
    -Wc11-extensions
  )
  set(PROJ_CXX_WARN_FLAGS ${PROJ_common_WARN_FLAGS}
    -Wfloat-conversion
  )
elseif("${CMAKE_C_COMPILER_ID}" STREQUAL "MSVC")
  add_definitions(/D_CRT_SECURE_NO_WARNINGS) # Eliminate deprecation warnings
  set(PROJ_C_WARN_FLAGS
    /W4
    /wd4706  # Suppress warning about assignment within conditional expression
    /wd4996  # Suppress warning about sprintf, etc., being unsafe
  )
  set(PROJ_CXX_WARN_FLAGS /EHsc ${PROJ_C_WARN_FLAGS})
elseif("${CMAKE_C_COMPILER_ID}" STREQUAL "Intel")
  if(MSVC)
    set(PROJ_C_WARN_FLAGS /Wall)
    set(PROJ_CXX_WARN_FLAGS /Wall)
  else()
    set(PROJ_C_WARN_FLAGS -Wall)
    set(PROJ_CXX_WARN_FLAGS -Wall)
  endif()
endif()

if (CMAKE_CXX_COMPILER_ID STREQUAL "IntelLLVM")
  # Intel CXX compiler based on clang defaults to -ffast-math, which
  # breaks std::isinf(), std::isnan(), etc.
  set(CMAKE_C_FLAGS ${CMAKE_C_FLAGS} -fno-fast-math)
  set(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} -fno-fast-math)
endif ()

set(PROJ_C_WARN_FLAGS "${PROJ_C_WARN_FLAGS}"
  CACHE STRING "C flags used to compile PROJ targets")
set(PROJ_CXX_WARN_FLAGS "${PROJ_CXX_WARN_FLAGS}"
  CACHE STRING "C++ flags used to compile PROJ targets")


set(PACKAGE_NAME ${PROJECT_NAME})
include(util)

# Version information
check_version(PROJECT_VERSION_MAJOR PROJECT_VERSION_MINOR PROJECT_VERSION_PATCH)

set(VERSION "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}")
if(OSX_FRAMEWORK)
    set(FRAMEWORK_VERSION "${PROJECT_VERSION_MAJOR}")

    set(INSTALL_MAN_DIR ${INSTALL_LIB_DIR}/${PROJECT_NAME}.framework/Versions/${FRAMEWORK_VERSION}/Resources/man CACHE INTERNAL "Man files directory" FORCE)
endif()

set(PROJ_SOVERSION 25)
set(PROJ_BUILD_VERSION "${PROJ_SOVERSION}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}")

report_version(${PROJECT_NAME} "${VERSION}")

################################################################################
# Build features and variants
################################################################################
# include(ProjSystemInfo)
include(ProjConfig)
# include(ProjMac)
include(policies)

configure_file(${CMAKE_SOURCE_DIR}/cmake/cmake_uninstall.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake IMMEDIATE @ONLY)

################################################################################
# Check for nlohmann_json
################################################################################

set(NLOHMANN_JSON_ORIGIN "auto" CACHE STRING
"nlohmann/json origin. The default auto will try to use external \
nlohmann/json if possible")
set_property(CACHE NLOHMANN_JSON_ORIGIN PROPERTY STRINGS auto internal external)

# Probably not the strictest minimum, but known to work with it
set(MIN_NLOHMANN_JSON_VERSION 3.7.0)

if(NLOHMANN_JSON_ORIGIN STREQUAL "external")
  find_package(nlohmann_json REQUIRED)
  set(NLOHMANN_JSON "external")
elseif(NLOHMANN_JSON_ORIGIN STREQUAL "internal")
  set(NLOHMANN_JSON "internal")
else()
  find_package(nlohmann_json QUIET)
  if(nlohmann_json_FOUND)
    set(NLOHMANN_JSON "external")
  else()
    set(NLOHMANN_JSON "internal")
  endif()
endif()

if(NLOHMANN_JSON STREQUAL "external")
  # Check minimum version
  if(nlohmann_json_VERSION VERSION_LESS MIN_NLOHMANN_JSON_VERSION)
    message(STATUS "external nlohmann/json version ${nlohmann_json_VERSION} "
      "is older than minimum requirement ${MIN_NLOHMANN_JSON_VERSION}")
    set(NLOHMANN_JSON "internal")
  else()
    message(STATUS "found nlohmann/json version ${nlohmann_json_VERSION}")
  endif()
endif()

message(STATUS "nlohmann/json: ${NLOHMANN_JSON}")

################################################################################
# Check for sqlite3
################################################################################
include(FindAnyProject)
find_anyproject(SQLite3 REQUIRED)
if(NOT SQLITE3_FOUND)
  message(SEND_ERROR "sqlite3 dependency not found!")
endif()

################################################################################
# Check for libtiff
################################################################################

option(ENABLE_TIFF "Enable TIFF support to read some grids" ON)
mark_as_advanced(ENABLE_TIFF)
set(TIFF_ENABLED FALSE)
if(ENABLE_TIFF)
  find_anyproject(TIFF REQUIRED)
  if(TIFF_FOUND)
    set(TIFF_ENABLED TRUE)
  else()
    message(SEND_ERROR
      "libtiff dependency not found! Use ENABLE_TIFF=OFF to force it off")
  endif()
else()
  message(WARNING
    "TIFF support is not enabled and will result in the inability to read "
    "some grids")
endif()


################################################################################
# Check for curl
################################################################################

option(ENABLE_CURL "Enable Curl support" ON)
set(CURL_ENABLED FALSE)
if(ENABLE_CURL)
  find_anyproject(CURL REQUIRED)
  if(CURL_FOUND)
    set(CURL_ENABLED TRUE)
  else()
    message(SEND_ERROR "curl dependency not found!")
  endif()
endif()
################################################################################

option(PROJ_LIB_ENV_VAR_TRIED_LAST "Whether the PROJ_LIB environment variable should be tried after the hardcoded location" OFF)
if(PROJ_LIB_ENV_VAR_TRIED_LAST)
    add_definitions(-DPROJ_LIB_ENV_VAR_TRIED_LAST)
endif()

################################################################################
# threading configuration
################################################################################
set(CMAKE_THREAD_PREFER_PTHREAD TRUE)
find_package(Threads)

include(CheckIncludeFiles)

include(CheckCSourceCompiles)
if(MSVC)
  set(CMAKE_REQUIRED_FLAGS "${CMAKE_C_FLAGS} /WX /W4")
else()
  set(CMAKE_REQUIRED_LIBRARIES m)
  set(CMAKE_REQUIRED_FLAGS "${CMAKE_C_FLAGS} -Werror -Wall")
endif()

if(Threads_FOUND AND CMAKE_USE_PTHREADS_INIT)
  set(CMAKE_REQUIRED_LIBRARIES
    "${CMAKE_REQUIRED_LIBRARIES} ${CMAKE_THREAD_LIBS_INIT}")
  check_c_source_compiles("
#include <pthread.h>

int main(int argc, char* argv[]) {
  (void)PTHREAD_MUTEX_RECURSIVE;
  (void)argv;
  return argc;
}
  " HAVE_PTHREAD_MUTEX_RECURSIVE_DEFN)
  if(HAVE_PTHREAD_MUTEX_RECURSIVE_DEFN)
    add_definitions(-DHAVE_PTHREAD_MUTEX_RECURSIVE=1)
  endif()
endif()

# Set a default build type for single-configuration cmake generators if
# no build type is set.
if(NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

if(MSVC OR CMAKE_CONFIGURATION_TYPES)
  # For multi-config systems and for Visual Studio, the debug version of
  # the library has _d appended.
  set(CMAKE_DEBUG_POSTFIX _d)
endif()

# Put the libraries and binaries that get built into directories at the
# top of the build tree rather than in hard-to-find leaf
# directories. This simplifies manual testing and the use of the build
# tree rather than installed PROJ libraries.
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bin)
link_directories(${CMAKE_LIBRARY_OUTPUT_DIRECTORY})

# configure_file(${CMAKE_SOURCE_DIR}/cmake/proj.pc.cmakein  ${CMAKE_BINARY_DIR}/proj.pc IMMEDIATE @ONLY)
################################################################################
# Tests
################################################################################
include(CTest)

if(BUILD_TESTING)
    include(ProjTest)
else()
    message(STATUS "Testing disabled")
endif()

string(TOUPPER ${PACKAGE_NAME} PACKAGE_UPPER_NAME)
################################################################################
# Build configured components
################################################################################
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src)

# message(STATUS "")
add_subdirectory(data)
# add_subdirectory(include)
add_subdirectory(src)
add_subdirectory(man)
# add_subdirectory(cmake)
if(BUILD_TESTING)
  add_subdirectory(test)
endif()

################################################################################
# pkg-config support
################################################################################
if(UNIX OR MINGW)
    include(ProjUtilities)
    configure_proj_pc()
endif()

add_custom_target(uninstall COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake)

# Export package ===============================================================

if(REGISTER_PACKAGE)
    # Export the package for use from the build-tree
    # (this registers the build-tree with a global CMake-registry)
    export(PACKAGE ${PACKAGE_UPPER_NAME})
endif()

# Archiving ====================================================================

set(CPACK_PACKAGE_NAME "${PACKAGE_NAME}")
set(CPACK_PACKAGE_VENDOR "${PACKAGE_VENDOR}")
set(CPACK_PACKAGE_VERSION "${VERSION}")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "${PACKAGE_NAME} Installation")
set(CPACK_PACKAGE_RELOCATABLE TRUE)
set(CPACK_ARCHIVE_COMPONENT_INSTALL ON)
set(CPACK_GENERATOR "ZIP")
set(CPACK_MONOLITHIC_INSTALL ON)
set(CPACK_STRIP_FILES TRUE)

# Get cpack zip archive name
get_cpack_filename(${VERSION} PROJECT_CPACK_FILENAME)
set(CPACK_PACKAGE_FILE_NAME ${PROJECT_CPACK_FILENAME})

include(CPack)
