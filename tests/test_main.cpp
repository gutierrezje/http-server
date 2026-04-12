#include "../src/server.h"

#include <gtest/gtest.h>

TEST(ServerTest, HandleRequest) {
    HttpServer server;
    std::string response = server.handleRequest("GET / HTTP/1.1");
    EXPECT_TRUE(response.find("200 OK") != std::string::npos);
}
