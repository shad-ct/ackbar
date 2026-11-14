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

    signal milestoneToggled(string goalId, string milestoneId)
    signal milestoneAdded(string goalId, string title, int weight)

    ColumnLayout {
        anchors.fill: parent
        spacing: 8

        Text {
            text: i18n("Milestones by Goal")
            font.pointSize: Kirigami.Theme.defaultFont.pointSize
            font.weight: Font.DemiBold
            color: Kirigami.Theme.textColor
        }

        PlasmaComponents.ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ListView {
                id: mainList
                width: parent.width
                spacing: 12
                model: root.goalsList

                delegate: Shared.CardContainer {
                    width: mainList.width
                    height: implicitHeight
                    contentPadding: 10
                    contentSpacing: 8

                    property var currentGoal: modelData

                    // Goal Header
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            text: currentGoal.title
                            font.pointSize: Kirigami.Theme.defaultFont.pointSize
                            font.weight: Font.Bold
                            color: Kirigami.Theme.textColor
                            Layout.fillWidth: true
                        }

                        Shared.MetricBadge {
                            text: Calc.calculateGoalProgress(currentGoal, root.allTasks) + "%"
                            badgeColor: Kirigami.Theme.highlightColor
                        }
                    }

                    // Milestones List
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6

                        Repeater {
                            model: currentGoal.milestones || []

                            delegate: Rectangle {
                                Layout.fillWidth: true
                                implicitHeight: mRow.implicitHeight + 8
                                radius: 6
                                color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.04)

                                RowLayout {
                                    id: mRow
                                    anchors.fill: parent
                                    anchors.margins: 6
                                    spacing: 8

                                    PlasmaComponents.CheckBox {
                                        checked: modelData.completed
                                        onToggled: root.milestoneToggled(currentGoal.id, modelData.id)
                                    }

                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 2

                                        Text {
                                            text: modelData.title
                                            font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 1, 9)
                                            font.weight: Font.Medium
                                            font.strikeout: modelData.completed
                                            color: modelData.completed
                                                   ? Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.5)
                                                   : Kirigami.Theme.textColor
                                            Layout.fillWidth: true
                                        }

                                        // Linked tasks indicator
                                        Text {
                                            property var linkedTasks: (root.allTasks || []).filter(function(t) { return t.milestoneId === modelData.id; })
                                            visible: linkedTasks.length > 0
                                            text: i18n("%1 linked tasks (%2 completed)", linkedTasks.length, linkedTasks.filter(function(t){ return t.status === "Completed"; }).length)
                                            font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 3, 8)
                                            color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.55)
                                        }
                                    }

                                    Shared.MetricBadge {
                                        text: Calc.getMilestoneProgress(modelData, root.allTasks) + "%"
                                        badgeColor: Calc.getMilestoneProgress(modelData, root.allTasks) >= 100 ? "#27ae60" : Kirigami.Theme.highlightColor
                                        subtle: true
                                    }
                                }
                            }
                        }

                        // Add Milestone Input
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 6

                            PlasmaComponents.TextField {
                                id: newMilestoneTitle
                                Layout.fillWidth: true
                                placeholderText: i18n("Add milestone to %1...", currentGoal.title)
                                font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 2, 8)

                                Keys.onReturnPressed: {
                                    if (text.trim().length > 0) {
                                        root.milestoneAdded(currentGoal.id, text.trim(), 1);
                                        text = "";
                                    }
                                }
                            }

                            PlasmaComponents.Button {
                                text: i18n("Add")
                                flat: true
                                enabled: newMilestoneTitle.text.trim().length > 0
                                onClicked: {
                                    root.milestoneAdded(currentGoal.id, newMilestoneTitle.text.trim(), 1);
                                    newMilestoneTitle.text = "";
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
