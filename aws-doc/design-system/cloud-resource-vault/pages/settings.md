# Settings Page Override

> Overrides `../MASTER.md` for the Obsidian Settings modal only.

## Direction

- Reference: Chrome Settings / Google Material desktop preferences.
- Tone: calm, familiar, utilitarian, content-first.
- Density: compact desktop layout with 44px minimum interactive rows.
- Motion: state feedback only; no entrance or decorative animation.

## Tokens

| Role | Light | Dark |
| --- | --- | --- |
| Shell | `#F0F4F9` | `#1F1F1F` |
| Surface | `#FFFFFF` | `#282A2D` |
| Surface hover | `#E9EEF6` | `#34363A` |
| Primary | `#0B57D0` | `#A8C7FA` |
| Primary container | `#D3E3FD` | `#0842A0` |
| Text | `#1F1F1F` | `#E3E3E3` |
| Muted text | `#444746` | `#C4C7C5` |
| Group divider | `#DADCE0` | `rgba(255,255,255,.10)` |
| Control border | `#747775` | `#8E918F` |
| Danger | `#B3261E` | `#F2B8B5` |
| Focus | `#0B57D0` | `#A8C7FA` |

## Layout

- Modal: maximum `1160px × 760px`, 16px radius.
- Navigation: 264px desktop sidebar with pill-shaped active state.
- Content: 680px readable measure centered in the available pane.
- Setting groups: one 8px-radius surface card with row dividers; do not turn each row into a floating card.
- Settings rows: 48px single-line / 64px two-line rhythm with 20px horizontal inset.
- Search: 44px high tonal pill.

## Interaction

- Use existing Obsidian SVG icons; do not inject emoji or raster icons.
- Keep native Obsidian semantics and behavior; change presentation only.
- Show a 2px `:focus-visible` ring with 2px offset.
- Use 160ms color and shadow transitions; disable them for reduced motion.
- Reflow narrow desktop windows into stacked navigation/content below 600px; preserve Obsidian's native phone navigation.

## Anti-patterns

- No gradients, glass blur, exaggerated shadows, or decorative motion.
- No hidden focus rings or hover-only affordances.
- No remote font import; use the local system/Roboto stack.
- No selectors outside `.modal.mod-settings` unless required for the modal scrim.
