# Caching and Batching

Caching changes freshness, failure, memory, and resource semantics. Choose it from observed access behavior, not as a default optimization.

## Select the abstraction

```text
one effect result                           → Effect memoization
same key across calls                       → Cache
cached resources requiring cleanup          → scoped cache
many keys and a real backend batch endpoint → Request + RequestResolver
many keys but only per-item backend calls   → bounded concurrency
```

## Keyed caches

- Build the cache once in the owning Layer; a cache constructed per call caches nothing.
- Set a capacity and explicit lifetime.
- Use the library's shared in-flight lookup behavior rather than another deduplication map.
- Choose success and failure lifetimes by semantics: transient failures usually should not be cached; stable not-found results may tolerate short negative caching.
- Invalidate or refresh when the application has evidence that a value changed.
- Acquire expensive clients outside the lookup and close over them.

Prefer the installed Effect cache over a hand-built `Map`, timestamps, prune loop, and in-flight registry when its semantics fit. A documented isolate-local memo may remain valid when its runtime purpose differs.

## Batching

Request batching earns its machinery only when the backend can answer many keys in one operation, such as SQL `IN` or a batch endpoint. A resolver that loops over per-item HTTP calls is concurrency with extra abstraction; use bounded traversal, optionally behind a cache.

Test freshness, capacity-sensitive behavior when important, failure caching, invalidation, shared concurrent lookup, and resource cleanup through the owning module interface.
