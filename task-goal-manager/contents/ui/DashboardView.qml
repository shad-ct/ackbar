import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import "shared" as Shared
import "../js/progress-calculator.js" as Calc

Item {
    id: root

    property var metrics: null

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        // 4 Key Metric Cards
        GridLayout {
            Layout.fillWidth: true
            columns: 2
            rowSpacing: 8
            columnSpacing: 8

            Shared.CardContainer {
                Layout.fillWidth: true
                contentPadding: 8

                Text {
                    text: i18n("Tasks Due Today")
                    font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 3, 8)
                    color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.6)
                }
                Text {
                    text: (root.metrics ? root.metrics.dueTodayCount : 0).toString()
                    font.pointSize: Kirigami.Theme.defaultFont.pointSize + 4
                    font.weight: Font.Bold
                    color: Kirigami.Theme.highlightColor
                }
            }

            Shared.CardContainer {
                Layout.fillWidth: true
                contentPadding: 8

                Text {
                    text: i18n("Overdue Tasks")
                    font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 3, 8)
                    color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.6)
                }
                Text {
                    text: (root.metrics ? root.metrics.overdueCount : 0).toString()
                    font.pointSize: Kirigami.Theme.defaultFont.pointSize + 4
                    font.weight: Font.Bold
                    color: root.metrics && root.metrics.overdueCount > 0 ? "#e74c3c" : "#27ae60"
                }
            }

            Shared.CardContainer {
                Layout.fillWidth: true
                contentPadding: 8

                Text {
                    text: i18n("Upcoming (7 Days)")
                    font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 3, 8)
                    color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.6)
                }
                Text {
                    text: (root.metrics ? root.metrics.upcomingCount : 0).toString()
                    font.pointSize: Kirigami.Theme.defaultFont.pointSize + 4
                    font.weight: Font.Bold
                    color: "#3498db"
                }
            }

            Shared.CardContainer {
                Layout.fillWidth: true
                contentPadding: 8

                Text {
                    text: i18n("Active Goals")
                    font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 3, 8)
                    color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.6)
                }
                Text {
                    text: (root.metrics && root.metrics.activeGoals ? root.metrics.activeGoals.length : 0).toString()
                    font.pointSize: Kirigami.Theme.defaultFont.pointSize + 4
                    font.weight: Font.Bold
                    color: "#9b59b6"
                }
            }
        }

        // Active Goals Section
        Text {
            text: i18n("Active Goal Progress:")
            font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 1, 9)
            font.weight: Font.DemiBold
            color: Kirigami.Theme.textColor
        }

        PlasmaComponents.ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ListView {
                width: parent.width
                spacing: 6
                model: root.metrics ? root.metrics.activeGoals : []

                delegate: Shared.CardContainer {
                    width: parent.width
                    contentPadding: 8
                    contentSpacing: 4

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            text: modelData.title
                            font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 1, 9)
                            font.weight: Font.Medium
                            color: Kirigami.Theme.textColor
                            Layout.fillWidth: true
                        }

                        Shared.MetricBadge {
                            text: modelData.progress + "%"
                            badgeColor: modelData.progress >= 100 ? "#27ae60" : Kirigami.Theme.highlightColor
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 4
                        radius: 2
                        color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.08)

                        Rectangle {
                            height: parent.height
                            radius: 2
                            width: parent.width * (modelData.progress / 100.0)
                            color: modelData.progress >= 100 ? "#27ae60" : Kirigami.Theme.highlightColor
                        }
                    }
                }
            }
        }
    }
}

