---
name: write-skill
description: Create, edit, review, or classify an agent skill. Use when writing or changing a SKILL.md, deciding whether a lesson or correction should become a skill, or when a skill misfires.
metadata:
  family: workflow
---

# Write a Skill

A skill is the one home of a recurring opinion, loaded when a task needs it. It earns its place only by changing a decision: without it the agent does X, with it the agent does Y. Fewer, sharper skills beat more skills; fewer, sharper lines beat more lines.

## 1. Start from a failure

Name the real session, correction, or review finding the skill fixes, and write its X → Y in one line.

Route it elsewhere when it is:

| It is | It belongs in |
| --- | --- |
| Needed on every task | the global AGENTS.md |
| A fact about one project | that project's AGENTS.md, docs, or code |
| Enforceable by a machine | a type, lint rule, test, script, or hook, with no text |
| A one-off, or already the model's default | nowhere |
| Covered by an existing skill | an edit to that skill |

Done when X → Y comes from observed behavior and none of the rows above fits.

## 2. Classify

Pick one family. A skill that mixes families rots unevenly, so a workflow that needs a principle names the principle skill instead of restating it.

| Family | Holds | Wrong when | Named as |
| --- | --- | --- | --- |
| principle | how we judge: named rules | taste changes | `<topic>-principles` |
| workflow | how we do a task: steps to a deliverable | the process changes | a verb: `shape-feature` |
| knowledge | how one technology realizes our principles | the technology ships | the technology: `effect-patterns` |

Pick its category: the topic directory in the skill repo, such as `engineering`, not its family. A project skill lives in that project's `.agents/skills/`.

Make it model-invoked when the agent must reach it unprompted or another skill must reach it; its description then costs context on every turn. Otherwise set `disable-model-invocation: true` and invoke it by name.

Done when family, category, invocation, and name are chosen.

## 3. Draft

```text
<name>/
  SKILL.md       frontmatter: name, description, metadata.family; target ≤ 100 lines
  references/    what only some uses need, one level deep
  scripts/       deterministic work the agent runs instead of reasoning through
```

A model-invoked description says what the skill does, then "Use when" with one trigger per distinct situation, in the words the user types. A user-invoked description is one line for a human.

Body by family:

- **principle:** a `##` heading per named rule, then the rule as one imperative line, **Why** in one line, **Smell** (what a violation looks like), and **Check** (the mechanism that could enforce it, if any).
- **workflow:** numbered steps, each ending in "Done when" with a condition the agent can observe, then the deliverable.
- **knowledge:** the version and the source of truth, a rules table in which each rule names the principle it realizes, and pointers to the official docs.

Taste belongs to the user. For a principle skill, interview them one question at a time and keep their words. Draft only what they confirmed or what the observed failure shows.

Done when every line passes the taste rules.

## 4. Test

Give a fresh session a realistic request, once with the skill and once without it (or with the old version). Phrase the request as a user would, without naming the skill or the test. Compare what each session did, not how its answer reads.

Done when X → Y appears and nothing else regressed. If you could not run the comparison, report the skill as unverified.

## 5. Prune and register

Apply the taste rules once more and delete what fails. Credit adapted work where the repo records origins. Run the repo's validation.

Done when validation passes and the report names the failure, the classification, and the test result.

## Taste

1. **Every line changes a decision.** Test each sentence alone; delete a sentence that fails rather than rewording it.
2. **Command, don't justify.** A principle gets one line of why; a step gets none.
3. **Name it.** A precise, familiar word (_slice_, _red_, _tight_) carries a behavior in one token. Reuse it until it is the skill's vocabulary.
4. **One home per meaning.** Point to another skill by name; never restate it.
5. **Show, don't narrate.** Prefer a table, tree, signature, or example to a paragraph.
6. **Structure over text.** When a check can enforce a rule, build the check and delete the rule.
7. **Disclose by use.** Inline what every use needs. Move what only some uses need to `references/<topic>.md`, behind a pointer that says when to read it.
8. **Small.** A skill does one job. A skill that keeps growing is two skills, or one skill and a reference.

## Diagnose

| Symptom | Cause | Fix |
| --- | --- | --- |
| Doesn't fire | the description lacks the user's words | rewrite the triggers |
| Fires on the wrong tasks | a trigger is too broad | narrow it, or make the skill user-invoked |
| Steps skipped or finished early | a vague "Done when" | sharpen the condition; if the rush persists, split off the later steps |
| A rule is ignored | the model already does it, or the wording is weak or buried | delete it, use a stronger word, move it up, or make it a check |
| Contradicts another skill | the same meaning lives in two homes | keep one home |
| Stale lines | nobody prunes | delete each line that no current failure justifies |
