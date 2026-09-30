# Landings

Group a plan's slices into landings that each leave `main` releasable. Pick the cheapest technique that does it; a plan often combines them.

| Technique | Use when | Landings |
| --- | --- | --- |
| **Tidy first** | the feature needs a restructure | The tidies land alone, first, usually as show. |
| **Additive** | the new code has no caller yet | Types, modules, and schema land before anything calls them. |
| **Keystone** | the feature has a user-facing entry point | Every landing before it is reachable only from tests. The **keystone** slice adds the route, command, or control, and goes in the last landing. |
| **Parallel change** | an interface, schema, or format changes incompatibly | Expand: support old and new. Migrate: move the callers, over as many landings as needed. Contract: delete the old. |
| **Branch by abstraction** | a module many callers use is being replaced | Put an abstraction over the old module and move callers to it; build the new one behind it; switch; delete the old. |
| **Flag** | a half-built feature must be tried in the running app | The flag guards the keystone only, never logic below it. The slice that deletes the flag is in the plan. |
