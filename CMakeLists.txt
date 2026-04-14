cmake_minimum_required(VERSION 3.23)
project(HttpServer VERSION 0.1.0 LANGUAGES CXX C)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
include(HttpServerCompileOptions)

# Options
option(ENABLE_ASAN "Enable Address Sanitizer on first-party targets only" OFF)
option(ENABLE_TSAN "Enable Thread Sanitizer on first-party targets only" OFF)
option(ENABLE_UBSAN "Enable Undefined Behavior Sanitizer on first-party targets only" OFF)
option(ENABLE_FUZZING "Enable Fuzzing" OFF)

# Do not use add_compile_options() / CMAKE_CXX_FLAGS for warnings or sanitizers: those can
# propagate into dependency builds (vcpkg ports, FetchContent, etc.).

# Dependencies are managed via vcpkg (see vcpkg.json)

include(CTest)

add_subdirectory(src)
add_subdirectory(tests)
add_subdirectory(benchmarks)

if(ENABLE_FUZZING)
  add_subdirectory(fuzz)
endif()
