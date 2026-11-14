import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Rectangle {
    id: root

    property string text: ""
    property string iconName: ""
    property color badgeColor: Kirigami.Theme.highlightColor
    property bool subtle: true

    implicitWidth: rowLayout.implicitWidth + 12
    implicitHeight: Math.max(rowLayout.implicitHeight + 4, 22)
    radius: height / 2

    color: subtle
           ? Qt.rgba(badgeColor.r, badgeColor.g, badgeColor.b, 0.14)
           : badgeColor

    border.color: subtle
                  ? Qt.rgba(badgeColor.r, badgeColor.g, badgeColor.b, 0.3)
                  : "transparent"
    border.width: 1

    RowLayout {
        id: rowLayout
        anchors.centerIn: parent
        spacing: 4

        Kirigami.Icon {
            id: badgeIcon
            visible: root.iconName !== ""
            source: root.iconName
            Layout.preferredWidth: 13
            Layout.preferredHeight: 13
            color: root.subtle ? root.badgeColor : "#ffffff"
        }

        Text {
            id: labelText
            text: root.text
            color: root.subtle ? root.badgeColor : "#ffffff"
            font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 2, 8)
            font.weight: Font.Medium
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
}

