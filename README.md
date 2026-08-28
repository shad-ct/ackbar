<img src="logo.svg" width="96" alt="AckBar logo">

# AckBar+

A minimal KDE Plasma 6 panel widget that shows the **one thing you are doing right now** — with persistent Pomodoro history, focus statistics, and task tracking.

> **AckBar+** is a productivity-extended fork of [AckBar](https://github.com/rodbv/ackbar) by Rodrigo Vieira.

**[Get it on the KDE Store](https://store.kde.org/p/2366085)**

![Task with elapsed timer](screenshots/001-bar.png)

---

## Features

### Original AckBar features (preserved)

- **One task, always visible** — lives in your panel, no window to lose. Double-click the bar, type, done. Everything survives reboots and plasmashell restarts.
- **Elapsed timer** — `MM:SS` (or `H:MM:SS` past an hour) at the right edge, monospace so it doesn't jiggle; resets when the task changes.
- **Quiet when idle** — with no task set, the bar is a nearly transparent nudge.
- **Blink reminder** — optionally flash the bar in a color of your choice every N minutes.
- **Pomodoro mode** — opt-in, see below.
- **Vertical panels** — the task rotates to read along the panel; pomodoro and timer stack flat.
- **Configurable** — bar color, fonts, font color, timer on/off, blink interval and color, pomodoro durations and rest color.

### AckBar+ new features

- **Persistent Pomodoro history** — every completed work session is recorded with task name, start/end time, and duration.
- **Task-level time tracking** — see how long you've spent on each task, aggregated across multiple Pomodoros.
- **Daily statistics** — focused time and Pomodoro count for today, shown in the history view.
- **History UI** — right-click → *History…* to open a scrollable session history grouped by day and task.
- **Delete individual entries** — remove a specific session; statistics update immediately.
- **Clear all history** — one button with a confirmation step; never accidental.
- **Notification sounds** — opt-in sound when a Pomodoro or break finishes.
- **Independent feature toggles** — every new feature has its own on/off switch.

---

## Pomodoro mode

Off by default; toggle it from the widget's right-click menu. While it's on,
setting a task starts a pomodoro: the bar shows a countdown and session
counter (`🍅x3 12:34`) on the left, next to the usual elapsed timer on the right.

**Nothing advances without your say-so.** When a pomodoro ends, the bar
flashes and a notification asks what's next — keep working or take a break.

During rest the bar turns gray (color configurable) and counts the break down.

Run over the clock and the bar shows the overtime (`🍅x3 25+2:34`).
Changing the task resets the counter and starts fresh; *Rest now* and
*Restart pomodoro* in the right-click menu cover the two common shortcuts.

---

## History

When a work Pomodoro completes, AckBar+ automatically records:

- Task name
- Session start and end timestamps
- Duration (nominal Pomodoro length)
- Pomodoro count

You can view your history from **right-click → History…**

```
SESSION HISTORY

Today                           🎯 1h 40m  🍅 4

  Study DBMS                    1h 15m  🍅×3
    09:00  ·  25m  [🗑]
    09:32  ·  25m  [🗑]
    10:05  ·  25m  [🗑]

  MERN Backend                  25m  🍅×1
    11:00  ·  25m  [🗑]

Yesterday                       🎯 50m  🍅 2
  …

[ Clear History ]
```

History is stored locally in your Plasma configuration. No data ever leaves your computer.

---

## Data & Privacy

- **All data is local.** History is stored in KDE's Plasma configuration, under `~/.config/plasma-org.kde.plasma.desktop-appletsrc` (or the equivalent for your panel configuration).
- **No network connection required.** AckBar+ is a fully offline widget.
- **No data is uploaded** to any server, cloud service, or third party — ever.
- **Deleting history** removes it from your local configuration immediately and permanently.
- **Clearing history** removes all session records. Your current task, timer state, and settings are not affected.

---

## Requirements

- KDE Plasma 6
- KDE Frameworks 6

---

## Installation

```sh
git clone https://github.com/shad-ct/ackbar.git
cd ackbar
./install.sh
systemctl --user restart plasma-plasmashell
```

Then right-click your panel → *Enter Edit Mode* → *Add Widgets…* → search for **AckBar** and drag it onto the panel.

### Manual install

```sh
kpackagetool6 --type Plasma/Applet --install .   # or --upgrade on updates
```

### Install from .plasmoid

```sh
kpackagetool6 --type Plasma/Applet --install releases/com.rodbv.ackbar-2.1.0.plasmoid
```

### Uninstall

```sh
kpackagetool6 --type Plasma/Applet --remove com.rodbv.ackbar
```

---

## Usage

| Action | Result |
|---|---|
| Double-click the bar | Open the task popup |
| Type + <kbd>Enter</kbd> (or *Set*) | Set the task, start the timer |
| Clear button (✕) | Clear the task |
| <kbd>Esc</kbd> | Close the popup without changes |
| Right-click → *Configure AckBar…* | Colors, fonts, timer, blink, pomodoro, history & sounds |
| Right-click → *Pomodoro mode* | Toggle pomodoro mode on/off |
| Right-click → *Rest now* / *Restart pomodoro* | Skip ahead / redo the current session |
| Right-click → *History…* | Open the session history view |

---

## Settings

Settings are split across four pages: **General**, **Blink reminder**, **Pomodoro**, and **History & Sounds**.

### History & Sounds settings

| Setting | Default | Description |
|---|---|---|
| Enable productivity history | ON | Master switch for all history recording |
| Track completed Pomodoros | ON | Record completed work sessions |
| Include task name in history | ON | Save task name alongside each record |
| Show daily statistics | ON | Show focused time and Pomodoro count in the history view |
| Enable notification sounds | OFF | Play a sound when Pomodoro or break finishes |
| Play sound when Pomodoro finishes | ON | (when sounds enabled) |
| Play sound when break finishes | ON | (when sounds enabled) |

> **Disabling history tracking stops new recording but does not delete existing history.**
> To remove data, use the delete buttons in the History view.

---

## Persistence behavior

| State | Survives? |
|---|---|
| Current task text | ✅ Reboot / plasmashell restart / logout |
| Task start timestamp | ✅ Reboot |
| Pomodoro phase (work/rest/ended) | ✅ Reboot |
| Pomodoro countdown (timestamp-based) | ✅ Reboot, sleep/resume |
| Pomodoro session history | ✅ Reboot |
| Daily statistics | ✅ Calculated from history, never double-counted |
| Settings | ✅ Reboot |

The Pomodoro timer uses **absolute timestamps** (`phaseEndsAt`) rather than a decrementing counter. After a system restart or sleep/resume, the remaining time is recalculated from the persisted end timestamp. This means the widget is always correct, even if the system was asleep for hours during a Pomodoro.

### Duplicate prevention

A completed Pomodoro is recorded exactly once. The implementation uses:

1. A stable unique record ID derived from the phase start timestamp and Pomodoro count — the same ID is always generated for the same session, making duplicates detectable.
2. A `lastRecordedPomodoroId` config key that persists across restarts — prevents re-recording after a plasmashell restart.
3. An in-memory dedup check as a secondary guard.

---

## Development

```sh
./install.sh && systemctl --user restart plasma-plasmashell
```

Widget code is plain QML — no build step:

```
contents/
├── ui/
│   ├── main.qml              # bar (compact) + popup editor + history integration
│   ├── HistoryView.qml       # history dialog (Kirigami.Dialog)
│   ├── configGeneral.qml     # settings: General page
│   ├── configBlink.qml       # settings: Blink reminder page
│   ├── configPomodoro.qml    # settings: Pomodoro page
│   └── configHistory.qml     # settings: History & Sounds page (NEW)
├── js/
│   ├── history.js            # history CRUD, serialization, dedup
│   └── statistics.js         # statistics from raw records, formatting
├── config/
│   ├── main.xml              # config schema
│   └── config.qml            # settings pages registry
└── locale/                   # compiled translations (.mo)
po/                           # translation sources (.po)
docs/
└── ARCHITECTURE.md           # full architecture documentation
```

### Packaging for the KDE Store

```sh
./package.sh   # writes releases/com.rodbv.ackbar-<version>.plasmoid
```

`package.sh` produces a **zip** archive with `metadata.json` and `contents/` at the root.

Release checklist:

1. Bump `"Version"` in `metadata.json`.
2. `./package.sh`, then smoke-test the artifact:
   ```sh
   kpackagetool6 --type Plasma/Applet --install releases/com.rodbv.ackbar-<version>.plasmoid
   ```
3. Upload the `.plasmoid` to the store.

---

## License

[MIT](LICENSE)

The project logo (`logo.svg`) is the `check_constraint` icon from
[KDE Breeze icons](https://invent.kde.org/frameworks/breeze-icons),
licensed LGPL-3.0-or-later.

Upstream project: [rodbv/ackbar](https://github.com/rodbv/ackbar)
