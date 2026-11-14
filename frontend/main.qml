import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import "theme"
import "components"
import "views"

QQC2.ApplicationWindow {
    id: window
    visible: true
    width: 1260
    height: 840
    minimumWidth: 980
    minimumHeight: 650
    title: "TimeTrack Visual Analytics — KDE Plasma 6"
    color: "#181820"

    property string currentSection: "overview"
    property var liveStatus: null
    property var overviewData: null
    property string activeStartDate: "2026-11-14"
    property string activeEndDate: "2026-11-14"
    property string activePreset: "today"
    property var dateBounds: null

    function reloadAll() {
        if (typeof backend === "undefined" || !backend) return;
        try {
            var s = JSON.parse(backend.getLiveStatus());
            window.liveStatus = s;

            var b = JSON.parse(backend.getDateBounds());
            window.dateBounds = b;

            var ov = JSON.parse(backend.getOverview(window.activeStartDate, window.activeEndDate));
            window.overviewData = ov;
        } catch (e) {
            console.warn("Error refreshing analytics:", e);
        }
    }

    // Connect to bridge signals
    Connections {
        target: typeof backend !== "undefined" ? backend : null
        function onLiveStatusChanged(statusJson) {
            try {
                window.liveStatus = JSON.parse(statusJson);
            } catch (e) {}
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // ================= Sidebar =================
        Rectangle {
            Layout.preferredWidth: 230
            Layout.fillHeight: true
            color: "#14141a"
            border.color: "#282834"
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 6

                // App Brand
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10
                    Layout.bottomMargin: 10

                    Rectangle {
                        width: 34
                        height: 34
                        radius: 8
                        color: "#3498db"
                        Text {
                            anchors.centerIn: parent
                            text: "⏱️"
                            font.pixelSize: 18
                        }
                    }

                    ColumnLayout {
                        spacing: 1
                        Text {
                            text: "TIMETRACK"
                            font.pixelSize: 14
                            font.weight: Font.Bold
                            color: "#ffffff"
                            font.letterSpacing: 1.0
                        }
                        Text {
                            text: "Visual Analytics"
                            font.pixelSize: 10
                            color: "#3498db"
                            font.weight: Font.DemiBold
                        }
                    }
                }

                Rectangle { Layout.fillWidth: true; height: 1; color: "#282834"; Layout.bottomMargin: 8 }

                // Navigation Items
                SidebarItem {
                    label: "Overview"
                    icon: "📊"
                    selected: window.currentSection === "overview"
                    onClicked: window.currentSection = "overview"
                }

                SidebarItem {
                    label: "Timeline"
                    icon: "⏱️"
                    badgeText: "Centerpiece"
                    selected: window.currentSection === "timeline"
                    onClicked: window.currentSection = "timeline"
                }

                SidebarItem {
                    label: "Daily Analytics"
                    icon: "📅"
                    selected: window.currentSection === "daily"
                    onClicked: window.currentSection = "daily"
                }

                SidebarItem {
                    label: "Weekly Analytics"
                    icon: "📈"
                    selected: window.currentSection === "weekly"
                    onClicked: window.currentSection = "weekly"
                }

                SidebarItem {
                    label: "Monthly Analytics"
                    icon: "🗓️"
                    selected: window.currentSection === "monthly"
                    onClicked: window.currentSection = "monthly"
                }

                SidebarItem {
                    label: "Yearly Analytics"
                    icon: "📆"
                    selected: window.currentSection === "yearly"
                    onClicked: window.currentSection = "yearly"
                }

                SidebarItem {
                    label: "All-Time Analytics"
                    icon: "🌟"
                    selected: window.currentSection === "alltime"
                    onClicked: window.currentSection = "alltime"
                }

                Rectangle { Layout.fillWidth: true; height: 1; color: "#282834"; Layout.topMargin: 4; Layout.bottomMargin: 4 }

                SidebarItem {
                    label: "Applications"
                    icon: "📱"
                    selected: window.currentSection === "apps"
                    onClicked: window.currentSection = "apps"
                }

                SidebarItem {
                    label: "Categories"
                    icon: "📂"
                    selected: window.currentSection === "categories"
                    onClicked: window.currentSection = "categories"
                }

                SidebarItem {
                    label: "Historical Explorer"
                    icon: "🔍"
                    selected: window.currentSection === "historical"
                    onClicked: window.currentSection = "historical"
                }

                Item { Layout.fillHeight: true }

                // Live Service Pill in Sidebar Footer
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 68
                    radius: 8
                    color: "#1c1c24"
                    border.color: "#2d2d3a"
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 4

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 6

                            Rectangle {
                                width: 8
                                height: 8
                                radius: 4
                                color: (window.liveStatus && window.liveStatus.service_active) ? "#2ecc71" : "#e74c3c"
                            }

                            Text {
                                text: (window.liveStatus && window.liveStatus.service_active) ? "TRACKER ACTIVE" : "TRACKER INACTIVE"
                                font.pixelSize: 10
                                font.weight: Font.Bold
                                color: (window.liveStatus && window.liveStatus.service_active) ? "#2ecc71" : "#e74c3c"
                                Layout.fillWidth: true
                            }
                        }

                        Text {
                            text: (window.liveStatus ? window.liveStatus.current_app : "None") + " (" + (window.liveStatus ? window.liveStatus.current_duration_formatted : "0s") + ")"
                            font.pixelSize: 11
                            color: "#f5f6fa"
                            font.weight: Font.Medium
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                    }
                }
            }
        }

        // ================= Content Area =================
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            // Top Header Bar
            Rectangle {
                Layout.fillWidth: true
                height: 60
                color: "#1b1b24"
                border.color: "#282834"
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20
                    spacing: 14

                    // Date Range Picker (visible in Overview and applicable sections)
                    DateRangePicker {
                        id: rangePicker
                        Layout.fillWidth: true
                        earliestDate: window.dateBounds ? window.dateBounds.min_date : "2026-10-05"
                        latestDate: window.dateBounds ? window.dateBounds.max_date : "2026-11-14"
                        onRangeChanged: function(s, e, p) {
                            window.activeStartDate = s;
                            window.activeEndDate = e;
                            window.activePreset = p;
                            window.reloadAll();
                        }
                    }

                    QQC2.Button {
                        text: "↻ Refresh"
                        onClicked: window.reloadAll()
                    }
                }
            }

            // View Switcher Stack
            StackLayout {
                id: viewStack
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: {
                    var map = {
                        "overview": 0,
                        "timeline": 1,
                        "daily": 2,
                        "weekly": 3,
                        "monthly": 4,
                        "yearly": 5,
                        "alltime": 6,
                        "apps": 7,
                        "categories": 8,
                        "historical": 9
                    };
                    return map[window.currentSection] || 0;
                }

                OverviewView {
                    overviewData: window.overviewData
                    startDate: window.activeStartDate
                    endDate: window.activeEndDate
                }

                TimelineView {
                    bridge: typeof backend !== "undefined" ? backend : null
                    activeDate: window.activeEndDate
                }

                DailyView {
                    bridge: typeof backend !== "undefined" ? backend : null
                    targetDate: window.activeEndDate
                }

                WeeklyView {
                    bridge: typeof backend !== "undefined" ? backend : null
                    endDate: window.activeEndDate
                }

                MonthlyView {
                    bridge: typeof backend !== "undefined" ? backend : null
                    selectedYear: 2026
                    selectedMonth: 11
                    onOpenDay: function(d) {
                        window.activeStartDate = d;
                        window.activeEndDate = d;
                        window.currentSection = "daily";
                    }
                }

                YearlyView {
                    bridge: typeof backend !== "undefined" ? backend : null
                    selectedYear: 2026
                }

                AllTimeView {
                    bridge: typeof backend !== "undefined" ? backend : null
                }

                AppsView {
                    bridge: typeof backend !== "undefined" ? backend : null
                }

                CategoriesView {
                    bridge: typeof backend !== "undefined" ? backend : null
                }

                HistoricalView {
                    bridge: typeof backend !== "undefined" ? backend : null
                }
            }
        }
    }

    Component.onCompleted: {
        window.reloadAll();
    }
}

