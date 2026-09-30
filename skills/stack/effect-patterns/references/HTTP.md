# HTTP Clients

Use the installed Effect HTTP modules when their typed errors, Layers, interruption, and transforms improve an application adapter. The v4 HTTP surface may be unstable; verify every import and signature against installed guidance and source.

## Own the whole boundary

An HTTP adapter operation should:

1. construct the request;
2. attach authentication and headers;
3. execute with interruption support;
4. classify transport and status failures;
5. decode the response with Schema;
6. translate failures into application errors;
7. apply retry or rate-limit policy only when truthful.

Keep provider request and response types inside the adapter. Keep network calls outside authoritative database transactions.

## Choose retry by meaning

Use the installed HTTP client's transient retry support for transport failures and status codes it truthfully classifies. Use operation-level Effect retry when policy depends on domain errors, provider payloads, or application idempotency.

Do not assume every `408`, `429`, or `5xx` request can be repeated. The operation—not the status code—determines safety. Preserve the exhausted failure and provider evidence needed for diagnosis.

## Raw fetch is an adapter option

Raw `fetch` can remain appropriate for browser or edge constraints, platform transports, small isolated adapters, and libraries that intentionally avoid unstable Effect HTTP modules.

When using it:

- wrap it once with the installed Promise interop API;
- pass the cancellation signal to `fetch`;
- classify status before decoding a success body;
- decode unknown JSON with Schema;
- translate errors at the adapter seam;
- redact credentials and private payloads.

Do not replace a documented raw-fetch boundary merely for consistency. Verify its runtime, bundle, and platform constraints first.
