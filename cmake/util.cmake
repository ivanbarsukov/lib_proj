################################################################################
# Project:  Lib TIFF
# Purpose:  CMake build scripts
# Author:   Dmitry Baryshnikov, dmitry.baryshnikov@nexgis.com
################################################################################
# Copyright (C) 2015, NextGIS <info@nextgis.com>
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

function(check_version major minor patch)

    # Read version information from configure.ac.
    file(READ "${CMAKE_SOURCE_DIR}/src/proj_api.h" PROJ_API_H_CONTENTS)
    string(REGEX MATCH "PJ_VERSION[ \t]+([0-9]+)"
      PJ_VERSION ${PROJ_API_H_CONTENTS})
    string (REGEX MATCH "([0-9]+)"
      PJ_VERSION ${PJ_VERSION})
    
    string(SUBSTRING ${PJ_VERSION} 0 1 PROJ4_MAJOR_VERSION)
    string(SUBSTRING ${PJ_VERSION} 1 1 PROJ4_MINOR_VERSION)
    string(SUBSTRING ${PJ_VERSION} 2 1 PROJ4_PATCH_VERSION)
    
    
    set(${major} ${PROJ4_MAJOR_VERSION} PARENT_SCOPE)
    set(${minor} ${PROJ4_MINOR_VERSION} PARENT_SCOPE)
    set(${patch} ${PROJ4_PATCH_VERSION} PARENT_SCOPE)

endfunction(check_version)


function(report_version name ver)

    if(NOT WIN32)
      string(ASCII 27 Esc)
      set(BoldYellow  "${Esc}[1;33m")
      set(ColourReset "${Esc}[m")
    endif()    
        
    message(STATUS "${BoldYellow}${name} version ${ver}${ColourReset}")
    
endfunction()  
