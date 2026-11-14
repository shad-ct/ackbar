import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2

Rectangle {
    id: root

    property string label: ""
    property string icon: ""
    property bool selected: false
    property string badgeText: ""
    signal clicked()

    Layout.fillWidth: true
    implicitHeight: 38
    radius: 8
    color: root.selected
           ? Qt.rgba(52/255, 152/255, 219/255, 0.18)
           : (mouseArea.containsMouse ? Qt.rgba(255, 255, 255, 0.05) : "transparent")

    Behavior on color { ColorAnimation { duration: 120 } }

    Rectangle {
        id: activeIndicator
        width: 3
        height: 18
        radius: 2
        color: "#3498db"
        anchors.left: parent.left
        anchors.leftMargin: 2
        anchors.verticalCenter: parent.verticalCenter
        visible: root.selected
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 10
        spacing: 10

        Text {
            text: root.icon
            font.pixelSize: 15
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            text: root.label
            font.pixelSize: 13
            font.weight: root.selected ? Font.DemiBold : Font.Normal
            color: root.selected ? "#f5f6fa" : (mouseArea.containsMouse ? "#f5f6fa" : "#a4b0be")
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            elide: Text.ElideRight
        }

        Rectangle {
            visible: root.badgeText !== ""
            radius: 4
            color: Qt.rgba(255, 255, 255, 0.1)
            implicitWidth: badgeTextItem.implicitWidth + 8
            implicitHeight: 18
            Layout.alignment: Qt.AlignVCenter

            Text {
                id: badgeTextItem
                anchors.centerIn: parent
                text: root.badgeText
                font.pixelSize: 10
                font.weight: Font.DemiBold
                color: "#a4b0be"
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}

