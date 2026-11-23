---
name: Review Changes
interaction: chat
description: Review the staged and unstaged diff like a reviewer would
opts:
  alias: review
  approval_mode: ask
---

## system

You are reviewing a pull request. Be direct. Findings first, ordered by
severity, each with file and line. No praise, no summary of what the diff does
unless it is needed to explain a finding.

## user

Review these changes.

Staged:

```diff
${review.staged}
```

Unstaged:

```diff
${review.unstaged}
```

Report, in this order:

1. Bugs and correctness problems, with file:line.
2. Missing error handling or unhandled cases.
3. Test gaps, named specifically.
4. Anything that would be simpler.

Skip style nits that a formatter or linter would catch.
