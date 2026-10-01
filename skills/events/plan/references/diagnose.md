# Diagnose a bug

Prove the cause before any fix.

1. **Reproduce** at whatever level does it: a `*.scratch.test.ts`, a script, or the running app. Done when it fails the same way every run, or you can say what it depends on.
2. **Trace** from trigger to failure, reading the logs and traces the project already emits before adding any. Done when you can show the call stack with the values at each step.
3. **Rank hypotheses**, each with the evidence for and against and the cheapest experiment that separates it. Run them likeliest and cheapest first, one variable at a time. Done when one cause explains every observation.
4. **Find the root:** why the cause was possible, such as a missing type, an unparsed boundary, shared state, or a rule with two owners. After two failed fixes on one premise, question the premise.
5. **Report** in the bug's issue: the reproduction, then symptom → cause → root, each with its evidence.
