# Plan template

A plan lives at `plans/<name>.md` in the project repository and is deleted by its last pull request. Keep only the sections that carry a decision.

````markdown
# <Feature or bug, as the behavior>

Track: big feature | big fix [+ stakes] · Status: shaping | approved | building · PRs: <merged>/<total>

<Two or three lines: the problem, who has it, and what users can do once the last pull request merges.>

## Needs you                    <!-- delete when empty -->

- <open question, or decision awaiting approval>: <your recommendation>

## Trunk path

What trunk holds after each pull request merges. Every row is releasable.

| PR | Trunk gains | Users see | Technique | Undo | Mode | Status |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | `Money` type and parser | nothing | additive | revert | show | merged #41 |
| 2 | new checkout behind `checkout_v2` | nothing, flag off | flag | revert | ask | open #42 |
| 3 | `checkout_v2` on | the new checkout | keystone | flag off | ask | |
| 4 | old checkout, flag, and this plan deleted | nothing | contract | revert | show | |

## Contract                    <!-- feature: from the shape-feature skill -->

- Scenarios: <concrete behavior, as the user sees it>
- Non-goals: <what this deliberately does not do>
- Constraints: <invariants that must hold>

## Diagnosis                   <!-- fix: from the diagnose skill -->

The reproduction, then symptom → cause → root, each with its evidence.

## Design

<One call stack per changed behavior, as a diff from today's, then the new or changed types as code.>

## Decisions

- <decision>: <choice> over <alternative> (<why>)

## Pull requests

### 1. <trunk gains>

- [ ] `<change subject>`: <the behavior it adds, or for a tidy, the restructure>
  - Proof: types | test `<name>` (<level>) | app: <what to check> | review: <why that is enough>
````

Techniques are those of [`releasable.md`](releasable.md). Undo is `revert`, another way back such as `flag off`, or what blocks a revert: a migration, a published API, data already sent.

Write each call stack with the real signature at the top and each failure beside the step that raises it:

```diff
 checkout(input: CheckoutInput): Promise<Result<Order, CheckoutError>>
-  ├─ chargeCard(input.total) → Charge
+  ├─ Inventory.reserve(input.lines) → Reservation
+  │    └─ unavailable → OutOfStock
+  ├─ Payments.authorize(input.total) → Authorization
+  │    └─ declined → PaymentDeclined
   └─ Orders.place(reservation, authorization) → Order
```

A test not named in a change's proof lands only with a reason in the pull request description.
