cmake_minimum_required(VERSION 3.20)
project(HttpServer VERSION 0.1.0 LANGUAGES CXX C)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Options
option(ENABLE_ASAN "Enable Address Sanitizer" OFF)
option(ENABLE_TSAN "Enable Thread Sanitizer" OFF)
option(ENABLE_UBSAN "Enable Undefined Behavior Sanitizer" OFF)
option(ENABLE_FUZZING "Enable Fuzzing" OFF)

# Compiler warnings
if(MSVC)
    add_compile_options(/W4 /WX)
else()
    add_compile_options(-Wall -Wextra -Wpedantic)
endif()

# Sanitizer configuration
if(MSVC)
    if(ENABLE_ASAN)
        message(STATUS "Address Sanitizer enabled (MSVC)")
        add_compile_options(/fsanitize=address)
    endif()
    if(ENABLE_TSAN OR ENABLE_UBSAN)
        message(WARNING "TSan and UBSan are not fully supported on MSVC in this configuration.")
    endif()
else()
    if(ENABLE_ASAN)
        message(STATUS "Address Sanitizer enabled")
        add_compile_options(-fsanitize=address -fno-omit-frame-pointer)
        add_link_options(-fsanitize=address)
    endif()

    if(ENABLE_TSAN)
        message(STATUS "Thread Sanitizer enabled")
        add_compile_options(-fsanitize=thread)
        add_link_options(-fsanitize=thread)
    endif()

    if(ENABLE_UBSAN)
        message(STATUS "Undefined Behavior Sanitizer enabled")
        add_compile_options(-fsanitize=undefined)
        add_link_options(-fsanitize=undefined)
    endif()
endif()


# Dependencies
# Dependencies are managed via vcpkg (see vcpkg.json)


# Subdirectories
add_subdirectory(src)
add_subdirectory(tests)
add_subdirectory(benchmarks)

if(ENABLE_FUZZING)
    add_subdirectory(fuzz)
endif()
