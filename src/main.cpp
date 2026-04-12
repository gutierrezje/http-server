#include "server.h"

#include <iostream>

int main() {
    HttpServer server;
    server.start(8080);
    return 0;
}
