import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import "../components"

Flickable {
    id: root

    property var bridge: null
    property string targetDate: "2026-11-14"
    property var dailyData: null

    contentHeight: mainCol.implicitHeight + 40
    clip: true

    function reloadDay() {
        if (!bridge) return;
        try {
            var res = bridge.getDailyAnalytics(root.targetDate);
            root.dailyData = JSON.parse(res);
        } catch (e) {
            root.dailyData = null;
        }
    }

    ColumnLayout {
        id: mainCol
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 20
        spacing: 16

        // Date Header with Next/Prev Buttons
        Rectangle {
            Layout.fillWidth: true
            height: 48
            radius: 10
            color: "#1e1e26"
            border.color: "#323242"
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12

                QQC2.Button {
                    text: "◀ " + (root.dailyData ? root.dailyData.prev_date : "Prev")
                    onClicked: {
                        if (root.dailyData) {
                            root.targetDate = root.dailyData.prev_date;
                            root.reloadDay();
                        }
                    }
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: "🗓️ Daily Screen Time: " + root.targetDate
                    font.pixelSize: 15
                    font.weight: Font.Bold
                    color: "#f5f6fa"
                }

                Item { Layout.fillWidth: true }

                QQC2.Button {
                    text: (root.dailyData ? root.dailyData.next_date : "Next") + " ▶"
                    onClicked: {
                        if (root.dailyData) {
                            root.targetDate = root.dailyData.next_date;
                            root.reloadDay();
                        }
                    }
                }
            }
        }

        // Daily KPI Cards
        GridLayout {
            Layout.fillWidth: true
            columns: 3
            rowSpacing: 12
            columnSpacing: 12

            MetricCard {
                title: "Active Focus"
                icon: "⚡"
                value: root.dailyData && root.dailyData.overview ? root.dailyData.overview.active_formatted : "0s"
                subtitle: (root.dailyData && root.dailyData.overview ? root.dailyData.overview.active_percent : 0) + "% of day"
                accentColor: "#2ecc71"
            }

            MetricCard {
                title: "Away / Locked"
                icon: "🔒"
                value: root.dailyData && root.dailyData.overview ? root.dailyData.overview.locked_formatted : "0s"
                subtitle: (root.dailyData && root.dailyData.overview ? root.dailyData.overview.locked_percent : 0) + "% of day"
                accentColor: "#f39c12"
            }

            MetricCard {
                title: "Total Online"
                icon: "⏳"
                value: root.dailyData && root.dailyData.overview ? root.dailyData.overview.online_formatted : "0s"
                subtitle: "Total session uptime"
                accentColor: "#3498db"
            }
        }

        // 24-Hour Hourly Activity Bar Chart
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 180
            radius: 12
            color: "#22222c"
            border.color: "#323242"
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 8

                Text {
                    text: "24-Hour Hourly Usage Distribution"
                    font.pixelSize: 13
                    font.weight: Font.DemiBold
                    color: "#f5f6fa"
                }

                Row {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 2

                    Repeater {
                        model: root.dailyData ? root.dailyData.hourly_distribution : []

                        delegate: Item {
                            width: (parent.width - 48) / 24
                            height: parent.height

                            Column {
                                anchors.fill: parent
                                anchors.bottomMargin: 14

                                Item { width: parent.width; height: parent.height - barItem.height }

                                Rectangle {
                                    id: barItem
                                    width: parent.width - 2
                                    height: Math.max(2, (modelData.active_seconds / 3600.0) * (parent.parent.height - 24))
                                    radius: 2
                                    color: barMouse.containsMouse ? "#ffffff" : (modelData.active_seconds > 0 ? "#2ecc71" : "#2d2d3a")
                                    anchors.horizontalCenter: parent.horizontalCenter

                                    MouseArea {
                                        id: barMouse
                                        anchors.fill: parent
                                        hoverEnabled: true
                                    }

                                    QQC2.ToolTip.visible: barMouse.containsMouse
                                    QQC2.ToolTip.text: modelData.label + " : " + modelData.formatted
                                }
                            }

                            Text {
                                text: modelData.hour % 3 === 0 ? modelData.hour : ""
                                font.pixelSize: 9
                                color: "#718093"
                                anchors.bottom: parent.bottom
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                }
            }
        }

        // Top Window Tasks & Top Apps Row
        RowLayout {
            Layout.fillWidth: true
            spacing: 16

            BarChart {
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                title: "Top Applications Today"
                model: root.dailyData && root.dailyData.overview ? root.dailyData.overview.top_apps : []
            }

            // Top Windows List
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                implicitHeight: 250
                radius: 12
                color: "#22222c"
                border.color: "#323242"
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 8

                    Text {
                        text: "Key Window Titles & Tasks"
                        font.pixelSize: 13
                        font.weight: Font.DemiBold
                        color: "#f5f6fa"
                    }

                    ListView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        spacing: 6
                        model: root.dailyData ? root.dailyData.top_windows : []

                        delegate: Rectangle {
                            width: ListView.view ? ListView.view.width : 200
                            height: 28
                            radius: 4
                            color: Qt.rgba(255, 255, 255, 0.03)

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 8
                                anchors.rightMargin: 8
                                spacing: 8

                                Text { text: modelData.category_icon || "📌"; font.pixelSize: 12 }
                                Text {
                                    text: modelData.window_title
                                    font.pixelSize: 11
                                    color: "#f5f6fa"
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                                Text {
                                    text: modelData.formatted
                                    font.pixelSize: 11
                                    font.weight: Font.Bold
                                    color: "#2ecc71"
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        root.reloadDay();
    }
}
