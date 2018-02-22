################################################################################
# Project:  proj4
# Purpose:  CMake build scripts
# Author:   Dmitry Baryshnikov, dmitry.baryshnikov@nextgis.com
################################################################################
# Copyright (C) 2018, NextGIS <info@nextgis.com>
# Copyright (C) 2018 Dmitry Baryshnikov
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.
################################################################################

if(BUILD_TESTING)
    if(UNIX) # Disable test on Windows
        set(GEODTEST_SRC ${PROJECT_SOURCE_DIR}/src/geodtest.c)
        set(GEODTEST_INCLUDE)

        #Executable
        add_executable(geodtest ${GEODTEST_SRC} ${GEODTEST_INCLUDE})
        target_link_libraries(geodtest ${LIB_NAME})

        # Instead run as a test
        add_test(NAME geodesic-test COMMAND geodtest)
    endif()

    # Find python
    find_package(PythonInterp)
    if(PYTHONINTERP_FOUND)
        add_test(NAME proj-test
            COMMAND ${PYTHON_EXECUTABLE} ${PROJECT_SOURCE_DIR}/test/gigs/test_json.py -e $<TARGET_FILE:cs2cs> -d cs2cs -t ${CMAKE_CURRENT_SOURCE_DIR}/gigs/*.json)
    endif()
endif()
