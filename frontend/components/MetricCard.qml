import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import "../theme"

Rectangle {
    id: root

    property string title: ""
    property string value: ""
    property string subtitle: ""
    property string icon: ""
    property color accentColor: "#3498db"
    property string badgeText: ""

    Layout.fillWidth: true
    implicitHeight: 110
    radius: 12
    color: mouseArea.containsMouse ? "#292936" : "#22222c"
    border.color: mouseArea.containsMouse ? Qt.rgba(accentColor.r, accentColor.g, accentColor.b, 0.45) : "#323242"
    border.width: 1

    Behavior on color { ColorAnimation { duration: 150 } }
    Behavior on border.color { ColorAnimation { duration: 150 } }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 4

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Text {
                text: root.icon
                font.pixelSize: 18
                visible: root.icon !== ""
            }

            Text {
                text: root.title.toUpperCase()
                font.pixelSize: 11
                font.weight: Font.DemiBold
                font.letterSpacing: 0.8
                color: "#a4b0be"
                Layout.fillWidth: true
                elide: Text.ElideRight
            }

            Rectangle {
                visible: root.badgeText !== ""
                radius: 4
                color: Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.2)
                implicitWidth: badgeLabel.implicitWidth + 8
                implicitHeight: 18

                Text {
                    id: badgeLabel
                    anchors.centerIn: parent
                    text: root.badgeText
                    font.pixelSize: 10
                    font.weight: Font.Bold
                    color: root.accentColor
                }
            }
        }

        Item { Layout.fillHeight: true }

        Text {
            text: root.value
            font.pixelSize: 22
            font.weight: Font.Bold
            color: "#f5f6fa"
            elide: Text.ElideRight
            Layout.fillWidth: true
        }

        Text {
            text: root.subtitle
            font.pixelSize: 11
            color: Qt.rgba(164/255, 176/255, 190/255, 0.8)
            elide: Text.ElideRight
            Layout.fillWidth: true
            visible: root.subtitle !== ""
        }
    }
}
