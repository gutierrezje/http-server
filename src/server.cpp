#include "server.h"
#include <iostream>

void HttpServer::start(int port) {
    std::cout << "Server starting on port " << port << std::endl;
}

void HttpServer::stop() {
    std::cout << "Server stopping" << std::endl;
}

std::string HttpServer::handleRequest(const std::string& request) {
    // Simple echo for now
    return "HTTP/1.1 200 OK\r\nContent-Length: 13\r\n\r\nHello, World!";
}
