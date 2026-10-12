# Pull request

The title is the Conventional Commit subject. The description fits on one screen, in this order:

```markdown
<What changes for users, in one sentence.>

<Why: the problem it solves, in one or two lines.> Closes #<n>

    + <path>   <what it adds>
    ~ <path>   <what changes>

Look at: `<file>` `<symbol>`: <why it needs your eyes>
Verified: <command> · test `<name>` · <manual check>
⚠️ Not verified: <what, and why>
```

Example:

```markdown
Agents create human tasks with one HTTP call, using an org API key.

Agents can only reach Moku through the web app today; this is the first step of #46. Closes #51.

    + apps/web/src/routes/api/tasks/+server.ts      POST: key → HumanTasks.create → 201 { id, url }
    ~ packages/core/src/human-task/human-tasks.ts   create accepts an API-key actor

Look at: `+server.ts` `authenticate`: a revoked key must return 401 before any read.
Verified: `bun run check` · tests `creates a task`, `rejects a revoked key` · curl against dev
```

- The first line is the outcome; a reviewer can stop there.
- The file list shows only files a reviewer needs; for UI, a before and after screenshot instead.
- Look at only names lines worth a second read: signatures, security, tricky assertions. Delete it when there are none.
- Write ⚠️ Not verified only when it's true; never hide it below the fold.
- Don't restate the plan, the diff, or the commits.
