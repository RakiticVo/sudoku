# Implementation Plan: Phase 1 — Stage 4: Visual Style & UI Layout

This plan outlines the implementation of the premium "Newspaper Classic" visual style, responsive UI layout, and custom interactive assets for the Sudoku game. It prioritizes advanced screen aesthetics, responsive board scaling, micro-animations, and complete alignment with the user's aesthetic selections.

---

## 1. Applied Skills
*   **Using Agent Skills**: Adhering to the locked agent skill registry.
*   **Writing Plans**: Creating a decision-complete plan for the visual presentation layer.
*   **design-md**: Specifying visual properties (colors, typography, spacing, radius) as the project's source of truth.
*   **State Management Selection**: Using Cubit for predictable game state transitions.
*   **Testing Checklist**: Defining UI and Cubit test behaviors.

---

## 2. Visual Style & Aesthetic Intentions (Newspaper Classic)
*   **The Theme**: Warm, tactile printed paper aesthetic ("Newspaper Classic" / Cổ điển tinh tế). Feels like playing Sudoku in a premium, high-quality print newspaper, minimizing eye strain through soft warm tones instead of harsh white or dark displays.
*   **Color Palette**:
    *   *App Background*: `#FAF7F2` (Warm printed paper cream).
    *   *Card Backgrounds*: `#FFFFFF` (Bright paper white for containers/dialogs).
    *   *Grid Outer Border*: `#1E2022` (Bold dark charcoal ink, 3.5px thickness).
    *   *3x3 Sub-grid Borders*: `#5C5850` (Medium charcoal/sepia ink, 2px thickness).
    *   *Inner Cell Borders*: `#D6D0C2` (Muted fading sepia, 0.75px thickness).
    *   *Pre-filled Clues*: `#1E2022` (High-contrast dark charcoal ink, bold font).
    *   *User Placements*: `#2B6CB0` (Subtle elegant deep blue print ink, regular/medium font).
    *   *Invalid Cells*: `#C53030` (Muted crimson red ink, with subtle light-red warning background `#FFF5F5`).
    *   *Notes (Pencil Marks)*: `#718096` (Soft newsprint gray).
    *   *Active Selection*: Soft warm sepia cross-hair shade (`rgba(214, 208, 194, 0.35)` for row/col/box, and `rgba(214, 208, 194, 0.7)` for the active cell itself).
*   **Typography**:
    *   *Title and Headings*: Elegant Serif font (e.g. `Georgia`, `Lora` or system serif).
    *   *Cell Numbers*: High-contrast monospaced or classic serif numbers to maximize scanning efficiency and feel authentic to a printed paper puzzle.
    *   *Pencil Notes*: Small, clean sans-serif numbers (1-9) organized in a 3x3 mini-grid inside empty cells.

---

## 3. UI/UX Use Cases & Component States

### Use Case 1: Main Game View (`SudokuGridView` & `CellWidget`)
*   **Aspect Ratio Preservation**: The 9x9 board is strictly locked to a 1:1 aspect ratio. It dynamically scales to fit 100% of any viewport height or width (iOS, Android, Tablet, Web) without scrollbars or clipping.
*   **Cell Selection States**:
    *   *Idle Empty*: Soft white card background `#FFFFFF`.
    *   *Clue Cell*: Bold dark charcoal text. Non-tappable/immutable.
    *   *Selected Cell*: Accent sepia border glow, dark charcoal cursor.
    *   *Cross-hair Highlight*: Row, column, and 3x3 box containing the selected cell are shaded with the extremely subtle sepia tint.
    *   *Same-Value Highlight*: Selecting a cell with a placed value (e.g. `5`) highlights all other cells containing `5` with a soft blue-grey tint.
    *   *Notes/Pencil Marks*: Displayed in a tiny, perfect 3x3 numeric grid inside empty cells.

### Use Case 2: Game Controls & Input Panel (`ControlPad`)
*   **Action Keys Layout**: Located in the header area, on the top-right side above the main Sudoku grid, arranged in a compact, elegant horizontal bar. This ensures easy thumb access while keeping the area around the grid clean.
*   **Action Keys**:
    *   *Undo*: Elegant icon to revert the last move.
    *   *Eraser*: Elegant icon to clear user entries or notes.
    *   *Notes Mode*: Toggle button with an active tactile stamp indicator.
    *   *Hint*: Reveal the correct number for the selected cell (hidden on Hard/Expert to maintain difficulty standards).
*   **Keypad Layout**: Standard Row running horizontally underneath the Sudoku grid. Large, tactile stamped-paper keys.
*   **Completed Numbers**: Numbers that are fully completed (all 9 placed on the board) will show a subtle strike-through or pencil stamp icon, guiding logical scanning.

### Use Case 3: Home & Menu Screens (`HomeView` & `DifficultySelection`)
*   **Home View**: Elegant minimalist title screen.
*   **Difficulty Selection**: Tactile cards for "Beginner", "Medium", "Hard", "Expert", matching the human-like solver difficulty logic.

---

## 4. Main Files to Create/Modify
*   `lib/core/style/design_system.dart` — Newspaper Classic tokens and styles.
*   `lib/features/sudoku/presentation/widgets/sudoku_grid_view.dart` — 9x9 layout.
*   `lib/features/sudoku/presentation/widgets/cell_widget.dart` — Individual cells.
*   `lib/features/sudoku/presentation/widgets/control_pad.dart` — Keys & keypad.
*   `lib/features/sudoku/presentation/pages/game_page.dart` — Whole play screen layout.
*   `lib/features/sudoku/presentation/pages/home_page.dart` — Starting menu view.
