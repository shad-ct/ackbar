import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import "../components"

Flickable {
    id: root

    property var overviewData: null
    property string startDate: ""
    property string endDate: ""

    contentHeight: mainCol.implicitHeight + 40
    clip: true

    ColumnLayout {
        id: mainCol
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 20
        spacing: 16

        // Primary Metrics Grid
        GridLayout {
            Layout.fillWidth: true
            columns: 3
            rowSpacing: 12
            columnSpacing: 12

            MetricCard {
                title: "Active Focus Time"
                icon: "⚡"
                value: root.overviewData ? root.overviewData.active_formatted : "0s"
                subtitle: (root.overviewData ? root.overviewData.active_percent : 0) + "% of total online time"
                accentColor: "#2ecc71"
                badgeText: "Primary"
            }

            MetricCard {
                title: "Locked / Away Time"
                icon: "🔒"
                value: root.overviewData ? root.overviewData.locked_formatted : "0s"
                subtitle: (root.overviewData ? root.overviewData.locked_percent : 0) + "% of total online time"
                accentColor: "#f39c12"
            }

            MetricCard {
                title: "Total Online Time"
                icon: "⏳"
                value: root.overviewData ? root.overviewData.online_formatted : "0s"
                subtitle: "Tracked system uptime"
                accentColor: "#3498db"
            }

            MetricCard {
                title: "Applications Used"
                icon: "📱"
                value: root.overviewData ? root.overviewData.app_count.toString() : "0"
                subtitle: "Distinct desktop apps"
                accentColor: "#1abc9c"
            }

            MetricCard {
                title: "Active Sessions"
                icon: "🔄"
                value: root.overviewData ? root.overviewData.session_count.toLocaleString() : "0"
                subtitle: "Window switch events"
                accentColor: "#9b59b6"
            }

            MetricCard {
                title: "Longest Session"
                icon: "⏱️"
                value: root.overviewData && root.overviewData.longest_session ? root.overviewData.longest_session.formatted : "0s"
                subtitle: root.overviewData && root.overviewData.longest_session ? root.overviewData.longest_session.app_name : "None"
                accentColor: "#e74c3c"
            }
        }

        // Secondary Metrics Bar
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 70
            radius: 10
            color: "#1e1e26"
            border.color: "#323242"
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 16

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2
                    Text { text: "MOST USED APP"; font.pixelSize: 10; font.weight: Font.DemiBold; color: "#718093" }
                    Text {
                        text: (root.overviewData && root.overviewData.top_app ? root.overviewData.top_app.name : "None") + " (" + (root.overviewData && root.overviewData.top_app ? root.overviewData.top_app.formatted : "0s") + ")"
                        font.pixelSize: 12; font.weight: Font.Bold; color: "#f5f6fa"; elide: Text.ElideRight
                    }
                }

                Rectangle { width: 1; height: 35; color: "#323242" }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2
                    Text { text: "TOP CATEGORY"; font.pixelSize: 10; font.weight: Font.DemiBold; color: "#718093" }
                    Text {
                        text: (root.overviewData && root.overviewData.top_category ? root.overviewData.top_category.icon + " " + root.overviewData.top_category.name : "None") + " (" + (root.overviewData && root.overviewData.top_category ? root.overviewData.top_category.formatted : "0s") + ")"
                        font.pixelSize: 12; font.weight: Font.Bold; color: "#3498db"; elide: Text.ElideRight
                    }
                }

                Rectangle { width: 1; height: 35; color: "#323242" }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2
                    Text { text: "DAILY AVERAGE"; font.pixelSize: 10; font.weight: Font.DemiBold; color: "#718093" }
                    Text {
                        text: root.overviewData ? root.overviewData.daily_avg_active_formatted : "0s"
                        font.pixelSize: 12; font.weight: Font.Bold; color: "#2ecc71"
                    }
                }

                Rectangle { width: 1; height: 35; color: "#323242" }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2
                    Text { text: "HIGHEST DAY"; font.pixelSize: 10; font.weight: Font.DemiBold; color: "#718093" }
                    Text {
                        text: (root.overviewData && root.overviewData.highest_day ? root.overviewData.highest_day.date : "None") + " (" + (root.overviewData && root.overviewData.highest_day ? root.overviewData.highest_day.formatted : "0s") + ")"
                        font.pixelSize: 12; font.weight: Font.Bold; color: "#f5f6fa"
                    }
                }
            }
        }

        // Charts Row 1: Donut + Top Apps
        RowLayout {
            Layout.fillWidth: true
            spacing: 16

            DonutChart {
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                model: root.overviewData ? root.overviewData.category_distribution : []
                centerValue: root.overviewData ? root.overviewData.active_formatted : "0s"
            }

            BarChart {
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                model: root.overviewData ? root.overviewData.top_apps : []
            }
        }

        // Charts Row 2: Trend Area Chart
        TrendAreaChart {
            Layout.fillWidth: true
            model: root.overviewData ? root.overviewData.activity_trend : []
        }
    }
}

