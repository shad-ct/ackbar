import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import "../components"

Flickable {
    id: root

    property var bridge: null
    property string endDate: "2026-11-14"
    property var weeklyData: null

    contentHeight: mainCol.implicitHeight + 40
    clip: true

    function reloadWeek() {
        if (!bridge) return;
        try {
            var res = bridge.getWeeklyAnalytics(root.endDate);
            root.weeklyData = JSON.parse(res);
        } catch (e) {
            root.weeklyData = null;
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
                text: "WEEKLY ANALYTICS"
                font.pixelSize: 15
                font.weight: Font.Bold
                color: "#f5f6fa"
                Layout.fillWidth: true
            }

            Rectangle {
                implicitHeight: 28
                implicitWidth: rangeText.implicitWidth + 18
                radius: 14
                color: Qt.rgba(52/255, 152/255, 219/255, 0.15)
                border.color: "#3498db"
                border.width: 1

                Text {
                    id: rangeText
                    anchors.centerIn: parent
                    text: root.weeklyData ? (root.weeklyData.start_date + "  ➔  " + root.weeklyData.end_date) : ""
                    font.pixelSize: 11
                    font.weight: Font.Medium
                    color: "#74b9ff"
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
                title: "Weekly Active Focus"
                icon: "⚡"
                value: root.weeklyData && root.weeklyData.current ? root.weeklyData.current.active_formatted : "0s"
                subtitle: (root.weeklyData ? (root.weeklyData.delta_percent > 0 ? "+" : "") + root.weeklyData.delta_percent + "% vs prior 7 days" : "")
                accentColor: root.weeklyData && root.weeklyData.delta_percent >= 0 ? "#2ecc71" : "#e74c3c"
                badgeText: "7-Day Sum"
            }

            MetricCard {
                title: "Daily Average Focus"
                icon: "📊"
                value: root.weeklyData && root.weeklyData.current ? root.weeklyData.current.daily_avg_active_formatted : "0s"
                subtitle: "Across 7 consecutive days"
                accentColor: "#3498db"
            }

            MetricCard {
                title: "Total Online Time"
                icon: "⏳"
                value: root.weeklyData && root.weeklyData.current ? root.weeklyData.current.online_formatted : "0s"
                subtitle: "Active + Away combined"
                accentColor: "#f39c12"
            }
        }

        // 7-Day Trend Chart
        TrendAreaChart {
            Layout.fillWidth: true
            title: "7-Day Daily Active vs Online Trends"
            model: root.weeklyData && root.weeklyData.current ? root.weeklyData.current.activity_trend : []
        }

        // Top Apps & Category Distribution
        RowLayout {
            Layout.fillWidth: true
            spacing: 16

            BarChart {
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                title: "Top Applications This Week"
                model: root.weeklyData && root.weeklyData.current ? root.weeklyData.current.top_apps : []
            }

            DonutChart {
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                title: "Category Breakdown This Week"
                model: root.weeklyData && root.weeklyData.current ? root.weeklyData.current.category_distribution : []
                centerValue: root.weeklyData && root.weeklyData.current ? root.weeklyData.current.active_formatted : "0s"
            }
        }
    }

    Component.onCompleted: {
        root.reloadWeek();
    }
}
