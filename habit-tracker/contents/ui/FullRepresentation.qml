import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasmoid
import "shared" as Shared
import "../js/habit-storage.js" as Storage
import "../js/streak-calculator.js" as StreakCalc

Item {
    id: root

    Layout.minimumWidth: Math.max(340, Kirigami.Units.gridUnit * 20)
    Layout.preferredWidth: Math.max(360, Kirigami.Units.gridUnit * 22)
    Layout.minimumHeight: Math.max(460, Kirigami.Units.gridUnit * 26)
    Layout.preferredHeight: Math.max(500, Kirigami.Units.gridUnit * 29)

    implicitWidth: Layout.preferredWidth
    implicitHeight: Layout.preferredHeight
    property var globalStats: ({ todayDone: 0, todayTotal: 0, todayPercent: 0, weeklyRate: 0, monthlyRate: 0, totalCompletions: 0, longestStreak: 0 })
    property var activityGrid: []
    property var habitsList: []
    property string currentTab: "today" // today | activity | stats

    function reloadData() {
        if (typeof plasmoid === "undefined") return;
        var list = Storage.loadHabits(plasmoid);
        root.habitsList = list;
        root.globalStats = StreakCalc.calculateGlobalStats(list);
        root.activityGrid = StreakCalc.generateActivityGridData(list, plasmoid.configuration.historyDaysToShow || 70);

        if (root.parent && root.parent.doneCount !== undefined) {
            root.parent.doneCount = root.globalStats.todayDone;
            root.parent.totalCount = root.globalStats.todayTotal;
        }
    }

    Component.onCompleted: {
        root.reloadData();
    }

    Connections {
        target: typeof plasmoid !== "undefined" ? plasmoid.configuration : null
        function onHabitsDataChanged() {
            root.reloadData();
        }
        function onHistoryDaysToShowChanged() {
            root.reloadData();
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        // Header
        Shared.HeaderBar {
            title: i18n("Habit Tracker")
            subtitle: i18n("Consistency & Growth")
            iconName: "user-identity"
            Layout.fillWidth: true

            Shared.MetricBadge {
                text: root.globalStats.todayDone + "/" + root.globalStats.todayTotal + " " + i18n("Done")
                badgeColor: root.globalStats.todayDone >= root.globalStats.todayTotal && root.globalStats.todayTotal > 0 ? "#27ae60" : Kirigami.Theme.highlightColor
                subtle: false
            }

            PlasmaComponents.Button {
                text: i18n("Clear All")
                icon.name: "edit-clear-all"
                visible: root.habitsList.length > 0
                flat: true
                Layout.preferredHeight: 28
                onClicked: {
                    Storage.clearAllHabits(plasmoid);
                    root.reloadData();
                }
            }

            PlasmaComponents.Button {
                text: i18n("+ Add")
                icon.name: "list-add"
                Layout.preferredHeight: 28
                onClicked: habitDialog.openForNew()
            }
        }

        // Today's Progress Bar
        Rectangle {
            Layout.fillWidth: true
            height: 6
            radius: 3
            color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.08)

            Rectangle {
                height: parent.height
                radius: 3
                width: parent.width * (root.globalStats.todayTotal > 0 ? (root.globalStats.todayDone / root.globalStats.todayTotal) : 0)
                color: root.globalStats.todayDone >= root.globalStats.todayTotal && root.globalStats.todayTotal > 0 ? "#27ae60" : Kirigami.Theme.highlightColor

                Behavior on width {
                    NumberAnimation { duration: 250 }
                }
            }
        }

        // Navigation Tabs
        RowLayout {
            Layout.fillWidth: true
            spacing: 4

            Repeater {
                model: [
                    { label: i18n("Today's Habits"), id: "today" },
                    { label: i18n("Activity"), id: "activity" },
                    { label: i18n("Statistics"), id: "stats" }
                ]
                delegate: PlasmaComponents.Button {
                    Layout.fillWidth: true
                    text: modelData.label
                    flat: root.currentTab !== modelData.id
                    font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 2, 8)
                    onClicked: root.currentTab = modelData.id
                }
            }
        }

        // Tab 1: Today's Habits List
        Item {
            visible: root.currentTab === "today"
            Layout.fillWidth: true
            Layout.fillHeight: true

            Shared.EmptyState {
                visible: root.habitsList.length === 0
                anchors.centerIn: parent
                title: i18n("No habits created")
                description: i18n("Click '+ Add' above to begin building your habits.")
                iconName: "user-identity"
            }

            PlasmaComponents.ScrollView {
                anchors.fill: parent
                visible: root.habitsList.length > 0
                clip: true

                ListView {
                    id: habitsListView
                    width: parent.width
                    spacing: 6
                    model: root.habitsList

                    delegate: HabitRow {
                        width: habitsListView.width
                        height: implicitHeight
                        habitData: modelData
                        isCompletedToday: StreakCalc.isHabitCompletedOn(modelData, StreakCalc.toDateKey(new Date()))
                        streakInfo: StreakCalc.calculateHabitStreak(modelData)
                        showStreak: typeof plasmoid !== "undefined" && plasmoid.configuration ? plasmoid.configuration.showStreakBadges : true

                        onToggledToday: function(id) {
                            Storage.toggleCompletion(plasmoid, id, StreakCalc.toDateKey(new Date()));
                            root.reloadData();
                        }

                        onEditRequested: function(habit) {
                            habitDialog.openForEdit(habit);
                        }

                        onDeleteRequested: function(id) {
                            Storage.deleteHabit(plasmoid, id);
                            root.reloadData();
                        }
                    }
                }
            }
        }

        // Tab 2: Activity Graph
        Item {
            visible: root.currentTab === "activity"
            Layout.fillWidth: true
            Layout.fillHeight: true

            ContributionGrid {
                anchors.centerIn: parent
                gridData: root.activityGrid
            }
        }

        // Tab 3: Statistics Overview
        Item {
            visible: root.currentTab === "stats"
            Layout.fillWidth: true
            Layout.fillHeight: true

            GridLayout {
                anchors.fill: parent
                anchors.margins: 4
                columns: 2
                rowSpacing: 10
                columnSpacing: 10

                Shared.CardContainer {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    contentPadding: 12

                    Text {
                        text: i18n("Longest Streak")
                        font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 2, 8)
                        color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.6)
                    }
                    Text {
                        text: root.globalStats.longestStreak + " " + i18n("Days")
                        font.pointSize: Kirigami.Theme.defaultFont.pointSize + 4
                        font.weight: Font.Bold
                        color: "#e67e22"
                    }
                }

                Shared.CardContainer {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    contentPadding: 12

                    Text {
                        text: i18n("Total Completions")
                        font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 2, 8)
                        color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.6)
                    }
                    Text {
                        text: root.globalStats.totalCompletions.toString()
                        font.pointSize: Kirigami.Theme.defaultFont.pointSize + 4
                        font.weight: Font.Bold
                        color: "#27ae60"
                    }
                }

                Shared.CardContainer {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    contentPadding: 12

                    Text {
                        text: i18n("Weekly Consistency")
                        font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 2, 8)
                        color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.6)
                    }
                    Text {
                        text: root.globalStats.weeklyRate + "%"
                        font.pointSize: Kirigami.Theme.defaultFont.pointSize + 4
                        font.weight: Font.Bold
                        color: Kirigami.Theme.highlightColor
                    }
                }

                Shared.CardContainer {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    contentPadding: 12

                    Text {
                        text: i18n("Monthly Consistency")
                        font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 2, 8)
                        color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.6)
                    }
                    Text {
                        text: root.globalStats.monthlyRate + "%"
                        font.pointSize: Kirigami.Theme.defaultFont.pointSize + 4
                        font.weight: Font.Bold
                        color: Kirigami.Theme.highlightColor
                    }
                }
            }
        }
    }

    // Modal Add / Edit Habit overlay dialog
    AddHabitDialog {
        id: habitDialog
        anchors.fill: parent
        anchors.margins: 14
        visible: false

        onSaved: function(data) {
            if (habitDialog.isEditing) {
                Storage.updateHabit(plasmoid, data.id, data);
            } else {
                Storage.addHabit(plasmoid, data);
            }
            root.reloadData();
        }
    }
}
