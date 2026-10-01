# Service Review

Use this exhaustive branch for a codebase, package, feature slice, or diff. Apply the service test and module shape from [`SERVICES.md`](SERVICES.md).

## 1. Inventory

Find every Context service, tag, Layer, constructor, provide call, service-shaped interface, injected dependency, direct runtime capability, test implementation, and module mock.

For each candidate record:

| Field | Question |
| --- | --- |
| Owner | Which module owns the capability's meaning? |
| Interface | Where are its service contract and tag? |
| Construction | Where are dependencies acquired? |
| Production | Which adapter or module owns the concrete Layer? |
| Consumers | Do requirements propagate or get drilled/hidden? |
| Tests | Is its substitute honest and observable? |
| Verdict | Keep, deepen, relocate, merge, remove, or create? |

**Complete when:** every discovered service, tag, and Layer appears exactly once.

## 2. Trace requirements

Trace one public operation per candidate to every effect. Mark where each capability appears, is yielded, is passed as a value, and is concretely provided. Verify that the provider owns the implementation choice.

Look for drilled services, accepted Layers, dependency bags, local `provide` calls, ambient clocks/configuration/fetch/persistence, and service pieces scattered across unrelated owners.

**Complete when:** every requirement has an unbroken path from use to a truthful composition root or documented value boundary.

## 3. Classify

Classify each candidate as:

- built-in Effect capability;
- application-owned authority;
- technology adapter;
- request or domain value;
- framework boundary;
- pass-through abstraction.

Apply the deletion test and inspect existing capabilities before proposing another service.

**Complete when:** every candidate has one evidence-backed classification and no finding rests only on style.

## 4. Review tests

Classify each substitute as a complete static implementation, reusable stateful test service, faithful memory implementation, real local adapter, or local fixture. Compare its advertised contract with its behavior.

**Complete when:** every production service has an intentional test strategy or an explicit reason no substitute is needed.

## 5. Report

Prioritize correctness, hidden authority, ownership, and requirement visibility before naming or colocation. Each finding includes evidence, impact, the smallest target shape, composition/test consequences, and what remains unchanged. Include explicit keep decisions.

**Complete when:** every inventory row has a disposition and all speculative abstractions have been removed from the report.
