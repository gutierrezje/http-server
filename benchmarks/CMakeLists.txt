find_package(benchmark CONFIG REQUIRED)

add_executable(server_benchmarks benchmark_main.cpp)
target_link_libraries(server_benchmarks PRIVATE server_lib benchmark::benchmark_main)

http_server_apply_compile_options(server_benchmarks)
# BENCHMARK() uses __COUNTER__; Clang -Wpedantic can warn in this TU even though the macro comes from vcpkg.
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  target_compile_options(server_benchmarks PRIVATE -Wno-c2y-extensions)
endif()
http_server_apply_sanitizers(server_benchmarks)
http_server_enable_clang_tidy(server_benchmarks)
