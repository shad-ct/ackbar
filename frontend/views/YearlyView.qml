import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import "../components"

Flickable {
    id: root

    property var bridge: null
    property int selectedYear: 2026
    property var yearlyData: null

    contentHeight: mainCol.implicitHeight + 40
    clip: true

    function reloadYear() {
        if (!bridge) return;
        try {
            var res = bridge.getYearlyAnalytics(root.selectedYear);
            root.yearlyData = JSON.parse(res);
        } catch (e) {
            root.yearlyData = null;
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
                text: "YEARLY ANALYTICS"
                font.pixelSize: 15
                font.weight: Font.Bold
                color: "#f5f6fa"
                Layout.fillWidth: true
            }

            QQC2.Button {
                text: "◀ " + (root.selectedYear - 1)
                onClicked: {
                    root.selectedYear -= 1;
                    root.reloadYear();
                }
            }

            Rectangle {
                implicitHeight: 32
                implicitWidth: 80
                radius: 6
                color: "#1e1e26"
                border.color: "#323242"
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: root.selectedYear.toString()
                    font.pixelSize: 14
                    font.weight: Font.Bold
                    color: "#74b9ff"
                }
            }

            QQC2.Button {
                text: (root.selectedYear + 1) + " ▶"
                onClicked: {
                    root.selectedYear += 1;
                    root.reloadYear();
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
                title: "Annual Active Time"
                icon: "⚡"
                value: root.yearlyData && root.yearlyData.overview ? root.yearlyData.overview.active_formatted : "0s"
                subtitle: "Total tracked focus time"
                accentColor: "#2ecc71"
            }

            MetricCard {
                title: "Most Active Month"
                icon: "🏆"
                value: root.yearlyData && root.yearlyData.most_active_month ? (root.yearlyData.most_active_month.month_name + " (" + root.yearlyData.most_active_month.active_hours + "h)") : "None"
                subtitle: "Peak computer usage"
                accentColor: "#f39c12"
            }

            MetricCard {
                title: "Annual Online Time"
                icon: "⏳"
                value: root.yearlyData && root.yearlyData.overview ? root.yearlyData.overview.online_formatted : "0s"
                subtitle: "Uptime across " + root.selectedYear
                accentColor: "#3498db"
            }
        }

        // 12-Month Bar Chart
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 200
            radius: 12
            color: "#22222c"
            border.color: "#323242"
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 8

                Text {
                    text: "Monthly Focus Time Trends (Hours)"
                    font.pixelSize: 13
                    font.weight: Font.DemiBold
                    color: "#f5f6fa"
                }

                Row {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 4

                    Repeater {
                        model: root.yearlyData ? root.yearlyData.monthly_series : []

                        delegate: Item {
                            width: (parent.width - 44) / 12
                            height: parent.height

                            Column {
                                anchors.fill: parent
                                anchors.bottomMargin: 16

                                Item { width: parent.width; height: parent.height - yBar.height }

                                Rectangle {
                                    id: yBar
                                    width: parent.width - 4
                                    height: Math.max(3, (modelData.active_hours / 120.0) * (parent.parent.height - 30))
                                    radius: 3
                                    color: ymMouse.containsMouse ? "#ffffff" : (modelData.has_data ? "#3498db" : "#282834")
                                    anchors.horizontalCenter: parent.horizontalCenter

                                    MouseArea {
                                        id: ymMouse
                                        anchors.fill: parent
                                        hoverEnabled: true
                                    }

                                    QQC2.ToolTip.visible: ymMouse.containsMouse
                                    QQC2.ToolTip.text: modelData.month_name + ": " + (modelData.has_data ? modelData.active_hours + "h active" : "No records")
                                }
                            }

                            Text {
                                text: modelData.month_name
                                font.pixelSize: 10
                                color: "#718093"
                                anchors.bottom: parent.bottom
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                }
            }
        }

        // Top Apps & Categories of the Year
        RowLayout {
            Layout.fillWidth: true
            spacing: 16

            BarChart {
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                title: "Top Applications of " + root.selectedYear
                model: root.yearlyData && root.yearlyData.overview ? root.yearlyData.overview.top_apps : []
            }

            DonutChart {
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                title: "Category Distribution in " + root.selectedYear
                model: root.yearlyData && root.yearlyData.overview ? root.yearlyData.overview.category_distribution : []
                centerValue: root.yearlyData && root.yearlyData.overview ? root.yearlyData.overview.active_formatted : "0s"
            }
        }
    }

    Component.onCompleted: {
        root.reloadYear();
    }
}

