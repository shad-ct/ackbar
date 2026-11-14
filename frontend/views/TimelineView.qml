import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import "../components"

Flickable {
    id: root

    property var bridge: null
    property string activeDate: "2026-11-14"
    property string timelineMode: "daily" // daily | multiday | alltime
    property var dailyBlocks: []
    property var multiDayData: []
    property string appFilter: ""
    property string categoryFilter: "all"
    property var inspectedBlock: null

    contentHeight: mainCol.implicitHeight + 40
    clip: true

    function reloadTimeline() {
        if (!bridge) return;
        if (root.timelineMode === "daily") {
            try {
                var jsonStr = bridge.getTimelineBlocks(root.activeDate, root.appFilter, root.categoryFilter);
                root.dailyBlocks = JSON.parse(jsonStr);
            } catch (e) {
                root.dailyBlocks = [];
            }
        } else if (root.timelineMode === "multiday") {
            try {
                var multiStr = bridge.getMultiDayTimeline("2026-10-05", root.activeDate, 7);
                root.multiDayData = JSON.parse(multiStr);
            } catch (e) {
                root.multiDayData = [];
            }
        }
    }

    ColumnLayout {
        id: mainCol
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 20
        spacing: 16

        // Header & Mode Switcher
        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Text {
                text: "HISTORICAL TIMELINE"
                font.pixelSize: 15
                font.weight: Font.Bold
                color: "#f5f6fa"
                Layout.fillWidth: true
            }

            // Mode Pills
            RowLayout {
                spacing: 6

                Repeater {
                    model: [
                        { id: "daily", label: "Daily (24h Axis)" },
                        { id: "multiday", label: "Multi-Day Stack" }
                    ]

                    delegate: Rectangle {
                        implicitHeight: 28
                        implicitWidth: modeLabel.implicitWidth + 20
                        radius: 14
                        color: root.timelineMode === modelData.id ? "#3498db" : Qt.rgba(255, 255, 255, 0.05)

                        Text {
                            id: modeLabel
                            anchors.centerIn: parent
                            text: modelData.label
                            font.pixelSize: 11
                            font.weight: Font.DemiBold
                            color: "#ffffff"
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.timelineMode = modelData.id;
                                root.reloadTimeline();
                            }
                        }
                    }
                }
            }
        }

        // Filters Bar
        SearchFilterBar {
            showPrivacyToggle: false
            onSearchChanged: function(text) {
                root.appFilter = text;
                root.reloadTimeline();
            }
            onFilterChanged: function(cat) {
                root.categoryFilter = cat;
                root.reloadTimeline();
            }
        }

        // Mode 1: Daily Timeline View
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 16
            visible: root.timelineMode === "daily"

            // Date Navigator
            Rectangle {
                Layout.fillWidth: true
                height: 40
                radius: 8
                color: "#1e1e26"
                border.color: "#323242"
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12

                    QQC2.Button {
                        text: "◀ Previous Day"
                        onClicked: {
                            var d = new Date(root.activeDate);
                            d.setDate(d.getDate() - 1);
                            root.activeDate = d.toISOString().slice(0, 10);
                            root.reloadTimeline();
                        }
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: "Viewing Date: " + root.activeDate
                        font.pixelSize: 13
                        font.weight: Font.Bold
                        color: "#74b9ff"
                    }

                    Item { Layout.fillWidth: true }

                    QQC2.Button {
                        text: "Next Day ▶"
                        onClicked: {
                            var d = new Date(root.activeDate);
                            d.setDate(d.getDate() + 1);
                            root.activeDate = d.toISOString().slice(0, 10);
                            root.reloadTimeline();
                        }
                    }
                }
            }

            // Interactive 24-Hour Block Axis
            TimelineBlockChart {
                Layout.fillWidth: true
                blocks: root.dailyBlocks
                onBlockClicked: function(b) {
                    root.inspectedBlock = b;
                }
            }

            // Inspected Block Detail Card
            Rectangle {
                visible: root.inspectedBlock !== null
                Layout.fillWidth: true
                implicitHeight: 120
                radius: 10
                color: "#22222c"
                border.color: root.inspectedBlock ? (root.inspectedBlock.color || "#3498db") : "#3498db"
                border.width: 1.5

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 6

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            text: root.inspectedBlock ? root.inspectedBlock.icon : ""
                            font.pixelSize: 20
                        }

                        Text {
                            text: root.inspectedBlock ? root.inspectedBlock.app_name : ""
                            font.pixelSize: 15
                            font.weight: Font.Bold
                            color: "#ffffff"
                        }

                        Rectangle {
                            radius: 4
                            color: Qt.rgba(255, 255, 255, 0.1)
                            implicitWidth: catLabel.implicitWidth + 8
                            implicitHeight: 20

                            Text {
                                id: catLabel
                                anchors.centerIn: parent
                                text: root.inspectedBlock ? root.inspectedBlock.category_name : ""
                                font.pixelSize: 10
                                color: "#a4b0be"
                            }
                        }

                        Item { Layout.fillWidth: true }

                        Text {
                            text: root.inspectedBlock ? ("Duration: " + root.inspectedBlock.duration_formatted) : ""
                            font.pixelSize: 13
                            font.weight: Font.Bold
                            color: "#2ecc71"
                        }

                        Text {
                            text: "✕"
                            font.pixelSize: 14
                            color: "#a4b0be"
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.inspectedBlock = null
                            }
                        }
                    }

                    Text {
                        text: root.inspectedBlock ? ("Time Interval: " + root.inspectedBlock.start_time + "  ➔  " + root.inspectedBlock.end_time) : ""
                        font.pixelSize: 11
                        font.family: "monospace"
                        color: "#a4b0be"
                    }

                    Text {
                        text: root.inspectedBlock ? ("Window Caption: " + root.inspectedBlock.window_title) : ""
                        font.pixelSize: 12
                        color: "#f5f6fa"
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }
            }
        }

        // Mode 2: Multi-Day Stacked Timelines
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 12
            visible: root.timelineMode === "multiday"

            Repeater {
                model: root.multiDayData

                delegate: Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 110
                    radius: 10
                    color: "#22222c"
                    border.color: "#323242"
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 6

                        RowLayout {
                            Layout.fillWidth: true

                            Text {
                                text: "📅 " + modelData.date
                                font.pixelSize: 13
                                font.weight: Font.Bold
                                color: "#f5f6fa"
                            }

                            Item { Layout.fillWidth: true }

                            Text {
                                text: "⚡ Active: " + modelData.active_formatted
                                font.pixelSize: 12
                                font.weight: Font.DemiBold
                                color: "#2ecc71"
                            }
                        }

                        // Mini 24h timeline strip
                        Rectangle {
                            Layout.fillWidth: true
                            height: 38
                            radius: 6
                            color: "#181820"
                            clip: true

                            Repeater {
                                model: modelData.blocks

                                delegate: Rectangle {
                                    x: (modelData.start_minute / 1440.0) * parent.width
                                    y: 4
                                    height: parent.height - 8
                                    width: Math.max(2, (modelData.duration_minutes / 1440.0) * parent.width)
                                    radius: 2
                                    color: modelData.is_locked ? "#34495e" : (modelData.color || "#3498db")
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        root.reloadTimeline();
    }
}

