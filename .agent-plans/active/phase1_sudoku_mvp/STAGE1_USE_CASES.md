# Product Use Cases — Phase 1: Newspaper Sudoku MVP

## Use Case 1: Start a New Game
*   **Actor**: Hardcore Sudoku Player
*   **Flow**:
    1.  User launches the app and is presented with a clean, classic newspaper-style home screen.
    2.  User selects "New Game".
    3.  User chooses a difficulty level: **Easy**, **Medium**, **Hard**, or **Expert**.
    4.  The generator executes offline, creating a valid board in under 1.5 seconds.
    5.  The game board displays with clues pre-filled (stylized like black printed ink) and blank cells ready for input.
    6.  The timer starts counting.

---

## Use Case 2: Enter Pencil Marks (Notes Mode)
*   **Actor**: Hardcore Sudoku Player
*   **Precondition**: Game in progress.
*   **Flow**:
    1.  User selects an empty cell.
    2.  User taps the "Pencil" or "Notes" icon to toggle Notes Mode ON.
    3.  User inputs digits 1–9.
    4.  Instead of filling the cell completely, the selected digits are displayed as small pencil marks inside the cell (supporting multiple notes per cell).
    5.  User toggles Notes Mode OFF, and entering numbers now performs standard cell filling.

---

## Use Case 3: Handle Invalid Placements (Mistake Rules)
*   **Actor**: Hardcore Sudoku Player
*   **Precondition**: Game in progress.
*   **Flow**:
    1.  User selects an empty cell and enters a digit that does not match the generated solution.
    2.  The cell displays an invalid indicator (stylized like an ink smudge or red marker, keeping within the newspaper print aesthetic).
    3.  The mistake count increases by 1.
    4.  **System checks mistake limit**:
        *   *Easy*: If mistakes reach 3, trigger Game Over.
        *   *Medium*: If mistakes reach 2, trigger Game Over.
        *   *Hard*: If mistakes reach 1, trigger Game Over.
        *   *Expert*: Game Over triggers immediately on the very first invalid placement (mistake limit = 0).
    5.  On Game Over, a modal or screen resembling a "Newspaper Correction Notice" is displayed, ending the session.

---

## Use Case 4: Utilize Limited Hints
*   **Actor**: Hardcore Sudoku Player
*   **Precondition**: Game in progress on Easy or Medium difficulty.
*   **Flow**:
    1.  User selects an empty cell and taps the "Hint" button.
    2.  **System checks limits**:
        *   *Easy*: Allowed up to 2 times. If count < 2, pre-fill cell with the correct solution digit, increment hint counter, and update UI.
        *   *Medium*: Allowed 1 time. If count < 1, pre-fill, increment, and disable Hint button.
    3.  If no hints remain, the button is locked.
    4.  On **Hard** and **Expert** difficulties, the Hint button is completely hidden or disabled from the start.

---

## Use Case 5: Auto-Save and Session Restoration
*   **Actor**: Hardcore Sudoku Player
*   **Precondition**: Game in progress.
*   **Flow**:
    1.  User is playing a game, has input 10 correct digits, 4 pencil marks, and made 1 mistake.
    2.  User closes the app, locks their screen, or receives a phone call.
    3.  The system automatically serialized and writes the current game state to local storage.
    4.  When the user re-opens the app, the app detects an active game state.
    5.  The board is fully restored, showing the exact board values, pencil marks, mistake count, hints used, and the timer resumes from the exact saved second.
