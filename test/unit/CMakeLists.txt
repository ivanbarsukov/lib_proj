find_anyproject(GTest REQUIRED)

#
# Build PROJ unit tests
#

if(MSVC AND BUILD_SHARED_LIBS)
  add_definitions(-DPROJ_MSVC_DLL_IMPORT=1)
endif()

include_directories(${CMAKE_SOURCE_DIR}/include)
include_directories(${SQLITE3_INCLUDE_DIR})
# Add the directory containing proj_config.h
include_directories(${CMAKE_BINARY_DIR}/src)

# Apply to targets in the current directory and below
add_compile_options(${PROJ_CXX_WARN_FLAGS})

set(PROJ_TEST_ENVIRONMENT
  "PROJ_SKIP_READ_USER_WRITABLE_DIRECTORY=YES"
  "PROJ_LIB=${PROJECT_BINARY_DIR}/data/for_tests"
  "PROJ_SOURCE_DATA=${PROJECT_SOURCE_DIR}/data"
)

add_executable(proj_errno_string_test
  main.cpp
  proj_errno_string_test.cpp)
target_link_libraries(proj_errno_string_test
    PRIVATE ${GTEST_LIBRARIES}
#  gtest
    PRIVATE ${PROJ_LIBRARIES})
add_test(NAME proj_errno_string_test COMMAND proj_errno_string_test)
set_property(TEST proj_errno_string_test 
    PROPERTY ENVIRONMENT ${PROJ_TEST_ENVIRONMENT})

add_executable(proj_angular_io_test
  main.cpp
  proj_angular_io_test.cpp)
target_link_libraries(proj_angular_io_test
    PRIVATE ${GTEST_LIBRARIES}
#  gtest
    PRIVATE ${PROJ_LIBRARIES})
add_test(NAME proj_angular_io_test COMMAND proj_angular_io_test)
set_property(TEST proj_angular_io_test PROPERTY ENVIRONMENT ${PROJ_TEST_ENVIRONMENT})

add_executable(proj_context_test
  main.cpp
  proj_context_test.cpp)
target_link_libraries(proj_context_test
    PRIVATE ${GTEST_LIBRARIES}
#  gtest
    PRIVATE ${PROJ_LIBRARIES})
add_test(NAME proj_context_test COMMAND proj_context_test)
set_property(TEST proj_context_test PROPERTY ENVIRONMENT ${PROJ_TEST_ENVIRONMENT})

if(MSVC AND BUILD_SHARED_LIBS)
  # ph_phi2_test not compatible of a .dll build
else()
  add_executable(pj_phi2_test
    main.cpp
    pj_phi2_test.cpp)
  target_link_libraries(pj_phi2_test
  PRIVATE ${GTEST_LIBRARIES}
  PRIVATE ${PROJ_LIBRARIES})
  add_test(NAME pj_phi2_test COMMAND pj_phi2_test)
  set_property(TEST pj_phi2_test
    PROPERTY ENVIRONMENT ${PROJ_TEST_ENVIRONMENT})
endif()

add_executable(proj_test_cpp_api
  main.cpp
  test_util.cpp
  test_common.cpp
  test_crs.cpp
  test_metadata.cpp
  test_io.cpp
  test_operation.cpp
  test_datum.cpp
  test_factory.cpp
  test_c_api.cpp)
target_link_libraries(proj_test_cpp_api
    PRIVATE ${GTEST_LIBRARIES}
    PRIVATE ${PROJ_LIBRARIES}
    PRIVATE ${SQLITE3_LIBRARY})
add_test(NAME proj_test_cpp_api COMMAND proj_test_cpp_api)
set_property(TEST proj_test_cpp_api PROPERTY ENVIRONMENT ${PROJ_TEST_ENVIRONMENT})

add_executable(gie_self_tests
  main.cpp
  gie_self_tests.cpp)
target_link_libraries(gie_self_tests
    PRIVATE ${GTEST_LIBRARIES}
    PRIVATE ${PROJ_LIBRARIES})
add_test(NAME gie_self_tests COMMAND gie_self_tests)
set_property(TEST gie_self_tests PROPERTY ENVIRONMENT ${PROJ_TEST_ENVIRONMENT})


add_executable(test_network
  main.cpp
  test_network.cpp)
if(CURL_ENABLED)
  include_directories(${CURL_INCLUDE_DIR})
  target_compile_definitions(test_network PRIVATE -DCURL_ENABLED)
  target_link_libraries(test_network PRIVATE ${CURL_LIBRARY})
endif()
target_link_libraries(test_network
  PRIVATE ${GTEST_LIBRARIES}
  PRIVATE ${PROJ_LIBRARIES}
  PRIVATE ${SQLITE3_LIBRARY})
add_test(NAME test_network COMMAND test_network)
set_property(TEST test_network
  PROPERTY ENVIRONMENT ${PROJ_TEST_ENVIRONMENT})

add_executable(test_defmodel
  main.cpp
  test_defmodel.cpp)
target_link_libraries(test_defmodel
  PRIVATE ${GTEST_LIBRARIES}
  PRIVATE ${PROJ_LIBRARIES})
add_test(NAME test_defmodel COMMAND test_defmodel)
set_property(TEST test_defmodel
  PROPERTY ENVIRONMENT ${PROJ_TEST_ENVIRONMENT})

add_executable(test_tinshift
  main.cpp
  test_tinshift.cpp)
target_link_libraries(test_tinshift
  PRIVATE ${GTEST_LIBRARIES}
  PRIVATE ${PROJ_LIBRARIES})
add_test(NAME test_tinshift COMMAND test_tinshift)
set_property(TEST test_tinshift
  PROPERTY ENVIRONMENT ${PROJ_TEST_ENVIRONMENT})

add_executable(test_misc
  main.cpp
  test_misc.cpp)
target_link_libraries(test_misc
  PRIVATE ${GTEST_LIBRARIES}
  PRIVATE ${PROJ_LIBRARIES})
add_test(NAME test_misc COMMAND test_misc)
set_property(TEST test_misc
  PROPERTY ENVIRONMENT ${PROJ_TEST_ENVIRONMENT})

if (USE_THREAD AND Threads_FOUND AND CMAKE_USE_PTHREADS_INIT)
add_definitions(-DMUTEX_pthread)
add_executable(test_fork
  test_fork.c)
target_link_libraries(test_fork
  PRIVATE ${PROJ_LIBRARIES}
  PRIVATE ${CMAKE_THREAD_LIBS_INIT})
add_test(NAME test_fork COMMAND test_fork)
set_property(TEST test_fork
  PROPERTY ENVIRONMENT ${PROJ_TEST_ENVIRONMENT})
endif()

# Copy dependencies to bin dir
set(TEST_DEPENDENCIES
    lib_openssl
    lib_jpeg
    lib_jbig
    lib_lzma
    lib_webp
)
if(WIN32)    
    find_anyproject(JPEG REQUIRED)
    find_anyproject(JBIG REQUIRED)
    find_anyproject(LIBLZMA REQUIRED)
    find_anyproject(WEBP REQUIRED)
    find_anyproject(OPENSSL REQUIRED)
    find_anyproject(ZLIB REQUIRED)
    
    add_custom_command(TARGET proj_errno_string_test
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -DDST_PATH=$<TARGET_FILE_DIR:proj_errno_string_test> -DSRC_PATH="${PROJECT_BINARY_DIR}" -P ${PROJECT_SOURCE_DIR}/cmake/test_dependency_win.cmake
        COMMENT "Copy DLLs"
    )
elseif(OSX_FRAMEWORK)
    get_compiler_version(COMPILER)
    foreach(TEST_DEPENDENCY ${TEST_DEPENDENCIES})
        add_custom_command(TARGET proj_errno_string_test
            POST_BUILD
            COMMAND ${CMAKE_COMMAND} -DDST_PATH="${CMAKE_LIBRARY_OUTPUT_DIRECTORY}" -DSRC_PATH="${PROJECT_BINARY_DIR}" -DREPKA_PACKAGE="${TEST_DEPENDENCY}" -DCOMPILER="${COMPILER}" -P ${PROJECT_SOURCE_DIR}/cmake/test_dependency_mac.cmake
            COMMENT "Get framework ${TEST_DEPENDENCY}"
        )
    endforeach()
    
endif()
