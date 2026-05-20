# Test Cases Catalog: Phase 2 — Stage 8: Refinements & Testing Suite

This document serves as the catalog of test cases for the Phase 2 — Stage 8 improvements of the Sudoku project, detailing both manual validation and automated unit/widget/integration test scenarios written in Dart.

---

## 1. Settings Cubit Test Cases (`test/features/sudoku/presentation/cubit/settings_cubit_test.dart`)

### TC_SETTINGS_001: Initial State Profile Defaults
*   **Description**: Verify that the SettingsState initializes with the correct default values before any SharedPreferences exist.
*   **Expected Outcome**: Default username is `User`, font family is `Georgia`, ink color is `Charcoal`, stamp style is `Classic`, and `isDarkNewsprint` is `false`.

### TC_SETTINGS_002: Load Saved Profile & Username
*   **Description**: Verify that `loadSettings` correctly reads user preferences and custom publisher name from database/SharedPreferences storage.
*   **Input**: Mock SharedPreferences containing:
    *   `settings_username` -> `"Master Solver"`
    *   `settings_fontFamily` -> `"Garamond"`
    *   `settings_isDark` -> `true`
*   **Expected Outcome**: State successfully loads and matches all saved preferences, displaying `"Master Solver"` as the active username.

### TC_SETTINGS_003: Update Publisher Username
*   **Description**: Verify that `setUsername` saves the updated publisher name to SharedPreferences and emits the correct state.
*   **Input**: Invoke `setUsername("Grandmaster Sudoku")`.
*   **Expected Outcome**: State updates to `"Grandmaster Sudoku"` and writes `"Grandmaster Sudoku"` to SharedPreferences at key `settings_username`.

### TC_SETTINGS_004: Toggle Dark Newsprint Mode
*   **Description**: Verify that toggle dark mode successfully saves to storage and updates state.
*   **Input**: Call `toggleDarkNewsprint(true)`.
*   **Expected Outcome**: State `isDarkNewsprint` becomes `true` and key `settings_isDark` is written to SharedPreferences.

---

## 2. Economy Cubit Test Cases (`test/features/sudoku/presentation/cubit/economy_cubit_test.dart`)

### TC_ECONOMY_001: Initial Balance & Defaults
*   **Description**: Verify that economy starts with default balance and default unlocked list.
*   **Expected Outcome**: Balance is exactly `100` droplets, unlocked font list contains `['Georgia']`, and unlocked ink list contains `['Charcoal']`.

### TC_ECONOMY_002: Add Droplet Rewards
*   **Description**: Verify that earning droplets correctly increases balance and writes to database.
*   **Input**: Invoke `addDroplets(250)`.
*   **Expected Outcome**: State balance increases to `350` droplets and saves to SharedPreferences.

### TC_ECONOMY_003: Spend Droplets
*   **Description**: Verify that spending droplets decreases the wallet balance if affordable.
*   **Input**: Call `spendDroplets(50)`.
*   **Expected Outcome**: Returns `true`, balance decreases to `50` droplets, and saves to SharedPreferences.

### TC_ECONOMY_004: Unlock Font Item
*   **Description**: Verify that unlocking a premium font correctly spends droplets and updates the list of unlocked fonts.
*   **Input**: Call `unlockFont("Courier New", 50)`.
*   **Expected Outcome**: Returns `true`, balance decreases from `100` to `50`, and `Courier New` is added to `unlockedFonts`.

### TC_ECONOMY_005: Unlock Unlocked Font (Free Action)
*   **Description**: Verify that attempting to unlock a font that is already owned has zero droplet cost and returns true.
*   **Input**: Call `unlockFont("Georgia", 50)`.
*   **Expected Outcome**: Returns `true` instantly, balance remains `100` droplets (no charge).

### TC_ECONOMY_006: Insufficient Droplets Unlock Prevention
*   **Description**: Verify that attempts to unlock an item costing more than the wallet balance fail.
*   **Input**: Call `unlockFont("Modern Sans", 200)`.
*   **Expected Outcome**: Returns `false` and balance remains unchanged.

---

## 3. Campaign Cubit Test Cases (`test/features/sudoku/presentation/cubit/campaign_cubit_test.dart`)

### TC_CAMPAIGN_001: Setup Volume Progress Defaults
*   **Description**: Verify that the three volumes (`vol_gutenberg`, `vol_pennypress`, `vol_moderntimes`) initialize with all completion states set to false.
*   **Expected Outcome**: Completion status mapping matches volume lengths, filled with `false`.

### TC_CAMPAIGN_002: Load Completed Level Progress
*   **Description**: Verify that loading campaign progress reads completed levels correctly from SQLite.
*   **Input**: Database returns completed indicators for level index `1` and `3` on Gutenberg press volume.
*   **Expected Outcome**: State completes indices `1` and `3` specifically, leaving `0`, `2`, and `4` as `false`.

### TC_CAMPAIGN_003: Save Completed Level
*   **Description**: Verify that solving a campaign level saves the completion score to SQLite and updates the state.
*   **Input**: Complete level index `2` of volume `vol_gutenberg` in `120` seconds.
*   **Expected Outcome**: Database is called to save progress, and state completionStatus of index `2` transitions to `true`.

### TC_CAMPAIGN_004: Solved Volume Milestone Reward
*   **Description**: Verify that completing the last remaining unsolved level in a volume triggers the special volume droplet reward.
*   **Input**: Gutenberg volume has indices `0` through `3` solved. Solve level index `4` (the final level).
*   **Expected Outcome**: Economy balance is credited with Gutenberg's `500` droplets bonus, changing balance from `100` to `600`.

### TC_CAMPAIGN_005: Prevent Re-rewarding droplets
*   **Description**: Verify that resolving levels in an already fully-completed volume does not reward the volume-complete droplets award again.
*   **Input**: Gutenberg volume is already completed. Solve index `2` again in a faster time.
*   **Expected Outcome**: SQLite is updated, but droplet wallet balance remains unchanged.

---

## 4. Settings UI Page Widget Tests (`test/features/sudoku/presentation/pages/settings_page_test.dart`)

### TC_UI_SETTINGS_001: Renders Publisher Profile Name Field
*   **Description**: Verify that the settings page renders the username editing field containing the current name from SettingsCubit.
*   **Expected Outcome**: TextFormField `username_field` is visible and contains `"Alice"`.

### TC_UI_SETTINGS_002: Name Field Input Interaction
*   **Description**: Verify that editing the text form field successfully notifies the SettingsCubit.
*   **Input**: Type `"Bob"` in the `username_field`.
*   **Expected Outcome**: `mockSettingsCubit.setUsername("Bob")` is verified called exactly once.

### TC_UI_SETTINGS_003: locked Fonts & Inks Display Padlock
*   **Description**: Verify that locked fonts/inks display with a padlock suffix and their choice selections are disabled.
*   **Input**: Setup unlocked list with Courier New but without Garamond.
*   **Expected Outcome**: 
    *   Text `"Garamond (Elegant old-style type) 🔒"` renders on screen.
    *   RadioListTile for Garamond has `onChanged: null` (disabled).

### TC_UI_SETTINGS_004: Unlocked Fonts & Inks Selection
*   **Description**: Verify that unlocked custom styling themes are fully enabled for selection.
*   **Expected Outcome**: RadioListTile for Courier New has `onChanged` set to a callback (enabled).

---

## 5. Home Page UI Widget Tests (`test/features/sudoku/presentation/pages/home_page_test.dart`)

### TC_UI_HOME_001: Personalized Greeting Renders
*   **Description**: Verify that the top-left section displays the custom Vietnamese greeting instead of a hardcoded volume number.
*   **Input**: SettingsCubit state contains username `"Sudoku Expert"`.
*   **Expected Outcome**: Text `"Xin chào, Sudoku Expert"` is verified visible on the top-left of the broadsheet.

### TC_UI_HOME_002: Declutter redundant Shop Carousel Card
*   **Description**: Verify that `"THE NEWSSTAND"` card has been removed from special editions list to avoid homepage clutter.
*   **Expected Outcome**: Find text `"THE NEWSSTAND"` returns zero results.

### TC_UI_HOME_003: Quick Play Mode Dialog Launch
*   **Description**: Verify that clicking the "PLAY QUICK EDITION" card opens the elegant difficulty selector picker dialog.
*   **Input**: Tap widget with key `quick_play_card`.
*   **Expected Outcome**: An AlertDialog displays displaying the title `"SELECT DIFFICULTY"`.

### TC_UI_HOME_004: Dialog Difficulties Uppercase Style
*   **Description**: Verify that difficulty choices in the Dialog are uppercase print-styled.
*   **Expected Outcome**: Options `"BEGINNER"`, `"MEDIUM"`, `"HARD"`, and `"EXPERT"` render correctly on the dialog card.

---

## 6. Smoke Test cases (`test/widget_test.dart`)

### TC_SMOKE_001: App Launch & Quick Play Flow Smoke Test
*   **Description**: Verify that building the main app renders the Home Page and supports selecting a quick difficulty to start playing.
*   **Input**: Launch `MyApp()`, tap `quick_play_card`, and assert options are select-ready.
*   **Expected Outcome**: All views render with correct initial titles, dialogue opens on tap, and test completes with zero assertions.
