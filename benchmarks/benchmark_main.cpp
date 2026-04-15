#include "../src/server.h"

#include <benchmark/benchmark.h>

static void BM_HandleRequest(benchmark::State& state) {
    HttpServer server;
    std::string request = "GET / HTTP/1.1";

    // NOLINTNEXTLINE(clang-analyzer-deadcode.DeadStores)
    for (auto _ : state) {
        (void)_;
        // This code gets timed
        std::string response = server.handleRequest(request);
        benchmark::DoNotOptimize(response);
    }
}
BENCHMARK(BM_HandleRequest);
