---
name: ai-gen-summary
description: Give a human unfamiliar with AI-generated changes a high-level mental model and check for fundamental problems, without a detailed code review.
---

The human knows nothing about the AI-generated code. Explain the big picture and identify fundamental problems, not fine-grained correctness issues or style feedback.

Respect the user's specified scope or filter. If none is provided or it is unclear, review all unstaged changes: use `git diff` for tracked files and `git status --porcelain` for untracked files. Read untracked code files; name binary files and assets. Exclude staged changes. State what was included and excluded, then give a big-picture overview and any big-picture problems or other commentary.
