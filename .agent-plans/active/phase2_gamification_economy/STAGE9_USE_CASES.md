# Use Cases — Phase 2: Stage 9 (Advanced Gameplay & Economy Refinements)

This document details the functional behavior, user actions, system inputs, and step-by-step flows for the advanced Stage 9 gameplay and economic adjustments.

---

## Use Case 1: decluttered HomePage & Personalized Greeting
*   **Actor**: Player
*   **Preconditions**: Player has set their username in the "Press Room" (Settings) to "Alice".
*   **Main Flow**:
    1.  The player opens the app or returns to the home page from the game session.
    2.  The system renders the home screen.
    3.  The system reads the persistent username from settings (`'Alice'`) and dynamically prints the welcoming greeting in the top-left corner: **"Hello Alice"** (replacing `"Xin chào, Alice"`).
    4.  The system renders the list of feature cards ("PLAY QUICK EDITION", "THE EDITORIAL JOURNEY", "THE DAILY EDITION", "THE PRESS ARCHIVES") sequentially.
    5.  The system omits the horizontal dividers and category text labels (`"QUICK PLAY"` and `"SPECIAL EDITIONS"`), rendering a sleek, highly premium, unified print broadsheet without visual grid clutter.

---

## Use Case 2: Newsstand Purchases & Wallet Restrictions (Hints & Revives)
*   **Actor**: Player
*   **Preconditions**: Player opens the "Newsstand" (Shop) and has accumulated Ink Droplets (💧).
*   **Main Flow**:
    1.  The player views the shop inventory. The system presents locked and unlocked aesthetic collections (Inks, Stamps) alongside a new **"Gameplay Utilities"** section.
    2.  The system displays the **Logical Hint** card showing:
        - Price: `50 💧`
        - Current Wallet: `X / 50`
    3.  The player taps **"Buy"**.
    4.  If the player's wallet is already at `50 / 50` hints:
        - The purchase button is **disabled** and displays `'MAX 50'`.
    5.  If wallet capacity is $\le 49$ and balance $\ge 50 💧$:
        - The system deducts 50 droplets, increments the player's Hint Wallet count by 1, and saves it to SharedPreferences (`economy_hints`).
    6.  The player views the **Revive Token** card showing:
        - Price: `500 💧`
        - Current Wallet: `Y` (no maximum carrying cap).
    7.  The player taps **"Buy Revive"**.
    8.  If droplets balance is $\ge 500 💧$:
        - The system deducts 500 droplets, increments the player's Revive Token Wallet by 1, and saves it to SharedPreferences (`economy_revives`).

---

## Use Case 3: In-Game Logical Hints with Difficulty Cap Constraints
*   **Actor**: Player
*   **Preconditions**: Player is in an active Sudoku game session.
*   **Main Flow**:
    1.  The player selects an empty cell and taps the **Hint** (💡) action button on the control panel.
    2.  The system checks the puzzle's difficulty level to verify the game session cap:
        - **Easy**: Max 5 hints allowed
        - **Medium**: Max 4 hints allowed
        - **Hard**: Max 3 hints allowed
        - **Expert**: 0 hints allowed (Expert has absolute logic restriction).
    3.  If the player is in an **Expert** game:
        - Tapping the Hint button shows a snackbar message: `"Expert Edition: Logical hints are not permitted on Expert broadsheets."` and does not reveal the cell.
    4.  If the player has already reached the maximum hints allowed in the current session (e.g. 3/3 hints on Hard):
        - Tapping the Hint button shows a snackbar message: `"Logical Limit Reached: You can only use at most 3 hints on Hard difficulty."`.
    5.  If the hint count is within the difficulty cap:
        - The system checks if the player's Hint Wallet has $\ge 1$ tokens:
          - **Case A (Has token)**: The system decrements the persistent Hint Wallet by 1, increments `hintsUsed` in the active game state by 1, and reveals the selected cell's correct digit.
          - **Case B (0 tokens)**: The system pauses the game timer and displays a vintage confirmation popup:
            - `"OUT OF HINTS. Would you like to buy and use a logical hint instantly for 50 Droplets (💧)?"`
            - **Button A (Buy & Use (50 💧))**: Enabled if player has $\ge 50 💧$. Deducts 50 droplets, increments `hintsUsed` by 1, reveals the cell, and closes the popup.
            - **Button B (Buy & Use (50 💧))**: **Disabled and grayed out** if player has $< 50 💧$.
            - **Button C (Cancel)**: Closes the popup and resumes the game without revealing the cell.

---

## Use Case 4: The In-Game "Revive / Buy Mistake" Recovery Flow
*   **Actor**: Player
*   **Preconditions**: Player is playing a puzzle and makes their 3rd mistake (e.g., `mistakesMade` changes from 2 to 3, matching `maxMistakes`).
*   **Main Flow**:
    1.  The player stamps a wrong digit onto the grid.
    2.  The system increments mistakes to 3/3.
    3.  The system checks if the player is eligible to revive:
        - If the player has **0 pre-purchased Revive Tokens** in inventory AND has **less than 500 droplets**, the system **directly triggers the standard Game Over/Defeat screen** without showing the revive dialog.
        - If the player has already used a Revive in this game session (state tracks `reviveUsed == true`), the system **directly triggers the standard Game Over/Defeat screen**.
        - Otherwise, the system pauses the game timer and interrupts the screen with a beautiful custom dialogue: **"THE PRESS OVERFLOWED: OUT OF MISTAKES"**.
    4.  The system displays the recovery options:
        - `"Would you like to use a Revive Token to retract one mistake and continue solving? (Limit: Once per game)"`.
        - Button A: `"Use 1 Revive Token"` (only active if persistent wallet `economy_revives` $\ge 1$).
        - Button B: `"Buy & Use Revive (500 💧)"` (only active if wallet is 0 and droplets balance $\ge 500$).
        - Button C: `"Accept Defeat"` (exits game, counts as a loss).
    5.  If the player selects to Revive (using an inventory token or purchasing one for 500 💧):
        - The system deducts the token (or 500 droplets), updates the active state mistakes to `2/3`, marks the game session's `reviveUsed` as `true`, closes the dialogue, resumes the game timer, and allows the player to continue playing.

---

## Use Case 5: Restructured Campaign Progression & Escalation
*   **Actor**: Player
*   **Preconditions**: Player enters "The Editorial Journey" (Campaign Mode).
*   **Main Flow**:
    1.  The player selects one of the 3 theme broadsheets: *Volume 1: The Gutenberg Press* (100 levels).
    2.  The system renders the TabBar and isolated volume subpages, fully supporting horizontal swipes and gestures to switch between historical Volumes.
    3.  The player views the levels, which are unlocked sequentially:
        - **Levels 1 - 25**: **Easy** difficulty (allowing beginners to adapt to the volume's theme).
        - **Levels 26 - 60**: **Medium** difficulty (gradually introducing complex intersections).
        - **Levels 61 - 90**: **Hard** difficulty (requiring advanced pencil mark scans and candidates cleanup).
        - **Levels 91 - 100**: **Expert** difficulty (the ultimate typographic gauntlet, permitting zero hints).
    4.  The player completes level 100 of the volume.
    5.  The system checks completion, awards the volume's grand droplets reward (e.g., `+500 💧`), and permanently unlocks the historic era broadsheet reader, allowing the player to inspect their special commemorative edition.
