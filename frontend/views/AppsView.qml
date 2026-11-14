import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import "../components"

Item {
    id: root

    property var bridge: null
    property var appsList: []
    property string searchFilter: ""
    property string categoryFilter: "all"
    property string sortBy: "duration"
    property var selectedAppDetail: null

    function reloadApps() {
        if (!bridge) return;
        try {
            var res = bridge.getApplicationsList(root.searchFilter, root.categoryFilter, root.sortBy, true);
            root.appsList = JSON.parse(res);
        } catch (e) {
            root.appsList = [];
        }
    }

    function loadAppDetail(appName) {
        if (!bridge) return;
        try {
            var res = bridge.getApplicationDetail(appName);
            root.selectedAppDetail = JSON.parse(res);
        } catch (e) {
            root.selectedAppDetail = null;
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 14

        // Header & Search Filter Bar
        RowLayout {
            Layout.fillWidth: true

            Text {
                text: "APPLICATION EXPLORER (" + root.appsList.length + " Apps)"
                font.pixelSize: 15
                font.weight: Font.Bold
                color: "#f5f6fa"
                Layout.fillWidth: true
            }
        }

        SearchFilterBar {
            showPrivacyToggle: false
            onSearchChanged: function(txt) {
                root.searchFilter = txt;
                root.reloadApps();
            }
            onFilterChanged: function(cat) {
                root.categoryFilter = cat;
                root.reloadApps();
            }
        }

        // Split Layout: App List + Detail Drawer
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 16

            // Apps List
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 12
                color: "#22222c"
                border.color: "#323242"
                border.width: 1

                ListView {
                    id: appListView
                    anchors.fill: parent
                    anchors.margins: 10
                    clip: true
                    spacing: 8
                    model: root.appsList

                    delegate: Rectangle {
                        width: appListView.width
                        height: 54
                        radius: 8
                        color: (root.selectedAppDetail && root.selectedAppDetail.app_name === modelData.app_name)
                               ? Qt.rgba(52/255, 152/255, 219/255, 0.2)
                               : (aMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.05) : Qt.rgba(255, 255, 255, 0.02))
                        border.color: (root.selectedAppDetail && root.selectedAppDetail.app_name === modelData.app_name)
                                      ? "#3498db"
                                      : "transparent"
                        border.width: 1

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12
                            spacing: 12

                            Text { text: modelData.icon || "📱"; font.pixelSize: 18 }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2

                                Text {
                                    text: modelData.app_name
                                    font.pixelSize: 13
                                    font.weight: Font.Bold
                                    color: "#f5f6fa"
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }

                                Text {
                                    text: modelData.category_name + " • " + modelData.session_count + " sessions • Avg: " + modelData.avg_session_formatted
                                    font.pixelSize: 10
                                    color: "#a4b0be"
                                }
                            }

                            ColumnLayout {
                                spacing: 2
                                Layout.alignment: Qt.AlignRight

                                Text {
                                    text: modelData.total_formatted
                                    font.pixelSize: 13
                                    font.weight: Font.Bold
                                    color: "#2ecc71"
                                    horizontalAlignment: Text.AlignRight
                                }

                                Text {
                                    text: modelData.active_percent + "% active"
                                    font.pixelSize: 10
                                    font.weight: Font.DemiBold
                                    color: modelData.color || "#3498db"
                                    horizontalAlignment: Text.AlignRight
                                }
                            }
                        }

                        MouseArea {
                            id: aMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.loadAppDetail(modelData.app_name)
                        }
                    }
                }
            }

            // Detail Drawer (Shows when an app is selected)
            Rectangle {
                Layout.preferredWidth: 380
                Layout.fillHeight: true
                radius: 12
                color: "#22222c"
                border.color: "#323242"
                border.width: 1
                visible: root.selectedAppDetail !== null

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 12

                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: root.selectedAppDetail ? root.selectedAppDetail.app_name : ""
                            font.pixelSize: 15
                            font.weight: Font.Bold
                            color: "#ffffff"
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                        Text {
                            text: "✕"
                            font.pixelSize: 14
                            color: "#a4b0be"
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.selectedAppDetail = null
                            }
                        }
                    }

                    Text {
                        text: "Associated Window Captions & Tasks"
                        font.pixelSize: 11
                        font.weight: Font.DemiBold
                        color: "#74b9ff"
                    }

                    ListView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        spacing: 6
                        model: root.selectedAppDetail ? root.selectedAppDetail.window_titles : []

                        delegate: Rectangle {
                            width: parent.width
                            height: 38
                            radius: 4
                            color: Qt.rgba(255, 255, 255, 0.03)

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 6
                                spacing: 2

                                Text {
                                    text: modelData.title
                                    font.pixelSize: 11
                                    color: "#f5f6fa"
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Text {
                                        text: modelData.sessions + " sessions"
                                        font.pixelSize: 9
                                        color: "#718093"
                                    }
                                    Item { Layout.fillWidth: true }
                                    Text {
                                        text: modelData.formatted
                                        font.pixelSize: 10
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
    }

    Component.onCompleted: {
        root.reloadApps();
    }
}

