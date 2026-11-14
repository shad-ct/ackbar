import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    property alias cfg_quickSaveWithEnter: enterSavesCheck.checked
    property alias cfg_maxDisplayCount: countSpinBox.value
    property alias cfg_defaultCategory: defaultCatCombo.currentText

    Kirigami.FormLayout {
        QQC2.CheckBox {
            id: enterSavesCheck
            text: i18n("Press Enter to save (Shift+Enter for newline)")
        }

        QQC2.SpinBox {
            id: countSpinBox
            Kirigami.FormData.label: i18n("Recent entries limit:")
            from: 10
            to: 200
            stepSize: 10
        }

        QQC2.ComboBox {
            id: defaultCatCombo
            Kirigami.FormData.label: i18n("Default category:")
            model: ["Idea", "Task", "Reminder", "Learning", "Project", "Miscellaneous"]
        }
    }
}

