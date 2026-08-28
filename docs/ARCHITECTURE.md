# AckBar+ Architecture

## Overview

AckBar is a KDE Plasma 6 panel widget. All widget code is plain QML — no compilation step. The widget runs inside `plasmashell` as a QML component tree.

This document describes the architecture of the extended AckBar+ fork, which adds persistent history, productivity statistics, and notification sounds while fully preserving the original widget's behaviour.

---

## File Structure

```
contents/
├── config/
│   ├── config.qml              # Settings pages registry
│   └── main.xml                # KConfig schema (settings only, NOT history)
├── js/
│   ├── history.js              # History read/write/delete logic
│   └── statistics.js           # Statistics calculation from history records
└── ui/
    ├── main.qml                # Main widget: timer, pomodoro, history integration
    ├── HistoryView.qml         # History popup dialog component
    ├── ColorSwatches.qml       # Existing colour picker helper
    ├── configGeneral.qml       # Settings: General page
    ├── configBlink.qml         # Settings: Blink reminder page
    ├── configPomodoro.qml      # Settings: Pomodoro page
    └── configHistory.qml       # Settings: History & Notifications page (NEW)
docs/
└── ARCHITECTURE.md             # This file
```

---

## Persistent State

### Settings — KConfig (`plasmoid.configuration.*`)

Plasma's built-in KConfig system stores all **settings** and **current operational state**. These values survive widget reload, plasmashell restart, logout, and reboot automatically.

#### Existing keys (preserved verbatim)
| Key | Type | Purpose |
|---|---|---|
| `taskText` | String | Current task text |
| `taskStartedAt` | String | Unix ms timestamp when task was set |
| `barColor` | Color | Bar colour |
| `fontFamily` | String | Task font |
| `fontColor` | Color | Font colour (transparent = theme) |
| `timerFontFamily` | String | Timer font |
| `placeholderText` | String | Idle hint text |
| `showTimer` | Bool | Show elapsed timer |
| `blinkEnabled` | Bool | Blink reminder on/off |
| `blinkIntervalMinutes` | Int | Blink interval |
| `blinkColor` | Color | Blink colour |
| `pomodoroEnabled` | Bool | Pomodoro mode on/off |
| `pomodoroMinutes` | Int | Work duration |
| `restMinutes` | Int | Break duration |
| `restColor` | Color | Rest bar colour |
| `pomodoroPhase` | String | Current phase: `""`, `"work"`, `"rest"`, `"workEnded"`, `"restEnded"` |
| `phaseEndsAt` | String | Unix ms timestamp when current phase ends |
| `pomodoroCount` | Int | Pomodoro counter in current session |

#### New settings keys (AckBar+)
| Key | Type | Default | Purpose |
|---|---|---|---|
| `enableHistory` | Bool | true | Master switch: record history at all |
| `trackPomodoros` | Bool | true | Record completed Pomodoro history entries |
| `trackTasks` | Bool | true | Include task info in history entries |
| `showDailyStats` | Bool | true | Show today's stats in history view |
| `enableNotificationSound` | Bool | false | Play sound on Pomodoro/break completion |
| `soundOnPomodoroComplete` | Bool | true | Play sound when work Pomodoro finishes |
| `soundOnBreakComplete` | Bool | true | Play sound when break finishes |
| `lastRecordedPomodoroId` | String | "" | ID of last persisted Pomodoro (dedup guard) |

### History — Local JSON file

History records are **not** stored in KConfig. A JSON file is used instead because:
- KConfig is not designed for unbounded lists of records
- Storing N history entries as N separate config keys would be fragile and slow
- A JSON file is lightweight, trivially parseable in QML/JS, and survives all restarts

**Location:**
```
~/.local/share/ackbar-history/history.json
```

This is within the XDG data home, is user-local, and requires no external tools.

**Format:**
```json
{
  "version": 1,
  "records": [
    {
      "id": "pomo-1722345678901-3",
      "task": "Study DBMS",
      "startedAt": 1722345000000,
      "endedAt": 1722346200000,
      "durationSeconds": 1200,
      "pomodorosCompleted": 1,
      "type": "pomodoro"
    }
  ]
}
```

#### Record Fields
| Field | Type | Description |
|---|---|---|
| `id` | String | Unique ID: `"pomo-{timestamp}-{count}"` — prevents duplicates |
| `task` | String | Task name at time of completion |
| `startedAt` | Number | Unix ms timestamp — phase start |
| `endedAt` | Number | Unix ms timestamp — phase scheduled end (not overtime end) |
| `durationSeconds` | Number | Nominal Pomodoro duration in seconds |
| `pomodorosCompleted` | Number | Always 1 per record; allows aggregation across records |
| `type` | String | `"pomodoro"` (future: `"manual"`) |

---

## Timer Architecture

### Timestamp-Based (restart-safe)

The timer does **not** store remaining seconds. Instead:

- `phaseEndsAt` — absolute Unix ms timestamp when the current phase ends
- On every 1-second tick: `remaining = phaseEndsAt - Date.now()`
- On `Component.onCompleted`: if `Date.now() >= phaseEndsAt`, phase is already over → set to `workEnded`/`restEnded` silently (no notification, no history entry)

This means the widget reconstructs the correct state correctly after:
- plasmashell restart
- system sleep/hibernate/resume
- logout/login
- reboot

### Duplicate Prevention

A Pomodoro history entry is created **only** in the `onPomodoroPhaseExpired` signal handler — which fires only when the live timer transitions from `"work"` to `"workEnded"` in real time. It does **not** fire on `Component.onCompleted` reconstruction.

Additionally:
- Each record gets a unique ID: `"pomo-{phaseStartTimestamp}-{pomodoroCount}"`
- Before writing, check if the last recorded ID matches — if so, skip
- `lastRecordedPomodoroId` config key stores this guard persistently

---

## History Logic (`js/history.js`)

Functions:
- `loadHistory()` → parses `~/.local/share/ackbar-history/history.json`, returns records array
- `saveHistory(records)` → writes full records array to file atomically
- `addRecord(record)` → loads, appends, saves
- `deleteRecord(id)` → loads, filters out id, saves
- `clearHistory()` → writes `{ version:1, records:[] }`

Error handling: all file operations are wrapped in try/catch. If the file is missing or malformed, the widget recovers to an empty history without crashing.

---

## Statistics (`js/statistics.js`)

Statistics are calculated **on demand** from the raw records. No precomputed totals are stored.

Functions:
- `getTodayRecords(records)` → filter records where `endedAt` falls in today's local calendar day
- `getDailyFocusedSeconds(records)` → sum `durationSeconds` for today's records
- `getDailyPomodoroCount(records)` → sum `pomodorosCompleted` for today's records
- `getTaskTotals(records)` → group by task name, sum durations and counts
- `formatDuration(seconds)` → `"1h 15m"` or `"45m"` string

"Today" is determined using JavaScript `new Date()` in local timezone. Records are compared by their `endedAt` date converted to local `YYYY-MM-DD`.

---

## Pomodoro Completion Flow

```
1. Timer tick: now >= phaseEndsAt  AND  phase === "work"
2. pomodoroPhase → "workEnded"
3. signal pomodoroPhaseExpired("work") emitted
4. onPomodoroPhaseExpired handler:
   a. flashRequested()
   b. workEndNotification.sendEvent()
   c. [NEW] if enableHistory && trackPomodoros:
        - build record with unique id
        - check lastRecordedPomodoroId ≠ record.id
        - if not duplicate: addRecord(record), update lastRecordedPomodoroId
   d. [NEW] if enableNotificationSound && soundOnPomodoroComplete:
        - play KDE notification sound
```

The same flow applies for `"rest"` → `"restEnded"` for break completion sound.

---

## History View

`HistoryView.qml` is a `PlasmaComponents3.Dialog`-style overlay launched from a context menu action "History…" added to `Plasmoid.contextualActions`.

Structure:
- ScrollView with daily sections
- Each day: header + task groups + individual entries with delete button
- Today's summary: focused time + Pomodoro count
- Clear History button (requires confirmation dialog)

---

## Notification Sound

KDE Plasma uses `canberra` for system notification sounds (via `ca_context_play`). In QML, the simplest native approach is to trigger a `Notification` with the `soundName` property set to a freedesktop event ID (e.g. `"complete"`), or alternatively call `plasmoid.internalAction("notify")`.

The implementation uses a `Process` via `Qt.openUrlExternally` fallback: `paplay /usr/share/sounds/freedesktop/stereo/complete.oga` — this is available on all systems with PulseAudio/PipeWire and avoids bundling audio files.

A `soundTimer` single-shot Timer prevents duplicate sounds on widget reconstruction.

---

## Settings Architecture

New settings page: **History & Notifications** (`configHistory.qml`)

```
History & Notifications
─────────────────────────────────
[✓] Enable productivity history
    [✓] Track completed Pomodoros
    [✓] Track task history
    [✓] Show daily statistics in history

Notifications
─────────────────────────────────
[  ] Enable notification sounds
    [  ] Play sound when Pomodoro finishes
    [  ] Play sound when break finishes
```

---

## Weekly Statistics — Future Architecture

The raw record schema already supports weekly queries:
- Filter records by `endedAt` in the target week (local TZ)
- Group by `task` for per-task totals
- Group by local date for daily breakdown
- Find max daily total for "most productive day"

No implementation needed now — the data model is ready.

---

## Data Retention

History is retained indefinitely until the user explicitly:
1. Deletes an individual record (trash icon per entry)
2. Clears all history (Clear History button with confirmation)

Disabling `enableHistory` stops **recording** new data but does **not** delete existing records.

---

## Backward Compatibility

All new KConfig keys have sensible defaults in `main.xml`. An existing AckBar installation will load this widget and immediately work with all new features active by default (history tracking on, sounds off). No manual config migration needed.
