import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import "../components"

Item {
    id: root

    property var bridge: null
    property string searchText: ""
    property string categoryFilter: "all"
    property string appFilter: ""
    property string sortBy: "start_time"
    property bool sortDesc: true
    property int currentPage: 1
    property int totalPages: 1
    property int totalRecords: 0
    property var recordsList: []
    property bool hideWindowTitles: false
    property string exportFeedback: ""

    function reloadRecords() {
        if (!bridge) return;
        try {
            var res = bridge.getHistoricalRecords(
                root.searchText,
                root.appFilter,
                root.categoryFilter,
                "", // start date
                "", // end date
                root.sortBy,
                root.sortDesc,
                root.currentPage,
                30 // page size
            );
            var parsed = JSON.parse(res);
            root.recordsList = parsed.records;
            root.currentPage = parsed.page;
            root.totalPages = parsed.total_pages;
            root.totalRecords = parsed.total_count;
        } catch (e) {
            root.recordsList = [];
        }
    }

    function doExport(fmt) {
        if (!bridge) return;
        var msg = bridge.exportData(fmt, "2026-10-05", "2026-11-14", "");
        root.exportFeedback = msg;
        fbTimer.restart();
    }

    Timer {
        id: fbTimer
        interval: 3500
        onTriggered: root.exportFeedback = ""
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 12

        // Header & Export Actions
        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Text {
                text: "HISTORICAL ACTIVITY EXPLORER (" + root.totalRecords.toLocaleString() + " Records)"
                font.pixelSize: 15
                font.weight: Font.Bold
                color: "#f5f6fa"
                Layout.fillWidth: true
            }

            Text {
                text: root.exportFeedback
                font.pixelSize: 11
                color: "#2ecc71"
                visible: root.exportFeedback !== ""
            }

            QQC2.Button {
                text: "Export CSV"
                onClicked: root.doExport("csv")
            }

            QQC2.Button {
                text: "Export JSON"
                onClicked: root.doExport("json")
            }

            QQC2.Button {
                text: "Export Markdown"
                onClicked: root.doExport("md")
            }
        }

        // Search & Filter & Privacy Bar
        SearchFilterBar {
            showPrivacyToggle: true
            hideWindowTitles: root.hideWindowTitles
            onSearchChanged: function(txt) {
                root.searchText = txt;
                root.currentPage = 1;
                root.reloadRecords();
            }
            onFilterChanged: function(cat) {
                root.categoryFilter = cat;
                root.currentPage = 1;
                root.reloadRecords();
            }
            onPrivacyToggled: function(hidden) {
                root.hideWindowTitles = hidden;
            }
        }

        // Records Table
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 10
            color: "#22222c"
            border.color: "#323242"
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                // Table Header Row
                Rectangle {
                    Layout.fillWidth: true
                    height: 36
                    color: "#1c1c24"
                    radius: 10

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 12
                        spacing: 10

                        Text { text: "Time"; font.pixelSize: 11; font.weight: Font.Bold; color: "#718093"; Layout.preferredWidth: 130 }
                        Text { text: "Application"; font.pixelSize: 11; font.weight: Font.Bold; color: "#718093"; Layout.preferredWidth: 140 }
                        Text { text: "Category"; font.pixelSize: 11; font.weight: Font.Bold; color: "#718093"; Layout.preferredWidth: 120 }
                        Text { text: "Duration"; font.pixelSize: 11; font.weight: Font.Bold; color: "#718093"; Layout.preferredWidth: 70 }
                        Text { text: "Window Caption / Title"; font.pixelSize: 11; font.weight: Font.Bold; color: "#718093"; Layout.fillWidth: true }
                    }
                }

                Rectangle { Layout.fillWidth: true; height: 1; color: "#323242" }

                // Table Rows
                ListView {
                    id: recListView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    model: root.recordsList

                    delegate: Rectangle {
                        width: recListView.width
                        height: 38
                        color: rMouse.containsMouse
                               ? Qt.rgba(255, 255, 255, 0.05)
                               : (index % 2 === 0 ? "transparent" : Qt.rgba(255, 255, 255, 0.015))

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12
                            spacing: 10

                            Text {
                                text: modelData.start_time
                                font.pixelSize: 11
                                font.family: "monospace"
                                color: "#a4b0be"
                                Layout.preferredWidth: 130
                            }

                            Text {
                                text: modelData.app_name
                                font.pixelSize: 11
                                font.weight: Font.DemiBold
                                color: "#f5f6fa"
                                elide: Text.ElideRight
                                Layout.preferredWidth: 140
                            }

                            RowLayout {
                                Layout.preferredWidth: 120
                                spacing: 4
                                Text { text: modelData.icon || "📌"; font.pixelSize: 11 }
                                Text {
                                    text: modelData.category_name
                                    font.pixelSize: 11
                                    color: modelData.color || "#3498db"
                                    elide: Text.ElideRight
                                }
                            }

                            Text {
                                text: modelData.duration_formatted
                                font.pixelSize: 11
                                font.weight: Font.Bold
                                color: "#2ecc71"
                                Layout.preferredWidth: 70
                            }

                            Text {
                                text: root.hideWindowTitles ? "••••••••••••••••••••••••••••••••••••" : modelData.window_title
                                font.pixelSize: 11
                                color: root.hideWindowTitles ? "#718093" : "#f5f6fa"
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                        }

                        MouseArea {
                            id: rMouse
                            anchors.fill: parent
                            hoverEnabled: true
                        }
                    }
                }
            }
        }

        // Pagination Bar
        Rectangle {
            Layout.fillWidth: true
            height: 42
            radius: 8
            color: "#1e1e26"
            border.color: "#323242"
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12

                QQC2.Button {
                    text: "◀ Previous Page"
                    enabled: root.currentPage > 1
                    onClicked: {
                        if (root.currentPage > 1) {
                            root.currentPage -= 1;
                            root.reloadRecords();
                        }
                    }
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: "Page " + root.currentPage + " of " + root.totalPages
                    font.pixelSize: 12
                    font.weight: Font.DemiBold
                    color: "#f5f6fa"
                }

                Item { Layout.fillWidth: true }

                QQC2.Button {
                    text: "Next Page ▶"
                    enabled: root.currentPage < root.totalPages
                    onClicked: {
                        if (root.currentPage < root.totalPages) {
                            root.currentPage += 1;
                            root.reloadRecords();
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        root.reloadRecords();
    }
}

