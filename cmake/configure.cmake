###############################################################################
#
# CMake configuration file
#
# Author: Mateusz Loskot <mateusz@loskot.net>
# Author: Dmitry Baryshnikov <polimax@mail.ru>
#
###############################################################################

include (CheckSymbolExists)
include (CheckIncludeFiles)
include (CheckLibraryExists)
include (CheckFunctionExists)

if(CMAKE_GENERATOR_TOOLSET MATCHES "v([0-9]+)_xp")
    add_definitions(-D_WIN32_WINNT=0x0501)
endif()

set(CMAKE_THREAD_PREFER_PTHREAD TRUE)
find_package (Threads)

check_symbol_exists(PTHREAD_MUTEX_RECURSIVE pthread.h HAVE_PTHREAD_MUTEX_RECURSIVE_DEFN)
if (HAVE_PTHREAD_MUTEX_RECURSIVE_DEFN)
    add_definitions(-DHAVE_PTHREAD_MUTEX_RECURSIVE=1)
endif()

# check needed include file
check_include_files (dlfcn.h HAVE_DLFCN_H)
check_include_files (inttypes.h HAVE_INTTYPES_H)
check_include_files (jni.h HAVE_JNI_H)
check_include_files (memory.h HAVE_MEMORY_H)
check_include_files (stdint.h HAVE_STDINT_H)
check_include_files (stdlib.h HAVE_STDLIB_H)
check_include_files (string.h HAVE_STRING_H)
check_include_files (sys/stat.h HAVE_SYS_STAT_H)
check_include_files (sys/types.h HAVE_SYS_TYPES_H)
check_include_files (unistd.h HAVE_UNISTD_H)
check_include_files ("stdlib.h;stdarg.h;string.h;float.h" STDC_HEADERS)

check_function_exists(localeconv HAVE_LOCALECONV)

# check libm need on unix
check_library_exists(m ceil "" HAVE_LIBM)

set(PACKAGE "proj")
set(PACKAGE_BUGREPORT "warmerdam@pobox.com")
# set(PACKAGE_NAME "PROJ.4 Projections")
set(PACKAGE_STRING "${PACKAGE_NAME} ${VERSION}")
set(PACKAGE_TARNAME "${PACKAGE}")
set(PACKAGE_VERSION "${VERSION}")

configure_file(${CMAKE_SOURCE_DIR}/cmake/proj_config.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/src/proj_config.h IMMEDIATE @ONLY)
add_definitions(-DHAVE_CONFIG_H)

if(NOT OSX_FRAMEWORK)
    configure_file(${CMAKE_SOURCE_DIR}/cmake/proj.pc.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/proj.pc @ONLY)
    install(FILES ${CMAKE_CURRENT_BINARY_DIR}/proj.pc DESTINATION "${INSTALL_PKGCONFIG_DIR}")
endif()
