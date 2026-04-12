add_executable(fuzz_target fuzz_target.cpp)
target_link_libraries(fuzz_target PRIVATE server_lib)

http_server_apply_compile_options(fuzz_target)
http_server_enable_clang_tidy(fuzz_target)

# LibFuzzer is incompatible with applying -fsanitize=address twice; combine when ASan is on.
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  if(ENABLE_ASAN)
    target_compile_options(
      fuzz_target
      PRIVATE -fsanitize=fuzzer,address -fno-omit-frame-pointer
    )
    target_link_options(fuzz_target PRIVATE -fsanitize=fuzzer,address)
  else()
    target_compile_options(fuzz_target PRIVATE -fsanitize=fuzzer)
    target_link_options(fuzz_target PRIVATE -fsanitize=fuzzer)
  endif()
else()
  message(
    WARNING "Fuzzing is typically supported with Clang. You might need to adjust flags for other compilers."
  )
endif()
