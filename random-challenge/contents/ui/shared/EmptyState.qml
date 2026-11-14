import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Item {
    id: root

    property string title: "No items yet"
    property string description: ""
    property string iconName: "document-edit"

    implicitWidth: 200
    implicitHeight: layout.implicitHeight + 20

    ColumnLayout {
        id: layout
        anchors.centerIn: parent
        width: Math.min(parent.width - 24, 280)
        spacing: 8

        Kirigami.Icon {
            source: root.iconName
            Layout.preferredWidth: 32
            Layout.preferredHeight: 32
            Layout.alignment: Qt.AlignHCenter
            opacity: 0.4
        }

        Text {
            text: root.title
            color: Kirigami.Theme.textColor
            font.pointSize: Kirigami.Theme.defaultFont.pointSize
            font.weight: Font.Medium
            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
            opacity: 0.8
        }

        Text {
            visible: root.description !== ""
            text: root.description
            color: Kirigami.Theme.textColor
            font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 2, 8)
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            opacity: 0.55
        }
    }
}

