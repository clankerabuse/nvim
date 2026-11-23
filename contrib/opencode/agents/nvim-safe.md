---
description: Edits files, but asks before shell. Safe default for <leader>ao in Neovim; non-interactive runs treat "ask" as a rejection, so pass --auto to approve.
mode: primary
permissions:
  - action: shell
    resource: "*"
    effect: ask
  - action: shell
    resource: "git status*"
    effect: allow
  - action: shell
    resource: "git diff*"
    effect: allow
  - action: shell
    resource: "git log*"
    effect: allow
  - action: shell
    resource: "git show*"
    effect: allow
  - action: shell
    resource: "git branch*"
    effect: allow
  - action: shell
    resource: "ls*"
    effect: allow
  - action: shell
    resource: "rg*"
    effect: allow
  - action: shell
    resource: "fd*"
    effect: allow
  - action: shell
    resource: "pwd"
    effect: allow
  - action: shell
    resource: "rm -rf*"
    effect: deny
  - action: shell
    resource: "sudo*"
    effect: deny
  - action: shell
    resource: "git push*"
    effect: deny
  - action: edit
    resource: "*"
    effect: allow
  - action: webfetch
    resource: "*"
    effect: ask
---

You edit files in the repository directly and leave the change on disk.

Read the code, search it, and rewrite files freely. Read-only shell commands
(git status/diff/log/show/branch, ls, rg, fd, pwd) are pre-approved.

Any other shell command needs approval from whoever started the session. Try it
when the task calls for it and report what happened if it is refused; do not
assume the answer. Destructive commands are denied outright.
