###############################################################################
#
# CMake configuration file
#
# Author: Mateusz Loskot <mateusz@loskot.net>
# Author: Dmitry Baryshnikov <polimax@mail.ru>
#
###############################################################################

option(USE_THREAD "Build libproj with thread/mutex support " ON)
if(NOT USE_THREAD)
   add_definitions( -DMUTEX_stub)
endif(NOT USE_THREAD)
find_package(Threads QUIET)
if(USE_THREAD AND Threads_FOUND AND CMAKE_USE_WIN32_THREADS_INIT )
   add_definitions( -DMUTEX_win32)
endif(USE_THREAD AND Threads_FOUND AND CMAKE_USE_WIN32_THREADS_INIT )
if(USE_THREAD AND Threads_FOUND AND CMAKE_USE_PTHREADS_INIT )
   add_definitions( -DMUTEX_pthread)
endif(USE_THREAD AND Threads_FOUND AND CMAKE_USE_PTHREADS_INIT )
if(USE_THREAD AND NOT Threads_FOUND)
  message(FATAL_ERROR "No thread library found and thread/mutex support is required by USE_THREAD option")
endif(USE_THREAD AND NOT Threads_FOUND)

include_directories (${CMAKE_CURRENT_BINARY_DIR})
include_directories (${CMAKE_CURRENT_SOURCE_DIR} )
include_directories (${CMAKE_CURRENT_BINARY_DIR}/src)
include_directories (${CMAKE_CURRENT_SOURCE_DIR}/src)

set(SRC_LIBPROJ_PJ
        nad_init.c
        PJ_aea.c
        PJ_aeqd.c
        PJ_airy.c
        PJ_aitoff.c
        PJ_august.c
        PJ_bacon.c
        PJ_bipc.c
        PJ_boggs.c
        PJ_bonne.c
        PJ_calcofi.c
        PJ_cass.c
        PJ_cc.c
        PJ_cea.c
        PJ_chamb.c
        PJ_collg.c
        PJ_crast.c
        PJ_denoy.c
        PJ_eck1.c
        PJ_eck2.c
        PJ_eck3.c
        PJ_eck4.c
        PJ_eck5.c
        PJ_eqc.c
        PJ_eqdc.c
        PJ_fahey.c
        PJ_fouc_s.c
        PJ_gall.c
        PJ_geos.c
        PJ_gins8.c
        PJ_gnom.c
        PJ_gn_sinu.c
        PJ_goode.c
        PJ_gstmerc.c
        PJ_hammer.c
        PJ_hatano.c
        PJ_igh.c
        PJ_isea.c
        PJ_imw_p.c
        PJ_krovak.c
        PJ_labrd.c
        PJ_laea.c
        PJ_lagrng.c
        PJ_larr.c
        PJ_lask.c
        PJ_lcca.c
        PJ_lcc.c
        PJ_loxim.c
        PJ_lsat.c
        PJ_mbt_fps.c
        PJ_mbtfpp.c
        PJ_mbtfpq.c
        PJ_merc.c
        PJ_mill.c
        PJ_mod_ster.c
        PJ_moll.c
        PJ_natearth.c
        PJ_nell.c
        PJ_nell_h.c
        PJ_nocol.c
        PJ_nsper.c
        PJ_nzmg.c
        PJ_ob_tran.c
        PJ_ocea.c
        PJ_oea.c
        PJ_omerc.c
        PJ_ortho.c
        PJ_poly.c
        PJ_putp2.c
        PJ_putp3.c
        PJ_putp4p.c
        PJ_putp5.c
        PJ_putp6.c
        PJ_qsc.c
        PJ_robin.c
        PJ_rpoly.c
        PJ_sconics.c
        PJ_somerc.c
        PJ_sterea.c
        PJ_stere.c
        PJ_sts.c
        PJ_tcc.c
        PJ_tcea.c
        PJ_tmerc.c
        PJ_tpeqd.c
        PJ_urm5.c
        PJ_urmfps.c
        PJ_vandg.c
        PJ_vandg2.c
        PJ_vandg4.c
        PJ_wag2.c
        PJ_wag3.c
        PJ_wag7.c
        PJ_wink1.c
        PJ_wink2.c
        proj_etmerc.c
)

SET(SRC_LIBPROJ_CORE
        aasincos.c
        adjlon.c
        bch2bps.c
        bchgen.c
        biveval.c
        dmstor.c
        emess.c
        emess.h
        geocent.c
        geocent.h
        geodesic.c
        mk_cheby.c
        nad_cvt.c
        nad_init.c
        nad_intr.c
        pj_apply_gridshift.c
        pj_apply_vgridshift.c
        pj_auth.c
        pj_ctx.c
        pj_fileapi.c
        pj_datum_set.c
        pj_datums.c
        pj_deriv.c
        pj_ell_set.c
        pj_ellps.c
        pj_errno.c
        pj_factors.c
        pj_fwd.c
        pj_gauss.c
        pj_gc_reader.c
        pj_geocent.c
        pj_gridcatalog.c
        pj_gridinfo.c
        pj_gridlist.c
        PJ_healpix.c
        pj_init.c
        pj_initcache.c
        pj_inv.c
        pj_latlong.c
        pj_list.c
        pj_list.h
        pj_log.c
        pj_malloc.c
        pj_mlfn.c
        pj_msfn.c
        pj_mutex.c
        pj_open_lib.c
        pj_param.c
        pj_phi2.c
        pj_pr_list.c
        pj_qsfn.c
        pj_release.c
        pj_strerrno.c
        pj_transform.c
        pj_tsfn.c
        pj_units.c
        pj_utils.c
        pj_zpoly1.c
        proj_mdist.c
        proj_rouss.c
        rtodms.c
        vector1.c
        pj_strtod.c
        ${CMAKE_CURRENT_BINARY_DIR}/proj_config.h
 )

set(HEADERS_LIBPROJ
        projects.h
        proj_api.h
        geodesic.h
)

# Group source files for IDE source explorers (e.g. Visual Studio)
source_group("Header Files" FILES ${HEADERS_LIBPROJ})
source_group("Source Files\\Core" FILES ${SRC_LIBPROJ_CORE})
source_group("Source Files\\PJ" FILES ${SRC_LIBPROJ_PJ})
source_group("CMake Files" FILES CMakeLists.txt)


# Embed PROJ_LIB data files location
add_definitions(-DPROJ_LIB="${INSTALL_DATA_DIR}")

#################################################
## java wrapping with jni
#################################################
option(JNI_SUPPORT "Build support of java/jni wrapping for proj library" OFF)
find_package(JNI QUIET)
if(JNI_SUPPORT AND NOT JNI_FOUND)
  message(FATAL_ERROR "jni support is required but jni is not found")
endif(JNI_SUPPORT AND NOT JNI_FOUND)
if(JNI_SUPPORT)
  set(SRC_LIBPROJ_CORE ${SRC_LIBPROJ_CORE}
                       jniproj.c )
  set(HEADERS_LIBPROJ ${HEADERS_LIBPROJ}
                        org_proj4_PJ.h
                        org_proj4_Projections.h)
  source_group("Source Files\\JNI" FILES ${SRC_LIBPROJ_JNI})
  add_definitions(-DJNI_ENABLED)
  include_directories( ${JNI_INCLUDE_DIRS})
endif(JNI_SUPPORT)

#################################################
## targets: libproj and proj_config.h
#################################################
set(ALL_LIBPROJ_SOURCES ${SRC_LIBPROJ_PJ} ${SRC_LIBPROJ_CORE})
set(ALL_LIBPROJ_HEADERS ${HEADERS_LIBPROJ} )

if(BUILD_SHARED_LIBS)
    set(LIB_NAME proj)
    if(WIN32)
        set(ALL_LIBPROJ_SOURCES ${ALL_LIBPROJ_SOURCES} proj.def )
    endif()
    
    add_library(${LIB_NAME} SHARED ${ALL_LIBPROJ_SOURCES} ${ALL_LIBPROJ_HEADERS} ${PROJ_RESOURCES})
else()    
    set(LIB_NAME projstatic)
    add_library(${LIB_NAME} STATIC ${ALL_LIBPROJ_SOURCES} ${ALL_LIBPROJ_HEADERS} ${PROJ_RESOURCES})
endif()   

if(WIN32)
  set_target_properties(${LIB_NAME}
    PROPERTIES
    VERSION "${VERSION}"
    CLEAN_DIRECT_OUTPUT 1)
else()
  set_target_properties(${LIB_NAME}
    PROPERTIES
    VERSION "${VERSION}"
    SOVERSION "${API_VERSION}"
    CLEAN_DIRECT_OUTPUT 1)
endif()

set_target_properties(${LIB_NAME}
    PROPERTIES
    LINKER_LANGUAGE C)

##############################################
# install
##############################################
export(TARGETS ${LIB_NAME} FILE ../${LIB_NAME}-exports.cmake)     

if(NOT SKIP_INSTALL_LIBRARIES AND NOT SKIP_INSTALL_ALL )
    install(TARGETS ${LIB_NAME} 
        EXPORT targets
        RUNTIME DESTINATION "${INSTALL_BIN_DIR}"
        ARCHIVE DESTINATION "${INSTALL_LIB_DIR}"
        LIBRARY DESTINATION "${INSTALL_LIB_DIR}" )
endif()
        

if(NOT SKIP_INSTALL_HEADERS AND NOT SKIP_INSTALL_ALL )
  install(FILES ${ALL_LIBPROJ_HEADERS} DESTINATION ${INSTALL_INC_DIR})
endif()
