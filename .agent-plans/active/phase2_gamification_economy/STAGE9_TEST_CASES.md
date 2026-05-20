# Test Cases Catalog: Phase 2 — Stage 9: Advanced Gameplay & Economy Refinements

This document serves as the catalog of test cases for the Phase 2 — Stage 9 adjustments of the Sudoku project, detailing both manual validation and automated widget/unit test scenarios.

---

## 1. Automated Test Cases: Game Page Widget Tests (`test/features/sudoku/presentation/pages/game_page_test.dart`)

### TC_GAME_001: Expert Mode Hint Restriction
*   **Description**: Verify that attempts to use a logical hint in Expert mode are blocked and show a retro SnackBar.
*   **Action**: Start a quick play game on `'expert'` difficulty. Tap the "Hint" action button.
*   **Expected Outcome**: 
    *   No hint is applied to the cell (value is unchanged).
    *   A SnackBar is shown with text: `"Expert Edition: Logical hints are not permitted on Expert broadsheets."`

### TC_GAME_002: Difficulty-Based Hint Limit Cap
*   **Description**: Verify that the hint limit cap is strictly enforced per difficulty (Easy: 5, Medium: 4, Hard: 3).
*   **Action**: Start a game on `'hard'` difficulty. Tap Hint 3 times to consume the allowed hints. Tap Hint a 4th time.
*   **Expected Outcome**:
    *   The 4th hint is blocked.
    *   A SnackBar is shown with text: `"Logical Limit Reached: You can only use at most 3 hints on hard difficulty."` (case-insensitive checks, specifically matching the standard message format).

### TC_GAME_003: Hint Instant Purchase Dialog (0 Inventory)
*   **Description**: Verify that if a player has 0 hint tokens in inventory, tapping Hint pauses the game and displays the "OUT OF HINTS" confirmation dialog.
*   **Preconditions**: `EconomyState.hints = 0`, `EconomyState.balance = 100` droplets, active game is `'medium'`.
*   **Action**: Tap the "Hint" action button.
*   **Expected Outcome**:
    *   SudokuCubit timer is paused.
    *   A Dialog appears displaying `"OUT OF HINTS"` as the title.
    *   Content displays: `"Would you like to buy and use a logical hint instantly for 50 Droplets (💧)?"`
    *   Option A `"Buy & Use (50 💧)"` and Option B `"Cancel"` are rendered.

### TC_GAME_004: Hint Instant Purchase Success
*   **Description**: Verify that choosing "Buy & Use" deducts droplets, applies the hint, and resumes the timer.
*   **Preconditions**: `EconomyState.hints = 0`, `EconomyState.balance = 100` droplets, active game is `'medium'`.
*   **Action**: Tap Hint. In the `"OUT OF HINTS"` dialog, tap `"Buy & Use (50 💧)"`.
*   **Expected Outcome**:
    *   `spendDroplets(50)` (or droplet deduct) is triggered.
    *   A correct digit is revealed on the active cell.
    *   The dialog is closed and the game timer resumes.
    *   Droplet balance becomes `50` droplets.

### TC_GAME_005: Out of Hints Dialog with Insufficient Balance
*   **Description**: Verify that if the player has 0 hints and < 50 droplets, the "Buy & Use" option is disabled or shows insufficient funds.
*   **Preconditions**: `EconomyState.hints = 0`, `EconomyState.balance = 20` droplets, active game is `'medium'`.
*   **Action**: Tap Hint.
*   **Expected Outcome**:
    *   The dialog shows.
    *   The "Buy & Use (50 💧)" button is disabled or tapping it shows an alert, or the option is clearly marked as unavailable, so the user cannot proceed with a purchase.

### TC_GAME_006: Mistake Revive Dialog Interrupt (3rd Mistake)
*   **Description**: Verify that committing the 3rd mistake pauses the game and triggers the "THE PRESS OVERFLOWED" custom revive dialog.
*   **Preconditions**: `GameState.mistakesMade = 2`, `GameState.reviveUsed = false`.
*   **Action**: Enter an incorrect digit on the selected cell to trigger the 3rd mistake.
*   **Expected Outcome**:
    *   State `mistakesMade` becomes 3, and game timer is paused.
    *   A Dialog appears displaying `"THE PRESS OVERFLOWED: OUT OF MISTAKES"` as the title.
    *   The dialog offers: `"Would you like to use a Revive Token to retract one mistake and continue solving? (Limit: Once per game)"`
    *   Buttons: `"Use 1 Revive Token"`, `"Buy & Use Revive (500 💧)"`, and `"Accept Defeat"`.

### TC_GAME_007: Mistake Revive via Pre-owned Token
*   **Description**: Verify consuming a pre-owned token retracts the mistake and resumes the game.
*   **Preconditions**: Revive dialog is open. `EconomyState.revives = 2`, `EconomyState.balance = 100`.
*   **Action**: Tap `"Use 1 Revive Token"`.
*   **Expected Outcome**:
    *   `useReviveToken()` is called.
    *   `retractMistake()` is called on SudokuCubit (mistakes become 2/3, `reviveUsed` becomes `true`).
    *   The dialog closes, and the game timer resumes.
    *   State `revives` becomes `1`.

### TC_GAME_008: Mistake Revive via Droplet Purchase
*   **Description**: Verify purchasing a revive instantly retracts the mistake and resumes the game.
*   **Preconditions**: Revive dialog is open. `EconomyState.revives = 0`, `EconomyState.balance = 600`.
*   **Action**: Tap `"Buy & Use Revive (500 💧)"`.
*   **Expected Outcome**:
    *   `spendDroplets(500)` is triggered.
    *   `retractMistake()` is called (mistakes become 2/3, `reviveUsed` becomes `true`).
    *   The dialog closes, and the game timer resumes.
    *   Economy balance becomes `100` droplets.

### TC_GAME_009: Mistake Revive - Accept Defeat Flow
*   **Description**: Verify that clicking "Accept Defeat" triggers the standard failure Game Over dialog.
*   **Preconditions**: Revive dialog is open.
*   **Action**: Tap `"Accept Defeat"`.
*   **Expected Outcome**:
    *   The revive dialog closes.
    *   The standard `"PUZZLE FAILED"` Game Over screen appears, letting the player exit to home or restart.

### TC_GAME_010: Mistake Revive - Double Mistake Defeat
*   **Description**: Verify that if `reviveUsed` is already true, making a 3rd mistake immediately fails the game without showing the revive dialog.
*   **Preconditions**: `GameState.reviveUsed = true`, `GameState.mistakesMade = 2`.
*   **Action**: Enter an incorrect digit on the selected cell to trigger the 3rd mistake.
*   **Expected Outcome**:
    *   The revive dialog is NOT displayed.
    *   The standard `"PUZZLE FAILED"` Game Over dialog is displayed immediately.

### TC_GAME_011: Mistake Revive - Direct Defeat on Low Balance
*   **Description**: Verify that if the player has 0 revive tokens and < 500 droplets, making the 3rd mistake immediately fails the game without showing the revive dialog.
*   **Preconditions**: `GameState.reviveUsed = false`, `GameState.mistakesMade = 2`, `EconomyState.revives = 0`, `EconomyState.balance = 100` droplets.
*   **Action**: Enter an incorrect digit on the selected cell to trigger the 3rd mistake.
*   **Expected Outcome**:
    *   The revive dialog is NOT displayed.
    *   The standard `"PUZZLE FAILED"` Game Over dialog is displayed immediately.

---


## 2. Automated Test Cases: Campaign Page Widget Tests (`test/features/sudoku/presentation/pages/campaign_page_test.dart`)

### TC_CAMPAIGN_001: Vintage Newspaper TabBar Render
*   **Description**: Verify that the Campaign Page renders with a 3-tab custom printed newspaper TabBar.
*   **Expected Outcome**: 
    *   TabBar contains exactly 3 tabs: `"1456 GUTENBERG"`, `"1833 PENNY ERA"`, and `"1920 TIMES"`.
    *   Standard styling uses Georgia serif and thin horizontal printed dividers.

### TC_CAMPAIGN_002: Tab Switching Page Isolation
*   **Description**: Verify that tapping tabs isolates and renders the appropriate campaign volume levels without lag.
*   **Action**: Tap on the `"1833 PENNY ERA"` tab.
*   **Expected Outcome**:
    *   The `TabBarView` slides to display Volume 2 levels.
    *   First level displays `"ED. 1"` under Volume 2 seeds (base seed 2000).

### TC_CAMPAIGN_003: Locked broadsheet Reader Text Update
*   **Description**: Verify that tapping the locked volume reader button shows the updated SnackBar text.
*   **Preconditions**: Volume 1 Gutenberg has unsolved editions (incomplete).
*   **Action**: Tap `"VOLUME LOCKED"` reader button for Volume 1.
*   **Expected Outcome**:
    *   A SnackBar is displayed showing: `"Complete all 100 editions to unlock the Historical Front Page broadsheet reward (+500💧)."` (case-insensitive and formatted to 100 editions).

---

## 3. Automated Test Cases: Home Page Updates (`test/features/sudoku/presentation/pages/home_page_test.dart`)

### TC_HOME_001: Corrected English Greeting
*   **Description**: Verify that the homepage renders the correct greeting prefix in English.
*   **Preconditions**: Settings username is set to `"Sudoku Expert"`.
*   **Expected Outcome**: Text on homepage matches `"Hello Sudoku Expert"` (Xin chào greeting is removed).

---

## 4. Manual Verification Scenarios

### TC_MAN_001: Shop Ink & Fonts Integrity
*   **Steps**:
    1. Open settings page and verify custom font list is completely removed (Georgia is only option).
    2. Open Shop page and verify that `Classic Crimson` is gone.
    3. Verify that `Teal Cyan` is displayed as an unlockable ink option.
    4. Buy `Teal Cyan` and verify that the ink color renders custom player stamps and pencil marks in the gameplay grid with high-contrast vintage teal.
