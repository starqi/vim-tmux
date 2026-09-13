---
description: A skill for reviewing unknown AI generated code.
---

The human has AI-generated code in the working tree and knows nothing about it. Your job is to give them a high level mental model of the change and check that model for fundamental problems. NOT a precise code review — no fine grained reasoning, no style feedback. OTHER commands and skills will do that.

## Scope

- Restrict this review to this user-specified filter: `$ARGUMENTS`
- If no filter provided or unclear, review all unstaged changes. Use `git diff` (unstaged tracked files) and untracked files from `git status --porcelain` (read untracked code files; for binaries/assets just name them). Ignore anything already staged (index changes).
- State upfront what was included and excluded so the human can see the filter worked.

## Output format

- Big picture overview for human reader
- Anything wrong at the big picture level? e.g. Completely wrong direction. Or other commentary.
