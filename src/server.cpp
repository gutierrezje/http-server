#include "server.h"

#include <iostream>

// NOLINTBEGIN(readability-convert-member-functions-to-static)
// Instance API; will use state when the real server is wired up.
void HttpServer::start(int port) {
    std::cout << "Server starting on port " << port << '\n';
}

void HttpServer::stop() {
    std::cout << "Server stopping" << '\n';
}
// NOLINTEND(readability-convert-member-functions-to-static)

// NOLINTNEXTLINE(readability-convert-member-functions-to-static)
std::string HttpServer::handleRequest([[maybe_unused]] const std::string& request) {
    // Simple echo for now
    return "HTTP/1.1 200 OK\r\nContent-Length: 13\r\n\r\nHello, World!";
}
