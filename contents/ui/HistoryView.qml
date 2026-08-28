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
    width:  Math.min(480, Screen.desktopAvailableWidth  * 0.85)
    height: Math.min(600, Screen.desktopAvailableHeight * 0.80)
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

    // ── Internal computed model ────────────────────────────────────────────

    property var days:          []
    property var dayRecordsMap: ({})   // dateKey → records[]
    property var dayTaskMap:    ({})   // dateKey → [{task,totalSeconds,pomodoroCount}]

    onHistoryRecordsChanged: rebuildModel()
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
    }

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

        // ── Empty state ────────────────────────────────────────────────────
        PlasmaExtras.PlaceholderMessage {
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: historyWindow.days.length === 0
            iconName: "chronometer"
            text: i18n("No completed sessions yet")
            explanation: i18n("Complete a Pomodoro to start recording your focus history.")
        }

        // ── History scroll list ────────────────────────────────────────────
        QQC2.ScrollView {
            visible: historyWindow.days.length > 0
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ListView {
                id: dayListView
                model: historyWindow.days
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

                        // Daily stats on the right
                        QQC2.Label {
                            visible: historyWindow.showDailyStats
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: Kirigami.Units.largeSpacing
                            font: Kirigami.Theme.smallFont
                            opacity: 0.8
                            text: {
                                var rec = historyWindow.dayRecordsMap[dayDelegate.modelData] || [];
                                return "🎯 " + Stats.formatDuration(Stats.getTotalFocusedSeconds(rec))
                                     + "  🍅 " + Stats.getTotalPomodoroCount(rec);
                            }
                        }
                    }

                    // ── Task groups for this day ───────────────────────────

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
                                    var dayRec = historyWindow.dayRecordsMap[taskDelegate.capturedDateKey] || [];
                                    var taskName = taskDelegate.modelData.task;
                                    var out = [];
                                    for (var i = 0; i < dayRec.length; i++) {
                                        var r = dayRec[i];
                                        if ((r.task || "") === taskName || (!r.task && !taskName)) {
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
