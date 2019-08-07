#################################################################################
#
# This file is part of CMake configuration for PROJ4 library (inspired from SOCI
# CMake,  Copyright (C) 2009-2010 Mateusz Loskot <mateusz@loskot.net> )
#
# Copyright (C) 2011 Nicolas David <nicolas.david@ign.fr>
# Distributed under the MIT license
#
# Modified by Dmitry Baryshnikov <polimax@mail.ru> for NextGIS Borsch build system
# Copyright (C) 2016,2019 NextGIS, <info@nextgis.com>
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
set(PROJ_C_WARN_FLAGS "${PROJ_C_WARN_FLAGS}"
  CACHE STRING "C flags used to compile PROJ targets")
set(PROJ_CXX_WARN_FLAGS "${PROJ_CXX_WARN_FLAGS}"
  CACHE STRING "C++ flags used to compile PROJ targets")


set(PACKAGE_NAME proj)
include(util)

# Version information
check_version(PROJECT_VERSION_MAJOR PROJECT_VERSION_MINOR PROJECT_VERSION_PATCH)

set(VERSION "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}")
if(OSX_FRAMEWORK)
    set(FRAMEWORK_VERSION "${PROJECT_VERSION_MAJOR}")

    set(INSTALL_MAN_DIR ${INSTALL_LIB_DIR}/${PROJECT_NAME}.framework/Versions/${FRAMEWORK_VERSION}/Resources/man CACHE INTERNAL "Man files directory" FORCE)
endif()

set(PROJ_API_VERSION "1${PROJECT_VERSION_MAJOR}")
set(PROJ_BUILD_VERSION "1${VERSION}")

set(API_VERSION ${PROJ_API_VERSION})
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
# Check for sqlite3
################################################################################
include(FindAnyProject)
find_anyproject(SQLite3 REQUIRED)
if(NOT SQLITE3_FOUND)
  message(SEND_ERROR "sqlite3 dependency not found!")
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
# Check whether the C99 math function: hypot, atanh, etc. are available.
check_c_source_compiles("
#include <math.h>
int main() {
  int q;
  return (int)(
    hypot(3.0, 4.0) + atanh(0.8) + cbrt(8.0) +
    remquo(100.0, 90.0, &q) +
    remainder(100.0, 90.0) + copysign(1.0, -0.0) +
    log1p(0.1) + asinh(0.1)) + isnan(0.0);
}
" C99_MATH)
if(C99_MATH)
  add_definitions(-DHAVE_C99_MATH=1)
else()
  add_definitions(-DHAVE_C99_MATH=0)
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

# boost_report_value(PROJ_PLATFORM_NAME)
# boost_report_value(PROJ_COMPILER_NAME)

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

option(PROJ_TESTS "Enable build of collection of PROJ tests" ON)
# boost_report_value(PROJ_TESTS)
if(PROJ_TESTS)
  enable_testing()
endif()
include(ProjTest)

# Put the libraries and binaries that get built into directories at the
# top of the build tree rather than in hard-to-find leaf
# directories. This simplifies manual testing and the use of the build
# tree rather than installed Boost libraries.
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bin)
link_directories(${CMAKE_LIBRARY_OUTPUT_DIRECTORY})

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
if(PROJ_TESTS)
  add_subdirectory(test)
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
