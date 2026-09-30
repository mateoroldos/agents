# Modeling

Model the program's truths before its instructions.

```ts
declare const invite: (
  input: InviteMember,
) => Promise<Result<Invitation, AlreadyMember | MailUnavailable>>
```

The signature should reveal what enters, what leaves, what can fail, and which distinctions matter.

## Parse into meaning

Turn unknown, wire, storage, and configuration values into trusted application or domain values at their first owned edge:

```text
unknown → CreateUserRequest → CreateUserInput → EmailAddress
row     → UserRecord        → User
```

- A parser returns a refined value or a precise parse failure.
- A smart constructor builds a valid value from already typed pieces.
- A predicate answers a boolean question without claiming construction.
- A schema belongs at a trust boundary, not scattered through core logic.
- Keep protocol and persistence projections only when their shape or meaning truly differs.

Prefer `parseEmailAddress` over `validateEmail`: parsing preserves the stronger type it established.

## Construct valid values

Use branded or refined values when they prevent a realistic mistake:

```ts
type UserId = string & Brand<"UserId">
type OrgId = string & Brand<"OrgId">
type Milliseconds = number & Brand<"Milliseconds">
```

Brand identifiers that cross contexts or are easy to confuse. Keep a primitive when branding prevents no plausible misuse and centralizes no rule. Construction goes through a parser or smart constructor, never a caller cast.

Push optionality outward. A function that requires a value accepts the value, not `T | undefined`. Avoid `Partial<T>` unless partiality is itself the domain concept.

## Model states, not flags

Use a tagged union when fields or operations depend on lifecycle state:

```ts
type Invoice =
  | { readonly _tag: "Draft"; readonly lines: NonEmptyArray<LineItem> }
  | { readonly _tag: "Sent"; readonly sentAt: Instant }
  | { readonly _tag: "Paid"; readonly paidAt: Instant }
```

Consume tagged unions exhaustively. Prefer a `switch` with a `never` check, or an equivalent exhaustive matcher. Use a catch-all only when fallback behavior is part of the domain contract.

Avoid boolean parameters that hide behavior. Prefer a named domain choice:

```ts
sendInvitation(input, { notification: "skip" })
```

Booleans remain appropriate for predicates such as `isExpired`.

## Model failures

An expected failure is part of the output type. Give each failure enough structure for callers to decide, render, retry, and diagnose without parsing a message.

```ts
type FindUserError =
  | { readonly _tag: "UserNotFound"; readonly userId: UserId }
  | { readonly _tag: "UserStoreUnavailable"; readonly operation: "find"; readonly cause: unknown }
```

- Keep failure unions precise at module interfaces.
- Translate third-party rejection inside the adapter that understands it.
- Widen errors only at an entrypoint that must render several outcomes.
- Carry safe identifiers and operation labels; never secrets.
- Preserve the original cause when it helps diagnosis.

Within application-owned APIs, throw only for defects: impossible branches, violated internal invariants, or catastrophic runtime conditions. “The caller cannot recover” does not turn an expected failure into a defect. At a framework or library boundary whose contract is exception-based, honor that contract and translate exceptions at the nearest owned seam.
