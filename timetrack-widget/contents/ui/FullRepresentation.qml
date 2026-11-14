import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasmoid

Item {
    id: root

    property var plasmoidItem: null

    Layout.minimumWidth: 340
    Layout.preferredWidth: 360
    Layout.minimumHeight: 380
    Layout.preferredHeight: 400

    implicitWidth: Layout.preferredWidth
    implicitHeight: Layout.preferredHeight

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        // Header
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Kirigami.Icon {
                source: "office-chart-line"
                Layout.preferredWidth: 24
                Layout.preferredHeight: 24
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 1

                Text {
                    text: i18n("TimeTrack Analytics")
                    font.pointSize: Kirigami.Theme.defaultFont.pointSize + 1
                    font.weight: Font.DemiBold
                    color: Kirigami.Theme.textColor
                }

                Text {
                    text: i18n("Computer Usage & Focus")
                    font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 3, 8)
                    color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.6)
                }
            }

            Rectangle {
                implicitWidth: statusText.implicitWidth + 12
                implicitHeight: 22
                radius: 11
                color: Qt.rgba(46, 204, 113, 0.15)
                border.color: "#2ecc71"
                border.width: 1

                Text {
                    id: statusText
                    anchors.centerIn: parent
                    text: root.plasmoidItem && root.plasmoidItem.isTrackerRunning ? i18n("Tracking Active") : i18n("Tracker Offline")
                    font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 3, 8)
                    font.weight: Font.Medium
                    color: "#2ecc71"
                }
            }

            PlasmaComponents.Button {
                icon.name: "view-refresh"
                Layout.preferredWidth: 26
                Layout.preferredHeight: 26
                flat: true
                onClicked: {
                    if (root.plasmoidItem) {
                        root.plasmoidItem.refreshData();
                    }
                }
            }
        }

        // Metrics Grid (2x2 Cards)
        GridLayout {
            Layout.fillWidth: true
            columns: 2
            rowSpacing: 8
            columnSpacing: 8

            // 1. Today's Active Focus Time
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 64
                radius: 8
                color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.05)
                border.color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.1)

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 2

                    Text {
                        text: i18n("Active Focus")
                        font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 3, 8)
                        color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.6)
                    }

                    Text {
                        text: root.plasmoidItem ? root.plasmoidItem.activeFormatted : "0m"
                        font.pointSize: Kirigami.Theme.defaultFont.pointSize + 3
                        font.weight: Font.Bold
                        color: "#2ecc71"
                    }
                }
            }

            // 2. Today's Total Online Time
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 64
                radius: 8
                color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.05)
                border.color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.1)

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 2

                    Text {
                        text: i18n("Total Online")
                        font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 3, 8)
                        color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.6)
                    }

                    Text {
                        text: root.plasmoidItem ? root.plasmoidItem.onlineFormatted : "0m"
                        font.pointSize: Kirigami.Theme.defaultFont.pointSize + 3
                        font.weight: Font.Bold
                        color: "#3498db"
                    }
                }
            }

            // 3. Current Application & Continuous Duration
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 64
                radius: 8
                color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.05)
                border.color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.1)

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 2

                    Text {
                        text: i18n("Current Application")
                        font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 3, 8)
                        color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.6)
                    }

                    Text {
                        text: (root.plasmoidItem ? root.plasmoidItem.currentApp : "Idle")
                        font.pointSize: Kirigami.Theme.defaultFont.pointSize
                        font.weight: Font.DemiBold
                        color: Kirigami.Theme.textColor
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    Text {
                        text: i18n("Duration: %1", root.plasmoidItem ? root.plasmoidItem.currentDurationFormatted : "0s")
                        font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 3, 8)
                        color: "#f39c12"
                    }
                }
            }

            // 4. Today's Most-Used Application
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 64
                radius: 8
                color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.05)
                border.color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.1)

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 2

                    Text {
                        text: i18n("Most Used App")
                        font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 3, 8)
                        color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.6)
                    }

                    Text {
                        text: (root.plasmoidItem ? root.plasmoidItem.topApp : "None")
                        font.pointSize: Kirigami.Theme.defaultFont.pointSize
                        font.weight: Font.DemiBold
                        color: Kirigami.Theme.textColor
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    Text {
                        text: (root.plasmoidItem ? root.plasmoidItem.topAppDuration : "0s")
                        font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 3, 8)
                        color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.6)
                    }
                }
            }
        }

        // Weekly Activity Sparkline
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 8
            color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.03)
            border.color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.08)

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 6

                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        text: i18n("7-Day Activity Trend")
                        font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 2, 8)
                        font.weight: Font.Medium
                        color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.7)
                        Layout.fillWidth: true
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 6

                    Repeater {
                        model: root.plasmoidItem ? root.plasmoidItem.sparklineData : []

                        delegate: ColumnLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: 4

                            property real maxActive: {
                                var m = 1;
                                if (root.plasmoidItem && root.plasmoidItem.sparklineData) {
                                    for (var i = 0; i < root.plasmoidItem.sparklineData.length; i++) {
                                        var val = root.plasmoidItem.sparklineData[i].active_seconds || 0;
                                        if (val > m) m = val;
                                    }
                                }
                                return m;
                            }

                            Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                Rectangle {
                                    anchors.bottom: parent.bottom
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    width: Math.max(parent.width - 4, 12)
                                    height: Math.max(parent.height * ((modelData.active_seconds || 0) / maxActive), 4)
                                    radius: 3
                                    color: (index === 6) ? "#2ecc71" : "#3498db"
                                    opacity: modelData.active_seconds > 0 ? 0.9 : 0.2
                                }
                            }

                            Text {
                                text: modelData.date ? modelData.date.substring(8, 10) : ""
                                font.pointSize: 7
                                color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.5)
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }
                }
            }
        }

        // Action Button: Open Full Dashboard
        PlasmaComponents.Button {
            text: i18n("Open Analytics Dashboard")
            icon.name: "office-chart-line"
            highlighted: true
            Layout.fillWidth: true
            Layout.preferredHeight: 36
            onClicked: {
                if (root.plasmoidItem) {
                    root.plasmoidItem.openDashboard();
                }
            }
        }
    }
}
