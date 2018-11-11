# We need thread support
find_package(Threads REQUIRED)

set(INSTALL_GTEST OFF CACHE BOOL "Enable installation of googletest.")
set(gtest_force_shared_crt ON CACHE BOOL "Use shared (DLL) run-time lib even when Google Test is built as static lib." FORCE)

set(PROJECT_DEFAULT_DATA_PATH "${CMAKE_CURRENT_LIST_FILE}/default_data_path.in.hpp")
set(PROJECT_GTEST_MAIN_CC "${CMAKE_CURRENT_LIST_FILE}/googletest.cpp")

add_subdirectory(${CMAKE_CURRENT_LIST_FILE}/gtest gtest)

set_target_properties(gmock PROPERTIES FOLDER tools/testing)
set_target_properties(gmock_main PROPERTIES FOLDER tools/testing)
set_target_properties(gtest PROPERTIES FOLDER tools/testing)
set_target_properties(gtest_main PROPERTIES FOLDER tools/testing)
