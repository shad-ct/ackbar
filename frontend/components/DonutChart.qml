import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property var model: []
    property string title: "Category Distribution"
    property string centerLabel: "Total Active"
    property string centerValue: "0s"
    property int hoveredIndex: -1

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

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 16

            // Canvas Donut
            Item {
                Layout.preferredWidth: 170
                Layout.preferredHeight: 170
                Layout.alignment: Qt.AlignVCenter

                Canvas {
                    id: canvas
                    anchors.fill: parent
                    antialiasing: true

                    onPaint: {
                        var ctx = getContext("2d");
                        ctx.reset();

                        var w = width;
                        var h = height;
                        var cx = w / 2;
                        var cy = h / 2;
                        var radius = Math.min(cx, cy) - 10;
                        var innerRadius = radius * 0.68;

                        var data = root.model || [];
                        var total = 0;
                        for (var i = 0; i < data.length; ++i) {
                            total += (data[i].duration || 0);
                        }

                        if (total <= 0 || data.length === 0) {
                            // Empty state circle
                            ctx.beginPath();
                            ctx.arc(cx, cy, radius, 0, Math.PI * 2);
                            ctx.arc(cx, cy, innerRadius, Math.PI * 2, 0, true);
                            ctx.closePath();
                            ctx.fillStyle = "#2d2d3a";
                            ctx.fill();
                            return;
                        }

                        var startAngle = -Math.PI / 2;

                        for (var j = 0; j < data.length; ++j) {
                            var item = data[j];
                            var sliceAngle = (item.duration / total) * (Math.PI * 2);
                            var endAngle = startAngle + sliceAngle;

                            ctx.beginPath();
                            ctx.arc(cx, cy, radius, startAngle, endAngle);
                            ctx.arc(cx, cy, innerRadius, endAngle, startAngle, true);
                            ctx.closePath();

                            ctx.fillStyle = item.color || "#7f8c8d";
                            ctx.fill();

                            startAngle = endAngle;
                        }
                    }

                    Connections {
                        target: root
                        function onModelChanged() { canvas.requestPaint(); }
                    }
                }

                // Center Label
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 2

                    Text {
                        text: root.centerValue
                        font.pixelSize: 15
                        font.weight: Font.Bold
                        color: "#f5f6fa"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: root.centerLabel
                        font.pixelSize: 10
                        color: "#a4b0be"
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }

            // Legend List
            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                model: root.model
                spacing: 6

                delegate: Rectangle {
                    width: parent.width
                    height: 24
                    radius: 4
                    color: itemMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.05) : "transparent"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 6
                        anchors.rightMargin: 6
                        spacing: 8

                        Rectangle {
                            width: 10
                            height: 10
                            radius: 3
                            color: modelData.color || "#7f8c8d"
                            Layout.alignment: Qt.AlignVCenter
                        }

                        Text {
                            text: (modelData.icon || "📌") + " " + (modelData.name || modelData.category)
                            font.pixelSize: 11
                            color: "#f5f6fa"
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }

                        Text {
                            text: modelData.formatted || "0s"
                            font.pixelSize: 11
                            font.weight: Font.Medium
                            color: "#a4b0be"
                        }

                        Text {
                            text: (modelData.percent || 0) + "%"
                            font.pixelSize: 11
                            font.weight: Font.DemiBold
                            color: modelData.color || "#3498db"
                            Layout.preferredWidth: 40
                            horizontalAlignment: Text.AlignRight
                        }
                    }

                    MouseArea {
                        id: itemMouse
                        anchors.fill: parent
                        hoverEnabled: true
                    }
                }
            }
        }
    }
}
