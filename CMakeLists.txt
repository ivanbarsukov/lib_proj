cmake_minimum_required (VERSION 2.8)
project (proj4)
set(the_target proj4)
set(PROJ_VERSION "4.8.0")

set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "Configs" FORCE)
set(CMAKE_COLOR_MAKEFILE ON)

include_directories(${CMAKE_CURRENT_SOURCE_DIR})
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src)
include_directories(${CMAKE_CURRENT_BINARY_DIR})

set(PROJ_HHEADERS
    ${CMAKE_CURRENT_SOURCE_DIR}/src/emess.h
    ${CMAKE_CURRENT_SOURCE_DIR}/src/geocent.h
    ${CMAKE_CURRENT_SOURCE_DIR}/src/geodesic.h
    #${CMAKE_CURRENT_SOURCE_DIR}/src/nad_list.h
    #${CMAKE_CURRENT_SOURCE_DIR}/src/org_proj4_PJ.h
    ${CMAKE_CURRENT_SOURCE_DIR}/src/org_proj4_Projections.h
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_list.h
    ${CMAKE_CURRENT_SOURCE_DIR}/src/projects.h
    ${CMAKE_CURRENT_SOURCE_DIR}/src/proj_api.h
)

set(PROJ_CSOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/src/proj.def
    ${CMAKE_CURRENT_SOURCE_DIR}/src/aasincos.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/adjlon.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/bch2bps.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/bchgen.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/biveval.c  
#    ${CMAKE_CURRENT_SOURCE_DIR}/src/cs2cs.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/dmstor.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/emess.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/gen_cheb.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/geocent.c  
#    ${CMAKE_CURRENT_SOURCE_DIR}/src/geod.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/geod_for.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/geod_inv.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/geod_set.c 
#    ${CMAKE_CURRENT_SOURCE_DIR}/src/hypot.c  
#    ${CMAKE_CURRENT_SOURCE_DIR}/src/jniproj.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/mk_cheby.c 
#    ${CMAKE_CURRENT_SOURCE_DIR}/src/multistresstest.c  
#    ${CMAKE_CURRENT_SOURCE_DIR}/src/nad2bin.c  
#    ${CMAKE_CURRENT_SOURCE_DIR}/src/nad2nad.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/nad_cvt.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/nad_init.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/nad_intr.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_aea.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_aeqd.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_airy.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_aitoff.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_apply_gridshift.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_apply_vgridshift.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_august.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_auth.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_bacon.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_bipc.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_boggs.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_bonne.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_cass.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_cc.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_cea.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_chamb.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_collg.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_crast.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_ctx.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_datums.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_datum_set.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_denoy.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_deriv.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_eck1.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_eck2.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_eck3.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_eck4.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_eck5.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_ellps.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_ell_set.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_eqc.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_eqdc.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_errno.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_factors.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_fahey.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_fouc_s.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_fwd.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_gall.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_gauss.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_geocent.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_geos.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_gins8.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_gnom.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_gn_sinu.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_goode.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_gridinfo.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_gridlist.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_gstmerc.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_hammer.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_hatano.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_healpix.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_igh.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_imw_p.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_init.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_initcache.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_inv.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_isea.c     
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_krovak.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_labrd.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_laea.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_lagrng.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_larr.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_lask.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_latlong.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_lcc.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_lcca.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_list.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_log.c
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_loxim.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_lsat.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_malloc.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_mbtfpp.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_mbtfpq.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_mbt_fps.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_merc.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_mill.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_mlfn.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_mod_ster.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_moll.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_msfn.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_mutex.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_natearth.c
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_nell.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_nell_h.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_nocol.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_nsper.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_nzmg.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_ob_tran.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_ocea.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_oea.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_omerc.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_open_lib.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_ortho.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_param.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_phi2.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_poly.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_pr_list.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_putp2.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_putp3.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_putp4p.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_putp5.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_putp6.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_qsfn.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_release.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_robin.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_rpoly.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_sconics.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_somerc.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_stere.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_sterea.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_strerrno.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_sts.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_tcc.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_tcea.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_tmerc.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_tpeqd.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_transform.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_tsfn.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_units.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_urm5.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_urmfps.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_utils.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_vandg.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_vandg2.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_vandg4.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_wag2.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_wag3.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_wag7.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_wink1.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/PJ_wink2.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pj_zpoly1.c  
#    ${CMAKE_CURRENT_SOURCE_DIR}/src/proj.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/proj_etmerc.c  
    ${CMAKE_CURRENT_SOURCE_DIR}/src/proj_mdist.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/proj_rouss.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/p_series.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/rtodms.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/vector1.c 
)

add_library(${the_target} SHARED ${PROJ_HHEADERS} ${PROJ_CSOURCES})
add_library(${the_target}static STATIC ${PROJ_HHEADERS} ${PROJ_CSOURCES})

# For windows, do not allow the compiler to use default target (Vista).
if(WIN32)
  add_definitions(-D_USRDLL)
  set(LIB_DEBUG_POSTFIX d)
endif()

add_definitions(-DSTRICT)

if(MSVC)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /W3")
    add_definitions(-D_CRT_SECURE_NO_DEPRECATE -D_CRT_NONSTDC_NO_DEPRECATE)
endif()

if(UNIX)
     if(CMAKE_COMPILER_IS_GNUCXX OR CV_ICC)
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")
     endif()
endif()

if(UNIX)
    # On unix-like platforms the library is almost always called libproj
   set_target_properties(${the_target} ${the_target}static PROPERTIES OUTPUT_NAME proj)
elseif(BUILD_SHARED_LIBS AND WIN32)
    # Creates proj4.dll when building shared library version
    set_target_properties(${the_target} PROPERTIES OUTPUT_NAME proj4)
    # Creates proj4_inc.lib when building static library version
    set_target_properties(${the_target}static PROPERTIES OUTPUT_NAME proj4_inc)
endif()

set_target_properties(${the_target} PROPERTIES VERSION ${VERSION})
set_target_properties(${the_target} PROPERTIES SOVERSION 1)

install(TARGETS ${the_target} ${the_target}static 
    RUNTIME DESTINATION bin
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
)

