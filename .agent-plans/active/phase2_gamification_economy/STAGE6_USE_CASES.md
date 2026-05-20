# Use Cases — Phase 2: Gamification, Economy, and Customization

This document details the functional behavior, user actions, and system flows for the advanced Phase 2 features.

---

## Use Case 1: Earning Ink Droplets & Purchasing Customizations
*   **Actor**: Player
*   **Preconditions**: Player has completed a Sudoku puzzle or Daily Challenge and has accumulated Ink Droplets (💧).
*   **Main Flow**:
    1.  Upon completing a Sudoku grid (e.g., Hard difficulty), the game displays a completion screen.
    2.  The system calculates the baseline reward (+50 💧) and displays a neat newspaper ink stamp animation showing `+50 💧 Earned`.
    3.  The player taps "Back to Menu" and opens **"The Newsstand" (Shop)**.
    4.  The system displays the list of locked and unlocked custom items (Fonts, Ink Colors, Stamps).
    5.  The player selects "Prussian Blue Ink" (costs 400 💧).
    6.  The system checks if the player's balance is $\ge$ 400 💧.
        *   If balance is sufficient, the system deducts 400 💧, unlocks the color permanently, and displays a classic Gutenberg Press seal stamp: *"UNLOCKED"*.
        *   If balance is insufficient, the purchase button remains disabled with a grayed-out ink status.
    7.  The player taps "Apply Style" to activate the new Prussian Blue Ink.
    8.  During any subsequent puzzle play, all player-inserted digits and selected crosshair highlights are rendered in the elegant Prussian Blue color scheme.

---

## Use Case 2: Progressing through Campaign Mode & Unlocking Big Historical Rewards
*   **Actor**: Player
*   **Preconditions**: Player opens "The Editorial Journey" (Campaign Mode).
*   **Main Flow**:
    1.  Player enters **"The Editorial Journey"** screen.
    2.  The system renders three scrollable Newspaper Volumes:
        *   *Volume 1: The Gutenberg Era* (100 Puzzles)
        *   *Volume 2: Fleet Street Chronicles* (100 Puzzles)
        *   *Volume 3: Codebreakers & Cryptography* (100 Puzzles)
    3.  The player selects *Volume 1* and enters the level selection board (grid of numbers 1 to 100, styled like classical typesetting lead blocks).
    4.  Player plays and completes the 100th level of the Volume.
    5.  Upon solving, the system displays the standard completion screen alongside a grand notification: **"Volume 1 Complete! Printing Special Historical Edition..."**
    6.  The system opens **"The Gutenberg Gazette Special Edition"**:
        *   A beautifully simulated physical newspaper page dated *August 24, 1456*.
        *   The headline reads: **"GUTENBERG PRESS PRINTS FIRST LATIN BIBLE!"**
        *   An interactive, beautifully typeset educational article explains the history of Johann Gutenberg, moveable metal type, and its impact on human knowledge.
        *   The article is unlocked permanently in the player's personal collection room.
    7.  The player is awarded a grand completion reward of **+500 Ink Droplets** (💧).

---

## Use Case 3: Selective Archiving for Replay Saves (Memory-Optimized)
*   **Actor**: Player
*   **Preconditions**: Player has solved a standard puzzle or Daily Challenge.
*   **Main Flow**:
    1.  The puzzle is successfully solved. The screen shows the final time, accuracy statistics, and Ink Droplets reward.
    2.  The system displays a prompt: **"File this puzzle in The Press Archives for future replay? [Save / Skip]"** with a memory footprint warning: *"Requires ~5 KB local storage"* to keep players aware.
    3.  If the player selects **Skip**:
        *   The system discards the detailed action history log from memory, saving only the basic statistics (date, time, difficulty, win status) to keep DB sizes minimal.
    4.  If the player selects **Save**:
        *   The system packs the chronological action array (`List<BoardMove>`) including cell tap timestamps, note toggles, digit entries, errors, and undos.
        *   The system compresses this payload into a single structured JSON string.
        *   The system saves it into the local database under `press_archives` table.
        *   The button displays an ink-stamped checkmark: *"Archived Successfully"*.
    5.  Later, the player goes to the HomePage, enters **"The Press Archives"**, selects this archived solve, and triggers **"Replay Solve"**.
    6.  The board opens in read-only mode with a media-bar style timeline (Play, Pause, Step Forward, Step Backward, Speed slider) allowing the user to watch their exact solving process.

---

## Use Case 4: Setting up Dark Newsprint Mode & Clean-up Room
*   **Actor**: Player
*   **Preconditions**: Player enters the "Press Room" (Settings).
*   **Main Flow**:
    1.  The player opens **"Settings"** from the top right corner of the HomePage.
    2.  The system displays settings options in a structured editorial ledger layout.
    3.  The player toggles **"Dark Newsprint"** mode.
    4.  The system instantly shifts all warm cream colors (`#FAF7F2`) to deep aged slate charcoal (`#1E2022`), and all dark charcoal ink colors (`#1E2022`) to soft vintage newsprint white (`#F0EAE1`). This provides a highly premium and eye-friendly dark aesthetic.
    5.  The player taps **"Manage Storage"**.
    6.  The system shows a calculation: *"Archived Replays: 12 Solves (~60 KB)"*.
    7.  The player taps **"Purge Archives"**.
    8.  The system prompts: *"Are you sure you want to delete all 12 replay logs? This cannot be undone."*
    9.  Upon confirmation, the system purges the `press_archives` table, freeing up local memory instantly.
