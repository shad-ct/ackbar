import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import "shared" as Shared
import "../js/challenges-data.js" as Data

Rectangle {
    id: root

    property var statsData: null
    property string activeTab: "stats" // stats | custom | history
    property var historyList: []

    signal customCreated(string title, string desc, string cat, string diff, int dur)
    signal closed()

    radius: 8
    color: Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, 0.98)
    border.color: Kirigami.Theme.highlightColor
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8

        // Header
        RowLayout {
            Layout.fillWidth: true
            spacing: 6

            Text {
                text: root.activeTab === "stats" ? i18n("Challenge Statistics")
                      : (root.activeTab === "custom" ? i18n("Create Custom Challenge") : i18n("Completed History"))
                font.pointSize: Kirigami.Theme.defaultFont.pointSize
                font.weight: Font.DemiBold
                color: Kirigami.Theme.textColor
                Layout.fillWidth: true
            }

            PlasmaComponents.Button {
                icon.name: "window-close"
                flat: true
                Layout.preferredWidth: 24
                Layout.preferredHeight: 24
                onClicked: root.closed()
            }
        }

        // Sub-tabs
        RowLayout {
            Layout.fillWidth: true
            spacing: 4

            PlasmaComponents.Button {
                Layout.fillWidth: true
                text: i18n("Statistics")
                flat: root.activeTab !== "stats"
                onClicked: root.activeTab = "stats"
            }
            PlasmaComponents.Button {
                Layout.fillWidth: true
                text: i18n("History")
                flat: root.activeTab !== "history"
                onClicked: root.activeTab = "history"
            }
            PlasmaComponents.Button {
                Layout.fillWidth: true
                text: i18n("+ Custom")
                flat: root.activeTab !== "custom"
                onClicked: root.activeTab = "custom"
            }
        }

        // View 1: Stats
        ColumnLayout {
            visible: root.activeTab === "stats"
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 8

            GridLayout {
                Layout.fillWidth: true
                columns: 2
                rowSpacing: 8
                columnSpacing: 8

                Shared.CardContainer {
                    Layout.fillWidth: true
                    contentPadding: 8
                    Text {
                        text: i18n("Total Completed")
                        font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 3, 8)
                        color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.6)
                    }
                    Text {
                        text: (root.statsData ? root.statsData.totalCompleted : 0).toString()
                        font.pointSize: Kirigami.Theme.defaultFont.pointSize + 4
                        font.weight: Font.Bold
                        color: "#27ae60"
                    }
                }

                Shared.CardContainer {
                    Layout.fillWidth: true
                    contentPadding: 8
                    Text {
                        text: i18n("Active Days")
                        font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 3, 8)
                        color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.6)
                    }
                    Text {
                        text: (root.statsData ? root.statsData.activeDays : 0).toString()
                        font.pointSize: Kirigami.Theme.defaultFont.pointSize + 4
                        font.weight: Font.Bold
                        color: Kirigami.Theme.highlightColor
                    }
                }
            }

            Text {
                text: i18n("Completions by Difficulty:")
                font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 2, 8)
                font.weight: Font.DemiBold
                color: Kirigami.Theme.textColor
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Shared.MetricBadge {
                    text: i18n("Beginner: %1", root.statsData && root.statsData.difficultyCounts ? root.statsData.difficultyCounts["Beginner"] || 0 : 0)
                    badgeColor: "#27ae60"
                }
                Shared.MetricBadge {
                    text: i18n("Intermediate: %1", root.statsData && root.statsData.difficultyCounts ? root.statsData.difficultyCounts["Intermediate"] || 0 : 0)
                    badgeColor: "#3498db"
                }
                Shared.MetricBadge {
                    text: i18n("Advanced: %1", root.statsData && root.statsData.difficultyCounts ? root.statsData.difficultyCounts["Advanced"] || 0 : 0)
                    badgeColor: "#9b59b6"
                }
            }

            Item { Layout.fillHeight: true }
        }

        // View 2: History
        Item {
            visible: root.activeTab === "history"
            Layout.fillWidth: true
            Layout.fillHeight: true

            Shared.EmptyState {
                visible: root.historyList.length === 0
                anchors.centerIn: parent
                title: i18n("No completions yet")
                description: i18n("Complete challenges to build your history log.")
                iconName: "task-complete"
            }

            PlasmaComponents.ScrollView {
                anchors.fill: parent
                visible: root.historyList.length > 0
                clip: true

                ListView {
                    width: parent.width
                    spacing: 4
                    model: root.historyList

                    delegate: Shared.CardContainer {
                        width: parent.width
                        contentPadding: 6

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 6

                            Shared.MetricBadge {
                                text: modelData.category
                                badgeColor: Kirigami.Theme.highlightColor
                            }

                            Text {
                                text: modelData.title
                                font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 1, 9)
                                color: Kirigami.Theme.textColor
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                            }

                            Text {
                                text: modelData.completedAt ? modelData.completedAt.substring(0, 10) : ""
                                font.pointSize: 7
                                color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.5)
                            }
                        }
                    }
                }
            }
        }

        // View 3: Custom Challenge Form
        ColumnLayout {
            visible: root.activeTab === "custom"
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 6

            PlasmaComponents.TextField {
                id: customTitle
                Layout.fillWidth: true
                placeholderText: i18n("Challenge title")
            }

            PlasmaComponents.TextArea {
                id: customDesc
                Layout.fillWidth: true
                Layout.preferredHeight: 60
                placeholderText: i18n("Actionable instruction...")
                wrapMode: TextEdit.WordWrap
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 6

                QQC2.ComboBox {
                    id: customCatCombo
                    Layout.fillWidth: true
                    model: Data.getCategories()
                }

                QQC2.ComboBox {
                    id: customDiffCombo
                    Layout.preferredWidth: 110
                    model: ["Beginner", "Intermediate", "Advanced"]
                }
            }

            PlasmaComponents.Button {
                text: i18n("Add Custom Challenge")
                icon.name: "list-add"
                highlighted: true
                Layout.alignment: Qt.AlignRight
                enabled: customTitle.text.trim().length > 0
                onClicked: {
                    root.customCreated(
                        customTitle.text.trim(),
                        customDesc.text.trim(),
                        customCatCombo.currentText,
                        customDiffCombo.currentText,
                        15
                    );
                    customTitle.text = "";
                    customDesc.text = "";
                    root.activeTab = "stats";
                }
            }
        }
    }
}

