import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasmoid
import "shared" as Shared
import "../js/task-goal-storage.js" as Storage
import "../js/progress-calculator.js" as Calc

Item {
    id: root

    Layout.minimumWidth: Math.max(340, Kirigami.Units.gridUnit * 20)
    Layout.preferredWidth: Math.max(360, Kirigami.Units.gridUnit * 22)
    Layout.minimumHeight: Math.max(460, Kirigami.Units.gridUnit * 26)
    Layout.preferredHeight: Math.max(500, Kirigami.Units.gridUnit * 29)

    implicitWidth: Layout.preferredWidth
    implicitHeight: Layout.preferredHeight
    property var allGoals: []
    property var allTasks: []
    property var dashboardMetrics: null
    property string activeTab: "dashboard" // dashboard | tasks | goals | milestones

    function reloadData() {
        if (typeof plasmoid === "undefined") return;
        root.allTasks = Storage.loadTasks(plasmoid);
        root.allGoals = Storage.loadGoals(plasmoid);
        root.dashboardMetrics = Calc.computeDashboardMetrics(root.allTasks, root.allGoals);

        if (root.parent && root.parent.pendingCount !== undefined) {
            root.parent.pendingCount = root.dashboardMetrics.pendingCount;
        }
    }

    function triggerAddTask() {
        root.activeTab = "tasks";
        tasksView.focusInput();
    }

    Component.onCompleted: {
        root.reloadData();
    }

    Connections {
        target: typeof plasmoid !== "undefined" ? plasmoid.configuration : null
        function onTasksDataChanged() {
            root.reloadData();
        }
        function onGoalsDataChanged() {
            root.reloadData();
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        // Header
        Shared.HeaderBar {
            title: i18n("Task & Goal Manager")
            subtitle: i18n("Daily focus & long-term targets")
            iconName: "view-calendar-tasks"
            Layout.fillWidth: true

            Shared.MetricBadge {
                text: i18n("%1 Active", root.dashboardMetrics ? root.dashboardMetrics.pendingCount : 0)
                badgeColor: Kirigami.Theme.highlightColor
                subtle: false
            }

            PlasmaComponents.Button {
                text: i18n("+ Task")
                icon.name: "list-add"
                highlighted: true
                Layout.preferredHeight: 28
                onClicked: root.triggerAddTask()
            }
        }

        // Top Navigation Bar
        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 4

            Repeater {
                model: [
                    { label: i18n("Dashboard"), id: "dashboard", icon: "dashboard-show" },
                    { label: i18n("Tasks"), id: "tasks", icon: "view-calendar-tasks" },
                    { label: i18n("Goals"), id: "goals", icon: "favorite" },
                    { label: i18n("Milestones"), id: "milestones", icon: "task-complete" }
                ]
                delegate: PlasmaComponents.Button {
                    Layout.fillWidth: true
                    text: modelData.label
                    flat: root.activeTab !== modelData.id
                    Layout.preferredHeight: 28
                    Layout.alignment: Qt.AlignVCenter
                    font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 2, 8)
                    onClicked: root.activeTab = modelData.id
                }
            }
        }

        // Content Views
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            // 1. Dashboard
            DashboardView {
                visible: root.activeTab === "dashboard"
                anchors.fill: parent
                metrics: root.dashboardMetrics
            }

            // 2. Tasks View
            TasksView {
                id: tasksView
                visible: root.activeTab === "tasks"
                anchors.fill: parent
                tasksList: root.allTasks
                goalsList: root.allGoals

                onTaskToggled: function(id) {
                    Storage.toggleTaskComplete(plasmoid, id);
                    root.reloadData();
                }

                onTaskDeleted: function(id) {
                    Storage.deleteTask(plasmoid, id);
                    root.reloadData();
                }

                onClearAllTasksClicked: {
                    Storage.clearAllTasks(plasmoid);
                    root.reloadData();
                }

                onTaskAdded: function(taskObj) {
                    Storage.addTask(plasmoid, taskObj);
                    root.reloadData();
                }
            }

            // 3. Goals View
            GoalsView {
                visible: root.activeTab === "goals"
                anchors.fill: parent
                goalsList: root.allGoals
                allTasks: root.allTasks

                onGoalAdded: function(g) {
                    Storage.addGoal(plasmoid, g);
                    root.reloadData();
                }

                onGoalDeleted: function(id) {
                    var filtered = (root.allGoals || []).filter(function(g) { return g.id !== id; });
                    Storage.saveGoals(plasmoid, filtered);
                    root.reloadData();
                }

                onMilestoneToggled: function(gid, mid) {
                    Storage.toggleMilestone(plasmoid, gid, mid);
                    root.reloadData();
                }

                onMilestoneAdded: function(gid, title, weight) {
                    Storage.addMilestone(plasmoid, gid, title, weight);
                    root.reloadData();
                }
            }

            // 4. Milestones View
            MilestonesView {
                visible: root.activeTab === "milestones"
                anchors.fill: parent
                goalsList: root.allGoals
                allTasks: root.allTasks

                onMilestoneToggled: function(gid, mid) {
                    Storage.toggleMilestone(plasmoid, gid, mid);
                    root.reloadData();
                }

                onMilestoneAdded: function(gid, title, weight) {
                    Storage.addMilestone(plasmoid, gid, title, weight);
                    root.reloadData();
                }
            }
        }
    }
}
