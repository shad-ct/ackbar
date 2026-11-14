pragma Singleton
import QtQuick

QtObject {
    // Colors - Dark First (Breeze Dark Compatible)
    readonly property color bgBase: "#181820"
    readonly property color bgCard: "#22222c"
    readonly property color bgCardHover: "#2a2a36"
    readonly property color bgSidebar: "#14141a"
    readonly property color bgHeader: "#1b1b24"
    readonly property color borderSubtle: "#323242"
    readonly property color borderFocus: "#3498db"

    // Text colors
    readonly property color textPrimary: "#f5f6fa"
    readonly property color textSecondary: "#a4b0be"
    readonly property color textMuted: "#718093"

    // Accents
    readonly property color accentPrimary: "#3498db"
    readonly property color accentSuccess: "#2ecc71"
    readonly property color accentWarning: "#f39c12"
    readonly property color accentDanger: "#e74c3c"
    readonly property color accentPurple: "#9b59b6"
    readonly property color accentTeal: "#1abc9c"

    // Spacing & Radii
    readonly property int radiusSmall: 6
    readonly property int radiusMedium: 10
    readonly property int radiusLarge: 14
    readonly property int radiusPill: 999

    readonly property int spacingSmall: 8
    readonly property int spacingMedium: 14
    readonly property int spacingLarge: 20
}

