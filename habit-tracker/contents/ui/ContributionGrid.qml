import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import "../js/streak-calculator.js" as StreakCalc

Item {
    id: root

    property var gridData: []
    property int cellSize: 12
    property int cellSpacing: 3

    implicitWidth: 300
    implicitHeight: (root.cellSize + root.cellSpacing) * 7 + 24

    ColumnLayout {
        anchors.fill: parent
        spacing: 6

        // Legend row
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Text {
                text: i18n("Consistency (Last 10 Weeks)")
                font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 2, 8)
                font.weight: Font.Medium
                color: Kirigami.Theme.textColor
                opacity: 0.8
                Layout.fillWidth: true
            }

            RowLayout {
                spacing: 4

                Text {
                    text: i18n("Less")
                    font.pointSize: 7
                    color: Kirigami.Theme.textColor
                    opacity: 0.5
                }

                Rectangle {
                    width: 10
                    height: 10
                    radius: 2
                    color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.08)
                }
                Rectangle {
                    width: 10
                    height: 10
                    radius: 2
                    color: Qt.rgba(0.18, 0.80, 0.44, 0.45)
                }
                Rectangle {
                    width: 10
                    height: 10
                    radius: 2
                    color: "#27ae60"
                }

                Text {
                    text: i18n("More")
                    font.pointSize: 7
                    color: Kirigami.Theme.textColor
                    opacity: 0.5
                }
            }
        }

        // Grid Flow / Repeater
        Flow {
            Layout.fillWidth: true
            flow: Flow.TopToBottom
            spacing: root.cellSpacing
            height: (root.cellSize + root.cellSpacing) * 7

            Repeater {
                model: root.gridData

                delegate: Rectangle {
                    id: dayCell
                    width: root.cellSize
                    height: root.cellSize
                    radius: 2

                    // Color based on status (non-punitive calm tones)
                    color: {
                        if (modelData.status === "full") {
                            return "#27ae60"; // Solid pleasant green
                        } else if (modelData.status === "partial") {
                            return Qt.rgba(0.15, 0.68, 0.38, 0.45); // Soft green
                        } else if (modelData.status === "missed") {
                            return Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.12); // Soft calm gray
                        } else {
                            // "none" (no habits scheduled on this day)
                            return Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.05);
                        }
                    }

                    border.color: cellMouse.containsMouse
                                  ? Kirigami.Theme.highlightColor
                                  : "transparent"
                    border.width: 1

                    QQC2.ToolTip.text: modelData.dateKey + ": " + modelData.completed + "/" + modelData.scheduled + " " + i18n("completed")
                    QQC2.ToolTip.visible: cellMouse.containsMouse

                    MouseArea {
                        id: cellMouse
                        anchors.fill: parent
                        hoverEnabled: true
                    }
                }
            }
        }
    }
}

