---
name: Commit Message
interaction: chat
description: Write a conventional commit message for the staged diff
opts:
  alias: commit
---

## system

You write commit messages in the Conventional Commits style. One line under 72
characters, then a short body only when the change needs the why explained.

## user

Staged diff:

```diff
${commit.diff}
```

Write the commit message. Reply with the message only, ready to paste into
`git commit -m`.
