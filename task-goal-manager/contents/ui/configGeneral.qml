import QtQuick
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    property alias cfg_defaultPriority: priorityCombo.currentText
    property alias cfg_sortBy: sortCombo.currentText

    Kirigami.FormLayout {
        QQC2.ComboBox {
            id: priorityCombo
            Kirigami.FormData.label: i18n("Default task priority:")
            model: ["Low", "Medium", "High", "Urgent"]
        }

        QQC2.ComboBox {
            id: sortCombo
            Kirigami.FormData.label: i18n("Default task sort order:")
            model: ["priority", "deadline"]
        }
    }
}

