.pragma library

function getDeletedIds(plasmoid) {
    if (!plasmoid || !plasmoid.configuration) return [];
    var raw = plasmoid.configuration.completedPromptIds;
    if (!raw) return [];
    try {
        var list = JSON.parse(raw);
        return Array.isArray(list) ? list : [];
    } catch (e) {
        return [];
    }
}

function getFavourites(plasmoid) {
    if (!plasmoid || !plasmoid.configuration) return [];
    var raw = plasmoid.configuration.favouritePromptIds;
    if (!raw) return [];
    try {
        var parsed = JSON.parse(raw);
        return Array.isArray(parsed) ? parsed : [];
    } catch (e) {
        return [];
    }
}

function saveFavourites(plasmoid, favs) {
    if (!plasmoid || !plasmoid.configuration) return false;
    plasmoid.configuration.favouritePromptIds = JSON.stringify(favs);
    if (typeof plasmoid.configuration.writeConfig === "function") {
        plasmoid.configuration.writeConfig();
    }
    return true;
}

function toggleFavorite(plasmoid, promptId) {
    var favs = getFavourites(plasmoid);
    var index = favs.indexOf(promptId);
    var isFav = false;
    if (index === -1) {
        favs.push(promptId);
        isFav = true;
    } else {
        favs.splice(index, 1);
        isFav = false;
    }
    saveFavourites(plasmoid, favs);
    return isFav;
}

function isFavorite(plasmoid, promptId) {
    return getFavourites(plasmoid).indexOf(promptId) !== -1;
}

function markDone(plasmoid, promptId) {
    if (!plasmoid || !plasmoid.configuration || !promptId) return;
    var done = getDeletedIds(plasmoid);
    if (done.indexOf(promptId) === -1) {
        done.push(promptId);
        plasmoid.configuration.completedPromptIds = JSON.stringify(done);
    }
    if (typeof plasmoid.configuration.writeConfig === "function") {
        plasmoid.configuration.writeConfig();
    }
}

function clearAllDone(plasmoid) {
    if (!plasmoid || !plasmoid.configuration) return;
    plasmoid.configuration.completedPromptIds = "[]";
    if (typeof plasmoid.configuration.writeConfig === "function") {
        plasmoid.configuration.writeConfig();
    }
}

function getTodayKey() {
    return new Date().toISOString().substring(0, 10);
}

function selectPrompt(plasmoid, allPrompts) {
    if (!allPrompts || allPrompts.length === 0) return null;

    var today = getTodayKey();
    var lastDate = plasmoid && plasmoid.configuration ? plasmoid.configuration.lastPromptDate : "";
    var lastId = plasmoid && plasmoid.configuration ? plasmoid.configuration.lastPromptId : "";

    // Rotate daily: if a new day, pick a fresh prompt
    var rotate = (lastDate !== today);

    var done = getDeletedIds(plasmoid);

    var candidates;
    if (rotate) {
        // Fresh day: pick from prompts not yet done (or all if everything done)
        candidates = allPrompts.filter(function(p) { return done.indexOf(p.id) === -1; });
        if (candidates.length === 0) candidates = allPrompts.slice();
    } else {
        // Same day: keep showing the last prompt if it exists
        var current = allPrompts.find(function(p) { return p.id === lastId; });
        if (current) return current;
        // Otherwise pick a random not-done one
        candidates = allPrompts.filter(function(p) { return done.indexOf(p.id) === -1; });
        if (candidates.length === 0) candidates = allPrompts.slice();
    }

    var idx = Math.floor(Math.random() * candidates.length);
    var chosen = candidates[idx];

    if (plasmoid && plasmoid.configuration) {
        plasmoid.configuration.lastPromptDate = today;
        plasmoid.configuration.lastPromptId = chosen.id;
        if (typeof plasmoid.configuration.writeConfig === "function") {
            plasmoid.configuration.writeConfig();
        }
    }
    return chosen;
}

function getPromptById(allPrompts, id) {
    if (!allPrompts || !id) return null;
    return allPrompts.find(function(p) { return p.id === id; }) || null;
}
