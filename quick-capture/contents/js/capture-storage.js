.pragma library

var CATEGORIES = ["Idea", "Task", "Reminder", "Learning", "Project", "Miscellaneous"];

var CATEGORY_ICONS = {
    "Idea": "lightbulb",
    "Task": "task-complete",
    "Reminder": "alarm-symbolic",
    "Learning": "help-contents",
    "Project": "folder-favorites",
    "Miscellaneous": "document-edit"
};

var CATEGORY_COLORS = {
    "Idea": "#e67e22",
    "Task": "#27ae60",
    "Reminder": "#3498db",
    "Learning": "#9b59b6",
    "Project": "#1abc9c",
    "Miscellaneous": "#7f8c8d"
};

function generateId() {
    return "qc_" + Date.now() + "_" + Math.floor(Math.random() * 10000);
}

function loadEntries(plasmoid) {
    if (!plasmoid || !plasmoid.configuration) {
        return [];
    }
    var raw = plasmoid.configuration.entriesData;
    if (!raw) return [];
    try {
        var list = JSON.parse(raw);
        if (Array.isArray(list)) {
            return list;
        }
        return [];
    } catch (e) {
        console.warn("[QuickCapture] Failed to parse entriesData:", e);
        return [];
    }
}

function saveEntries(plasmoid, list) {
    if (!plasmoid || !plasmoid.configuration) {
        return false;
    }
    try {
        plasmoid.configuration.entriesData = JSON.stringify(list);
        if (typeof plasmoid.configuration.writeConfig === "function") {
            plasmoid.configuration.writeConfig();
        }
        return true;
    } catch (e) {
        console.error("[QuickCapture] Failed to save entriesData:", e);
        return false;
    }
}

function createEntry(text, category) {
    var now = new Date().toISOString();
    return {
        id: generateId(),
        text: (text || "").trim(),
        category: category || "Idea",
        createdAt: now,
        updatedAt: now,
        pinned: false,
        processed: false
    };
}

function addEntry(plasmoid, text, category) {
    var trimmed = (text || "").trim();
    if (!trimmed) {
        return null;
    }
    var entries = loadEntries(plasmoid);
    var newEntry = createEntry(trimmed, category);
    entries.unshift(newEntry);
    saveEntries(plasmoid, entries);
    return newEntry;
}

function updateEntry(plasmoid, id, newText, newCategory) {
    var entries = loadEntries(plasmoid);
    for (var i = 0; i < entries.length; i++) {
        if (entries[i].id === id) {
            if (newText !== undefined) entries[i].text = newText.trim();
            if (newCategory !== undefined) entries[i].category = newCategory;
            entries[i].updatedAt = new Date().toISOString();
            saveEntries(plasmoid, entries);
            return entries[i];
        }
    }
    return null;
}

function togglePin(plasmoid, id) {
    var entries = loadEntries(plasmoid);
    for (var i = 0; i < entries.length; i++) {
        if (entries[i].id === id) {
            entries[i].pinned = !entries[i].pinned;
            entries[i].updatedAt = new Date().toISOString();
            saveEntries(plasmoid, entries);
            return entries[i].pinned;
        }
    }
    return false;
}

function toggleProcessed(plasmoid, id) {
    var entries = loadEntries(plasmoid);
    for (var i = 0; i < entries.length; i++) {
        if (entries[i].id === id) {
            entries[i].processed = !entries[i].processed;
            entries[i].updatedAt = new Date().toISOString();
            saveEntries(plasmoid, entries);
            return entries[i].processed;
        }
    }
    return false;
}

function deleteEntry(plasmoid, id) {
    var entries = loadEntries(plasmoid);
    var filtered = entries.filter(function(item) {
        return item.id !== id;
    });
    saveEntries(plasmoid, filtered);
    return filtered;
}

function clearAllEntries(plasmoid) {
    saveEntries(plasmoid, []);
    return [];
}

function filterEntries(entries, searchFilter, statusFilter, categoryFilter, maxLimit) {
    if (!Array.isArray(entries)) return [];

    var query = (searchFilter || "").toLowerCase().trim();
    var result = entries.filter(function(item) {
        if (query && item.text.toLowerCase().indexOf(query) === -1) {
            return false;
        }
        if (statusFilter === "active" && item.processed) {
            return false;
        }
        if (statusFilter === "processed" && !item.processed) {
            return false;
        }
        if (statusFilter === "pinned" && !item.pinned) {
            return false;
        }
        if (categoryFilter && categoryFilter !== "All" && item.category !== categoryFilter) {
            return false;
        }
        return true;
    });

    // Sort: pinned items first, then newer items first
    result.sort(function(a, b) {
        if (a.pinned !== b.pinned) {
            return a.pinned ? -1 : 1;
        }
        return new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime();
    });

    if (maxLimit && maxLimit > 0 && result.length > maxLimit) {
        result = result.slice(0, maxLimit);
    }
    return result;
}

function countUnprocessed(plasmoid) {
    var entries = loadEntries(plasmoid);
    var count = 0;
    for (var i = 0; i < entries.length; i++) {
        if (!entries[i].processed) count++;
    }
    return count;
}

