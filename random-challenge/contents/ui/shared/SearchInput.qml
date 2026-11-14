import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents

Rectangle {
    id: root

    property alias text: textField.text
    property alias placeholderText: textField.placeholderText
    signal cleared()

    implicitWidth: 200
    implicitHeight: 32
    radius: 6

    color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.05)
    border.color: textField.activeFocus
                  ? Kirigami.Theme.highlightColor
                  : Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.15)
    border.width: 1

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 6
        spacing: 6

        Kirigami.Icon {
            source: "search"
            Layout.preferredWidth: 14
            Layout.preferredHeight: 14
            opacity: 0.5
        }

        PlasmaComponents.TextField {
            id: textField
            Layout.fillWidth: true
            placeholderText: "Search..."
            background: Item {} // Use our custom border & background
            selectByMouse: true
            font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 1, 9)
        }

        PlasmaComponents.Button {
            visible: textField.text.length > 0
            icon.name: "edit-clear"
            Layout.preferredWidth: 20
            Layout.preferredHeight: 20
            flat: true
            onClicked: {
                textField.text = "";
                root.cleared();
            }
        }
    }
}

