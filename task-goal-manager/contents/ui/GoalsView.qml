import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import "shared" as Shared
import "../js/progress-calculator.js" as Calc

Item {
    id: root

    property var goalsList: []
    property var allTasks: []

    signal goalAdded(var goalObj)
    signal goalDeleted(string id)
    signal milestoneToggled(string goalId, string milestoneId)
    signal milestoneAdded(string goalId, string title, int weight)

    ColumnLayout {
        anchors.fill: parent
        spacing: 8

        // Header action
        RowLayout {
            Layout.fillWidth: true
            spacing: 6

            Text {
                text: i18n("Active Goals")
                font.pointSize: Kirigami.Theme.defaultFont.pointSize
                font.weight: Font.DemiBold
                color: Kirigami.Theme.textColor
                Layout.fillWidth: true
            }

            PlasmaComponents.Button {
                text: i18n("+ New Goal")
                icon.name: "list-add"
                highlighted: true
                onClicked: newGoalBox.visible = !newGoalBox.visible
            }
        }

        // New Goal Form
        Rectangle {
            id: newGoalBox
            visible: false
            Layout.fillWidth: true
            implicitHeight: newGoalLayout.implicitHeight + 16
            radius: 8
            color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.05)
            border.color: Kirigami.Theme.highlightColor
            border.width: 1

            ColumnLayout {
                id: newGoalLayout
                anchors.fill: parent
                anchors.margins: 8
                spacing: 6

                PlasmaComponents.TextField {
                    id: newGoalTitle
                    Layout.fillWidth: true
                    placeholderText: i18n("Goal name (e.g. ESP32 Drone Project)")
                }

                PlasmaComponents.TextField {
                    id: newGoalDesc
                    Layout.fillWidth: true
                    placeholderText: i18n("Description...")
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 6

                    PlasmaComponents.TextField {
                        id: newGoalCat
                        Layout.fillWidth: true
                        placeholderText: i18n("Category (e.g. Engineering)")
                    }

                    PlasmaComponents.TextField {
                        id: newGoalDate
                        Layout.preferredWidth: 120
                        placeholderText: "YYYY-MM-DD"
                    }

                    PlasmaComponents.Button {
                        text: i18n("Save")
                        highlighted: true
                        enabled: newGoalTitle.text.trim().length > 0
                        onClicked: {
                            root.goalAdded({
                                title: newGoalTitle.text.trim(),
                                description: newGoalDesc.text.trim(),
                                category: newGoalCat.text.trim() || "General",
                                targetDate: newGoalDate.text.trim() || "",
                                milestones: []
                            });
                            newGoalTitle.text = "";
                            newGoalDesc.text = "";
                            newGoalCat.text = "";
                            newGoalBox.visible = false;
                        }
                    }
                }
            }
        }

        // Goals List
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Shared.EmptyState {
                visible: root.goalsList.length === 0
                anchors.centerIn: parent
                title: i18n("No goals set")
                description: i18n("Create a long-term goal to track milestones and associated tasks.")
                iconName: "view-calendar-tasks"
            }

            PlasmaComponents.ScrollView {
                anchors.fill: parent
                visible: root.goalsList.length > 0
                clip: true

                ListView {
                    id: goalsListView
                    width: parent.width
                    spacing: 10
                    model: root.goalsList

                    delegate: Shared.CardContainer {
                        id: goalCard
                        width: goalsListView.width
                        height: implicitHeight
                        contentPadding: 10
                        contentSpacing: 8

                        property int progressVal: Calc.calculateGoalProgress(modelData, root.allTasks)

                        // Top header
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2

                                Text {
                                    text: modelData.title
                                    font.pointSize: Kirigami.Theme.defaultFont.pointSize + 1
                                    font.weight: Font.DemiBold
                                    color: Kirigami.Theme.textColor
                                    Layout.fillWidth: true
                                }

                                Text {
                                    visible: modelData.description !== ""
                                    text: modelData.description
                                    font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 3, 8)
                                    color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.6)
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                }
                            }

                            Shared.MetricBadge {
                                text: goalCard.progressVal + "%"
                                badgeColor: goalCard.progressVal >= 100 ? "#27ae60" : Kirigami.Theme.highlightColor
                                subtle: false
                            }

                            PlasmaComponents.Button {
                                icon.name: "edit-delete"
                                Layout.preferredWidth: 24
                                Layout.preferredHeight: 24
                                flat: true
                                onClicked: root.goalDeleted(modelData.id)
                            }
                        }

                        // Progress bar
                        Rectangle {
                            Layout.fillWidth: true
                            height: 6
                            radius: 3
                            color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.08)

                            Rectangle {
                                height: parent.height
                                radius: 3
                                width: parent.width * (goalCard.progressVal / 100.0)
                                color: goalCard.progressVal >= 100 ? "#27ae60" : Kirigami.Theme.highlightColor

                                Behavior on width {
                                    NumberAnimation { duration: 250 }
                                }
                            }
                        }

                        // Milestones overview
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4

                            Repeater {
                                model: modelData.milestones || []
                                delegate: RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 6

                                    PlasmaComponents.CheckBox {
                                        checked: modelData.completed
                                        onToggled: root.milestoneToggled(modelData.id, modelData.id)
                                    }

                                    Text {
                                        text: modelData.title
                                        font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 2, 8)
                                        font.strikeout: modelData.completed
                                        color: modelData.completed
                                               ? Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.5)
                                               : Kirigami.Theme.textColor
                                        Layout.fillWidth: true
                                    }

                                    Shared.MetricBadge {
                                        text: Calc.getMilestoneProgress(modelData, root.allTasks) + "%"
                                        subtle: true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
