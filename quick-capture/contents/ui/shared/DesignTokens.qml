import QtQuick
import org.kde.kirigami as Kirigami

QtObject {
    id: root

    // Corner radiuses
    readonly property real radiusSmall: 4
    readonly property real radiusMedium: 8
    readonly property real radiusLarge: 12

    // Spacing tokens (relative to Kirigami units where appropriate)
    readonly property int spaceXs: 4
    readonly property int spaceSm: 8
    readonly property int spaceMd: 12
    readonly property int spaceLg: 16
    readonly property int spaceXl: 24

    // Visual constraints
    readonly property real borderOpacitySubtle: 0.12
    readonly property real borderOpacityStrong: 0.25
    readonly property real backgroundSubtleAlpha: 0.05
    readonly property real hoverAlpha: 0.08
    readonly property real activeAlpha: 0.15

    // Standard animation durations
    readonly property int animDurationFast: 120
    readonly property int animDurationNormal: 200
    readonly property int animDurationSlow: 320

    // Widget sizing recommendations
    readonly property int defaultPanelIconSize: Kirigami.Units.iconSizes.medium
    readonly property int popupPreferredWidth: Math.round(Kirigami.Units.gridUnit * 22)
    readonly property int popupPreferredHeight: Math.round(Kirigami.Units.gridUnit * 26)
}

