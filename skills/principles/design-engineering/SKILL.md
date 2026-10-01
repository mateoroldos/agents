---
name: design-engineering
description: UI polish, component feel, and motion. Use when building or reviewing UI, or deciding whether and how something animates: easing, duration, transitions, gestures, or jank.
---

# Design Engineering

Emil Kowalski's design engineering: unseen details compound into an interface that feels right, and in software that is good enough, taste is the differentiator.

## Review in a table

Report UI review findings as one table with `| Before | After | Why |` columns, one row per finding, never as Before/After lines.

## Should it animate?

| How often users see it | Decision |
| --- | --- |
| 100+ times a day: keyboard shortcuts, command palette | No animation |
| Tens of times a day: hover, list navigation | Remove or drastically reduce |
| Occasionally: modals, drawers, toasts | Standard animation |
| Rarely: onboarding, celebrations | Room for delight |

Never animate a keyboard-initiated action.

Every animation needs a purpose: spatial consistency, state indication, explanation, feedback, or avoiding a jarring change. "It looks cool" on something seen often is not one.

## How it moves

- Enter and exit with a strong custom ease-out; never ease-in for UI.
- Keep UI animations under 300ms; exits faster than entrances.

## Chooser

Read the references that match the task.

- Picking an easing curve, deciding a duration, or animating a pair of elements that must agree: read [`references/EASING.md`](references/EASING.md).
- Building or reviewing a button, popover, tooltip, dropdown, toast, or any entering/exiting component; stagger: read [`references/COMPONENTS.md`](references/COMPONENTS.md).
- Springs, CSS transforms, clip-path reveals, or drag and gesture interactions: read [`references/MOTION.md`](references/MOTION.md).
- Jank, dropped frames, hardware acceleration, reduced motion, touch devices, or debugging an animation that looks wrong: read [`references/PERFORMANCE.md`](references/PERFORMANCE.md).

## Review Checklist

When reviewing UI code, check for:

| Issue                                      | Fix                                                              |
| ------------------------------------------ | ---------------------------------------------------------------- |
| `transition: all`                          | Specify exact properties: `transition: transform 200ms ease-out` |
| `scale(0)` entry animation                 | Start from `scale(0.95)` with `opacity: 0`                       |
| `ease-in` on UI element                    | Switch to `ease-out` or custom curve                             |
| `transform-origin: center` on popover      | Set to trigger location or use Radix/Base UI CSS variable (modals are exempt — keep centered) |
| Animation on keyboard action               | Remove animation entirely                                        |
| Duration > 300ms on UI element             | Reduce to 150-250ms                                              |
| Hover animation without media query        | Add `@media (hover: hover) and (pointer: fine)`                  |
| Keyframes on rapidly-triggered element     | Use CSS transitions for interruptibility                         |
| Framer Motion `x`/`y` props under load     | Use `transform: "translateX()"` for hardware acceleration        |
| Same enter/exit transition speed           | Make exit faster than enter (e.g., enter 2s, exit 200ms)         |
| Elements all appear at once                | Add stagger delay (30-80ms between items)                        |
