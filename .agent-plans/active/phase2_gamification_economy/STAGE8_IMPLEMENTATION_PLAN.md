# Implementation Plan: Phase 2 — Stage 8: Refinements & Testing Suite

## Objective
To describe the roadmap of Phase 2 and document the exact step-by-step refinements completed in **Stage 6 Refinements & testing**, securing premium print-journalism features and establishing a comprehensive testing suite of 46 green test cases.

---

## 1. Phase 2 Step-by-Step Roadmap

*   **Stage 6 (Completed & Verified)**: Settings profile customizations, username persistent loading/saving, and economy padlock locks.
*   **Stage 7 (Completed & Verified)**: Newsstand Shop page, AAA-compliant button contrasts, and purchase verification.
*   **Stage 8 (Completed & Verified)**: Editorial Journey (Campaign Mode) progress database and scroll context sliver fixes.
*   **Stage 9 (Future)**: Daily Edition Challenge calendar generator and calendar stamps.
*   **Stage 10 (Future)**: Selective solve archives compressing action-logs and timeline playback.

---

## 2. Completed Refinement Technical Details

### A. Settings Profile & Customization
*   **Settings Cubit Updates**:
    *   Exposed `username` string state, saved to key `settings_username` in `SharedPreferences`.
    *   Created `setUsername(String name)` method to save updates dynamically.
*   **Settings Page UI**:
    *   Added a tactile vintage-styled `TextFormField` at the top of settings to edit name.
    *   Wrapped the ink selection row displayName inside `Expanded` to prevent horizontal viewport overflow.
    *   Injected a nested `BlocBuilder<EconomyCubit, EconomyState>` to check unlocked stamps, inks, and fonts.
    *   Non-purchased options display with a suffix padlock `🔒` and set `onChanged: null` on RadioListTiles to prevent activation.

### B. AAA Shop Button Contrast
*   **Dark Newsprint Legibility**:
    *   Modified the active state buy action button in `shop_page.dart`.
    *   Dynamically updates the white text color to the deep charcoal paper background `#1E2022` in Dark Theme, matching AAA contrast standards.

### C. Sliver Viewport Keep-Alive Exceptions Resolved
*   **Context Scopes**:
    *   Calling `context.select` or `context.watch` inside list views built inside SliverList/ListView viewports registers listeners on the viewport itself.
    *   Wrapped campaign volumes list cards and press broadsheet entries in leaf `Builder` nodes to isolate context, resolving the `'widget is! SliverWithKeepAliveWidget'` assertion crash.

### D. Homepage Clean Up & Quick Play Dialog
*   **Select Difficulty Redesign**:
    *   Replaced the four static difficulty card listings with a single cohesive `"PLAY QUICK EDITION"` tactile block.
    *   Tapping the card triggers a custom, vintage-typeset AlertDialog named `"SELECT DIFFICULTY"`, listing `"BEGINNER"`, `"MEDIUM"`, `"HARD"`, and `"EXPERT"`.
*   **Decluttered Carousel**:
    *   Removed the redundant newsstand carousel card since droplet badge triggers shop navigation directly.
*   **Home Greeting**:
    *   Top-left header shows a personalized Vietnamese greeting: `Xin chào, [Username]` (e.g. `Xin chào, User`).

---

## 3. Automated Testing Blueprint

To prevent regressions, 6 dedicated test case files were integrated under the `test/` directory, verifying all features:

1.  **`test/features/sudoku/presentation/cubit/settings_cubit_test.dart`**:
    *   Ensures settings defaults initialize properly.
    *   Verifies persistent load/save actions of `username` on startup.
2.  **`test/features/sudoku/presentation/cubit/economy_cubit_test.dart`**:
    *   Tests initial 100 droplets balance and purchase deductions.
    *   Tests that unlocking fonts/inks updates unlocked list arrays.
3.  **`test/features/sudoku/presentation/cubit/campaign_cubit_test.dart`**:
    *   Verifies volumes completion mappings read from sqlite database.
    *   Tests solving level completion events and droplet rewards calculations.
4.  **`test/features/sudoku/presentation/pages/settings_page_test.dart`**:
    *   Checks padlock symbol formatting on locked fonts.
    *   Validates text fields submit name updates to cubits properly.
5.  **`test/features/sudoku/presentation/pages/home_page_test.dart`**:
    *   Verifies personalized greeting displays on homepage.
    *   Checks that the Quick Play picker dialog triggers on card tap.
6.  **`test/widget_test.dart`**:
    *   Maintains smoke test validation of full game starting flows.

---

## 4. Verification Commands

```powershell
# Run the complete test suite to ensure 46/46 passed test cases
flutter test
```
