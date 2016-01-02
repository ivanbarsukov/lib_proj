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

#
#install
#
set(ALL_DATA_FILE ${PROJ_DICTIONARY} ${GRIDSHIFT_FILES})
install(FILES ${ALL_DATA_FILE}
       DESTINATION ${INSTALL_DATA_DIR})

