# Reliability

Correctness includes what happens around the happy path: acquisition, cancellation, retries, duplicate delivery, diagnostics, and shutdown.

## Own resource lifetimes

Acquire and release files, connections, locks, subscriptions, workers, and temporary state in one visible scope. The module that starts background work owns its cancellation and cleanup. Do not start I/O at import time or hide process-wide mutable state inside an ordinary module.

Preserve cancellation when translating failures. Cleanup must run on success, expected failure, defect, and interruption.

## Make retries truthful

Retry only transient failures and only when repeating the operation is safe. Bound attempts or elapsed time and preserve the exhausted failure.

Every retried externally observable mutation needs an idempotency strategy:

- idempotency key;
- unique constraint;
- deduplication record;
- guarded state transition;
- transactional outbox or inbox.

Short technical retries belong to the adapter that understands the dependency. Application retries belong to the operation's policy. Crash-resilient retries belong to a durable workflow.

## Keep transactions bounded

Use transactions to protect one authoritative consistency boundary. Do not hold a database transaction open across network calls, long waits, or human interaction. Make cross-boundary progress explicit with state transitions, outboxes, compensation, or durable workflows.

## Parse configuration once

Read environment and configuration at startup, parse it into typed values, and inject what the application needs. Do not scatter environment reads through business logic. Treat malformed required configuration as a safe, diagnosable startup failure.

Wrap credentials and secrets in redacted values at the boundary. Unwrap only inside the adapter that must send them. Never place secrets in errors, logs, traces, tests, or snapshots.

## Make behavior diagnosable

Use structured logs and traces across application operations and external calls. Prefer stable fields:

- operation and dependency names;
- domain identifiers;
- state and error tags;
- retry counts and durations;
- safe summaries.

Observability is part of the behavior when operators depend on it. Renaming spans, removing fields, or changing expected failures from successful outcomes into defects can be a breaking change.
