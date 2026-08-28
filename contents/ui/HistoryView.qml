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
    flags: Qt.Dialog | Qt.WindowCloseButtonHint | Qt.WindowMinimizeButtonHint

    // Center on screen
    width:  Math.min(520, Screen.desktopAvailableWidth  * 0.85)
    height: Math.min(640, Screen.desktopAvailableHeight * 0.85)
    x: (Screen.desktopAvailableWidth  - width)  / 2 + Screen.virtualX
    y: (Screen.desktopAvailableHeight - height) / 2 + Screen.virtualY

    minimumWidth:  380
    minimumHeight: 320

    color: Kirigami.Theme.backgroundColor

    // Provided by main.qml binding through the Loader
    property var  historyRecords: []
    property bool showDailyStats: true

    signal deleteRecord(string id)
    signal deleteRecordsByDay(string dateKey)
    signal deleteRecordsByTask(string dateKey, string taskName)
    signal clearHistory()
    signal closed()

    onClosing: historyWindow.closed()

    // ── Search / filter state ──────────────────────────────────────────────────
    property string searchQuery: ""

    // ── Internal computed model ────────────────────────────────────────────────
    //   Filtered by searchQuery; rebuilt whenever records or query change.

    property var days:          []
    property var dayRecordsMap: ({})   // dateKey → filtered records[]
    property var dayTaskMap:    ({})   // dateKey → [{task,totalSeconds,pomodoroCount}]

    // Grand total stats across filtered records
    property int totalSeconds:   0
    property int totalPomodoros: 0

    onHistoryRecordsChanged: rebuildModel()
    onSearchQueryChanged:    rebuildModel()

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

        // Apply search filter
        var q = searchQuery.trim().toLowerCase();
        var filtered = q === "" ? records : records.filter(function(r) {
            return (r.task || "").toLowerCase().indexOf(q) !== -1;
        });

        var d   = Stats.getUniqueDays(filtered);
        var dr  = {}, dt = {};
        var sec = 0, pom = 0;

        for (var i = 0; i < d.length; i++) {
            var key    = d[i];
            var dayRec = Stats.getRecordsForDay(filtered, key);
            dr[key] = dayRec;
            dt[key] = Stats.getTaskTotals(dayRec);
            sec += Stats.getTotalFocusedSeconds(dayRec);
            pom += Stats.getTotalPomodoroCount(dayRec);
        }

        days          = d;
        dayRecordsMap = dr;
        dayTaskMap    = dt;
        totalSeconds  = sec;
        totalPomodoros = pom;
    }

    // ── Confirmation state ─────────────────────────────────────────────────────
    property bool confirmingClear: false

    // ── Root layout ───────────────────────────────────────────────────────────
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Kirigami.Units.largeSpacing
        spacing: Kirigami.Units.smallSpacing

        // ── Title bar ─────────────────────────────────────────────────────────
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
                text: historyWindow.confirmingClear ? i18n("Cancel") : i18n("Clear All")
                icon.name: historyWindow.confirmingClear ? "dialog-cancel" : "edit-delete"
                enabled: historyWindow.days.length > 0 || historyWindow.confirmingClear
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

        // ── Search bar ────────────────────────────────────────────────────────
        RowLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing
            visible: historyRecords.length > 0

            Kirigami.Icon {
                source: "search"
                implicitWidth:  Kirigami.Units.iconSizes.small
                implicitHeight: Kirigami.Units.iconSizes.small
                opacity: 0.6
            }

            QQC2.TextField {
                id: searchField
                Layout.fillWidth: true
                placeholderText: i18n("Search by task name…")
                text: historyWindow.searchQuery
                onTextChanged: historyWindow.searchQuery = text
                Keys.onEscapePressed: {
                    text = "";
                    historyWindow.searchQuery = "";
                }

                // Clear button inside field
                rightPadding: clearSearchBtn.visible ? clearSearchBtn.width + 4 : 4

                PlasmaComponents3.ToolButton {
                    id: clearSearchBtn
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    visible: searchField.text.length > 0
                    icon.name: "edit-clear-locationbar-rtl"
                    implicitWidth:  Kirigami.Units.iconSizes.small + Kirigami.Units.smallSpacing * 2
                    implicitHeight: implicitWidth
                    onClicked: {
                        searchField.text = "";
                        historyWindow.searchQuery = "";
                        searchField.forceActiveFocus();
                    }
                }
            }
        }

        // ── Grand-total stats pill ────────────────────────────────────────────
        Rectangle {
            Layout.fillWidth: true
            visible: historyWindow.totalPomodoros > 0
            implicitHeight: statsRow.implicitHeight + Kirigami.Units.smallSpacing * 2
            radius: Kirigami.Units.cornerRadius
            color: Qt.rgba(Kirigami.Theme.highlightColor.r,
                           Kirigami.Theme.highlightColor.g,
                           Kirigami.Theme.highlightColor.b, 0.10)

            RowLayout {
                id: statsRow
                anchors.centerIn: parent
                spacing: Kirigami.Units.largeSpacing * 2

                QQC2.Label {
                    font: Kirigami.Theme.smallFont
                    opacity: 0.85
                    text: "🎯 " + i18n("Total focus: %1",
                              Stats.formatDuration(historyWindow.totalSeconds))
                }
                QQC2.Label {
                    font: Kirigami.Theme.smallFont
                    opacity: 0.85
                    text: "🍅 " + i18np("%1 pomodoro", "%1 pomodoros",
                              historyWindow.totalPomodoros)
                }
                QQC2.Label {
                    visible: historyWindow.days.length > 0
                    font: Kirigami.Theme.smallFont
                    opacity: 0.85
                    text: "📅 " + i18np("%1 day", "%1 days",
                              historyWindow.days.length)
                }
            }
        }

        // ── Confirmation banner ───────────────────────────────────────────────
        Kirigami.InlineMessage {
            Layout.fillWidth: true
            visible: historyWindow.confirmingClear
            type: Kirigami.MessageType.Warning
            text: i18n("This permanently deletes ALL recorded sessions.")
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

        // ── Empty / no-results state ──────────────────────────────────────────
        PlasmaExtras.PlaceholderMessage {
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: historyWindow.days.length === 0
            iconName: historyWindow.searchQuery !== "" ? "search" : "chronometer"
            text: historyWindow.searchQuery !== ""
                ? i18n("No sessions match \"%1\"", historyWindow.searchQuery)
                : i18n("No completed sessions yet")
            explanation: historyWindow.searchQuery !== ""
                ? i18n("Try a different search term.")
                : i18n("Complete a Pomodoro to start recording your focus history.")
        }

        // ── History scroll list ───────────────────────────────────────────────
        QQC2.ScrollView {
            visible: historyWindow.days.length > 0
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            // Keyboard shortcut: Ctrl+F focuses search
            Keys.onPressed: event => {
                if ((event.modifiers & Qt.ControlModifier) && event.key === Qt.Key_F) {
                    searchField.forceActiveFocus();
                    event.accepted = true;
                }
            }

            ListView {
                id: dayListView
                model: historyWindow.days
                spacing: 0
                // Smooth scroll
                boundsMovement: Flickable.StopAtBounds

                delegate: ColumnLayout {
                    id: dayDelegate
                    width: dayListView.width
                    spacing: 0

                    required property string modelData  // dateKey
                    required property int index

                    // ── Day header ────────────────────────────────────────────

                    PlasmaExtras.ListSectionHeader {
                        id: dayHeader
                        Layout.fillWidth: true
                        label: Stats.formatDayLabel(dayDelegate.modelData)

                        // Hover tracking on the header bar
                        HoverHandler { id: dayHeaderHover }

                        // Daily stats on the right
                        QQC2.Label {
                            id: dayStatsLabel
                            visible: historyWindow.showDailyStats && !dayDeleteConfirm.visible
                            anchors.right: dayDeleteBtn.left
                            anchors.rightMargin: Kirigami.Units.smallSpacing
                            anchors.verticalCenter: parent.verticalCenter
                            font: Kirigami.Theme.smallFont
                            opacity: 0.8
                            text: {
                                var rec = historyWindow.dayRecordsMap[dayDelegate.modelData] || [];
                                return "🎯 " + Stats.formatDuration(Stats.getTotalFocusedSeconds(rec))
                                     + "  🍅 " + Stats.getTotalPomodoroCount(rec);
                            }
                        }

                        // Inline confirm label for day deletion
                        QQC2.Label {
                            id: dayDeleteConfirm
                            visible: false
                            anchors.right: dayDeleteBtn.left
                            anchors.rightMargin: Kirigami.Units.smallSpacing
                            anchors.verticalCenter: parent.verticalCenter
                            font: Kirigami.Theme.smallFont
                            color: Kirigami.Theme.negativeTextColor
                            text: i18n("Delete entire day? Click again to confirm")
                        }

                        // Delete-day button (hover-revealed)
                        PlasmaComponents3.ToolButton {
                            id: dayDeleteBtn
                            anchors.right: parent.right
                            anchors.rightMargin: Kirigami.Units.largeSpacing
                            anchors.verticalCenter: parent.verticalCenter
                            icon.name: dayDeleteConfirm.visible ? "edit-delete" : "edit-delete-remove"
                            display: PlasmaComponents3.AbstractButton.IconOnly
                            text: i18n("Delete this day")
                            opacity: (dayHeaderHover.containsMouse || dayDeleteConfirm.visible) ? 0.9 : 0.0
                            Behavior on opacity { NumberAnimation { duration: 120 } }
                            implicitWidth:  Kirigami.Units.iconSizes.small + Kirigami.Units.smallSpacing * 2
                            implicitHeight: implicitWidth

                            // Two-click confirm pattern
                            property bool confirming: false
                            Timer {
                                id: dayConfirmReset
                                interval: 3000
                                repeat: false
                                onTriggered: {
                                    dayDeleteBtn.confirming = false;
                                    dayDeleteConfirm.visible = false;
                                }
                            }
                            onClicked: {
                                if (!confirming) {
                                    confirming = true;
                                    dayDeleteConfirm.visible = true;
                                    dayConfirmReset.restart();
                                } else {
                                    confirming = false;
                                    dayDeleteConfirm.visible = false;
                                    historyWindow.deleteRecordsByDay(dayDelegate.modelData);
                                }
                            }

                            QQC2.ToolTip.text: i18n("Delete all sessions on this day")
                            QQC2.ToolTip.visible: hovered
                            QQC2.ToolTip.delay: 500
                        }
                    }

                    // ── Task groups for this day ──────────────────────────────

                    Repeater {
                        model: historyWindow.dayTaskMap[dayDelegate.modelData] || []

                        delegate: ColumnLayout {
                            id: taskDelegate
                            width: dayListView.width
                            spacing: 0

                            required property var modelData   // {task, totalSeconds, pomodoroCount}
                            property string capturedDateKey: dayDelegate.modelData

                            // Task summary row
                            Rectangle {
                                id: taskSummaryRect
                                Layout.fillWidth: true
                                implicitHeight: taskRow.implicitHeight + Kirigami.Units.smallSpacing * 2
                                color: taskHover.containsMouse
                                    ? Qt.rgba(Kirigami.Theme.highlightColor.r,
                                              Kirigami.Theme.highlightColor.g,
                                              Kirigami.Theme.highlightColor.b, 0.07)
                                    : "transparent"

                                Behavior on color { ColorAnimation { duration: 80 } }

                                HoverHandler { id: taskHover }

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

                                    // Highlight matched text when searching
                                    QQC2.Label {
                                        text: taskDelegate.modelData.task || i18n("(no task)")
                                        font.bold: true
                                        Layout.fillWidth: true
                                        elide: Text.ElideRight
                                        color: historyWindow.searchQuery !== ""
                                            && (taskDelegate.modelData.task || "").toLowerCase()
                                                .indexOf(historyWindow.searchQuery.toLowerCase()) !== -1
                                            ? Kirigami.Theme.highlightColor
                                            : Kirigami.Theme.textColor
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

                                    // Inline confirm label for task deletion
                                    QQC2.Label {
                                        id: taskDeleteConfirm
                                        visible: false
                                        font: Kirigami.Theme.smallFont
                                        color: Kirigami.Theme.negativeTextColor
                                        text: i18n("Click again to confirm")
                                    }

                                    // Delete-task button (hover-revealed)
                                    PlasmaComponents3.ToolButton {
                                        id: taskDeleteBtn
                                        icon.name: "edit-delete"
                                        display: PlasmaComponents3.AbstractButton.IconOnly
                                        text: i18n("Delete this task's sessions")
                                        opacity: (taskHover.containsMouse || taskDeleteConfirm.visible) ? 0.9 : 0.0
                                        Behavior on opacity { NumberAnimation { duration: 120 } }
                                        implicitWidth:  Kirigami.Units.iconSizes.small + Kirigami.Units.smallSpacing * 2
                                        implicitHeight: implicitWidth

                                        property bool confirming: false
                                        Timer {
                                            id: taskConfirmReset
                                            interval: 3000
                                            repeat: false
                                            onTriggered: {
                                                taskDeleteBtn.confirming = false;
                                                taskDeleteConfirm.visible = false;
                                            }
                                        }
                                        onClicked: {
                                            if (!confirming) {
                                                confirming = true;
                                                taskDeleteConfirm.visible = true;
                                                taskConfirmReset.restart();
                                            } else {
                                                confirming = false;
                                                taskDeleteConfirm.visible = false;
                                                // raw task name (empty string for "(no task)")
                                                var rawName = taskDelegate.modelData.task === i18n("(no task)")
                                                    ? "" : taskDelegate.modelData.task;
                                                historyWindow.deleteRecordsByTask(
                                                    taskDelegate.capturedDateKey, rawName);
                                            }
                                        }

                                        QQC2.ToolTip.text: i18n("Delete all sessions for this task today")
                                        QQC2.ToolTip.visible: hovered
                                        QQC2.ToolTip.delay: 500
                                    }
                                }
                            }

                            // Individual sessions for this task on this day
                            Repeater {
                                id: sessionRepeater
                                model: {
                                    var dayRec   = historyWindow.dayRecordsMap[taskDelegate.capturedDateKey] || [];
                                    var taskName = taskDelegate.modelData.task;
                                    // getTaskTotals normalises "(no task)" — match on raw field
                                    var rawName  = taskName === i18n("(no task)") ? "" : taskName;
                                    var out = [];
                                    for (var i = 0; i < dayRec.length; i++) {
                                        var r = dayRec[i];
                                        if ((r.task || "") === rawName) out.push(r);
                                    }
                                    return out;
                                }

                                delegate: Rectangle {
                                    id: sessionDelegate
                                    required property var modelData  // individual record
                                    width: dayListView.width
                                    implicitHeight: sessionRow.implicitHeight + Kirigami.Units.smallSpacing
                                    color: sessionHover.containsMouse
                                        ? Qt.rgba(Kirigami.Theme.highlightColor.r,
                                                  Kirigami.Theme.highlightColor.g,
                                                  Kirigami.Theme.highlightColor.b, 0.05)
                                        : "transparent"

                                    Behavior on color { ColorAnimation { duration: 80 } }
                                    HoverHandler { id: sessionHover }

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
                                            opacity: sessionHover.containsMouse ? 0.9 : 0.0
                                            Behavior on opacity { NumberAnimation { duration: 120 } }
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
