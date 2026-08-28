.pragma library
// statistics.js — AckBar+ statistics calculated on demand from raw history records
// All values are derived from the record list; no precomputed totals stored.

// ── Local-date helpers ────────────────────────────────────────────────────────

// Returns "YYYY-MM-DD" in local timezone for a Unix ms timestamp
function localDateKey(timestampMs) {
    var d = new Date(timestampMs);
    var y = d.getFullYear();
    var m = String(d.getMonth() + 1).padStart(2, "0");
    var day = String(d.getDate()).padStart(2, "0");
    return y + "-" + m + "-" + day;
}

// Returns today's local "YYYY-MM-DD" string
function todayKey() {
    return localDateKey(Date.now());
}

// ── Filtering ─────────────────────────────────────────────────────────────────

function getTodayRecords(records) {
    var today = todayKey();
    var out = [];
    for (var i = 0; i < records.length; i++) {
        if (localDateKey(records[i].endedAt) === today) out.push(records[i]);
    }
    return out;
}

function getRecordsForDay(records, dateKey) {
    var out = [];
    for (var i = 0; i < records.length; i++) {
        if (localDateKey(records[i].endedAt) === dateKey) out.push(records[i]);
    }
    return out;
}

// ── Aggregation ───────────────────────────────────────────────────────────────

function getTotalFocusedSeconds(records) {
    var total = 0;
    for (var i = 0; i < records.length; i++) total += (records[i].durationSeconds || 0);
    return total;
}

function getTotalPomodoroCount(records) {
    var total = 0;
    for (var i = 0; i < records.length; i++) total += (records[i].pomodorosCompleted || 0);
    return total;
}

// Returns [{task, totalSeconds, pomodoroCount}] sorted by totalSeconds desc
function getTaskTotals(records) {
    var map = {};
    for (var i = 0; i < records.length; i++) {
        var r = records[i];
        var t = r.task || "(no task)";
        if (!map[t]) map[t] = { task: t, totalSeconds: 0, pomodoroCount: 0 };
        map[t].totalSeconds   += (r.durationSeconds || 0);
        map[t].pomodoroCount  += (r.pomodorosCompleted || 0);
    }
    var arr = [];
    for (var key in map) arr.push(map[key]);
    arr.sort(function(a, b) { return b.totalSeconds - a.totalSeconds; });
    return arr;
}

// Returns sorted array of unique local date keys present in records (newest first)
function getUniqueDays(records) {
    var seen = {};
    for (var i = 0; i < records.length; i++) {
        seen[localDateKey(records[i].endedAt)] = true;
    }
    var days = Object.keys(seen);
    days.sort(function(a, b) { return b < a ? -1 : b > a ? 1 : 0; });
    return days;
}

// ── Formatting ────────────────────────────────────────────────────────────────

function formatDuration(totalSeconds) {
    if (totalSeconds <= 0) return "0m";
    var h = Math.floor(totalSeconds / 3600);
    var m = Math.floor((totalSeconds % 3600) / 60);
    if (h > 0 && m > 0) return h + "h " + m + "m";
    if (h > 0) return h + "h";
    return m + "m";
}

// "2026-08-28" → "Today" / "Yesterday" / "Wed, 28 Aug"
function formatDayLabel(dateKey) {
    var today = todayKey();
    if (dateKey === today) return "Today";
    // yesterday
    var d = new Date();
    d.setDate(d.getDate() - 1);
    var yKey = localDateKey(d.getTime());
    if (dateKey === yKey) return "Yesterday";
    // other days
    var parts = dateKey.split("-");
    var dd = new Date(Number(parts[0]), Number(parts[1]) - 1, Number(parts[2]));
    var days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return days[dd.getDay()] + ", " + dd.getDate() + " " + months[dd.getMonth()];
}
