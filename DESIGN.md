# Product Design Specifications: Newspaper Classic Theme

This document defines the visual design system, UI design tokens, component behaviors, responsive constraints, and design rationale for the hardcore Sudoku game. It serves as the single source of truth for the presentation layer.

---

## 1. Design Philosophy: "Newspaper Classic" (Cổ điển tinh tế)
The design centers on high legibility, tactile warmth, and retro sophistication. Inspired by the morning newspaper ritual, the game uses soft cream colors and high-contrast charcoal print-ink typography to evoke the feeling of solving a high-quality paper Sudoku.

*Goal*: Minimize digital eye-strain during prolonged, highly logical solving sessions, while celebrating classic typography and clean line-art divisions.

---

## 2. Design Tokens

### 2.1 Color Palette (HSL & Ink Tones)
*   **App Background (`colorBackground`)**: `#FAF7F2` (Soft warm newspaper cream).
*   **Card/Surface Background (`colorSurface`)**: `#FFFFFF` (Bright crisp printed white paper).
*   **Grid Outer Border (`colorGridOuter`)**: `#1E2022` (High-contrast deep charcoal ink).
*   **3x3 Sub-grid Line (`colorSubgridBorder`)**: `#5C5850` (Medium charcoal/sepia ink).
*   **Inner Cell Line (`colorCellBorder`)**: `#D6D0C2` (Muted fading sepia).
*   **Pre-filled Clues (`colorTextClue`)**: `#1E2022` (High-contrast charcoal bold ink).
*   **User Numbers (`colorTextUser`)**: `#2B6CB0` (subtle premium deep print-blue).
*   **Invalid Placements (`colorTextInvalid`)**: `#C53030` (Muted ink-crimson).
*   **Invalid Background (`colorBgInvalid`)**: `#FFF5F5` (Soft warm warning pink/red).
*   **Pencil Notes (`colorTextNote`)**: `#718096` (Newsprint slate gray).
*   **Primary Highlights (`colorHighlightActive`)**: `rgba(214, 208, 194, 0.7)` (Faded ink-stamped selection block).
*   **Secondary/Crosshair Highlights (`colorHighlightCrosshair`)**: `rgba(214, 208, 194, 0.3)` (Subtle sepia guide tint).
*   **Same-Value Highlights (`colorHighlightSameValue`)**: `rgba(43, 108, 176, 0.08)` (Transparent blue wash).

### 2.2 Typography
*   **Main Title / Game Status Headers**: `Georgia` or standard system serif (Bold, high line-height, elegant styling).
*   **Cell Numbers (1-9)**: Mono-spaced or high-legibility serif digits to ensure they fill the cell box symmetrically without visual jitter or offsets.
*   **Pencil Notes**: Clean, highly readable sans-serif (e.g. system sans-serif like Roboto/Inter/Helvetica) scaled to `10sp` or smaller.

### 2.3 Spacing, Borders, and Radii
*   **Inner Padding**: `8.0`, `12.0`, `16.0` (Multiples of `4.0` as per modern layout frameworks).
*   **Grid Thicknesses**:
    *   *Outer Boarder*: `3.5`
    *   *Sub-grid (3x3)*: `2.0`
    *   *Inner lines*: `0.75`
*   **Border Radius**: High tactile crispness. Rounded edges are minimal (`4.0` for keys, `8.0` for cards, `0` for Sudoku cells) to align with traditional printed paper columns.

---

## 3. Responsive Constraints

*   **Aspect Ratio Preservation**: The 9x9 board is locked in an aspect ratio of `1:1`.
*   **Dynamic Scaling**:
    *   *Mobile (Portrait)*: The board takes up `90-95%` of screen width, centering itself horizontally. Action keys (Undo, Eraser, Notes Mode, Hint) are neatly aligned in the header area, on the top-right side directly above the Sudoku grid, while the horizontal number pad (Standard Row) is positioned underneath the grid. No vertical scrolling is allowed under any conditions.
    *   *Tablet / Desktop (Landscape)*: The board scales relative to the viewport height (e.g., maximum `80vh` or `80%` of screen height), leaving the control pads and metrics side-by-side or stacked on the right to optimize wider layouts.

---

## 4. Component Behaviors & Micro-Animations

*   **Selected Cell Cross-hair**:
    When a cell is tapped, a cross-hair grid is illuminated. The row, column, and box containing the selected cell receive the `colorHighlightCrosshair` color. The selected cell itself receives `colorHighlightActive` with a thin surrounding border.
*   **Keypad Row Interaction**:
    The keypad keys behave like paper-press stamps. Pressing down shrinks the key slightly (`scale(0.96)`) and transitions its background to a slightly darker warm grey/sepia.
*   **Same-Value Illuminate**:
    When the user selects a cell containing a number, all other cells containing the same number glow with `colorHighlightSameValue` to facilitate rapid pattern recognition.
