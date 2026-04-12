find_package(GTest CONFIG REQUIRED)

add_executable(server_tests test_main.cpp)

target_link_libraries(server_tests PRIVATE server_lib GTest::gtest_main)

http_server_apply_compile_options(server_tests)
http_server_apply_sanitizers(server_tests)
http_server_enable_clang_tidy(server_tests)

include(GoogleTest)
gtest_discover_tests(server_tests)
