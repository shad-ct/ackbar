import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property string title: "Activity Intensity Heatmap"
    property var model: []
    signal dayClicked(string date)

    implicitHeight: 200
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

            // Legend
            RowLayout {
                spacing: 4

                Text { text: "Less"; font.pixelSize: 10; color: "#718093" }
                Rectangle { width: 10; height: 10; radius: 2; color: "#282834" }
                Rectangle { width: 10; height: 10; radius: 2; color: "#1e4620" }
                Rectangle { width: 10; height: 10; radius: 2; color: "#2e7d32" }
                Rectangle { width: 10; height: 10; radius: 2; color: "#43a047" }
                Rectangle { width: 10; height: 10; radius: 2; color: "#2ecc71" }
                Text { text: "More"; font.pixelSize: 10; color: "#718093" }
            }
        }

        // Grid of days
        Flow {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 5
            clip: true

            Repeater {
                model: root.model

                delegate: Rectangle {
                    width: 16
                    height: 16
                    radius: 3

                    function getColor(secs, hasData) {
                        if (!hasData || secs <= 0) return "#282834";
                        if (secs < 3600) return "#1e4620";
                        if (secs < 10800) return "#2e7d32";
                        if (secs < 21600) return "#43a047";
                        return "#2ecc71";
                    }

                    color: getColor(modelData.active_seconds || 0, modelData.has_data !== false)
                    border.color: cMouse.containsMouse ? "#ffffff" : "transparent"
                    border.width: 1

                    MouseArea {
                        id: cMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (modelData.date) {
                                root.dayClicked(modelData.date);
                            }
                        }
                    }

                    // Tooltip
                    Rectangle {
                        visible: cMouse.containsMouse
                        z: 99
                        y: -30
                        x: -20
                        width: tipLabel.implicitWidth + 12
                        height: 22
                        radius: 4
                        color: "#181820"
                        border.color: "#3498db"
                        border.width: 1

                        Text {
                            id: tipLabel
                            anchors.centerIn: parent
                            text: (modelData.date || "") + ": " + (modelData.formatted || "0s")
                            font.pixelSize: 10
                            font.weight: Font.Medium
                            color: "#f5f6fa"
                        }
                    }
                }
            }
        }
    }
}
