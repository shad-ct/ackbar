import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property string title: "Top Applications"
    property var model: []

    implicitHeight: 250
    Layout.fillWidth: true
    radius: 12
    color: "#22222c"
    border.color: "#323242"
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 10

        Text {
            text: root.title
            font.pixelSize: 13
            font.weight: Font.DemiBold
            color: "#f5f6fa"
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 8
            model: root.model

            delegate: ColumnLayout {
                width: ListView.view ? ListView.view.width : 200
                spacing: 3

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Text {
                        text: (index + 1) + "."
                        font.pixelSize: 11
                        font.weight: Font.Bold
                        color: "#718093"
                        Layout.preferredWidth: 16
                    }

                    Text {
                        text: modelData.name || modelData.app_name
                        font.pixelSize: 12
                        font.weight: Font.Medium
                        color: "#f5f6fa"
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    Text {
                        text: modelData.formatted || "0s"
                        font.pixelSize: 11
                        color: "#a4b0be"
                    }

                    Text {
                        text: (modelData.percent || 0) + "%"
                        font.pixelSize: 11
                        font.weight: Font.DemiBold
                        color: modelData.color || "#3498db"
                        Layout.preferredWidth: 38
                        horizontalAlignment: Text.AlignRight
                    }
                }

                // Progress Bar Background
                Rectangle {
                    Layout.fillWidth: true
                    height: 6
                    radius: 3
                    color: Qt.rgba(255, 255, 255, 0.05)

                    Rectangle {
                        height: parent.height
                        radius: parent.radius
                        width: Math.max(4, parent.width * ((modelData.percent || 0) / 100.0))
                        color: modelData.color || "#3498db"

                        Behavior on width {
                            NumberAnimation { duration: 250; easing.type: Easing.OutQuad }
                        }
                    }
                }
            }
        }
    }
}
