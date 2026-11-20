# KDE Productivity Suite & TimeTrack Visual Analytics

A native desktop productivity and visual analytics ecosystem built for **KDE Plasma 6** on Ubuntu Linux.

This repository provides two complete, complementary desktop solutions:
1. **KDE Productivity Suite**: Five independent, native Plasma 6 widgets (**Quick Capture**, **Habit Tracker**, **Random Challenge**, **Journal Prompts**, and **Task & Goal Manager**).
2. **TimeTrack Visual Analytics**: A comprehensive time-tracking analytics solution consisting of a **Compact Plasma 6 Widget** and a full **Desktop Analytics Application** (PyQt6 + QML) visualizing computer usage from `desktop-timetracker`.

---

## 📸 Overview of Components

### 1. KDE Productivity Suite (Plasma 6 Widgets)
- **Quick Capture** (`org.kde.plasma.productivitysuite.quickcapture`):
  - Ultra-fast brain dump widget for immediately capturing thoughts, ideas, tasks, reminders, and learning notes.
  - Category tags with visual badges (`Idea`, `Task`, `Reminder`, `Learning`, `Project`, `Miscellaneous`).
  - Quick-save with `Enter` (or multiline with `Shift+Enter`), automatic draft caching, search filter, pinning, clipboard copy, and "Clear All" action.
- **Habit Tracker** (`org.kde.plasma.productivitysuite.habittracker`):
  - Build positive habits and break negative ones with daily completion checkboxes.
  - Automatic streak calculations (current streak, best streak) and completion percentage.
  - 70-day GitHub-style contribution activity grid showing visual intensity.
  - "Clear All" action, customizable frequency (daily, weekdays, specific days).
- **Random Challenge** (`org.kde.plasma.productivitysuite.randomchallenge`):
  - 100+ bundled actionable micro-missions across 14 disciplines (Programming, Mathematics, Physics, Chemistry, Astronomy, Logic & Puzzles, Cryptography, Chess, Memory, Dexterity, Origami, Language Learning, Creative Writing, General Knowledge).
  - Deterministic Daily Mission mode or Random Explorer.
  - Difficulty filters (Beginner, Intermediate, Advanced) and estimated durations.
  - Completed challenge history, skip, delete, "Clear All", and "Restore Default Challenges".
- **Journal Prompts** (`org.kde.plasma.productivitysuite.journalprompts`):
  - Minimal daily random journaling prompt widget (deep, funny, grateful, creative, relationships, work, morning, evening, wild/weird, quick check-in).
  - 90+ bundled prompts across 11 flavours, rotating once per day.
  - Mark prompts as done or favourite them; copy a prompt to the clipboard.
- **Task & Goal Manager** (`org.kde.plasma.productivitysuite.taskgoalmanager`):
  - Daily priority task tracking (Urgent, High, Medium, Low) with deadline sorting.
  - Long-term hierarchical goals with weighted milestone tracking and automatic completion percentages.
  - High-level progress dashboard with active KPIs and "Clear All" actions.

### 2. TimeTrack Visual Analytics
- **Compact Plasma 6 Widget** (`org.kde.plasma.timetrackanalytics`):
  - Docks in top or bottom panel or directly on desktop.
  - Live display of today's **Active Focus Time**, **Total Online Time**, **Current Application & Continuous Duration**, and **Most-Used Application**.
  - 7-day weekly activity trend sparkline.
  - `[Open Analytics Dashboard]` button to launch the full desktop application with one click.
- **Full Analytics Desktop Application** (`./timetrack-dashboard`):
  - Dedicated, resizable Wayland/X11 window built with PyQt6 and QML.
  - **Strict Read-Only Database Safety**: Connects to `timetracker.db` via `?mode=ro` and `PRAGMA query_only = ON`. Never mutates or alters tracking records.
  - **10 Interactive Analytics Views**:
    1. *Overview*: Core KPIs, focus ratio, 24-hour hourly activity bar chart, top 5 applications.
    2. *Timeline*: Chronological block visualization of computer usage chunks with category color coding and duration filters.
    3. *Daily Analytics*: Day breakdown with 24-hour distribution, active vs away breakdown, and window titles list.
    4. *Weekly Analytics*: 7-day trends, week-over-week delta comparisons, and peak usage hours.
    5. *Monthly Analytics*: Interactive month calendar heatmap with color-coded active hours per day.
    6. *Yearly Analytics*: 12-month aggregated view with seasonal trends and peak months.
    7. *All-Time Analytics*: Complete lifetime analytics spanning all tracked records, total hours, and longest active days.
    8. *Applications*: Comprehensive application explorer with search, category filtering, and duration metrics.
    9. *Categories*: Time distribution across canonical application categories (Development, Browsing, Productivity, Media, Communication, etc.).
    10. *Historical Explorer*: Searchable, filterable tabular activity query table with pagination.
  - **Export Capabilities**: One-click exports to CSV, JSON, and Markdown summaries.
  - **Live Auto-Refresh**: 5-second polling thread updating live tracker state without UI stutter.

---

## 📋 System Requirements

- **Operating System**: Ubuntu 22.04 / 24.04+ (or any modern Linux distribution)
- **Desktop Environment**: KDE Plasma 6 (Wayland or X11)
- **Qt / QML**: Qt 6.4+, Qt Quick Controls 2, Kirigami 6
- **Python**: Python 3.10+ (PyQt6 6.5+)
- **Package Manager**: `kpackagetool6`

---

## 🚀 Installation & Setup

### Step 1: Install System & Python Dependencies

Install required packages via `apt`:

```bash
sudo apt update
sudo apt install -y \
    python3 \
    python3-pip \
    python3-pyqt6 \
    python3-pyqt6.qtquick \
    libplasma6 \
    kpackagetool6 \
    plasma-widgets-addons \
    qml6-module-qtquick \
    qml6-module-qtquick-layouts \
    qml6-module-qtquick-controls \
    qml6-module-org-kde-kirigami \
    qml6-module-org-kde-plasma-core \
    qml6-module-org-kde-plasma-components \
    qml6-module-org-kde-plasma-plasma5support
```

---

### Step 2: TimeTrack Tracking Service (`desktop-timetracker`)

The analytics dashboard and widget visualize data produced by the `desktop-timetracker` daemon.

#### Tracker Executable & Paths
- **Tracker Executable**: `~/.local/bin/desktop-timetracker`
- **CLI Alias**: `~/.local/bin/timetrack`
- **Database Location**: `~/.local/share/timetracker/timetracker.db`
- **Systemd User Service**: `~/.config/systemd/user/desktop-timetracker.service`

#### Verifying / Enabling the Tracker Service
If the tracking service is already installed, ensure it is active:

```bash
# Check service status
systemctl --user status desktop-timetracker.service

# Start and enable daemon on login
systemctl --user enable --now desktop-timetracker.service
```

#### TimeTrack CLI Commands
Verify tracking data from your terminal:

```bash
# View today's summary
timetrack today

# View 7-day weekly activity
timetrack week

# Check real-time tracking status
timetrack status

# Check daemon service health
timetrack service status

# Generate daily report
timetrack report --date $(date +%Y-%m-%d)

# Export daily activity records
timetrack export --date $(date +%Y-%m-%d)
```

---

### Step 3: Install All Plasma 6 Widgets

From the repository root, execute the automated installer script:

```bash
# Install all 6 widgets (5 Productivity Suite + TimeTrack Analytics)
./scripts/install-all.sh
```

This script:
1. Synchronizes reusable components (`shared/theme`, `shared/components`, `shared/utilities`).
2. Validates package metadata and manifests.
3. Automatically registers/upgrades each widget in `~/.local/share/plasma/plasmoids/` using `kpackagetool6`.

#### Installed Plasmoid IDs:
- `org.kde.plasma.productivitysuite.quickcapture`
- `org.kde.plasma.productivitysuite.habittracker`
- `org.kde.plasma.productivitysuite.randomchallenge`
- `org.kde.plasma.productivitysuite.journalprompts`
- `org.kde.plasma.productivitysuite.taskgoalmanager`
- `org.kde.plasma.timetrackanalytics`

#### Adding Widgets to Your Desktop or Panel
1. Right-click your KDE Plasma panel or desktop background.
2. Select **Add Widgets...** (or press `Meta + W`).
3. Search for:
   - **Quick Capture**
   - **Habit Tracker**
   - **Random Challenge**
   - **Journal Prompts**
   - **Task & Goal Manager**
   - **TimeTrack Analytics**
4. Drag and drop them into your panel or onto your desktop.

---

### Step 4: Launching TimeTrack Visual Analytics Dashboard

You can launch the desktop analytics dashboard using any of the following methods:

#### Method A: Via Command Line
```bash
./timetrack-dashboard
```

#### Method B: Via TimeTrack Plasma Widget
Click on the **TimeTrack Analytics** widget on your panel or desktop and click:
```
[ Open Analytics Dashboard ]
```

#### Method C: Via KDE Application Launcher
The installer configures `~/.local/share/applications/org.kde.timetrackanalytics.desktop`. You can launch **TimeTrack Visual Analytics** directly from the KDE Kickoff application menu.

---

### Journal Prompts Widget Usage

**Journal Prompts** (`org.kde.plasma.productivitysuite.journalprompts`) is a minimal daily journaling widget.

- **Panel view**: Shows only a minimal icon (no text). Click it to open the full prompt view.
- **Daily rotation**: A new random prompt is served each day across 11 flavours (Deep & Reflective, Funny & Light, Gratitude, Self-Discovery, Creative, Relationships, Work & Career, Morning, Evening, Wild & Weird, Quick Check-In).
- **Actions**: Mark a prompt as Done, copy it to clipboard, or favourite it.
- **Favourites**: Click the star (⭐) to favourite a prompt. Open the favourites list from the header to view and load any favourited prompt.

---

## 🗑️ Empty State & Data Clearing Behavior

All widgets support clean deletion and empty state persistence:
- **No Resurrecting Seed Data**: Deleting all tasks, goals, habits, or captures retains an empty state (`[]`) instead of reverting to default demo data. Seed data is only initialized once upon first run via persistent `hasSeeded` configuration flags.
- **One-Click "Clear All"**:
  - **Quick Capture**: Click the **Clear All** button in the header bar.
  - **Habit Tracker**: Click the **Clear All** button in the header bar.
  - **Task & Goal Manager**: Click the **Clear All** button in the tasks or goals view.
  - **Random Challenge**: Click **Clear All** in the header to clear all challenges. Click **Restore Default Challenges** on the empty state card to restore the bundled 100 challenges at any time.

---

## 🛠️ Developer Scripts & Tools

| Script | Purpose |
| :--- | :--- |
| `./scripts/install-all.sh` | Builds, syncs, and registers all 5 widgets into KDE Plasma 6. |
| `./scripts/uninstall-all.sh` | Uninstalls all 5 widgets from KDE Plasma via `kpackagetool6`. |
| `./scripts/package-all.sh` | Packages all widgets into standalone `.plasmoid` archives inside `dist/`. |
| `./scripts/test-all.sh` | Validates `metadata.json`, runs `qmllint`, tests runtime loads via `plasmawindowed`, and executes Python backend unit tests. |
| `./scripts/sync-shared.sh` | Propagates shared theme tokens and components to all widget directories. |
| `python3 -m unittest tests/test_backend.py` | Runs backend database reader, query service, and export service test suite. |

---

## 🔒 Security & Data Safety Guarantees

- **Strict Read-Only Connection**: SQLite connections are opened using URI mode `file:...timetracker.db?mode=ro`.
- **Query Only Enforced**: `PRAGMA query_only = ON` is executed on every database connection.
- **No Mutating SQL**: The codebase strictly prohibits `INSERT`, `UPDATE`, `DELETE`, `DROP`, `ALTER`, or schema modifications.
- **Zero Tracker Disruption**: Does not spawn competing daemons, lock sockets, or disrupt `desktop-timetracker.service`.

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

