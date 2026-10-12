# Scheduling

Use `Schedule` when retrying failures, repeating successes, polling, pacing, or backing off.

## Choose the policy first

```text
typed failure may be attempted again → retry
successful operation should run again → repeat
values arrive over time               → Stream
progress must survive process loss    → durable workflow
```

- Retry only failures classified as transient by the boundary that understands them.
- Repeat only when another successful pass is meaningful.
- Bound retries by attempts, elapsed time, or both.
- Add jitter to distributed backoff to avoid synchronized storms.
- Preserve the exhausted error unless a truthful fallback exists.
- Confirm how the installed Schedule counts the initial run and recurrences.

## Polling workers

Model one pass first, including its typed failures and observable result. Then repeat that pass on a Schedule. Handle expected pass failures before repetition only when “report and continue” is the declared worker policy; defects and interruption should still reach supervision.

For item batches, isolate an item's expected failure only when skipping or retrying that item later is truthful. Bound concurrency explicitly.

## Provider delays and rate limits

When an error carries a server-directed retry delay, combine it with local backoff by choosing the safer delay. Keep this policy near the provider adapter. Use HTTP-client retry only for transport semantics; use operation-level retry when domain idempotency or provider payloads determine safety.

## Timeouts and sleeps

- Add a timeout only when the operation has a real deadline and callers understand the resulting failure.
- Delay when one operation intentionally starts later.
- Sleep only when waiting is part of the workflow.
- Do not build recurrence with manual sleep loops when Schedule expresses it.
- Use `TestClock`, never real delay, in tests.

Adding or removing timeout or retry changes failures and latency. Treat it as behavior, not cleanup.
