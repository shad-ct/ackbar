import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import "shared" as Shared

Item {
    id: root

    property var tasksList: []
    property var goalsList: []
    property string activeStatusFilter: "Pending" // All | Pending | Completed
    property string activeSort: "priority" // priority | deadline

    signal taskToggled(string id)
    signal taskDeleted(string id)
    signal clearAllTasksClicked()
    signal taskAdded(var taskObj)

    function focusInput() {
        quickTaskTitle.forceActiveFocus();
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 8

        // Quick Add Task Bar
        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 6

            PlasmaComponents.TextField {
                id: quickTaskTitle
                Layout.fillWidth: true
                Layout.preferredHeight: 32
                Layout.alignment: Qt.AlignVCenter
                placeholderText: i18n("Add a new task... (press Enter)")
                font.pointSize: Kirigami.Theme.defaultFont.pointSize

                Keys.onReturnPressed: {
                    if (text.trim().length > 0) {
                        root.taskAdded({
                            title: text.trim(),
                            priority: quickPriorityCombo.currentText,
                            dueDate: new Date().toISOString().substring(0, 10),
                            goalId: null,
                            milestoneId: null
                        });
                        text = "";
                    }
                }
            }

            QQC2.ComboBox {
                id: quickPriorityCombo
                Layout.preferredWidth: 100
                Layout.preferredHeight: 32
                Layout.alignment: Qt.AlignVCenter
                model: ["Low", "Medium", "High", "Urgent"]
                currentIndex: 1 // Medium
            }

            PlasmaComponents.Button {
                text: i18n("Add")
                icon.name: "list-add"
                highlighted: true
                Layout.preferredHeight: 32
                Layout.alignment: Qt.AlignVCenter
                enabled: quickTaskTitle.text.trim().length > 0
                onClicked: {
                    root.taskAdded({
                        title: quickTaskTitle.text.trim(),
                        priority: quickPriorityCombo.currentText,
                        dueDate: new Date().toISOString().substring(0, 10),
                        goalId: null,
                        milestoneId: null
                    });
                    quickTaskTitle.text = "";
                }
            }
        }

        // Filters row
        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 4

            Repeater {
                model: [
                    { label: i18n("Pending"), val: "Pending" },
                    { label: i18n("Completed"), val: "Completed" },
                    { label: i18n("All"), val: "All" }
                ]
                delegate: PlasmaComponents.Button {
                    text: modelData.label
                    flat: root.activeStatusFilter !== modelData.val
                    Layout.preferredHeight: 26
                    Layout.alignment: Qt.AlignVCenter
                    font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 2, 8)
                    onClicked: root.activeStatusFilter = modelData.val
                }
            }

            PlasmaComponents.Button {
                text: i18n("Clear All")
                icon.name: "edit-clear-all"
                visible: root.tasksList.length > 0
                flat: true
                Layout.preferredHeight: 26
                Layout.alignment: Qt.AlignVCenter
                font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 2, 8)
                onClicked: root.clearAllTasksClicked()
            }

            Item { Layout.fillWidth: true }

            Text {
                text: i18n("Sort:")
                font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 2, 8)
                color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.6)
                Layout.alignment: Qt.AlignVCenter
            }

            QQC2.ComboBox {
                id: sortCombo
                Layout.preferredWidth: 100
                Layout.preferredHeight: 26
                Layout.alignment: Qt.AlignVCenter
                model: ["priority", "deadline"]
                currentIndex: root.activeSort === "priority" ? 0 : 1
                onActivated: root.activeSort = currentText
            }
        }

        // Tasks List
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Shared.EmptyState {
                visible: filteredTasks().length === 0
                anchors.centerIn: parent
                title: i18n("No tasks found")
                description: i18n("Create a task above to start tracking your daily progress.")
                iconName: "task-complete"
            }

            PlasmaComponents.ScrollView {
                anchors.fill: parent
                visible: filteredTasks().length > 0
                clip: true

                ListView {
                    id: listView
                    width: parent.width
                    spacing: 6
                    model: filteredTasks()

                    delegate: Shared.CardContainer {
                        id: taskCard
                        width: listView.width
                        height: implicitHeight
                        contentPadding: 10
                        contentSpacing: 4

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                            spacing: 10

                            PlasmaComponents.CheckBox {
                                checked: modelData.status === "Completed"
                                Layout.alignment: Qt.AlignVCenter
                                onToggled: root.taskToggled(modelData.id)
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter
                                spacing: 4

                                Text {
                                    text: modelData.title
                                    font.pointSize: Kirigami.Theme.defaultFont.pointSize
                                    font.weight: Font.Medium
                                    font.strikeout: modelData.status === "Completed"
                                    color: modelData.status === "Completed"
                                           ? Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.5)
                                           : Kirigami.Theme.textColor
                                    Layout.fillWidth: true
                                    wrapMode: Text.WordWrap
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter
                                    spacing: 6

                                    Shared.MetricBadge {
                                        text: modelData.priority
                                        badgeColor: {
                                            if (modelData.priority === "Urgent") return "#e74c3c";
                                            if (modelData.priority === "High") return "#e67e22";
                                            if (modelData.priority === "Medium") return "#3498db";
                                            return "#7f8c8d";
                                        }
                                        Layout.alignment: Qt.AlignVCenter
                                    }

                                    Text {
                                        visible: modelData.dueDate !== ""
                                        text: modelData.dueDate ? "📅 " + modelData.dueDate : ""
                                        font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 3, 8)
                                        color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.6)
                                        Layout.alignment: Qt.AlignVCenter
                                    }

                                    Text {
                                        visible: modelData.category !== ""
                                        text: modelData.category
                                        font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 3, 8)
                                        color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.5)
                                        Layout.alignment: Qt.AlignVCenter
                                    }
                                }
                            }

                            PlasmaComponents.Button {
                                icon.name: "edit-delete"
                                Layout.preferredWidth: 26
                                Layout.preferredHeight: 26
                                Layout.alignment: Qt.AlignVCenter
                                flat: true
                                onClicked: root.taskDeleted(modelData.id)
                            }
                        }
                    }
                }
            }
        }
    }

    function filteredTasks() {
        var list = (root.tasksList || []).filter(function(t) {
            if (root.activeStatusFilter === "Pending" && t.status === "Completed") return false;
            if (root.activeStatusFilter === "Completed" && t.status !== "Completed") return false;
            return true;
        });

        var priorityWeight = { "Urgent": 4, "High": 3, "Medium": 2, "Low": 1 };

        list.sort(function(a, b) {
            if (root.activeSort === "priority") {
                var wa = priorityWeight[a.priority] || 2;
                var wb = priorityWeight[b.priority] || 2;
                return wb - wa;
            } else {
                if (!a.dueDate) return 1;
                if (!b.dueDate) return -1;
                return a.dueDate.localeCompare(b.dueDate);
            }
        });
        return list;
    }
}
