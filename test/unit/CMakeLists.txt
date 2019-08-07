find_anyproject(GTest REQUIRED)

#
# Build PROJ unit tests
#

if("${CMAKE_C_COMPILER_ID}" STREQUAL "MSVC" AND BUILD_LIBPROJ_SHARED)
  add_definitions(-DPROJ_MSVC_DLL_IMPORT=1)
endif()

include_directories(${CMAKE_SOURCE_DIR}/include)
include_directories(${SQLITE3_INCLUDE_DIR})
# Add the directory containing proj_config.h
include_directories(${CMAKE_BINARY_DIR}/src)

# Apply to targets in the current directory and below
add_compile_options(${PROJ_CXX_WARN_FLAGS})

add_executable(proj_pj_transform_test
  main.cpp
  pj_transform_test.cpp)
target_link_libraries(proj_pj_transform_test
    ${GTEST_LIBRARIES}
#  gtest
  ${PROJ_LIBRARIES})
add_test(NAME proj_pj_transform_test COMMAND proj_pj_transform_test)
set_property(TEST proj_pj_transform_test PROPERTY ENVIRONMENT ${PENV})

add_executable(proj_errno_string_test
  main.cpp
  proj_errno_string_test.cpp)
target_link_libraries(proj_errno_string_test
    ${GTEST_LIBRARIES}
#  gtest
  ${PROJ_LIBRARIES})
add_test(NAME proj_errno_string_test COMMAND proj_errno_string_test)
set_property(TEST proj_errno_string_test PROPERTY ENVIRONMENT ${PENV})

add_executable(proj_angular_io_test
  main.cpp
  proj_angular_io_test.cpp)
target_link_libraries(proj_angular_io_test
    ${GTEST_LIBRARIES}
#  gtest
  ${PROJ_LIBRARIES})
add_test(NAME proj_angular_io_test COMMAND proj_angular_io_test)
set_property(TEST proj_angular_io_test PROPERTY ENVIRONMENT ${PENV})

add_executable(proj_context_test
  main.cpp
  proj_context_test.cpp)
target_link_libraries(proj_context_test
    ${GTEST_LIBRARIES}
#  gtest
  ${PROJ_LIBRARIES})
add_test(NAME proj_context_test COMMAND proj_context_test)
set_property(TEST proj_context_test PROPERTY ENVIRONMENT ${PENV})

if(MSVC AND BUILD_LIBPROJ_SHARED)
  # ph_phi2_test not compatible of a .dll build
else()
  add_executable(pj_phi2_test
    main.cpp
    pj_phi2_test.cpp)
  target_link_libraries(pj_phi2_test
      ${GTEST_LIBRARIES}
#  gtest
    ${PROJ_LIBRARIES})
  add_test(NAME pj_phi2_test COMMAND pj_phi2_test)
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
    ${GTEST_LIBRARIES}
#  gtest
  ${PROJ_LIBRARIES}
  ${SQLITE3_LIBRARY})
add_test(NAME proj_test_cpp_api COMMAND proj_test_cpp_api)
set_property(TEST proj_test_cpp_api PROPERTY ENVIRONMENT ${PENV})

add_executable(gie_self_tests
  main.cpp
  gie_self_tests.cpp)
target_link_libraries(gie_self_tests
  ${GTEST_LIBRARIES}
#  gtest
  ${PROJ_LIBRARIES})
add_test(NAME gie_self_tests COMMAND gie_self_tests)
set_property(TEST gie_self_tests PROPERTY ENVIRONMENT ${PENV})

# Copy dependencies to bin dir
if(WIN32)
    add_custom_command(TARGET proj_pj_transform_test
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -DDST_PATH="$<TARGET_FILE_DIR:proj_pj_transform_test>" -DSRC_PATH="${PROJECT_BINARY_DIR}" -P ${PROJECT_SOURCE_DIR}/cmake/test_dependency.cmake
        COMMENT "Copy DLLs"
    )
endif()
