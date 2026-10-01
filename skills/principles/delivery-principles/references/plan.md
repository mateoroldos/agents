# Plan

A plan lives at `plans/<name>.md` and is deleted by its last pull request. It holds only what the pull requests depend on.

````markdown
# <The issue, as the behavior>

Issue: #<n>

> [!IMPORTANT]
> **⚠️ Needs you**              <!-- only what the next pull request needs; delete when empty -->
>
> - <question>: <your recommendation>

## Pull requests

| # | Trunk gains | Approach | Done |
| --- | --- | --- | --- |
| 1 | `Money`, used by the existing cart total | `src/cart/total.ts` | ✅ #41 |
| 2 | new checkout behind `checkout_v2`, off | design | |
| 3 | `checkout_v2` on, old checkout deleted | `src/flags/remove.ts` | |

## Design: PR <n>               <!-- the next pull request only; replaced by its Decided lines once merged -->

<The alternatives weighed, one line each with its cost, and the one chosen.>

<The call stack as a diff from today's, and the key types.>

| Test | Level | Fails if |
| --- | --- | --- |
| `<name>` | <level> | <the regression it catches> |

Sources: <precedent paths and official docs, pinned to the installed versions>

## Decided                      <!-- technical decisions; product ones stay in the issue -->

- <choice> over <alternative>: <why>
````

Approach is the precedent path you opened, or `design`. Write each call stack with the real signature on top and each failure beside the step that raises it:

```diff
 checkout(input: CheckoutInput): Promise<Result<Order, CheckoutError>>
-  ├─ chargeCard(input.total) → Charge
+  ├─ Payments.authorize(input.total) → Authorization
+  │    └─ declined → PaymentDeclined
   └─ Orders.place(authorization) → Order
```
