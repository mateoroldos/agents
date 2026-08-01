---
name: show-me
description: Visual explanation. Use when the user asks for a diagram or when a flow, architecture, state model, UI structure, refactor, or comparison is clearer as a compact artifact than prose.
---

# Show Me

Show the current topic with the smallest visual that makes the important structure clear. Skip the preamble and use prose only for decisions, tradeoffs, or caveats the visual cannot express.

## Choose the view

- Logic or an algorithm → pseudocode.
- Runtime flow and failures → typed call stack.
- Files, components, or ownership → shallow tree.
- Existing versus proposed structure → diff.
- Options with shared criteria → table.
- Multi-party interaction → Mermaid.
- Copyable target shape → concrete code.
- Dense visual or UI concept → focused HTML.

### Logic

```text
on(save)
  if content is unchanged
    return cached result
  write content
  invalidate cache
  return fresh result
```

### Runtime and failures

Lead with the repository's actual or proposed signature:

```text
checkout(input: CheckoutInput): Promise<Result<Order, CheckoutError>>
  ├─ Inventory.reserve(input.lines) → Reservation
  │    └─ unavailable → OutOfStock
  ├─ Payments.authorize(input.total) → Authorization
  │    └─ declined → PaymentDeclined
  └─ Orders.place(reservation, authorization) → Order
```

### Ownership

```text
src/checkout/
├─ checkout.ts          # application policy
├─ inventory.ts         # owned port
└─ adapters/
   └─ stripe.ts         # payment translation
```

### Change

```diff
 checkout
-├─ chargeCard
-└─ saveOrder
+├─ reserveInventory
+├─ authorizePayment
+└─ placeOrder
```

Show the whole code block when most of it is new, omitted context would hide ownership or order, or the user needs a copyable target.

For HTML, load `design-engineering`, create one focused artifact, and open it with the available browser or review tooling. Use HTML only when text, code, or Mermaid cannot communicate the shape clearly.

## Restraint

- Use real names, paths, signatures, states, and data.
- Keep only the calls, boundaries, and details needed for the question.
- Prefer one visual. Use several only when they answer distinct questions.
- Place each visual next to the short text it supports; do not restate it.
- If a visual does not improve understanding, answer normally.
