# Product Requirements Document (PRD) — Phase 1: Newspaper Sudoku MVP

## 1. Problem and Target Users
Sudoku games on mobile are often filled with distracting, flashy elements, animations, and ads, ruining the quiet, thoughtful atmosphere preferred by hardcore Sudoku enthusiasts.
*   **Target Users**: Hardcore Sudoku players who enjoy maximum challenge, prefer solving puzzles offline, use advanced puzzle logic, and value a distraction-free, paper-like tactile aesthetic.
*   **Platform**: Mobile only (iOS & Android).

---

## 2. Goals and Non-Goals
### Goals (Phase 1)
*   **High-fidelity self-contained puzzle generator**: An in-app, completely offline generator capable of producing unique, valid 9x9 Sudoku puzzles with single logical solutions.
*   **Human-like logical classification**: Ability to classify difficulty precisely by simulating human solving techniques (scanning, candidates, intermediate, advanced fish/wing strategies).
*   **Tactile newspaper aesthetic**: A high-end visual theme replicating paper textures, neat borders, precise print typography, and high contrast ink elements. Light mode only.
*   **Hardcore gameplay mechanics**: Strict difficulty configurations, limit on hints, specific mistake parameters, and professional pencil marking systems.
*   **Auto-save and Resume**: Never lose a game due to a crash, minimised app, or incoming call.

### Non-Goals (Future Phases)
*   User account system or cloud sync.
*   Competitive multiplayer or leaderboards.
*   Player statistics page (deferred to Phase 2).
*   Sound effects/soundtracks.
*   Dark mode (explicitly Light Mode only).

---

## 3. Core Functional Requirements

### A. Sudoku Generator & Classifier Engine
*   Generate true 9x9 Sudoku puzzles with a **guaranteed unique solution**.
*   Classify four distinct difficulty levels accurately using a human-like logical solver engine:
    *   **Easy**: Only basic scanning needed (Naked Single / Hidden Single). Clues remaining: 35–45. Playable without pencil marks.
    *   **Medium**: Requires candidate notes. Solved using Naked/Hidden Pairs or Pointing Pairs/Box-Line Reduction. Clues remaining: 30–34.
    *   **Hard**: Requires Naked/Hidden Triples/Quads. Clues remaining: 25–29.
    *   **Expert**: Requires advanced positional patterns / Fish strategies (X-Wing, Swordfish, XY-Wing) or unique configurations (Unique Rectangles, BUG, Chains). Clues remaining: 17–24.

### B. Hardcore Playability Mechanics
1.  **Pencil Marks / Notes**:
    *   Toggleable manual note mode to write mini-pencil marks (1-9) in any empty cell.
2.  **Mistake Limits**:
    *   **Easy**: 3 allowed mistakes.
    *   **Medium**: 2 allowed mistakes.
    *   **Hard**: 1 allowed mistake.
    *   **Expert**: 0 mistakes allowed (the very first invalid digit placement ends the game instantly).
3.  **Hint System**:
    *   Fills a selected cell with the correct answer.
    *   **Easy**: Maximum of 2 hints per game.
    *   **Medium**: Maximum of 1 hint per game.
    *   **Hard**: 0 hints (Hint button disabled).
    *   **Expert**: 0 hints (Hint button disabled).
4.  **Timer & Game Controls**:
    *   Timer tracking the solve time.
    *   Pause, Resume, and Reset buttons.

### C. Auto-save & Persistence
*   The game state (current puzzle values, solution grid, original clue grid, pencil marks, elapsed time, mistakes made, and hints used) is automatically written to local storage on every cell edit, note update, or exit.
*   Upon launching the app, if an incomplete game is found, it automatically prompts or resumes where the player left off.

---

## 4. Visual & UX Requirements
*   **Visual Direction**: Classic Newspaper Print (paper texture backgrounds, sharp black borders, high-quality serif/sans-serif combination for numbers, clean grid spacing).
*   **Styling & Design System**: Custom parameters applied via **Google Stitch MCP** to guarantee high-end, premium newspaper ink looks.
*   **Distraction-free Solving**: No unnecessary popups, banners, or flashing particles on solve. Only elegant, clean indicators.

---

## 5. Acceptance Criteria
*   The puzzle generator works entirely offline, taking less than 1.5 seconds to build even an Expert grid.
*   Difficulty is classified strictly based on the highest human-like solving technique needed.
*   Mistake limits strictly trigger game-over screens based on the chosen difficulty.
*   Notes are preserved and displayed elegantly in cells.
*   Closing the app at any point preserves the board, timer, and notes exactly as they were.
*   The hint button is dynamically disabled/enabled and keeps track of correct counters.
