import QtQuick
import org.kde.plasma.configuration 2.0
import org.kde.kirigami as Kirigami

Item {
    Layout.fillWidth: true

    Kirigami.Heading {
        text: i18n("Journal Prompts")
        font.pointSize: Kirigami.Theme.defaultFont.pointSize + 2
        Layout.topMargin: Kirigami.Units.largeSpacing
        Layout.leftMargin: Kirigami.Units.largeSpacing
        Layout.rightMargin: Kirigami.Units.largeSpacing
    }

    Kirigami.Paragraph {
        text: i18n("A minimal daily widget that serves a random journaling prompt. Rotates once per day. Mark prompts as done or favourite them for later.")
        textFormat: Qt.AutoText
        wrapMode: Text.WordWrap
        Layout.fillWidth: true
        Layout.leftMargin: Kirigami.Units.largeSpacing
        Layout.rightMargin: Kirigami.Units.largeSpacing
    }
}
