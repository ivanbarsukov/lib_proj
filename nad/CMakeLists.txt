################################################################################
# Project:  Lib Proj
# Purpose:  CMake build scripts
# Author:   Dmitry Baryshnikov, dmitry.baryshnikov@nexgis.com
################################################################################
# Copyright (C) 2016, NextGIS <info@nextgis.com>
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
#
# files containing dictionnary of useful projection
#

set(PROJ_DICTIONARY  epsg
                     esri
                     world
                     esri.extra
                     other.extra
                     IGNF
                     nad27
                     GL27
                     nad83
                     nad.lst
                     proj_def.dat
                     CH )

#
# gridshift file
#

file(GLOB GSB_FILES  *.gsb)
set(GRIDSHIFT_FILES ${GSB_FILES})

if(OSX_FRAMEWORK)
    set(installdest ${INSTALL_LIB_DIR}/${PROJECT_NAME}.framework/Versions/${FRAMEWORK_VERSION}/Resources/proj)
else()
    set(installdest ${INSTALL_DATA_DIR})
endif()

#
#install
#
set(ALL_DATA_FILE ${PROJ_DICTIONARY} ${GRIDSHIFT_FILES})
install(FILES ${ALL_DATA_FILE}
       DESTINATION ${installdest})
