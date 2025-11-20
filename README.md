# Multithreaded HTTP Server

A modern C++ HTTP server project.

## Prerequisites

- **CMake** 3.20+
- **Git**
- **macOS**:
  - [Homebrew](https://brew.sh/)
  - LLVM (for Clang + LLD + Fuzzing): `brew install llvm`
  - *Note: The build preset assumes Homebrew is at `/opt/homebrew`. If you are on an Intel Mac or use a custom path, set the `LLVM_ROOT` environment variable before building.*

- **Windows**:
  - Visual Studio 2022 (with C++ Desktop Development workload)

## Build

This project uses `vcpkg` as a submodule for dependency management.

1.  **Initialize the repository and submodule:**

    ```bash
    git submodule update --init
    # Bootstrap vcpkg (only needed once)
    # macOS/Linux:
    ./vcpkg/bootstrap-vcpkg.sh
    # Windows:
    # .\vcpkg\bootstrap-vcpkg.bat
    ```

2.  **Build using CMake Presets:**

    The presets automatically detect your OS (macOS or Windows) and configure the appropriate compiler.

    **Debug Build** (Includes Fuzzing/ASan on macOS):
    ```bash
    cmake --preset debug
    cmake --build --preset debug
    ```

    **Release Build** (Optimized):
    ```bash
    cmake --preset release
    cmake --build --preset release
    ```

## Run

```bash
./src/http_server
```

## Tests

```bash
cd build
ctest
```

## Benchmarks

To run performance micro-benchmarks:

```bash
./build-release/benchmarks/server_benchmarks
```

