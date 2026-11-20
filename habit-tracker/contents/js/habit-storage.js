.pragma library

var DEFAULT_HABITS = [
    {
        id: "habit_default_1",
        name: "Morning Exercise",
        description: "20 minutes of stretching or cardio",
        icon: "run-build",
        color: "#27ae60",
        frequencyType: "daily",
        frequencyDays: [0, 1, 2, 3, 4, 5, 6],
        weeklyTarget: 7,
        targetCount: 1,
        startDate: "2026-01-01",
        completions: {}
    },
    {
        id: "habit_default_2",
        name: "Read 20 Pages",
        description: "Books, technical papers or essays",
        icon: "help-contents",
        color: "#3498db",
        frequencyType: "daily",
        frequencyDays: [0, 1, 2, 3, 4, 5, 6],
        weeklyTarget: 7,
        targetCount: 1,
        startDate: "2026-01-01",
        completions: {}
    },
    {
        id: "habit_default_3",
        name: "Deep Work Session",
        description: "Focused coding or study without distractions",
        icon: "system-run",
        color: "#9b59b6",
        frequencyType: "weekdays",
        frequencyDays: [1, 2, 3, 4, 5],
        weeklyTarget: 5,
        targetCount: 1,
        startDate: "2026-01-01",
        completions: {}
    },
    {
        id: "habit_default_4",
        name: "Hydration Target",
        description: "Drink at least 2 liters of water",
        icon: "draw-water",
        color: "#1abc9c",
        frequencyType: "daily",
        frequencyDays: [0, 1, 2, 3, 4, 5, 6],
        weeklyTarget: 7,
        targetCount: 1,
        startDate: "2026-01-01",
        completions: {}
    }
];

function generateId() {
    return "habit_" + Date.now() + "_" + Math.floor(Math.random() * 10000);
}

function loadHabits(plasmoid) {
    if (!plasmoid || !plasmoid.configuration) {
        return [];
    }
    // Only seed on initial install if hasSeeded is false
    var hasSeeded = plasmoid.configuration.hasSeeded;
    if (!hasSeeded) {
        plasmoid.configuration.hasSeeded = true;
        saveHabits(plasmoid, DEFAULT_HABITS);
        return DEFAULT_HABITS;
    }
    var raw = plasmoid.configuration.habitsData;
    if (!raw) return [];
    try {
        var list = JSON.parse(raw);
        if (Array.isArray(list)) {
            return list;
        }
        return [];
    } catch (e) {
        console.warn("[HabitStorage] Failed to parse habitsData:", e);
        return [];
    }
}

function clearAllHabits(plasmoid) {
    saveHabits(plasmoid, []);
    return [];
}

function restoreDefaultHabits(plasmoid) {
    if (!plasmoid || !plasmoid.configuration) return [];
    plasmoid.configuration.hasSeeded = false;
    if (typeof plasmoid.configuration.writeConfig === "function") {
        plasmoid.configuration.writeConfig();
    }
    var list = loadHabits(plasmoid);
    return list;
}

function saveHabits(plasmoid, habits) {
    if (!plasmoid || !plasmoid.configuration) return false;
    try {
        plasmoid.configuration.habitsData = JSON.stringify(habits);
        if (typeof plasmoid.configuration.writeConfig === "function") {
            plasmoid.configuration.writeConfig();
        }
        return true;
    } catch (e) {
        console.error("[HabitStorage] Failed to save habitsData:", e);
        return false;
    }
}

function addHabit(plasmoid, habitObj) {
    var habits = loadHabits(plasmoid);
    var nowKey = new Date().toISOString().substring(0, 10);
    var newHabit = {
        id: generateId(),
        name: (habitObj.name || "").trim(),
        description: (habitObj.description || "").trim(),
        icon: habitObj.icon || "user-identity",
        color: habitObj.color || "#27ae60",
        frequencyType: habitObj.frequencyType || "daily",
        frequencyDays: habitObj.frequencyDays || [0, 1, 2, 3, 4, 5, 6],
        weeklyTarget: habitObj.weeklyTarget || 7,
        targetCount: habitObj.targetCount || 1,
        startDate: habitObj.startDate || nowKey,
        completions: {}
    };

    habits.push(newHabit);
    saveHabits(plasmoid, habits);
    return newHabit;
}

function updateHabit(plasmoid, id, habitObj) {
    var habits = loadHabits(plasmoid);
    for (var i = 0; i < habits.length; i++) {
        if (habits[i].id === id) {
            if (habitObj.name !== undefined) habits[i].name = habitObj.name.trim();
            if (habitObj.description !== undefined) habits[i].description = habitObj.description.trim();
            if (habitObj.icon !== undefined) habits[i].icon = habitObj.icon;
            if (habitObj.color !== undefined) habits[i].color = habitObj.color;
            if (habitObj.frequencyType !== undefined) habits[i].frequencyType = habitObj.frequencyType;
            if (habitObj.frequencyDays !== undefined) habits[i].frequencyDays = habitObj.frequencyDays;
            if (habitObj.targetCount !== undefined) habits[i].targetCount = habitObj.targetCount;
            saveHabits(plasmoid, habits);
            return habits[i];
        }
    }
    return null;
}

function deleteHabit(plasmoid, id) {
    var habits = loadHabits(plasmoid);
    var filtered = habits.filter(function(h) { return h.id !== id; });
    saveHabits(plasmoid, filtered);
    return filtered;
}

function toggleCompletion(plasmoid, habitId, dateKey) {
    var habits = loadHabits(plasmoid);
    var targetDateKey = dateKey || new Date().toISOString().substring(0, 10);
    var newStatus = false;

    for (var i = 0; i < habits.length; i++) {
        if (habits[i].id === habitId) {
            if (!habits[i].completions) habits[i].completions = {};
            var targetCount = habits[i].targetCount || 1;
            var currentCount = habits[i].completions[targetDateKey] || 0;

            if (currentCount >= targetCount) {
                // Undo completion
                delete habits[i].completions[targetDateKey];
                newStatus = false;
            } else {
                // Complete
                habits[i].completions[targetDateKey] = targetCount;
                newStatus = true;
            }
            saveHabits(plasmoid, habits);
            break;
        }
    }
    return newStatus;
}

