import QtQuick
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    property alias cfg_showStreakBadges: streakBadgeCheck.checked
    property alias cfg_historyDaysToShow: daysSpinBox.value

    Kirigami.FormLayout {
        QQC2.CheckBox {
            id: streakBadgeCheck
            text: i18n("Show streak badges on habit items")
        }

        QQC2.SpinBox {
            id: daysSpinBox
            Kirigami.FormData.label: i18n("Activity grid range (days):")
            from: 28
            to: 140
            stepSize: 7
        }
    }
}

