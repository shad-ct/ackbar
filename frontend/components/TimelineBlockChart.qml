import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2

Rectangle {
    id: root

    property string title: "24-Hour Chronological Timeline (00:00 - 24:00)"
    property var blocks: []
    property real zoomFactor: 1.0
    property var selectedBlock: null

    signal blockClicked(var block)

    implicitHeight: 230
    Layout.fillWidth: true
    radius: 12
    color: "#22222c"
    border.color: "#323242"
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 10

        RowLayout {
            Layout.fillWidth: true

            Text {
                text: root.title
                font.pixelSize: 13
                font.weight: Font.DemiBold
                color: "#f5f6fa"
                Layout.fillWidth: true
            }

            // Zoom Controls
            RowLayout {
                spacing: 6

                Text { text: "Zoom:"; font.pixelSize: 11; color: "#a4b0be" }

                Repeater {
                    model: [
                        { label: "1x", factor: 1.0 },
                        { label: "2x", factor: 2.0 },
                        { label: "4x", factor: 4.0 }
                    ]

                    delegate: Rectangle {
                        implicitWidth: 32
                        implicitHeight: 22
                        radius: 4
                        color: root.zoomFactor === modelData.factor ? "#3498db" : Qt.rgba(255, 255, 255, 0.05)

                        Text {
                            anchors.centerIn: parent
                            text: modelData.label
                            font.pixelSize: 10
                            font.weight: Font.Medium
                            color: "#ffffff"
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.zoomFactor = modelData.factor
                        }
                    }
                }
            }
        }

        // Horizontal Timeline Scroll Container
        Flickable {
            id: flick
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentWidth: timelineCanvas.width
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            Item {
                id: timelineCanvas
                width: Math.max(flick.width, flick.width * root.zoomFactor)
                height: flick.height

                // Hour Grid & Ticks (00:00 to 24:00)
                Row {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 24

                    Repeater {
                        model: 24

                        Item {
                            width: timelineCanvas.width / 24
                            height: parent.height

                            Rectangle {
                                width: 1
                                height: parent.height
                                color: Qt.rgba(255, 255, 255, 0.08)
                                anchors.left: parent.left
                            }

                            Text {
                                text: (index < 10 ? "0" : "") + index + ":00"
                                font.pixelSize: 9
                                font.family: "monospace"
                                color: "#718093"
                                anchors.left: parent.left
                                anchors.leftMargin: 3
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                }

                // Timeline Track Area
                Rectangle {
                    id: track
                    anchors.top: parent.top
                    anchors.topMargin: 26
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: parent.height - 30
                    radius: 8
                    color: "#181820"
                    border.color: "#2d2d3a"
                    border.width: 1

                    // Empty state notice
                    Text {
                        anchors.centerIn: parent
                        text: "No activity blocks recorded for this timeframe"
                        font.pixelSize: 12
                        color: "#718093"
                        visible: !root.blocks || root.blocks.length === 0
                    }

                    // Blocks
                    Repeater {
                        model: root.blocks

                        delegate: Rectangle {
                            id: blockRect
                            // 1440 minutes in 24 hours
                            x: Math.min(track.width - 4, (modelData.start_minute / 1440.0) * track.width)
                            y: 4
                            height: track.height - 8
                            width: Math.max(3, (modelData.duration_minutes / 1440.0) * track.width)
                            radius: 3
                            color: modelData.is_locked
                                   ? "#34495e"
                                   : (modelData.color || "#3498db")
                            opacity: bMouse.containsMouse ? 1.0 : 0.88
                            border.color: (root.selectedBlock && root.selectedBlock.id === modelData.id)
                                          ? "#ffffff"
                                          : (bMouse.containsMouse ? "#ffffff" : Qt.darker(color, 1.2))
                            border.width: (root.selectedBlock && root.selectedBlock.id === modelData.id) ? 2 : 1

                            // Tiny label if wide enough
                            Text {
                                anchors.centerIn: parent
                                text: modelData.app_name
                                font.pixelSize: 9
                                font.weight: Font.DemiBold
                                color: "#ffffff"
                                elide: Text.ElideRight
                                width: parent.width - 4
                                visible: parent.width > 45
                            }

                            MouseArea {
                                id: bMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    root.selectedBlock = modelData;
                                    root.blockClicked(modelData);
                                }
                            }

                            // Hover Tooltip Card
                            Rectangle {
                                visible: bMouse.containsMouse
                                z: 999
                                y: -90
                                x: Math.min(Math.max(-50, -width / 2), track.width - width - 10)
                                width: Math.max(220, bTipCol.implicitWidth + 24)
                                height: bTipCol.implicitHeight + 16
                                radius: 8
                                color: "#14141a"
                                border.color: modelData.color || "#3498db"
                                border.width: 1.5

                                ColumnLayout {
                                    id: bTipCol
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    spacing: 3

                                    RowLayout {
                                        Layout.fillWidth: true
                                        spacing: 6

                                        Text {
                                            text: modelData.icon || "📌"
                                            font.pixelSize: 14
                                        }

                                        Text {
                                            text: modelData.app_name
                                            font.pixelSize: 12
                                            font.weight: Font.Bold
                                            color: "#ffffff"
                                            Layout.fillWidth: true
                                            elide: Text.ElideRight
                                        }

                                        Rectangle {
                                            radius: 3
                                            color: Qt.rgba(255, 255, 255, 0.1)
                                            implicitWidth: durText.implicitWidth + 6
                                            implicitHeight: 16

                                            Text {
                                                id: durText
                                                anchors.centerIn: parent
                                                text: modelData.duration_formatted
                                                font.pixelSize: 9
                                                font.weight: Font.Bold
                                                color: "#2ecc71"
                                            }
                                        }
                                    }

                                    Text {
                                        text: modelData.start_time + "  ➔  " + modelData.end_time
                                        font.pixelSize: 10
                                        font.family: "monospace"
                                        color: "#a4b0be"
                                    }

                                    Text {
                                        text: modelData.window_title || "Untitled"
                                        font.pixelSize: 10
                                        color: "#74b9ff"
                                        elide: Text.ElideRight
                                        Layout.fillWidth: true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
