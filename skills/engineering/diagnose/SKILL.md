---
name: diagnose
description: Find a bug's root cause with evidence before fixing it. Use when a bug is not yet understood, such as when it won't reproduce reliably, has more than one plausible cause, spans modules, or survived an earlier fix.
metadata:
  family: workflow
---

# Diagnose

A fix is only as good as the cause it targets. Change no product code until the cause is proven.

## 1. Reproduce

Make the failure happen on demand at whatever level does it: a `*.scratch.test.ts`, a script, or the running app. Record the exact steps and input, and what you observed versus what you expected.

Done when it fails the same way on every run, or you report what it depends on (timing, data, environment) and how often it fails.

## 2. Gather evidence

Trace the path from trigger to failure, and read the runtime evidence the project already emits (logs, traces) before adding temporary instrumentation.

Done when you can show that call stack with the values observed at each step.

## 3. Rank hypotheses

List each plausible cause with the evidence for and against it, and the cheapest experiment that would separate it from the others. Run the experiments cheapest and likeliest first, changing one variable at a time.

Done when one cause explains every observation and an experiment, not an argument, rules out each of the others.

## 4. Find the root

Ask why the cause was possible: a missing type, an unparsed boundary, shared state, a rule with two owners. The root is what, once fixed, prevents the whole class of bug. When two fixes built on the same premise have failed, question the premise instead of writing a third.

Done when you can state symptom → cause → root, each with its evidence.

## 5. Plan the fix

Write `plans/<name>.md` in the plan format of the `build` skill. When the bug passes the gate of the `audit-tests` skill for a regression test, the fix's slice carries one, at the owner boundary, that fails on the code before the fix for this cause.

Done when the plan's diagnosis and slices are ready for the user's approval.
