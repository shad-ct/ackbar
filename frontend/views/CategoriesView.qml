import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import "../components"

Flickable {
    id: root

    property var bridge: null
    property var categoriesList: []

    contentHeight: mainCol.implicitHeight + 40
    clip: true

    function reloadCategories() {
        if (!bridge) return;
        try {
            var res = bridge.getCategoriesList();
            root.categoriesList = JSON.parse(res);
        } catch (e) {
            root.categoriesList = [];
        }
    }

    ColumnLayout {
        id: mainCol
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 20
        spacing: 16

        Text {
            text: "CATEGORY EXPLORER"
            font.pixelSize: 15
            font.weight: Font.Bold
            color: "#f5f6fa"
        }

        // Category Cards Grid
        GridLayout {
            Layout.fillWidth: true
            columns: 2
            rowSpacing: 14
            columnSpacing: 14

            Repeater {
                model: root.categoriesList

                delegate: Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 160
                    radius: 12
                    color: "#22222c"
                    border.color: "#323242"
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 14
                        spacing: 8

                        // Category Title Bar
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            Text { text: modelData.icon || "📌"; font.pixelSize: 20 }

                            Text {
                                text: modelData.name || modelData.category
                                font.pixelSize: 14
                                font.weight: Font.Bold
                                color: "#f5f6fa"
                                Layout.fillWidth: true
                            }

                            Text {
                                text: modelData.total_formatted
                                font.pixelSize: 14
                                font.weight: Font.Bold
                                color: modelData.color || "#3498db"
                            }

                            Text {
                                text: "(" + modelData.active_percent + "%)"
                                font.pixelSize: 12
                                color: "#a4b0be"
                            }
                        }

                        // Progress Bar
                        Rectangle {
                            Layout.fillWidth: true
                            height: 6
                            radius: 3
                            color: Qt.rgba(255, 255, 255, 0.05)

                            Rectangle {
                                height: parent.height
                                radius: parent.radius
                                width: Math.max(4, parent.width * (modelData.active_percent / 100.0))
                                color: modelData.color || "#3498db"
                            }
                        }

                        // Meta details
                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                text: modelData.app_count + " apps • " + modelData.session_count + " sessions"
                                font.pixelSize: 10
                                color: "#718093"
                            }
                        }

                        // Top apps in this category
                        Text {
                            text: "Top Applications:"
                            font.pixelSize: 10
                            font.weight: Font.DemiBold
                            color: "#a4b0be"
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 6

                            Repeater {
                                model: modelData.top_apps

                                delegate: Rectangle {
                                    radius: 4
                                    color: Qt.rgba(255, 255, 255, 0.04)
                                    implicitHeight: 22
                                    implicitWidth: appItemText.implicitWidth + 12

                                    Text {
                                        id: appItemText
                                        anchors.centerIn: parent
                                        text: modelData.name + " (" + modelData.formatted + ")"
                                        font.pixelSize: 9
                                        color: "#f5f6fa"
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
        root.reloadCategories();
    }
}

