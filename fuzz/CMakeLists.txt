if(NOT CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  message(
    WARNING
    "ENABLE_FUZZING is ON but compiler is not Clang; skipping fuzz target. "
    "Use Clang with libFuzzer support (e.g. Homebrew LLVM on macOS)."
  )
  return()
endif()

# Apple Clang often ships without a usable libFuzzer runtime. Detect and skip if missing so
# the fuzz preset can still configure/build cleanly on machines without it.
execute_process(
  COMMAND "${CMAKE_CXX_COMPILER}" -print-resource-dir
  OUTPUT_VARIABLE _http_server_resource_dir
  OUTPUT_STRIP_TRAILING_WHITESPACE
)
set(_http_server_fuzzer_runtime "")
if(APPLE)
  set(_http_server_fuzzer_runtime
      "${_http_server_resource_dir}/lib/darwin/libclang_rt.fuzzer_osx.a")
  if(NOT EXISTS "${_http_server_fuzzer_runtime}")
    message(
      WARNING
      "ENABLE_FUZZING is ON but libFuzzer runtime was not found at "
      "'${_http_server_fuzzer_runtime}'. Skipping fuzz target. "
      "Install Homebrew LLVM (brew install llvm) and configure with that clang++."
    )
    return()
  endif()
endif()

add_executable(fuzz_target fuzz_target.cpp)
target_link_libraries(fuzz_target PRIVATE server_lib)

http_server_apply_compile_options(fuzz_target)
http_server_enable_clang_tidy(fuzz_target)

# LibFuzzer is incompatible with applying -fsanitize=address twice; combine when ASan is on.
if(ENABLE_ASAN)
  target_compile_options(fuzz_target PRIVATE -fsanitize=fuzzer,address -fno-omit-frame-pointer)
  target_link_options(fuzz_target PRIVATE -fsanitize=fuzzer,address)
else()
  target_compile_options(fuzz_target PRIVATE -fsanitize=fuzzer)
  target_link_options(fuzz_target PRIVATE -fsanitize=fuzzer)
endif()
