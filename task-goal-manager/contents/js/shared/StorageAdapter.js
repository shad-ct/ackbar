.pragma library

/**
 * StorageAdapter provides a consistent, versioned JSON persistence abstraction
 * backed by Plasma 6 KConfigXT configuration (plasmoid.configuration).
 */

function safeParse(jsonStr, fallback) {
    if (!jsonStr || typeof jsonStr !== "string") {
        return fallback;
    }
    try {
        var parsed = JSON.parse(jsonStr);
        return parsed !== null && parsed !== undefined ? parsed : fallback;
    } catch (e) {
        console.warn("[StorageAdapter] Failed to parse JSON:", e, "Payload was:", jsonStr);
        return fallback;
    }
}

function safeStringify(data) {
    try {
        return JSON.stringify(data);
    } catch (e) {
        console.error("[StorageAdapter] Failed to stringify data:", e);
        return "";
    }
}

function loadVersioned(plasmoid, configKey, currentVersion, defaultData, migrationFn) {
    if (!plasmoid || !plasmoid.configuration) {
        return defaultData;
    }
    var raw = plasmoid.configuration[configKey];
    var parsed = safeParse(raw, null);

    if (!parsed || typeof parsed !== "object") {
        return {
            version: currentVersion,
            data: defaultData
        };
    }

    if (parsed.version === undefined) {
        parsed = {
            version: 1,
            data: parsed
        };
    }

    if (migrationFn && parsed.version < currentVersion) {
        parsed = migrationFn(parsed, currentVersion);
    }

    return parsed;
}

function saveVersioned(plasmoid, configKey, version, data) {
    if (!plasmoid || !plasmoid.configuration) {
        console.warn("[StorageAdapter] plasmoid or plasmoid.configuration is unavailable");
        return false;
    }
    var envelope = {
        version: version,
        updatedAt: new Date().toISOString(),
        data: data
    };
    var serialized = safeStringify(envelope);
    plasmoid.configuration[configKey] = serialized;

    if (typeof plasmoid.configuration.writeConfig === "function") {
        plasmoid.configuration.writeConfig();
    }
    return true;
}

function loadRaw(plasmoid, configKey, fallback) {
    if (!plasmoid || !plasmoid.configuration) {
        return fallback;
    }
    var raw = plasmoid.configuration[configKey];
    return safeParse(raw, fallback);
}

function saveRaw(plasmoid, configKey, data) {
    if (!plasmoid || !plasmoid.configuration) {
        return false;
    }
    plasmoid.configuration[configKey] = safeStringify(data);
    if (typeof plasmoid.configuration.writeConfig === "function") {
        plasmoid.configuration.writeConfig();
    }
    return true;
}

