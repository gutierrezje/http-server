# Project Context
This is a high-performance, multithreaded HTTP server written in Modern C++23.
The core philosophy is "zero-cost abstractions with maximum safety." We prioritize memory safety, thread safety, and cache-friendly data structures over legacy C-style performance hacks.

# Tech Stack & Tooling
- **Language:** C++23 (Strictly enforced)
- **Build System:** CMake 3.23+ with Presets (`CMakePresets.json`)
- **Package Manager:** `vcpkg` (Manifest mode: `vcpkg.json`)
- **Testing:** GoogleTest (in `/tests`)
- **Benchmarking:** Google Benchmark (in `/benchmarks`)
- **Fuzzing:** LLVM LibFuzzer (in `/fuzz`)
- **Linting:** clang-tidy and clang-format (enforced via pre-commit)

# Architectural Rules (CRITICAL)

### 1. Memory & Ownership
- **NEVER** use raw `new`, `delete`, `malloc`, or `free`.
- Use `std::unique_ptr` for exclusive ownership. Use `std::shared_ptr` only when shared ownership is strictly mathematically required.
- Do not pass smart pointers to functions unless the function alters ownership. Pass by reference `T&` or `const T&` instead.

### 2. String & Buffer Parsing (HTTP Specifics)
- Keep raw buffers **at the boundary** (syscalls / OS APIs). Internally, represent read-only views as:
  - `std::string_view` for text
  - `std::span<const std::byte>` (or `std::span<const std::uint8_t>`) for bytes
- Avoid C-string APIs (`strtok`, `strcpy`, etc.). Prefer explicit length-aware operations.

#### 3. Error Handling (C++23 Monadic Style)
- Do not throw exceptions for normal control flow.
- Use `std::expected` for operations that can fail.
- Prefer monadic-style chaining over deeply nested `if (result.has_value())` blocks.
  - Note: availability of `.and_then()/.transform()/.or_else()` on `std::expected` depends on the standard library.
    If unsupported on the target toolchain, use small helpers or straightforward early-return code.

### 4. Concurrency & Networking
- Avoid raw `std::thread`. Use modern thread pools or asynchronous task runners.
- When parsing network data, be highly defensive against narrowing conversions (e.g., parsing a 64-bit `Content-Length` into a 32-bit `int`).
- For byte-order conversion, prefer explicit utilities built on `std::endian` + `std::byteswap`.
  - It's fine to use platform APIs at the boundary if needed; keep it isolated behind a small wrapper.
- All shared mutable state must be strictly protected or rely on lock-free atomic operations.

### 5. C++ Modernity & Anti-Patterns
- Prefer `<print>` (`std::print` / `std::println`) for user-facing output and logs where available.
- Prefer `std::ranges` / views where it improves clarity; do not force pipeline-style code in hot parsing loops without profiling.
- **Deducing This:** Use explicit object parameters (deducing `this`) to avoid duplicating `const` and non-`const` member functions, and to simplify recursive lambdas.
- Prefer `std::string_view::contains()` / `starts_with()` / `ends_with()` for substring checks where it improves readability.
- Use `[[maybe_unused]]`, `[[fallthrough]]`, and `[[likely]]`/`[[unlikely]]` to document intent and assist the optimizer/linter.
- Make classes `final` by default unless explicitly designed for polymorphic inheritance.

# Code Generation Directives
1. Before writing code, ensure it complies with our `.clang-tidy` rules (especially `cert-*` and `modernize-*`).
2. When creating new files, place them in the correct directory (`/src` for implementation, `/tests` for unit tests, etc.).
3. If writing parsing logic, proactively suggest adding a fuzzer target in `/fuzz`.
4. Tests must accompany any new core logic.
