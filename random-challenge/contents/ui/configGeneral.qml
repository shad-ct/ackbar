import QtQuick
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    property alias cfg_preferredDifficulty: difficultyCombo.currentText
    property alias cfg_preferredCategory: categoryCombo.currentText

    Kirigami.FormLayout {
        QQC2.ComboBox {
            id: difficultyCombo
            Kirigami.FormData.label: i18n("Preferred difficulty:")
            model: ["All", "Beginner", "Intermediate", "Advanced"]
        }

        QQC2.ComboBox {
            id: categoryCombo
            Kirigami.FormData.label: i18n("Preferred category:")
            model: [
                "All", "Programming", "Mathematics", "Physics", "Chemistry",
                "Astronomy", "Logic and puzzles", "Cryptography", "Chess",
                "Memory", "Dexterity", "Origami", "Language learning",
                "Creative writing", "General knowledge"
            ]
        }
    }
}

