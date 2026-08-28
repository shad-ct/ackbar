.pragma library
// history.js — AckBar+ history persistence via Plasma KConfig
//
// History is stored as a JSON string in plasmoid.configuration.historyJson.
// KConfig handles persistence across restarts, reboots, and logout/login automatically.
//
// All functions take/return record arrays and/or JSON strings.
// The caller (main.qml) is responsible for reading and writing
// plasmoid.configuration.historyJson — this module cannot access plasmoid
// directly because of .pragma library scope isolation.
//
// Record schema:
//   { id, task, startedAt, endedAt, durationSeconds, pomodorosCompleted, type }

var HISTORY_VERSION = 1;

// ── Serialization ──────────────────────────────────────────────────────────────

function parseHistoryJson(jsonString) {
    if (!jsonString || jsonString.trim() === "") {
        return [];
    }
    try {
        var parsed = JSON.parse(jsonString);
        if (!parsed || !Array.isArray(parsed.records)) {
            console.warn("AckBar+: historyJson malformed — recovering to empty history");
            return [];
        }
        return parsed.records;
    } catch (e) {
        console.warn("AckBar+: failed to parse historyJson:", e);
        return [];
    }
}

function serializeRecords(records) {
    try {
        return JSON.stringify({ version: HISTORY_VERSION, records: records });
    } catch (e) {
        console.warn("AckBar+: failed to serialize history:", e);
        return "";
    }
}

// ── Record operations ──────────────────────────────────────────────────────────

// Add a record to an existing records array.
// Returns { records, jsonString, isDuplicate }.
// Caller must write jsonString to plasmoid.configuration.historyJson if !isDuplicate.
function addRecord(existingRecords, record) {
    // Dedup: never add the same id twice
    for (var i = 0; i < existingRecords.length; i++) {
        if (existingRecords[i].id === record.id) {
            console.log("AckBar+: duplicate record", record.id, "— skipping");
            return { records: existingRecords, jsonString: null, isDuplicate: true };
        }
    }
    var newRecords = existingRecords.concat([record]);
    return { records: newRecords, jsonString: serializeRecords(newRecords), isDuplicate: false };
}

// Delete a record by id from an existing records array.
// Returns { records, jsonString }.
function deleteRecord(existingRecords, id) {
    var filtered = [];
    for (var i = 0; i < existingRecords.length; i++) {
        if (existingRecords[i].id !== id) filtered.push(existingRecords[i]);
    }
    return { records: filtered, jsonString: serializeRecords(filtered) };
}

// Delete all records for a given day (dateKey = "YYYY-MM-DD").
// Returns { records, jsonString }.
function deleteRecordsByDay(existingRecords, dateKey) {
    var filtered = [];
    for (var i = 0; i < existingRecords.length; i++) {
        var r = existingRecords[i];
        var d = new Date(r.startedAt);
        var rKey = d.getFullYear() + "-"
                 + String(d.getMonth() + 1).padStart(2, "0") + "-"
                 + String(d.getDate()).padStart(2, "0");
        if (rKey !== dateKey) filtered.push(r);
    }
    return { records: filtered, jsonString: serializeRecords(filtered) };
}

// Delete all records for a specific task name on a specific day.
// taskName is the raw task string ("") for un-named sessions.
// Returns { records, jsonString }.
function deleteRecordsByTask(existingRecords, dateKey, taskName) {
    var filtered = [];
    for (var i = 0; i < existingRecords.length; i++) {
        var r = existingRecords[i];
        var d = new Date(r.startedAt);
        var rKey = d.getFullYear() + "-"
                 + String(d.getMonth() + 1).padStart(2, "0") + "-"
                 + String(d.getDate()).padStart(2, "0");
        if (rKey === dateKey && (r.task || "") === taskName) continue;
        filtered.push(r);
    }
    return { records: filtered, jsonString: serializeRecords(filtered) };
}

// Clear all records.
// Returns { records: [], jsonString }.
function clearHistory() {
    var empty = [];
    return { records: empty, jsonString: serializeRecords(empty) };
}

// ── Unique ID generator ────────────────────────────────────────────────────────
// id = "pomo-{phaseStartMs}-{pomodoroCount}"
// Stable across restarts: phaseStartedAt is persisted in KConfig.

function makeRecordId(phaseStartMs, pomodoroCount) {
    return "pomo-" + phaseStartMs + "-" + pomodoroCount;
}
