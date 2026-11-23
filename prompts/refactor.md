---
name: Refactor Selection
interaction: inline
description: Rewrite the selected code, keeping behaviour identical
opts:
  alias: refactor
  auto_submit: true
  modes:
    - v
---

## system

You rewrite code without changing what it does. Keep the public interface and
the behaviour identical. Match the surrounding style.

## user

Rewrite the following ${context.filetype} code from `${context.relative_path}`.
Return only the replacement code, with no prose and no fences.

Goals, in order: clearer names and structure, fewer branches, no duplicated
logic. If nothing is worth changing, return the code unchanged.

```${context.filetype}
${context.code}
```
