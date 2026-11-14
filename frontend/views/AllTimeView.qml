import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import "../components"

Flickable {
    id: root

    property var bridge: null
    property var allTimeData: null

    contentHeight: mainCol.implicitHeight + 40
    clip: true

    function reloadAllTime() {
        if (!bridge) return;
        try {
            var res = bridge.getAllTimeAnalytics();
            root.allTimeData = JSON.parse(res);
        } catch (e) {
            root.allTimeData = null;
        }
    }

    ColumnLayout {
        id: mainCol
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 20
        spacing: 16

        // Header
        RowLayout {
            Layout.fillWidth: true

            Text {
                text: "ALL-TIME HISTORICAL ANALYTICS"
                font.pixelSize: 15
                font.weight: Font.Bold
                color: "#f5f6fa"
                Layout.fillWidth: true
            }

            Rectangle {
                implicitHeight: 28
                implicitWidth: timeSpanText.implicitWidth + 18
                radius: 14
                color: Qt.rgba(46/255, 204/255, 113/255, 0.15)
                border.color: "#2ecc71"
                border.width: 1

                Text {
                    id: timeSpanText
                    anchors.centerIn: parent
                    text: root.allTimeData ? ("Since " + root.allTimeData.earliest_date + " (" + root.allTimeData.total_tracked_days + " days)") : ""
                    font.pixelSize: 11
                    font.weight: Font.DemiBold
                    color: "#2ecc71"
                }
            }
        }

        // Summary Cards
        GridLayout {
            Layout.fillWidth: true
            columns: 3
            rowSpacing: 12
            columnSpacing: 12

            MetricCard {
                title: "All-Time Active Focus"
                icon: "⚡"
                value: root.allTimeData && root.allTimeData.overview ? root.allTimeData.overview.active_formatted : "0s"
                subtitle: (root.allTimeData && root.allTimeData.overview ? root.allTimeData.overview.active_percent : 0) + "% of total recorded uptime"
                accentColor: "#2ecc71"
                badgeText: "All Time"
            }

            MetricCard {
                title: "All-Time Online Uptime"
                icon: "⏳"
                value: root.allTimeData && root.allTimeData.overview ? root.allTimeData.overview.online_formatted : "0s"
                subtitle: (root.allTimeData ? root.allTimeData.total_records.toLocaleString() : "0") + " total activity events"
                accentColor: "#3498db"
            }

            MetricCard {
                title: "All-Time Daily Average"
                icon: "📊"
                value: root.allTimeData && root.allTimeData.overview ? root.allTimeData.overview.daily_avg_active_formatted : "0s"
                subtitle: "Active hours per tracked day"
                accentColor: "#f39c12"
            }
        }

        // All-Time Contribution Calendar
        CalendarHeatmap {
            Layout.fillWidth: true
            title: "Complete Historical Activity Heatmap"
            model: root.allTimeData ? root.allTimeData.heatmap : []
        }

        // Top Apps & Categories of All Time
        RowLayout {
            Layout.fillWidth: true
            spacing: 16

            BarChart {
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                title: "Top 10 Applications of All Time"
                model: root.allTimeData ? root.allTimeData.top_apps : []
            }

            DonutChart {
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                title: "All-Time Category Distribution"
                model: root.allTimeData && root.allTimeData.overview ? root.allTimeData.overview.category_distribution : []
                centerValue: root.allTimeData && root.allTimeData.overview ? root.allTimeData.overview.active_formatted : "0s"
            }
        }
    }

    Component.onCompleted: {
        root.reloadAllTime();
    }
}

