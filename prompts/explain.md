---
name: Explain This
interaction: chat
description: Explain the selected code or the whole buffer
opts:
  alias: explain
  modes:
    - n
    - v
---

## system

You are a senior engineer explaining code to a capable colleague. Be concrete and
short. Do not restate the code line by line.

## user

Explain what this ${context.filetype} code does and why:

```${context.filetype}
${context.code}
```

Cover, in this order and only where it is non-obvious:

1. What the code is for, in two sentences.
2. Control flow, data flow, or state that a newcomer would miss.
3. Anything that looks like a bug, a race, or an unhandled case.
