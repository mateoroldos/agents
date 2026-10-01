# Data and Schema

Use Schema for domain values and every untrusted boundary.

## Records

Our application default is a schema value plus a same-name interface when the installed version supports it:

```ts
export const User = Schema.Struct({
  id: UserId,
  name: Schema.NonEmptyString,
  email: Schema.optionalKey(Schema.String),
})

export interface User extends Schema.Schema.Type<typeof User> {}
```

Use the installed package's preferred class form when class behavior, annotations, or framework derivation makes it deeper than a plain record. Do not add a class merely to hold fields.

Annotate identifiers only when tooling consumes them: HTTP, RPC, OpenAPI, documentation, diagnostics, or code generation.

## Decode at boundaries

- Decode unknown request, response, event, row, and configuration values before application logic uses them.
- Keep decode failure in the typed error channel when it is an expected application outcome.
- Use synchronous throwing decoders only where throwing is intentional, such as a bounded startup path or test fixture.
- Never cast around decoding.
- Keep wire and persistence projections separate when their encoded shape or meaning differs from the domain.

Reuse schema fields only when contracts are semantically related. Use explicit mapping when translation, joins, defaults, or behavior are involved; field reuse must not become inheritance through one oversized schema.

## Optionality

Distinguish an absent key from a present key whose value is `undefined`. The exact Schema constructors have version-specific semantics; inspect every JavaScript construction and encoding site before changing one to the other.

- Model absent encoded keys as optional keys.
- Model explicit `undefined` only when it belongs to the contract.
- Keep normalized defaults required after decoding.
- Do not make domain values optional for construction convenience.

## Nominal values

Use constrained branded schemas for identifiers and scalar value objects that can be confused or constructed invalidly. Apply the real constraint before the brand. Callers construct through the schema, never a cast.

## Variants

Use the lightest representation that preserves the required behavior:

- Schema-backed tagged unions when values cross wire, storage, or tooling boundaries.
- Data tagged unions for internal control flow when no encoding or decoding is required.
- An external discriminator such as `type` or `kind` when the protocol owns that shape.

Match variants exhaustively. Do not add Schema solely to obtain constructors or pattern matching.

## Errors

Use the installed Schema-backed tagged-error constructor for errors that cross serialization boundaries or benefit from schema derivation:

```ts
export class PersistenceError extends Schema.TaggedError<PersistenceError>()(
  "UserRepo.PersistenceError",
  {
    operation: Schema.String,
    cause: Schema.Defect(),
  },
) {}
```

The constructor above matches Effect `4.0.0-rc.112`; verify it against the installed version. Plain Data tagged errors can remain appropriate for internal-only failures.

Keep failures specific, preserve safe context and causes, and preserve interruption when handling broad causes at runtime boundaries.
