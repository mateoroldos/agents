# Plan

A plan is what the user approves before code. Send it in the chat; it fits on one screen.

```text
Plan: <what someone can do once this lands>

What   <the behavior, concretely>
How    <the approach: the file you'll copy, or the one new idea>
Not    <what this leaves out>
Proof  <the test or command that will show it works>
PRs    <1, or a numbered list: one concern each, entry point last>

⚠️ Needs you: <question>. I recommend <answer>, because <reason>.
```

Example:

```text
Plan: agents create a human task with one HTTP call

What   POST /api/tasks with an org API key → 201 { id, url }
How    a SvelteKit +server.ts calling HumanTasks.create, like the task page's remote functions
Not    result webhooks (#52), MCP (#54), rate limits
Proof  tests: creates a task · rejects a revoked key; curl against dev
PRs    1. HumanTasks.create accepts an API-key actor
       2. POST /api/tasks, wired last

⚠️ Needs you: a task with no reviewer goes to the org owner? I recommend yes: no task is left unseen.
```

- The first line is what the user approves; they can stop there.
- One line per label. A label that needs a paragraph means the plan is too big: split it.
- Recommend one approach. Name an alternative only when the user must choose, inside ⚠️ Needs you.
- Delete ⚠️ Needs you when nothing waits on the user.
