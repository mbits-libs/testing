# testing
Quick support for Google Testing.

## Usage

The tool contains a CMake script for easy configuration. Provided the tool was added as a submodule under `tools`, you should add something like this to the root CMakeLists.txt:

```cmake
set(???_TESTING ON CACHE BOOL "Compile and/or run self-tests")

if (???_TESTING)
  enable_testing()
  include( ${CMAKE_CURRENT_SOURCE_DIR}/tools/testing/googletest.cmake )
endif()
```

Then in each tested library/module the tests themselves should be created:

```cmake
##################################################################
##  TESTING
##################################################################

if (???_TESTING)
set(DATA_DIR ${CMAKE_CURRENT_SOURCE_DIR}/tests/data)
configure_file(${PROJECT_DEFAULT_DATA_PATH}
               ${CMAKE_CURRENT_BINARY_DIR}/default_data_path.hpp
               @ONLY)
message(STATUS "Test data: ${DATA_DIR}")

file(GLOB TEST_SRCS tests/*.cc)

add_executable(???-test "${CMAKE_SOURCE_DIR}/tools/googletest.cpp" ${TEST_SRCS})
set_target_properties(???-test PROPERTIES FOLDER tests)
target_link_libraries(???-test lib??? gtest gmock ${CMAKE_THREAD_LIBS_INIT})

enable_testing()
add_test(NAME ...

endif()
```

### Generating

When properly configured, call the build system with the `coveralls` target, either

```shell
make -j`nproc` && make test
```

or

```shell
ninja -j`nproc` && ninja test
```
