**Problem**
This skill attempts to fix a very common problem:
- The user only has a rough idea and does not fully know what they want. 
- The user does not know if their idea has contradictions because the user has not explored the codebase.
- The user does not wish to explore the codebase as it defeats the purpose of using AI.
- The LLM interprets user commands too literally, trying to fulfill vague half-thought-out instructions.

**Solution**:
Grill the user relentlessly on all ambiguities, contradictions, yellow and red flags, and hesitations 
until everything makes sense.

**Key philosophy**:
If we reach a state of consistency, certainty and clarity, then this is evidence the task is a sound task.

**Workflow**:

In plan mode, simply ask many questions.
In build mode, same thing; you may ask questions while building, or ahead of time.
e.g. Notably, you may discover something during build, which changes the whole plan, this is normal.

This grilling phase goes on continuously, unlimited amount of questions!
But if the user says "just build", "just continue" or something similar, then break out of the grilling and proceed.

