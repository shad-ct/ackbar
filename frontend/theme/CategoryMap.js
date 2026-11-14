.pragma library

var CATEGORIES = {
    "browsing": { name: "Web Browsing", icon: "🌐", color: "#3498db" },
    "media": { name: "Media & Gaming", icon: "🎬", color: "#e74c3c" },
    "development": { name: "Development", icon: "💻", color: "#2ecc71" },
    "communication": { name: "Communication", icon: "💬", color: "#9b59b6" },
    "system": { name: "System & Desktop", icon: "⚙️", color: "#95a5a6" },
    "terminal": { name: "Terminal & Ops", icon: "📟", color: "#1abc9c" },
    "notes": { name: "Notes & Docs", icon: "📝", color: "#f39c12" },
    "design": { name: "Design & Creative", icon: "🎨", color: "#e67e22" },
    "other": { name: "Other Apps", icon: "📌", color: "#7f8c8d" },
    "locked": { name: "Locked / Away", icon: "🔒", color: "#34495e" }
};

function getCategoryInfo(key) {
    if (CATEGORIES[key]) {
        return CATEGORIES[key];
    }
    return { name: key || "Other", icon: "📌", color: "#7f8c8d" };
}

function getCategoryColor(key) {
    return getCategoryInfo(key).color;
}

function getCategoryIcon(key) {
    return getCategoryInfo(key).icon;
}

function getCategoryName(key) {
    return getCategoryInfo(key).name;
}
