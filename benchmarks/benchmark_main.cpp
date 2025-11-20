#include <benchmark/benchmark.h>
#include "../src/server.h"

static void BM_HandleRequest(benchmark::State& state) {
    HttpServer server;
    std::string request = "GET / HTTP/1.1";
    
    for (auto _ : state) {
        // This code gets timed
        std::string response = server.handleRequest(request);
        benchmark::DoNotOptimize(response);
    }
}
BENCHMARK(BM_HandleRequest);
