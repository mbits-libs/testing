# We need thread support
find_package(Threads REQUIRED)

set(PROJECT_DEFAULT_DATA_PATH "${CMAKE_CURRENT_LIST_DIR}/default_data_path.in.hpp")
set(PROJECT_GTEST_MAIN_CC "${CMAKE_CURRENT_LIST_DIR}/googletest.cpp")

# Since adding CONAN_PKG argument to add_test_executable,
# users need to call find_package(GTest) on their own

include(CMakeParseArguments)

function(add_test_executable TARGET)
	CMAKE_PARSE_ARGUMENTS(TEST_EXE "NO_DATA;CONAN_PKG" "DATA_PATH;TEST_SUBDIR" "LIBRARIES" ${ARGN})

	if (NOT TEST_EXE_TEST_SUBDIR)
		set(TEST_EXE_TEST_SUBDIR tests)
	endif()

	if (TEST_EXE_DATA_PATH)
		set(TEST_EXE_DATA_DIR "${CMAKE_CURRENT_SOURCE_DIR}/${TEST_EXE_TEST_SUBDIR}/${TEST_EXE_DATA_PATH}")
		message(STATUS "Test data: ${TEST_EXE_DATA_DIR}")
		configure_file("${PROJECT_DEFAULT_DATA_PATH}" "${CMAKE_CURRENT_BINARY_DIR}/default_data_path.hpp" @ONLY)
		set(DATA_DIR "${TEST_EXE_DATA_DIR}" PARENT_SCOPE)
	endif()

	if (TEST_EXE_CONAN_PKG)
		list(APPEND TEST_EXE_LIBRARIES CONAN_PKG::gtest)
		message(STATUS "${TARGET} uses CONAN_PKG::gtest")
	else()
		list(APPEND TEST_EXE_LIBRARIES GTest::GTest)
		message(STATUS "${TARGET} uses GTest::GTest")
	endif()

	file(GLOB TEST_SRCS_CC ${TEST_EXE_TEST_SUBDIR}/*.cc)
	file(GLOB TEST_SRCS_CPP ${TEST_EXE_TEST_SUBDIR}/*.cpp)
	file(GLOB TEST_SRCS_CXX ${TEST_EXE_TEST_SUBDIR}/*.cxx)
	add_executable(${TARGET} "${PROJECT_GTEST_MAIN_CC}" ${TEST_SRCS_CC} ${TEST_SRCS_CPP} ${TEST_SRCS_CXX})
	set_target_properties(${TARGET} PROPERTIES FOLDER ${TEST_EXE_TEST_SUBDIR} CXX_STANDARD 17 CXX_EXTENSIONS OFF)
	target_link_libraries(${TARGET} ${TEST_EXE_LIBRARIES})
	target_include_directories(${TARGET}
		PRIVATE
			${CMAKE_CURRENT_SOURCE_DIR}/${TEST_EXE_TEST_SUBDIR}
			${CMAKE_CURRENT_BINARY_DIR})
endfunction()

enable_testing()
