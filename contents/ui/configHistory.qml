import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

// configHistory.qml — AckBar+ History & Notifications settings page

KCM.SimpleKCM {

    // ── History feature settings ───────────────────────────────────────────
    property alias cfg_enableHistory:          enableHistoryCheck.checked
    property alias cfg_trackPomodoros:         trackPomodorosCheck.checked
    property alias cfg_trackTasks:             trackTasksCheck.checked
    property alias cfg_showDailyStats:         showDailyStatsCheck.checked

    // ── Notification sound settings ────────────────────────────────────────
    property alias cfg_enableNotificationSound:   enableSoundCheck.checked
    property alias cfg_soundOnPomodoroComplete:   soundPomodoroCheck.checked
    property alias cfg_soundOnBreakComplete:      soundBreakCheck.checked

    Kirigami.FormLayout {

        // ── History section ─────────────────────────────────────────────────
        Kirigami.Separator {
            Kirigami.FormData.label: i18n("Productivity History")
            Kirigami.FormData.isSection: true
        }

        QQC2.CheckBox {
            id: enableHistoryCheck
            text: i18n("Enable productivity history")
        }

        QQC2.Label {
            text: i18n("Records are stored locally. Disabling stops new recording but does not delete existing history.")
            font: Kirigami.Theme.smallFont
            opacity: 0.65
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        Item { Kirigami.FormData.isSection: true; implicitHeight: Kirigami.Units.largeSpacing }

        QQC2.CheckBox {
            id: trackPomodorosCheck
            text: i18n("Track completed Pomodoros")
            enabled: enableHistoryCheck.checked
        }

        QQC2.CheckBox {
            id: trackTasksCheck
            text: i18n("Include task name in history")
            enabled: enableHistoryCheck.checked && trackPomodorosCheck.checked
        }

        QQC2.CheckBox {
            id: showDailyStatsCheck
            text: i18n("Show daily statistics in history view")
            enabled: enableHistoryCheck.checked
        }

        Item { implicitHeight: Kirigami.Units.largeSpacing * 2 }

        // ── Notification sounds section ─────────────────────────────────────
        Kirigami.Separator {
            Kirigami.FormData.label: i18n("Notification Sounds")
            Kirigami.FormData.isSection: true
        }

        QQC2.CheckBox {
            id: enableSoundCheck
            text: i18n("Enable notification sounds")
        }

        QQC2.Label {
            text: i18n("Plays a system sound when a Pomodoro or break completes. Uses the freedesktop sound theme.")
            font: Kirigami.Theme.smallFont
            opacity: 0.65
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        Item { Kirigami.FormData.isSection: true; implicitHeight: Kirigami.Units.largeSpacing }

        QQC2.CheckBox {
            id: soundPomodoroCheck
            text: i18n("Play sound when Pomodoro finishes")
            enabled: enableSoundCheck.checked
        }

        QQC2.CheckBox {
            id: soundBreakCheck
            text: i18n("Play sound when break finishes")
            enabled: enableSoundCheck.checked
        }
    }
}
