add_library(server_lib
    server.cpp
    server.h
)
target_include_directories(server_lib PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

add_executable(http_server main.cpp)
target_link_libraries(http_server PRIVATE server_lib)
