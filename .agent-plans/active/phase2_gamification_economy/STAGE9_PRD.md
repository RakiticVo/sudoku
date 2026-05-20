# Product Requirements Document (PRD) — Phase 2: Stage 9 (Advanced Gameplay & Economy Refinements)

## 1. Vision & Purpose
Stage 9 enhances and refines the core gamification, economy, and progression mechanics of the Newspaper Sudoku app. By polishing the user interface, restructuring the campaign mode into gradual-progression Volumes, and introducing robust in-game utilities (Hint wallet caps, difficulty hint limits, and the Revive token mechanic), we elevate the game into a highly balanced, premium, and historically engaging broadsheet experience.

---

## 2. Key Objectives & Scope

### A. Interface Simplification & User Greeting
1. **Personalized Greeting**: Modify the HomePage top-left greeting prefix from the Vietnamese version `"Xin chào, [Username]"` to the english `"Hello [Username]"` (e.g., `"Hello Alice"` without comma).
2. **Decluttering the HomePage**: Strip the `"QUICK PLAY"` and `"SPECIAL EDITIONS"` category label dividers from the home screen layout to create a seamless, elegant, and modern newspaper aesthetic.

### B. Shop & Style Inventory Adjustments ("The Newsstand")
1. **Eliminate Typesetting Fonts**: Remove the entire custom typesetting fonts feature from the shop and settings pages, as they detract from the unified typographic brand. The app will default exclusively to the premium classic serif font family (`'Georgia'`) to maintain clean newsprint visual branding.
2. **Replace Classic Crimson Ink**: Remove `Classic Crimson` ink from the shop inventory and design system because it looks like a mistake/error color. In its place, introduce a beautiful, high-contrast **"Teal Cyan"** vintage ink color.
3. **Gameplay Utilities Integration**:
   - **Logical Hints**:
     - Hints can be purchased infinitely in the shop for **50 Ink Droplets** (💧) each.
     - The player's persistent Hint Wallet has a maximum carrying capacity of **50 hints**. If the wallet is at `50 / 50` hints, the purchase button in the shop is **disabled** with the text `"MAX 50"`.
   - **Revive Tokens (Buy Mistake)**:
     - Revive Tokens can be purchased in the shop for **500 Ink Droplets** (💧) each.
     - No wallet carrying limit, but only exactly **one** revive can be consumed or purchased per game session.

### C. Refined Gameplay Rules (Hints & Revives)
1. **Difficulty-Based Hint Restrictions**:
   - A player can only use a limited number of hints per individual game session based on the puzzle's difficulty:
     - **Easy**: Max 5 hints
     - **Medium**: Max 4 hints
     - **Hard**: Max 3 hints
     - **Expert**: **0 hints** (Expert puzzles do not permit any hint usage).
   - If a player has a Hint Token in their wallet, it is consumed. If they have 0 Hint Tokens, tapping Hint pauses the game and displays the `"OUT OF HINTS"` confirmation popup.
     - If they have $\ge 50 💧$, the `"Buy & Use (50 💧)"` option is active.
     - If they have $< 50 💧$, the `"Buy & Use (50 💧)"` button is **disabled/grayed out**, allowing them only to Cancel.
2. **"Revive / Buy Mistake" Mechanic**:
   - Tapping "Revive" decreases the current mistake count by exactly **1** (e.g., from 3/3 mistakes to 2/3 mistakes), allowing the player to avoid defeat and continue their solve.
   - A player can only use **exactly 1 revive** per game session.
   - A revive can be triggered by:
     - Consuming a pre-purchased Revive Token from their inventory.
     - Buying one directly on the Game Over screen for **500 Droplets** (💧).
   - If a player has **0 revive tokens** in their inventory AND **less than 500 Droplets**, the game will **immediately proceed to the standard Game Over/Defeat screen** upon reaching 3/3 mistakes without showing the revive dialog.
   - If a player reaches 3 mistakes after already using a revive in that session, they suffer immediate defeat without another opportunity to revive.

### D. Campaign Restructuring ("The Editorial Journey")
1. **Volume Progression Restructuring**:
   - Convert campaign volumes from short 5-level editions into massive **100-level volumes** designed for gradual, linear difficulty escalation.
   - The vintage Newspaper TabBar and isolated subpages will fully support **horizontal swiping (gestures)** to transition between historical volumes, in addition to clicking the tabs.
   - Maintain our three beautifully written historical broadsheet chapters:
     - **Volume 1 (1456)**: *The Gutenberg Press* (Droplet Reward: 500 💧)
     - **Volume 2 (1833)**: *The Penny Press Era* (Droplet Reward: 750 💧)
     - **Volume 3 (1920)**: *The Times Dispatch* (Droplet Reward: 1000 💧)
2. **Linear Difficulty Distribution within Each Volume**:
   - Difficulty scales systematically *within* each 100-level volume, rather than increasing by volume:
     - **Easy (25%)**: Levels 1 to 25 (Index 0 - 24)
     - **Medium (35%)**: Levels 26 to 60 (Index 25 - 59)
     - **Hard (30%)**: Levels 61 to 90 (Index 60 - 89)
     - **Expert (10%)**: Levels 91 to 100 (Index 90 - 99)
3. **Rewards & Completion broadsheets**:
   - Completing all 100 levels of a volume awards the grand volume droplet reward and permanently unlocks its **Interactive Era Front Page Article** inside the local archives list.

---

## 3. Data Shape & Persistent State

### SharedPreferences Fields (Settings & Inventory)
- `settings_username`: User's profile name (defaults to `'Alice'`).
- `economy_hints`: Int tracking currently held logical hint tokens (min 0, max 50).
- `economy_revives`: Int tracking currently held revive tokens (min 0).

### In-Game Session State (`GameState`)
- `hintsUsed`: Int tracking how many hints were consumed in the current game session.
- `revivesUsed`: Int tracking whether a revive was already applied in the current game session (min 0, max 1).
- `difficulty`: String representation (`'easy'`, `'medium'`, `'hard'`, `'expert'`) matching the active game.

---

## 4. Visual & Theme Specifications
- **Georgia Serif Standard**: Standardize typography exclusively to `'Georgia'` to achieve a flawless newsprint look across the entire application.
- **Teal Cyan Palette**:
  - **Light Theme**: `textUser: Color(0xFF0D7A80)`, `highlightSameValue: Color(0x140D7A80)`.
  - **Dark Theme**: `textUser: Color(0xFF4FD1C5)`, `highlightSameValue: Color(0x244FD1C5)`.
  - Shop Preview Bubble color: `Color(0xFF0D7A80)`.
- **Decluttered Hompage**: Stripping visual noise like dividers maximizes the clean spaces and highlights the premium broadsheet header.
