add_executable(fuzz_target fuzz_target.cpp)
target_link_libraries(fuzz_target PRIVATE server_lib)

if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    target_compile_options(fuzz_target PRIVATE -fsanitize=fuzzer)
    target_link_options(fuzz_target PRIVATE -fsanitize=fuzzer)
else()
    message(WARNING "Fuzzing is typically supported with Clang. You might need to adjust flags for other compilers.")
endif()
