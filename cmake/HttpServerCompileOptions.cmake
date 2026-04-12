# Strict flags apply only to HttpServer targets (PRIVATE), so vcpkg / FetchContent
# dependencies are not built with this project's warning or sanitizer settings.

option(HTTP_SERVER_WERROR "Treat warnings as errors for HttpServer targets only" OFF)
option(HTTP_SERVER_ENABLE_CLANG_TIDY "Run clang-tidy when compiling first-party targets" OFF)
set(
  HTTP_SERVER_CLANG_TIDY_EXECUTABLE ""
  CACHE FILEPATH "Path to clang-tidy; empty = search PATH (e.g. set to clang-tidy-18 on Debian/Ubuntu CI)"
)

function(http_server_apply_compile_options target)
  if(NOT TARGET "${target}")
    message(FATAL_ERROR "http_server_apply_compile_options: not a target: ${target}")
  endif()
  if(MSVC)
    target_compile_options("${target}" PRIVATE /W4)
    if(HTTP_SERVER_WERROR)
      target_compile_options("${target}" PRIVATE /WX)
    endif()
  else()
    target_compile_options(
      "${target}"
      PRIVATE
      -Wall
      -Wextra
      -Wpedantic
    )
    if(HTTP_SERVER_WERROR)
      target_compile_options("${target}" PRIVATE -Werror)
    endif()
  endif()
endfunction()

function(http_server_apply_sanitizers target)
  if(NOT TARGET "${target}")
    message(FATAL_ERROR "http_server_apply_sanitizers: not a target: ${target}")
  endif()
  if(MSVC)
    if(ENABLE_ASAN)
      target_compile_options("${target}" PRIVATE /fsanitize=address)
    endif()
    if(ENABLE_TSAN OR ENABLE_UBSAN)
      message(
        WARNING
        "TSan and UBSan are not fully supported on MSVC in this configuration (target: ${target})."
      )
    endif()
    return()
  endif()

  if(ENABLE_ASAN)
    target_compile_options("${target}" PRIVATE -fsanitize=address -fno-omit-frame-pointer)
    target_link_options("${target}" PRIVATE -fsanitize=address)
  endif()
  if(ENABLE_TSAN)
    target_compile_options("${target}" PRIVATE -fsanitize=thread)
    target_link_options("${target}" PRIVATE -fsanitize=thread)
  endif()
  if(ENABLE_UBSAN)
    target_compile_options("${target}" PRIVATE -fsanitize=undefined)
    target_link_options("${target}" PRIVATE -fsanitize=undefined)
  endif()
endfunction()

function(http_server_enable_clang_tidy target)
  if(NOT HTTP_SERVER_ENABLE_CLANG_TIDY)
    return()
  endif()
  if(NOT TARGET "${target}")
    message(FATAL_ERROR "http_server_enable_clang_tidy: not a target: ${target}")
  endif()
  if(HTTP_SERVER_CLANG_TIDY_EXECUTABLE)
    set(_http_server_tidy "${HTTP_SERVER_CLANG_TIDY_EXECUTABLE}")
  else()
    find_program(
      _http_server_tidy
      NAMES clang-tidy
      DOC "Path to clang-tidy executable"
    )
  endif()
  if(NOT _http_server_tidy)
    message(
      WARNING
      "HTTP_SERVER_ENABLE_CLANG_TIDY is ON but clang-tidy was not found; skipping for target ${target}"
    )
    return()
  endif()
  set_target_properties(
    "${target}"
    PROPERTIES CXX_CLANG_TIDY "${_http_server_tidy};-p=${CMAKE_BINARY_DIR}"
  )
endfunction()
