.pragma library
.import "challenges-data.js" as Data

function getDeletedIds(plasmoid) {
    if (!plasmoid || !plasmoid.configuration) return [];
    var raw = plasmoid.configuration.deletedChallenges;
    if (!raw) return [];
    try {
        var list = JSON.parse(raw);
        return Array.isArray(list) ? list : [];
    } catch (e) {
        return [];
    }
}

function getAllChallenges(plasmoid) {
    var base = Data.getInitialChallenges();
    if (!plasmoid || !plasmoid.configuration) {
        return base;
    }
    var deleted = getDeletedIds(plasmoid);
    var customRaw = plasmoid.configuration.customChallenges;
    var list = base.slice();
    if (customRaw) {
        try {
            var customList = JSON.parse(customRaw);
            if (Array.isArray(customList)) {
                list = list.concat(customList);
            }
        } catch (e) {
            console.warn("[ChallengeEngine] Failed to parse customChallenges:", e);
        }
    }
    if (deleted.length > 0) {
        list = list.filter(function(c) { return deleted.indexOf(c.id) === -1; });
    }
    return list;
}

function deleteChallenge(plasmoid, challengeId) {
    if (!plasmoid || !plasmoid.configuration || !challengeId) return;
    var customRaw = plasmoid.configuration.customChallenges;
    if (customRaw) {
        try {
            var customList = JSON.parse(customRaw);
            if (Array.isArray(customList)) {
                var filtered = customList.filter(function(c) { return c.id !== challengeId; });
                plasmoid.configuration.customChallenges = JSON.stringify(filtered);
            }
        } catch (e) {}
    }
    var deleted = getDeletedIds(plasmoid);
    if (deleted.indexOf(challengeId) === -1) {
        deleted.push(challengeId);
        plasmoid.configuration.deletedChallenges = JSON.stringify(deleted);
    }
    if (typeof plasmoid.configuration.writeConfig === "function") {
        plasmoid.configuration.writeConfig();
    }
}

function clearAllChallenges(plasmoid) {
    if (!plasmoid || !plasmoid.configuration) return;
    var all = Data.getInitialChallenges();
    var allIds = all.map(function(c) { return c.id; });
    plasmoid.configuration.deletedChallenges = JSON.stringify(allIds);
    plasmoid.configuration.customChallenges = "[]";
    if (typeof plasmoid.configuration.writeConfig === "function") {
        plasmoid.configuration.writeConfig();
    }
}

function resetAllChallenges(plasmoid) {
    if (!plasmoid || !plasmoid.configuration) return;
    plasmoid.configuration.deletedChallenges = "[]";
    if (typeof plasmoid.configuration.writeConfig === "function") {
        plasmoid.configuration.writeConfig();
    }
}

function clearCompletedHistory(plasmoid) {
    if (!plasmoid || !plasmoid.configuration) return;
    plasmoid.configuration.completedHistory = "[]";
    if (typeof plasmoid.configuration.writeConfig === "function") {
        plasmoid.configuration.writeConfig();
    }
}

function getFavorites(plasmoid) {
    if (!plasmoid || !plasmoid.configuration) return [];
    var raw = plasmoid.configuration.favoriteChallenges;
    if (!raw) return [];
    try {
        var parsed = JSON.parse(raw);
        return Array.isArray(parsed) ? parsed : [];
    } catch (e) {
        return [];
    }
}

function saveFavorites(plasmoid, favs) {
    if (!plasmoid || !plasmoid.configuration) return false;
    plasmoid.configuration.favoriteChallenges = JSON.stringify(favs);
    if (typeof plasmoid.configuration.writeConfig === "function") {
        plasmoid.configuration.writeConfig();
    }
    return true;
}

function toggleFavorite(plasmoid, challengeId) {
    var favs = getFavorites(plasmoid);
    var index = favs.indexOf(challengeId);
    var isFav = false;
    if (index === -1) {
        favs.push(challengeId);
        isFav = true;
    } else {
        favs.splice(index, 1);
        isFav = false;
    }
    saveFavorites(plasmoid, favs);
    return isFav;
}

function isFavorite(plasmoid, challengeId) {
    var favs = getFavorites(plasmoid);
    return favs.indexOf(challengeId) !== -1;
}

function getCompletedHistory(plasmoid) {
    if (!plasmoid || !plasmoid.configuration) return [];
    var raw = plasmoid.configuration.completedHistory;
    if (!raw) return [];
    try {
        var parsed = JSON.parse(raw);
        return Array.isArray(parsed) ? parsed : [];
    } catch (e) {
        return [];
    }
}

function markCompleted(plasmoid, challenge) {
    if (!plasmoid || !plasmoid.configuration || !challenge) return false;
    var history = getCompletedHistory(plasmoid);
    var record = {
        id: challenge.id,
        title: challenge.title,
        category: challenge.category,
        difficulty: challenge.difficulty,
        duration: challenge.duration,
        completedAt: new Date().toISOString()
    };
    history.unshift(record);
    plasmoid.configuration.completedHistory = JSON.stringify(history);
    if (typeof plasmoid.configuration.writeConfig === "function") {
        plasmoid.configuration.writeConfig();
    }
    return true;
}

function addCustomChallenge(plasmoid, title, description, category, difficulty, duration) {
    if (!plasmoid || !plasmoid.configuration) return null;
    var raw = plasmoid.configuration.customChallenges;
    var customList = [];
    if (raw) {
        try {
            var parsed = JSON.parse(raw);
            if (Array.isArray(parsed)) customList = parsed;
        } catch (e) {}
    }

    var newChallenge = {
        id: "custom_" + Date.now(),
        title: title.trim(),
        description: description.trim(),
        category: category || "Programming",
        difficulty: difficulty || "Beginner",
        duration: parseInt(duration, 10) || 15,
        isCustom: true
    };

    customList.push(newChallenge);
    plasmoid.configuration.customChallenges = JSON.stringify(customList);
    if (typeof plasmoid.configuration.writeConfig === "function") {
        plasmoid.configuration.writeConfig();
    }
    return newChallenge;
}

function getDailyChallenge(plasmoid) {
    var all = getAllChallenges(plasmoid);
    if (all.length === 0) return null;

    var todayKey = new Date().toISOString().substring(0, 10);
    // Hash the date string deterministically
    var hash = 0;
    for (var i = 0; i < todayKey.length; i++) {
        hash = (hash * 31 + todayKey.charCodeAt(i)) % all.length;
    }
    var daily = all[Math.abs(hash)];
    return daily;
}

function getRandomChallenge(plasmoid, categoryFilter, difficultyFilter, maxDuration, excludeId) {
    var all = getAllChallenges(plasmoid);

    var filtered = all.filter(function(item) {
        if (excludeId && item.id === excludeId) return false;
        if (categoryFilter && categoryFilter !== "All" && item.category !== categoryFilter) return false;
        if (difficultyFilter && difficultyFilter !== "All" && item.difficulty !== difficultyFilter) return false;
        if (maxDuration && maxDuration > 0 && item.duration > maxDuration) return false;
        return true;
    });

    if (filtered.length === 0) {
        // Fallback without exclusion if nothing matched
        filtered = all.filter(function(item) {
            if (categoryFilter && categoryFilter !== "All" && item.category !== categoryFilter) return false;
            if (difficultyFilter && difficultyFilter !== "All" && item.difficulty !== difficultyFilter) return false;
            return true;
        });
    }

    if (filtered.length === 0) {
        filtered = all;
    }

    var randIndex = Math.floor(Math.random() * filtered.length);
    return filtered[randIndex];
}

function calculateStatistics(plasmoid) {
    var history = getCompletedHistory(plasmoid);
    var totalCompleted = history.length;
    var categoryCounts = {};
    var difficultyCounts = { "Beginner": 0, "Intermediate": 0, "Advanced": 0 };
    var uniqueDays = {};

    for (var i = 0; i < history.length; i++) {
        var item = history[i];
        // Category
        if (!categoryCounts[item.category]) categoryCounts[item.category] = 0;
        categoryCounts[item.category]++;

        // Difficulty
        if (difficultyCounts[item.difficulty] !== undefined) {
            difficultyCounts[item.difficulty]++;
        }

        // Days
        var dayKey = item.completedAt ? item.completedAt.substring(0, 10) : "";
        if (dayKey) uniqueDays[dayKey] = true;
    }

    return {
        totalCompleted: totalCompleted,
        activeDays: Object.keys(uniqueDays).length,
        categoryCounts: categoryCounts,
        difficultyCounts: difficultyCounts
    };
}

