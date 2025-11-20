enable_testing()

find_package(GTest CONFIG REQUIRED)

add_executable(server_tests test_main.cpp)

target_link_libraries(server_tests PRIVATE server_lib GTest::gtest_main)

include(GoogleTest)
gtest_discover_tests(server_tests)
