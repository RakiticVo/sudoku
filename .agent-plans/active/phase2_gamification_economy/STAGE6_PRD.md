# Product Requirements Document (PRD) — Phase 2: Gamification, Economy, and Customization

## 1. Vision & Gamification Theme
Phase 2 transforms the Newspaper Sudoku MVP (Phase 1) into a highly engaging, long-term educational and collection experience. We introduce a complete in-game economy and customization system entirely themed around **"The Gutenberg Printing Press & Classic Journalism"**.

*   **Game Currency**: **"Ink Droplets" (Giọt Mực)** — earned by solving puzzles, completing daily challenges, and conquering campaign themes.
*   **The Shop / "The Newsstand"**: A retro shop where players spend their Ink Droplets to unlock aesthetic upgrades (vintage fonts, historic ink colors, custom completion stamps) and gameplay utilities.
*   **Campaign Mode / "The Editorial Journey"**: A series of thematic chapters (e.g., *The Gutenberg Era*, *Fleet Street Chronicles*, *The Golden Age of Cryptography*). Completion yields major historical collectibles.
*   **Daily Challenge / "The Daily Edition"**: A daily quick play with selectable difficulty. Higher difficulty awards more Ink Droplets.
*   **Selective Replay Archiving / "The Archives"**: An optional, memory-saving feature allowing players to archive completed grids to replay or review step-by-step.
*   **Settings / "The Press Room"**: Dark newsprint mode toggle, custom fonts, ink customizer, and storage cleaner.

---

## 2. Goals and Non-Goals
### Goals (Phase 2)
*   **Tactile Gutenberg Economy**: Ink Droplet currency system persistently saved and spendable in a beautifully typeset store ("The Newsstand").
*   **Thematic Campaign System**: A multi-volume editorial mode containing handcrafted puzzles, progressive unlocks, and educational historical articles.
*   **Time-bound Daily Challenges**: A curated daily board selection with scaled droplet rewards and a calendar overlay with calendar stamps.
*   **Selective Archives & Replay Player**: A lightweight serialized solve logger with a media-timeline player to watch exact solve steps.
*   **Premium Ink & Typography Styles**: Dynamic swap-ready styling (Sepia, Prussian Blue, Crimson) and fonts (Garamond, Courier) locked behind store unlocks.
*   **Dark Newsprint Aesthetics**: A specialized warm dark mode matching aged, print-style ink contrast on slate-charcoal paper.

---

## 3. Core Functional Requirements

### A. Game Economy & "The Newsstand" (Shop)
1.  **Currency System**:
    *   Players earn **Ink Droplets** (💧) on puzzle completion:
        *   **Beginner**: +10 💧 (Daily: +20 💧)
        *   **Medium**: +25 💧 (Daily: +50 💧)
        *   **Hard**: +50 💧 (Daily: +100 💧)
        *   **Expert**: +100 💧 (Daily: +200 💧)
    *   Ink Droplets balance is saved persistently in `SharedPreferences`.
2.  **The Newsstand Inventory**:
    *   **Classic Print Fonts**: Lock/Unlock retro typography for cell digits (e.g., *Garamond* (+200 💧), *Courier Prime* typewriter style (+300 💧), *Special Elite* (+400 💧)).
    *   **Historical Ink Colors**: Change the user digit and highlight colors (e.g., *Vintage Sepia* (+300 💧), *Prussian Blue* (+400 💧), *Classic Crimson* (+400 💧), *Forest Pine* (+500 💧)).
    *   **Completion Stamps**: Collectible ink stamps overlayed on the board when solved (e.g., *"APPROVED" stamp*, *"DELIVERED" stamp*, *Gutenberg Press seal*).
    *   **Hint Bundles**: Buy extra logical hints (only usable in Easy/Medium modes) at 50 💧 per hint.

### B. Campaign Mode — "The Editorial Journey"
1.  **Structure**:
    *   Divided into **Thematic Volumes** (e.g., *Volume 1: The Gutenberg Era*, *Volume 2: Fleet Street*, *Volume 3: Codebreakers*).
    *   Each Volume contains **100 handcrafted or classified puzzles** that increase in difficulty.
2.  **Unique "Big Rewards" (Historical Collectibles)**:
    *   Instead of standard images, completing a Volume unlocks an **Interactive Historic Front Page (Trang Nhất Lịch Sử)** designed with premium vintage layouts.
    *   *Examples*: Gutenberg's first Bible print, Neil Armstrong on the Moon, the end of World War II, or famous cryptology breakthroughs.
    *   Includes a beautifully written editorial article/essay detailing the historical context, which can be saved to local archives or shared.

### C. Daily Challenge — "The Daily Edition"
1.  **Mechanism**:
    *   Released daily at 00:00 local time.
    *   Unlike Phase 1 where difficulty was fixed, the player can **select their preferred difficulty** for the day's challenge.
    *   Rewards are scaled based on difficulty (as specified in Section A).
    *   Completing the Daily Challenge grants a date stamp on the retro print **Calendar Dashboard**.

### D. Selective Replays — "The Archives"
1.  **Memory-Optimized Storage**:
    *   To keep the app lightweight, games are **NOT** auto-archived with full step logs.
    *   Upon puzzle completion, the player is shown a toggle/button: **"Archive this solve to The Press Archives?"**.
    *   If selected:
        *   The complete grid solve history (array of compact action objects: `{"t": timestamp, "r": row, "c": col, "v": val, "m": isNote}`) is compressed into a tight JSON string and saved in local SQL/Prefs.
        *   The player can visit "The Archives" from the HomePage to replay their exact solve path step-by-step or share it.

### E. Settings — "The Press Room"
1.  **Dark Newsprint Mode**:
    *   A high-end dark theme mimicking faded black ink on aged charcoal/slate paper (Warm dark mode instead of standard cold blue OLED blacks).
2.  **Storage Manager**:
    *   Allows clearing all archived replays with one tap to free up memory.
3.  **Active Style Picker**:
    *   Instantly switch between unlocked fonts, ink colors, and stamp styles.

---

## 4. Visual & UX Requirements
*   **Dark Newsprint Aesthetics**: Sleek, warm dark mode (`#1E2022` primary background, slate-cream highlights) to ensure comfort during late-night solving.
*   **Dynamic Customization**: Instantly reflects color and font changes on the grid as soon as they are purchased and selected.
*   **Tactile Shop Card Layout**: Items in the shop look like premium stamps, ink jars, and classic newspaper advertisements.
