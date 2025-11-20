#pragma once
#include <string>

class HttpServer {
public:
    void start(int port);
    void stop();
    std::string handleRequest(const std::string& request);
};
