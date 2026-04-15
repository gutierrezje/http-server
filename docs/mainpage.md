# HttpServer

This is a small C++ HTTP server project focused on:

- A clean CMake + vcpkg workflow
- Strict, first-party-only warnings/sanitizers/tidy
- A path to safe parsing + concurrency testing (ASan/UBSan/TSan + fuzzing)

## Modules (planned)

- Request parsing (request line, headers, body)
- Routing / middleware
- Response building
