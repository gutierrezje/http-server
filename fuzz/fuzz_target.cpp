#include "../src/server.h"

#include <cstddef>
#include <cstdint>
#include <string>

extern "C" int LLVMFuzzerTestOneInput(const uint8_t* Data, size_t Size) {
    HttpServer server;
    std::string input(reinterpret_cast<const char*>(Data), Size);
    server.handleRequest(input);
    return 0;
}
