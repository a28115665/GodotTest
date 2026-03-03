# Battle UI Overflow Fix Design

## Problem

In the 320x288 viewport (web/WASM), battle action buttons (FIGHT/BAG/POKEMON/RUN) and move menu buttons overflow the bottom of the screen. The bottom UI area is 88px (y=196~284), and buttons at 22px height with theme padding exceed this space.

## Solution

### ActionMenu (FIGHT/BAG/POKEMON/RUN)

- Reduce button `custom_minimum_size.y` from 22 to 18
- Reduce StyleBox `content_margin_top/bottom` from 1 to 0
- Result: 4 x 18px = 72px < 88px available (16px margin)

### MoveMenu (move selection)

- Ensure ScrollContainer has `clip_contents = true`
- Reduce dynamically created button height from 22 to 18 (in `_apply_button_theme()`)
- Reduce StyleBox content margins to 0
- ScrollContainer handles any overflow (e.g., 5 buttons x 18px = 90px > 88px)

## Files Modified

| File | Change |
|------|--------|
| `scenes/battle/battle_scene.tscn` | Button min height 22→18, StyleBox margins 1→0 |
| `scripts/battle/battle_scene.gd` | `_apply_button_theme()` min height 22→18, margins 1→0 |
