# We need thread support
find_package(Threads REQUIRED)

set(INSTALL_GTEST OFF CACHE BOOL "Enable installation of googletest.")
set(gtest_force_shared_crt ON CACHE BOOL "Use shared (DLL) run-time lib even when Google Test is built as static lib." FORCE)

set(PROJECT_DEFAULT_DATA_PATH "${CMAKE_CURRENT_LIST_DIR}/default_data_path.in.hpp")
set(PROJECT_GTEST_MAIN_CC "${CMAKE_CURRENT_LIST_DIR}/googletest.cpp")

add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/gtest gtest)

file(RELATIVE_PATH ___GTEST_FOLDER_PROPERTY_VALUE "${PROJECT_SOURCE_DIR}" "${CMAKE_CURRENT_LIST_DIR}")
set_target_properties(gmock PROPERTIES FOLDER ${___GTEST_FOLDER_PROPERTY_VALUE})
set_target_properties(gmock_main PROPERTIES FOLDER ${___GTEST_FOLDER_PROPERTY_VALUE})
set_target_properties(gtest PROPERTIES FOLDER ${___GTEST_FOLDER_PROPERTY_VALUE})
set_target_properties(gtest_main PROPERTIES FOLDER ${___GTEST_FOLDER_PROPERTY_VALUE})

include(CMakeParseArguments)

function(add_test_executable TARGET)
	CMAKE_PARSE_ARGUMENTS(TEST_EXE "" "DATA_PATH;TEST_SUBDIR" "LIBRARIES" ${ARGN})

	if (NOT TEST_EXE_TEST_SUBDIR)
		set(TEST_EXE_TEST_SUBDIR tests)
	endif()

	if (TEST_EXE_DATA_PATH)
		set(TEST_EXE_DATA_DIR "${CMAKE_CURRENT_SOURCE_DIR}/${TEST_EXE_TEST_SUBDIR}/${TEST_EXE_DATA_PATH}")
		message(STATUS "Test data: ${TEST_EXE_DATA_DIR}")
		configure_file(${PROJECT_DEFAULT_DATA_PATH} ${CMAKE_CURRENT_BINARY_DIR}/default_data_path.hpp @ONLY)
		set(DATA_DIR "${TEST_EXE_DATA_DIR}" PARENT_SCOPE)
	endif()

	file(GLOB TEST_SRCS ${TEST_EXE_TEST_SUBDIR}/*.cc)
	add_executable(${TARGET} "${PROJECT_GTEST_MAIN_CC}" ${TEST_SRCS})
	set_target_properties(${TARGET} PROPERTIES FOLDER ${TEST_EXE_TEST_SUBDIR})
	target_link_libraries(${TARGET} ${TEST_EXE_LIBRARIES} gtest gmock ${CMAKE_THREAD_LIBS_INIT})
	target_include_directories(${TARGET}
		PRIVATE
			${CMAKE_CURRENT_SOURCE_DIR}/${TEST_EXE_TEST_SUBDIR}
			${CMAKE_CURRENT_BINARY_DIR})

endfunction()

enable_testing()
