# Documentation

This project uses a lightweight Doxygen setup so API documentation can be generated in one command
(similar in spirit to Rust's `cargo doc`, but for C++).

## Generate docs

From the repo root:

```bash
cmake --preset release
cmake --build --preset release --target docs
```

Output goes to `docs/doxygen/html/`.

## What to document

- **Public headers** in `src/` should have Doxygen comments on:
  - Classes / structs (purpose + invariants)
  - Public methods (preconditions, postconditions, thread-safety expectations)
  - Error behavior (exceptions vs return types)

## Suggested standards

- Prefer `@brief` + `@param` + `@return` + `@throws` where applicable.
- Document any **thread-safety** contract explicitly.
- Document all input validation and any intentionally accepted malformed input (important for parsers).
