import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2

Rectangle {
    id: root

    property string searchText: ""
    property string selectedCategory: "all"
    property string sortBy: "duration"
    property bool sortDesc: true
    property bool hideWindowTitles: false
    property bool showPrivacyToggle: false

    signal searchChanged(string text)
    signal filterChanged(string category)
    signal sortChanged(string sort, bool desc)
    signal privacyToggled(bool hidden)

    implicitHeight: 46
    Layout.fillWidth: true
    radius: 10
    color: "#1e1e26"
    border.color: "#323242"
    border.width: 1

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 10

        // Search Input
        Rectangle {
            Layout.preferredWidth: 260
            Layout.fillHeight: true
            Layout.topMargin: 6
            Layout.bottomMargin: 6
            radius: 6
            color: "#16161e"
            border.color: sInput.activeFocus ? "#3498db" : "#2d2d3c"
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 8
                anchors.rightMargin: 6
                spacing: 6

                Text { text: "🔍"; font.pixelSize: 12 }

                TextInput {
                    id: sInput
                    Layout.fillWidth: true
                    font.pixelSize: 12
                    color: "#f5f6fa"
                    selectByMouse: true
                    clip: true

                    Text {
                        anchors.fill: parent
                        text: "Search applications or titles..."
                        font.pixelSize: 12
                        color: "#718093"
                        visible: !sInput.text && !sInput.activeFocus
                    }

                    onTextChanged: {
                        root.searchText = text;
                        root.searchChanged(text);
                    }
                }

                Text {
                    text: "✕"
                    font.pixelSize: 11
                    color: "#a4b0be"
                    visible: sInput.text !== ""

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            sInput.text = "";
                        }
                    }
                }
            }
        }

        // Category Filter Combo
        QQC2.ComboBox {
            id: catCombo
            Layout.preferredWidth: 150
            Layout.fillHeight: true
            Layout.topMargin: 6
            Layout.bottomMargin: 6
            model: [
                { id: "all", label: "All Categories" },
                { id: "browsing", label: "🌐 Web Browsing" },
                { id: "media", label: "🎬 Media & Gaming" },
                { id: "development", label: "💻 Development" },
                { id: "communication", label: "💬 Communication" },
                { id: "system", label: "⚙️ System" },
                { id: "terminal", label: "📟 Terminal" },
                { id: "notes", label: "📝 Notes" },
                { id: "design", label: "🎨 Design" },
                { id: "other", label: "📌 Other" }
            ]
            textRole: "label"
            onActivated: function(index) {
                var item = model[index];
                root.selectedCategory = item.id;
                root.filterChanged(item.id);
            }
        }

        Item { Layout.fillWidth: true }

        // Privacy Toggle: Hide Window Titles
        RowLayout {
            visible: root.showPrivacyToggle
            spacing: 6

            Text {
                text: "🔒 Mask Titles"
                font.pixelSize: 11
                color: root.hideWindowTitles ? "#2ecc71" : "#a4b0be"
            }

            QQC2.Switch {
                checked: root.hideWindowTitles
                onToggled: {
                    root.hideWindowTitles = checked;
                    root.privacyToggled(checked);
                }
            }
        }
    }
}

