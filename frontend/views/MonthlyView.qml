import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import "../components"

Flickable {
    id: root

    property var bridge: null
    property int selectedYear: 2026
    property int selectedMonth: 11
    property var monthlyData: null

    signal openDay(string date)

    contentHeight: mainCol.implicitHeight + 40
    clip: true

    function reloadMonth() {
        if (!bridge) return;
        try {
            var res = bridge.getMonthlyAnalytics(root.selectedYear, root.selectedMonth);
            root.monthlyData = JSON.parse(res);
        } catch (e) {
            root.monthlyData = null;
        }
    }

    ColumnLayout {
        id: mainCol
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 20
        spacing: 16

        // Header & Month Navigator
        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Text {
                text: "MONTHLY ANALYTICS"
                font.pixelSize: 15
                font.weight: Font.Bold
                color: "#f5f6fa"
                Layout.fillWidth: true
            }

            QQC2.Button {
                text: "◀ Prev Month"
                onClicked: {
                    if (root.selectedMonth === 1) {
                        root.selectedYear -= 1;
                        root.selectedMonth = 12;
                    } else {
                        root.selectedMonth -= 1;
                    }
                    root.reloadMonth();
                }
            }

            Rectangle {
                implicitHeight: 32
                implicitWidth: 140
                radius: 6
                color: "#1e1e26"
                border.color: "#323242"
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: {
                        var names = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
                        return names[root.selectedMonth - 1] + " " + root.selectedYear;
                    }
                    font.pixelSize: 12
                    font.weight: Font.Bold
                    color: "#74b9ff"
                }
            }

            QQC2.Button {
                text: "Next Month ▶"
                onClicked: {
                    if (root.selectedMonth === 12) {
                        root.selectedYear += 1;
                        root.selectedMonth = 1;
                    } else {
                        root.selectedMonth += 1;
                    }
                    root.reloadMonth();
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
                title: "Month Active Time"
                icon: "⚡"
                value: root.monthlyData && root.monthlyData.current ? root.monthlyData.current.active_formatted : "0s"
                subtitle: (root.monthlyData ? (root.monthlyData.delta_percent > 0 ? "+" : "") + root.monthlyData.delta_percent + "% vs prior month" : "")
                accentColor: root.monthlyData && root.monthlyData.delta_percent >= 0 ? "#2ecc71" : "#e74c3c"
            }

            MetricCard {
                title: "Daily Average"
                icon: "📊"
                value: root.monthlyData && root.monthlyData.current ? root.monthlyData.current.daily_avg_active_formatted : "0s"
                subtitle: "Active time per recorded day"
                accentColor: "#3498db"
            }

            MetricCard {
                title: "Total Online Time"
                icon: "⏳"
                value: root.monthlyData && root.monthlyData.current ? root.monthlyData.current.online_formatted : "0s"
                subtitle: "Monthly recorded uptime"
                accentColor: "#f39c12"
            }
        }

        // Monthly Contribution Heatmap
        CalendarHeatmap {
            Layout.fillWidth: true
            title: "Daily Activity Calendar Heatmap (Click to view day)"
            model: root.monthlyData ? root.monthlyData.calendar_cells : []
            onDayClicked: function(d) {
                root.openDay(d);
            }
        }

        // Charts: Top Apps & Categories
        RowLayout {
            Layout.fillWidth: true
            spacing: 16

            BarChart {
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                title: "Most Used Applications in Month"
                model: root.monthlyData && root.monthlyData.current ? root.monthlyData.current.top_apps : []
            }

            DonutChart {
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                title: "Category Breakdown in Month"
                model: root.monthlyData && root.monthlyData.current ? root.monthlyData.current.category_distribution : []
                centerValue: root.monthlyData && root.monthlyData.current ? root.monthlyData.current.active_formatted : "0s"
            }
        }
    }

    Component.onCompleted: {
        root.reloadMonth();
    }
}
