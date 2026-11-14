.pragma library

/**
 * DateUtils provides date formatting, relative timestamps, and streak helpers.
 */

function toDateKey(dateObj) {
    var d = dateObj ? new Date(dateObj) : new Date();
    if (isNaN(d.getTime())) {
        d = new Date();
    }
    var year = d.getFullYear();
    var month = String(d.getMonth() + 1).padStart(2, "0");
    var day = String(d.getDate()).padStart(2, "0");
    return year + "-" + month + "-" + day;
}

function fromDateKey(key) {
    if (!key || typeof key !== "string") {
        return new Date();
    }
    var parts = key.split("-");
    if (parts.length === 3) {
        return new Date(parseInt(parts[0], 10), parseInt(parts[1], 10) - 1, parseInt(parts[2], 10));
    }
    return new Date(key);
}

function daysBetween(dateA, dateB) {
    var a = new Date(dateA.getFullYear(), dateA.getMonth(), dateA.getDate());
    var b = new Date(dateB.getFullYear(), dateB.getMonth(), dateB.getDate());
    var diffMs = b.getTime() - a.getTime();
    return Math.round(diffMs / (1000 * 60 * 60 * 24));
}

function relativeTime(isoString) {
    if (!isoString) {
        return "";
    }
    var d = new Date(isoString);
    if (isNaN(d.getTime())) {
        return "";
    }
    var now = new Date();
    var diffSec = Math.floor((now.getTime() - d.getTime()) / 1000);

    if (diffSec < 60) {
        return "Just now";
    }
    var diffMin = Math.floor(diffSec / 60);
    if (diffMin < 60) {
        return diffMin + "m ago";
    }
    var diffHour = Math.floor(diffMin / 60);
    if (diffHour < 24) {
        return diffHour + "h ago";
    }
    var diffDays = Math.floor(diffHour / 24);
    if (diffDays === 1) {
        return "Yesterday";
    }
    if (diffDays < 7) {
        return diffDays + "d ago";
    }
    return toDateKey(d);
}

function formatShortTime(isoString) {
    if (!isoString) return "";
    var d = new Date(isoString);
    if (isNaN(d.getTime())) return "";
    var hours = String(d.getHours()).padStart(2, "0");
    var mins = String(d.getMinutes()).padStart(2, "0");
    return hours + ":" + mins;
}

function formatShortDate(isoString) {
    if (!isoString) return "";
    var d = new Date(isoString);
    if (isNaN(d.getTime())) return "";
    var monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return monthNames[d.getMonth()] + " " + d.getDate();
}

function getPastDaysKeys(numDays) {
    var keys = [];
    var today = new Date();
    for (var i = numDays - 1; i >= 0; i--) {
        var d = new Date(today.getFullYear(), today.getMonth(), today.getDate() - i);
        keys.push(toDateKey(d));
    }
    return keys;
}

