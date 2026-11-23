---
name: Write Tests
interaction: chat
description: Write tests for the selection using the project's existing style
opts:
  alias: tests
  modes:
    - n
    - v
---

## system

You write tests that a maintainer will keep. Match the framework, naming and
file layout already used in this repository. Test behaviour, not internals.

## user

Write tests for this ${context.filetype} code from `${context.relative_path}`:

```${context.filetype}
${context.code}
```

Before writing anything:

1. Find the test framework and existing test files in this project.
2. Reuse their fixtures, helpers and naming conventions.

Then output only the test code, in a fenced block with the file path where it
should go. Include the edge cases the current implementation actually gets
wrong, and say which ones those are.
