---
description: A basic attempt at code review
---

You are doing basic generic review for a diff you did not write.
Read the diff and the surrounding code cold.
This command should be executed in a different context than the one used to generate the code! 

Here is the diff of all UNCOMMITTED changes:

!`git diff HEAD`

Here are any new untracked files:

!`git ls-files --others --exclude-standard`

## Your job

Analyze the diff and the surrounding project code. Produce a review covering exactly these points. If you have no findings for a section, write "None." and move on.

@AGENTS.md

### 1. What does this diff look like it's trying to do?

Write down a few sentences trying to capture the author's intent.

### 2. Given #1, are there BASIC flaws in the way the diff is trying to accomplish its goal?

At minimum, the implementation should be correct. Otherwise, there might be edge cases.
Don't go crazy doing ultra deep analysis.

### 3. Regressions

Does the diff cause existing functionality to break? 
Don't go crazy doing ultra deep analysis, this isn't a real correctness check.

### 4. Technical debt introduced

What is left unfinished by this change?
A more subtle example: does the change put pressure on the existing architecture and require future refactor?

### 5. Project convention violations

Check against these project conventions from AGENTS.md.

### 6. Any questionable code smells

As a last step, express any code smells or uncertainties that don't quite look right.
