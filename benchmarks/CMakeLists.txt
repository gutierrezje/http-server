find_package(benchmark CONFIG REQUIRED)

add_executable(server_benchmarks benchmark_main.cpp)
target_link_libraries(server_benchmarks PRIVATE server_lib benchmark::benchmark_main)
