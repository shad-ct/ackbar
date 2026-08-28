import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import QtQuick.Window
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents3
import org.kde.plasma.extras as PlasmaExtras
import "../js/statistics.js" as Stats

// HistoryView.qml — AckBar+ history & statistics window
// Instantiated lazily via a Loader in main.qml.
// Signals: deleteRecord(id), clearHistory()

Window {
    id: historyWindow

    title: i18n("Session History — AckBar+")
    flags: Qt.Dialog | Qt.WindowCloseButtonHint

    // Center on screen
    width:  Math.min(500, Screen.desktopAvailableWidth  * 0.85)
    height: Math.min(620, Screen.desktopAvailableHeight * 0.80)
    x: (Screen.desktopAvailableWidth  - width)  / 2 + Screen.virtualX
    y: (Screen.desktopAvailableHeight - height) / 2 + Screen.virtualY

    color: Kirigami.Theme.backgroundColor

    // Provided by main.qml binding through the Loader
    property var historyRecords: []
    property bool showDailyStats: true

    signal deleteRecord(string id)
    signal clearHistory()
    signal closed()

    onClosing: historyWindow.closed()

    // ── Search state ───────────────────────────────────────────────────────
    property string searchQuery: ""

    // ── Internal computed model ────────────────────────────────────────────

    // All days (unfiltered)
    property var days:          []
    property var dayRecordsMap: ({})   // dateKey → records[]
    property var dayTaskMap:    ({})   // dateKey → [{task,totalSeconds,pomodoroCount}]

    // Filtered view — recalculated whenever searchQuery or the raw model changes
    property var filteredDays:        []
    property var filteredDayTaskMap:  ({})   // dateKey → filtered task array
    property var filteredDayRecordsMap: ({}) // dateKey → filtered records[]

    onHistoryRecordsChanged: rebuildModel()
    onSearchQueryChanged:    applyFilter()

    Component.onCompleted: {
        rebuildModel();
        show();
        raise();
        requestActivate();
    }

    function open() {
        show();
        raise();
        requestActivate();
    }

    function rebuildModel() {
        var records = historyRecords || [];
        var d = Stats.getUniqueDays(records);
        var dr = {}, dt = {};
        for (var i = 0; i < d.length; i++) {
            var key = d[i];
            var dayRec = Stats.getRecordsForDay(records, key);
            dr[key] = dayRec;
            dt[key] = Stats.getTaskTotals(dayRec);
        }
        days = d;
        dayRecordsMap = dr;
        dayTaskMap    = dt;
        applyFilter();
    }

    // Filter task groups and record lists by searchQuery (case-insensitive substring)
    function applyFilter() {
        var q = searchQuery.trim().toLowerCase();

        if (q === "") {
            // No filter — show everything
            filteredDays        = days;
            filteredDayTaskMap  = dayTaskMap;
            filteredDayRecordsMap = dayRecordsMap;
            return;
        }

        var fd = [], fdt = {}, fdr = {};
        for (var i = 0; i < days.length; i++) {
            var key = days[i];
            var tasks = dayTaskMap[key] || [];
            var recs  = dayRecordsMap[key] || [];

            // Keep tasks whose name contains the query
            var matchedTasks = tasks.filter(function(t) {
                return (t.task || "").toLowerCase().indexOf(q) !== -1
                    || (q === "(no task)" && !t.task);
            });

            if (matchedTasks.length === 0) continue;

            // Keep only the records belonging to matched tasks
            var matchedTaskNames = matchedTasks.map(function(t) { return t.task || ""; });
            var matchedRecs = recs.filter(function(r) {
                return matchedTaskNames.indexOf(r.task || "") !== -1;
            });

            fd.push(key);
            fdt[key] = matchedTasks;
            fdr[key] = matchedRecs;
        }

        filteredDays        = fd;
        filteredDayTaskMap  = fdt;
        filteredDayRecordsMap = fdr;
    }

    // Convenience: are there any results right now?
    readonly property bool hasAnyHistory: days.length > 0
    readonly property bool hasFilteredResults: filteredDays.length > 0

    // ── Confirmation state ─────────────────────────────────────────────────
    property bool confirmingClear: false

    // ── Root layout ────────────────────────────────────────────────────────
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Kirigami.Units.largeSpacing
        spacing: Kirigami.Units.smallSpacing

        // ── Title bar ──────────────────────────────────────────────────────
        RowLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing

            Kirigami.Icon {
                source: "view-history"
                implicitWidth:  Kirigami.Units.iconSizes.small
                implicitHeight: Kirigami.Units.iconSizes.small
            }

            QQC2.Label {
                text: i18n("Session History")
                font.bold: true
                font.pointSize: Kirigami.Theme.defaultFont.pointSize * 1.1
                Layout.fillWidth: true
            }

            // Clear button
            PlasmaComponents3.ToolButton {
                id: clearBtn
                text: historyWindow.confirmingClear
                    ? i18n("Cancel")
                    : i18n("Clear History")
                icon.name: historyWindow.confirmingClear ? "dialog-cancel" : "edit-delete"
                enabled: historyWindow.hasAnyHistory || historyWindow.confirmingClear
                onClicked: historyWindow.confirmingClear = !historyWindow.confirmingClear

                QQC2.ToolTip.text: historyWindow.confirmingClear
                    ? i18n("Cancel clear")
                    : i18n("Clear all history")
                QQC2.ToolTip.visible: hovered
                QQC2.ToolTip.delay: 500
            }

            PlasmaComponents3.ToolButton {
                icon.name: "window-close"
                display: PlasmaComponents3.AbstractButton.IconOnly
                text: i18n("Close")
                onClicked: historyWindow.close()

                QQC2.ToolTip.text: i18n("Close")
                QQC2.ToolTip.visible: hovered
                QQC2.ToolTip.delay: 500
            }
        }

        Kirigami.Separator { Layout.fillWidth: true }

        // ── Search bar ─────────────────────────────────────────────────────
        RowLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing
            visible: historyWindow.hasAnyHistory

            Kirigami.Icon {
                source: "system-search"
                implicitWidth:  Kirigami.Units.iconSizes.small
                implicitHeight: Kirigami.Units.iconSizes.small
                opacity: searchField.activeFocus ? 1.0 : 0.5
            }

            QQC2.TextField {
                id: searchField
                Layout.fillWidth: true
                placeholderText: i18n("Search tasks…")
                text: historyWindow.searchQuery

                onTextChanged: historyWindow.searchQuery = text

                // Esc clears the search
                Keys.onEscapePressed: {
                    historyWindow.searchQuery = "";
                    text = "";
                }

                background: Rectangle {
                    radius: 4
                    color: searchField.activeFocus
                        ? Qt.rgba(Kirigami.Theme.highlightColor.r,
                                  Kirigami.Theme.highlightColor.g,
                                  Kirigami.Theme.highlightColor.b, 0.12)
                        : Qt.rgba(Kirigami.Theme.textColor.r,
                                  Kirigami.Theme.textColor.g,
                                  Kirigami.Theme.textColor.b, 0.06)
                    border.color: searchField.activeFocus
                        ? Kirigami.Theme.highlightColor
                        : "transparent"
                    border.width: 1
                }
            }

            // Clear search ×
            PlasmaComponents3.ToolButton {
                icon.name: "edit-clear"
                display: PlasmaComponents3.AbstractButton.IconOnly
                text: i18n("Clear search")
                visible: historyWindow.searchQuery !== ""
                onClicked: {
                    historyWindow.searchQuery = "";
                    searchField.text = "";
                    searchField.forceActiveFocus();
                }

                QQC2.ToolTip.text: i18n("Clear search")
                QQC2.ToolTip.visible: hovered
                QQC2.ToolTip.delay: 300
            }
        }

        // ── Confirmation banner ────────────────────────────────────────────
        Kirigami.InlineMessage {
            Layout.fillWidth: true
            visible: historyWindow.confirmingClear
            type: Kirigami.MessageType.Warning
            text: i18n("This permanently deletes all recorded sessions.")
            actions: [
                Kirigami.Action {
                    text: i18n("Confirm: Clear All")
                    icon.name: "edit-delete"
                    onTriggered: {
                        historyWindow.confirmingClear = false;
                        historyWindow.clearHistory();
                    }
                }
            ]
        }

        // ── Empty state: no history at all ─────────────────────────────────
        PlasmaExtras.PlaceholderMessage {
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: !historyWindow.hasAnyHistory
            iconName: "chronometer"
            text: i18n("No completed sessions yet")
            explanation: i18n("Complete a Pomodoro to start recording your focus history.")
        }

        // ── Empty state: search returned nothing ───────────────────────────
        PlasmaExtras.PlaceholderMessage {
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: historyWindow.hasAnyHistory && !historyWindow.hasFilteredResults
            iconName: "system-search"
            text: i18n("No results for "%1"", historyWindow.searchQuery)
            explanation: i18n("Try a different search term or clear the search.")
        }

        // ── History scroll list ────────────────────────────────────────────
        QQC2.ScrollView {
            visible: historyWindow.hasFilteredResults
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ListView {
                id: dayListView
                model: historyWindow.filteredDays
                spacing: 0

                delegate: ColumnLayout {
                    id: dayDelegate
                    width: dayListView.width
                    spacing: 0

                    required property string modelData  // dateKey
                    required property int index

                    // ── Day header ─────────────────────────────────────────

                    PlasmaExtras.ListSectionHeader {
                        Layout.fillWidth: true
                        label: Stats.formatDayLabel(dayDelegate.modelData)

                        // Daily stats on the right (from unfiltered records so totals are accurate)
                        QQC2.Label {
                            visible: historyWindow.showDailyStats
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: Kirigami.Units.largeSpacing
                            font: Kirigami.Theme.smallFont
                            opacity: 0.8
                            text: {
                                // Use filtered records when a search is active so stats match visible items
                                var rec = historyWindow.filteredDayRecordsMap[dayDelegate.modelData] || [];
                                return "🎯 " + Stats.formatDuration(Stats.getTotalFocusedSeconds(rec))
                                     + "  🍅 " + Stats.getTotalPomodoroCount(rec);
                            }
                        }
                    }

                    // ── Task groups for this day ───────────────────────────

                    Repeater {
                        model: historyWindow.filteredDayTaskMap[dayDelegate.modelData] || []

                        delegate: ColumnLayout {
                            id: taskDelegate
                            width: dayListView.width
                            spacing: 0

                            required property var modelData   // {task, totalSeconds, pomodoroCount}
                            property string capturedDateKey: dayDelegate.modelData

                            // Task summary row
                            Rectangle {
                                Layout.fillWidth: true
                                implicitHeight: taskRow.implicitHeight + Kirigami.Units.smallSpacing * 2
                                color: "transparent"

                                RowLayout {
                                    id: taskRow
                                    anchors {
                                        left: parent.left
                                        right: parent.right
                                        verticalCenter: parent.verticalCenter
                                        leftMargin: Kirigami.Units.largeSpacing * 2
                                        rightMargin: Kirigami.Units.largeSpacing
                                    }
                                    spacing: Kirigami.Units.smallSpacing

                                    // Highlight matching part of task name
                                    QQC2.Label {
                                        text: taskDelegate.modelData.task || i18n("(no task)")
                                        font.bold: true
                                        Layout.fillWidth: true
                                        elide: Text.ElideRight
                                    }
                                    QQC2.Label {
                                        text: Stats.formatDuration(taskDelegate.modelData.totalSeconds)
                                        opacity: 0.8
                                        font: Kirigami.Theme.smallFont
                                    }
                                    QQC2.Label {
                                        visible: taskDelegate.modelData.pomodoroCount > 0
                                        text: "🍅×" + taskDelegate.modelData.pomodoroCount
                                        opacity: 0.7
                                        font: Kirigami.Theme.smallFont
                                    }
                                }
                            }

                            // Individual sessions for this task on this day
                            Repeater {
                                id: sessionRepeater
                                model: {
                                    // Use filtered record map so deleted/searched records stay consistent
                                    var dayRec = historyWindow.filteredDayRecordsMap[taskDelegate.capturedDateKey] || [];
                                    var taskName = taskDelegate.modelData.task;
                                    var out = [];
                                    for (var i = 0; i < dayRec.length; i++) {
                                        var r = dayRec[i];
                                        if ((r.task || "") === (taskName || "")) {
                                            out.push(r);
                                        }
                                    }
                                    return out;
                                }

                                delegate: Rectangle {
                                    id: sessionDelegate
                                    required property var modelData  // individual record
                                    width: dayListView.width
                                    implicitHeight: sessionRow.implicitHeight + Kirigami.Units.smallSpacing
                                    color: "transparent"

                                    RowLayout {
                                        id: sessionRow
                                        anchors {
                                            left: parent.left
                                            right: parent.right
                                            verticalCenter: parent.verticalCenter
                                            leftMargin: Kirigami.Units.largeSpacing * 3
                                            rightMargin: Kirigami.Units.smallSpacing
                                        }
                                        spacing: Kirigami.Units.smallSpacing

                                        QQC2.Label {
                                            font: Kirigami.Theme.smallFont
                                            opacity: 0.55
                                            text: {
                                                var d = new Date(sessionDelegate.modelData.startedAt);
                                                return Qt.formatTime(d, "HH:mm")
                                                     + "  ·  "
                                                     + Stats.formatDuration(sessionDelegate.modelData.durationSeconds);
                                            }
                                            Layout.fillWidth: true
                                        }

                                        PlasmaComponents3.ToolButton {
                                            icon.name: "edit-delete"
                                            display: PlasmaComponents3.AbstractButton.IconOnly
                                            text: i18n("Delete this session")
                                            opacity: 0.65
                                            implicitWidth:  Kirigami.Units.iconSizes.small + Kirigami.Units.smallSpacing * 2
                                            implicitHeight: implicitWidth
                                            onClicked: historyWindow.deleteRecord(sessionDelegate.modelData.id)

                                            QQC2.ToolTip.text: i18n("Delete this session")
                                            QQC2.ToolTip.visible: hovered
                                            QQC2.ToolTip.delay: 500
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
}
