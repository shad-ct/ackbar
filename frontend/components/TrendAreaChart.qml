import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property string title: "Daily Activity Trend"
    property var model: []
    property int hoveredIdx: -1
    property real hoveredX: 0
    property real hoveredY: 0

    implicitHeight: 220
    Layout.fillWidth: true
    radius: 12
    color: "#22222c"
    border.color: "#323242"
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 8

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
                spacing: 12

                RowLayout {
                    spacing: 4
                    Rectangle { width: 8; height: 8; radius: 4; color: "#2ecc71" }
                    Text { text: "Active Focus"; font.pixelSize: 10; color: "#a4b0be" }
                }

                RowLayout {
                    spacing: 4
                    Rectangle { width: 8; height: 8; radius: 4; color: "#718093" }
                    Text { text: "Online Uptime"; font.pixelSize: 10; color: "#a4b0be" }
                }
            }
        }

        Item {
            id: chartArea
            Layout.fillWidth: true
            Layout.fillHeight: true

            Canvas {
                id: canvas
                anchors.fill: parent
                antialiasing: true

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();

                    var w = width;
                    var h = height - 20; // 20px reserved for X-axis labels
                    var data = root.model || [];

                    if (data.length === 0) {
                        ctx.fillStyle = "#a4b0be";
                        ctx.font = "12px sans-serif";
                        ctx.textAlign = "center";
                        ctx.fillText("No trend data in selected period", w / 2, h / 2);
                        return;
                    }

                    // Find max value
                    var maxVal = 1;
                    for (var i = 0; i < data.length; ++i) {
                        var online = data[i].online_seconds || 0;
                        if (online > maxVal) maxVal = online;
                    }

                    // Draw grid lines
                    ctx.strokeStyle = "rgba(255, 255, 255, 0.06)";
                    ctx.lineWidth = 1;
                    for (var g = 0; g <= 4; ++g) {
                        var gy = h - (g / 4.0) * h;
                        ctx.beginPath();
                        ctx.moveTo(0, gy);
                        ctx.lineTo(w, gy);
                        ctx.stroke();
                    }

                    var stepX = data.length > 1 ? w / (data.length - 1) : w;

                    // 1. Draw Online Area (Muted gray)
                    ctx.beginPath();
                    for (var j = 0; j < data.length; ++j) {
                        var px = j * stepX;
                        var py = h - ((data[j].online_seconds || 0) / maxVal) * h;
                        if (j === 0) ctx.moveTo(px, py);
                        else ctx.lineTo(px, py);
                    }
                    ctx.lineTo((data.length - 1) * stepX, h);
                    ctx.lineTo(0, h);
                    ctx.closePath();
                    ctx.fillStyle = "rgba(113, 128, 147, 0.12)";
                    ctx.fill();

                    // 2. Draw Active Area (Green gradient)
                    var grad = ctx.createLinearGradient(0, 0, 0, h);
                    grad.addColorStop(0, "rgba(46, 204, 113, 0.35)");
                    grad.addColorStop(1, "rgba(46, 204, 113, 0.02)");

                    ctx.beginPath();
                    for (var k = 0; k < data.length; ++k) {
                        var kx = k * stepX;
                        var ky = h - ((data[k].active_seconds || 0) / maxVal) * h;
                        if (k === 0) ctx.moveTo(kx, ky);
                        else ctx.lineTo(kx, ky);
                    }
                    ctx.lineTo((data.length - 1) * stepX, h);
                    ctx.lineTo(0, h);
                    ctx.closePath();
                    ctx.fillStyle = grad;
                    ctx.fill();

                    // Active Line Stroke
                    ctx.beginPath();
                    for (var m = 0; m < data.length; ++m) {
                        var mx = m * stepX;
                        var my = h - ((data[m].active_seconds || 0) / maxVal) * h;
                        if (m === 0) ctx.moveTo(mx, my);
                        else ctx.lineTo(mx, my);
                    }
                    ctx.strokeStyle = "#2ecc71";
                    ctx.lineWidth = 2.5;
                    ctx.stroke();

                    // Draw Points
                    for (var p = 0; p < data.length; ++p) {
                        var ppx = p * stepX;
                        var ppy = h - ((data[p].active_seconds || 0) / maxVal) * h;
                        ctx.beginPath();
                        ctx.arc(ppx, ppy, root.hoveredIdx === p ? 5 : 2.5, 0, Math.PI * 2);
                        ctx.fillStyle = root.hoveredIdx === p ? "#ffffff" : "#2ecc71";
                        ctx.fill();
                    }
                }

                Connections {
                    target: root
                    function onModelChanged() { canvas.requestPaint(); }
                    function onHoveredIdxChanged() { canvas.requestPaint(); }
                }
            }

            // Mouse interaction
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onPositionChanged: function(mouse) {
                    var data = root.model || [];
                    if (data.length <= 1) return;
                    var stepX = width / (data.length - 1);
                    var idx = Math.round(mouse.x / stepX);
                    if (idx >= 0 && idx < data.length) {
                        root.hoveredIdx = idx;
                        root.hoveredX = idx * stepX;
                        root.hoveredY = mouse.y;
                    }
                }

                onExited: {
                    root.hoveredIdx = -1;
                }
            }

            // Hover Tooltip Popup
            Rectangle {
                visible: root.hoveredIdx >= 0 && root.hoveredIdx < (root.model ? root.model.length : 0)
                x: Math.min(Math.max(10, root.hoveredX - width / 2), parent.width - width - 10)
                y: Math.max(0, root.hoveredY - height - 10)
                width: tipCol.implicitWidth + 16
                height: tipCol.implicitHeight + 12
                radius: 6
                color: "#181820"
                border.color: "#3498db"
                border.width: 1

                ColumnLayout {
                    id: tipCol
                    anchors.centerIn: parent
                    spacing: 2

                    Text {
                        text: (root.hoveredIdx >= 0 && root.model && root.model[root.hoveredIdx]) ? root.model[root.hoveredIdx].date : ""
                        font.pixelSize: 10
                        font.weight: Font.Bold
                        color: "#74b9ff"
                    }

                    Text {
                        text: {
                            if (root.hoveredIdx >= 0 && root.model && root.model[root.hoveredIdx]) {
                                var s = root.model[root.hoveredIdx].active_seconds || 0;
                                return "⚡ Active: " + Math.floor(s/3600) + "h " + Math.floor((s%3600)/60) + "m";
                            }
                            return "";
                        }
                        font.pixelSize: 10
                        color: "#2ecc71"
                    }

                    Text {
                        text: {
                            if (root.hoveredIdx >= 0 && root.model && root.model[root.hoveredIdx]) {
                                var o = root.model[root.hoveredIdx].online_seconds || 0;
                                return "⏳ Online: " + Math.floor(o/3600) + "h " + Math.floor((o%3600)/60) + "m";
                            }
                            return "";
                        }
                        font.pixelSize: 10
                        color: "#a4b0be"
                    }
                }
            }
        }
    }
}
