import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Rectangle {
    id: root

    default property alias contentData: contentLayout.data
    property alias contentChildren: contentLayout.children
    property int contentPadding: 10
    property int contentSpacing: 8
    property color customBgColor: "transparent"
    property bool interactive: false
    property bool hovered: interactive && mouseArea.containsMouse
    signal clicked()

    radius: 8
    implicitWidth: contentLayout.implicitWidth + (contentPadding * 2)
    implicitHeight: contentLayout.implicitHeight + (contentPadding * 2)

    color: customBgColor !== "transparent"
           ? customBgColor
           : (interactive && hovered
              ? Qt.rgba(Kirigami.Theme.highlightColor.r, Kirigami.Theme.highlightColor.g, Kirigami.Theme.highlightColor.b, 0.12)
              : Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.04))

    border.color: interactive && hovered
                  ? Qt.rgba(Kirigami.Theme.highlightColor.r, Kirigami.Theme.highlightColor.g, Kirigami.Theme.highlightColor.b, 0.35)
                  : Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.10)
    border.width: 1

    Behavior on color {
        ColorAnimation { duration: 150 }
    }
    Behavior on border.color {
        ColorAnimation { duration: 150 }
    }

    ColumnLayout {
        id: contentLayout
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: root.contentPadding
        spacing: root.contentSpacing
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: root.interactive
        hoverEnabled: root.interactive
        cursorShape: root.interactive ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: root.clicked()
    }
}
