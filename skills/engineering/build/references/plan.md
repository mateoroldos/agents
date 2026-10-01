# Plan template

A plan lives at `plans/<name>.md` in the project repository and is deleted by its last pull request. Keep only the sections that carry a decision.

```markdown
# <Feature or bug, as the behavior>

Track: big feature | big fix [+ stakes] · Status: shaping | approved | building

<Two or three lines: the problem, who has it, and what "done" means.>

## Contract                    <!-- feature: from the shape-feature skill -->

- Scenarios: <concrete behavior, as the user sees it>
- Non-goals: <what this deliberately does not do>
- Constraints: <invariants that must hold>

## Diagnosis                   <!-- fix: from the diagnose skill -->

The reproduction, then symptom → cause → root, each with its evidence.

## Design

<The new or changed types and signatures, as code. One call stack per changed behavior.>

## Decisions

- <decision>: <choice> over <alternative> (<why>)
- Open: <question that blocks a change>

## Pull requests

### 1. <what trunk gains> · <technique> · ask | show

- [ ] `<change subject>`: <the behavior it adds, or for a tidy, the restructure>
  - Proof: types | test `<name>` (<level>) | app: <what to check> | review: <why that is enough>

PR: <URL, once opened>

### 2. <what trunk gains> · keystone · ask
```

Write each call stack with the real signature at the top and each failure beside the step that raises it:

```text
checkout(input: CheckoutInput): Promise<Result<Order, CheckoutError>>
  ├─ Inventory.reserve(input.lines) → Reservation
  │    └─ unavailable → OutOfStock
  ├─ Payments.authorize(input.total) → Authorization
  │    └─ declined → PaymentDeclined
  └─ Orders.place(reservation, authorization) → Order
```

A test not named in a change's proof lands only with a reason in the pull request description.
