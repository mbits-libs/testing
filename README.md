# testing
Quick support for Google Testing.

## Usage

The tool contains a CMake script for easy configuration. Provided the tool was added as a submodule under `tools`, you should add something like this to the root CMakeLists.txt:

```cmake
set(???_TESTING ON CACHE BOOL "Compile and/or run self-tests")

if (???_TESTING)
  include( ${CMAKE_CURRENT_SOURCE_DIR}/tools/testing/googletest.cmake )
endif()
```

Then in each tested library/module the tests themselves should be created:

```cmake
##################################################################
##  TESTING
##################################################################

if (???_TESTING)

add_test_executable(???-test DATA_PATH data LIBRARIES lib???)
add_test(NAME some.name COMMAND ???-test --gtest_filter=??? --data_path=${DATA_DIR})
...

endif()
```

### Generating

When properly configured, call the build system with the `test` target, either

```shell
make -j`nproc` && make test
```

or

```shell
ninja -j`nproc` && ninja test
```

or

```shell
ninja -j`nproc` && ctest .
```

### add_test_executable(target [TEST_SUBDIR] [DATA_PATH] [LIBRARIES ...])

The `add_test_executable` function takes the name of the executable target to create and, optionally, name of the subdirectory with test code, data directory within the test subdir and list of libraries to link against:

#### target

Name of the test target to create.

#### TEST_SUBDIR dirname

If present, will be used as a base for other options. Defaults to `tests`. Will be appended to `${CMAKE_CURRENT_SOURCE_DIR}`. The tests will be taken by globbing `${TEST_SUBDIR}/*.cc`.

#### DATA_PATH dirname

If present, will configure file `default_data_path.in.hpp` as `default_data_path.hpp`, using `${CMAKE_CURRENT_SOURCE_DIR}/${TEST_SUBDIR}/${DATA_PATH}` as the default data directory. It will also create `${DATA_DIR}` with the same value in the parent scope.

### LIBRARIES target [target ...]

List of targets this executable should be linked against. Apart from this list, the resulting target will be linked against `gtest`, `gmock` and `${CMAKE_THREAD_LIBS_INIT}`.
