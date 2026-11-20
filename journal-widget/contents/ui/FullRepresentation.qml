import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasmoid
import "../js/journal-data.js" as Data
import "../js/journal-storage.js" as Storage

Item {
    id: root

    Layout.minimumWidth: Math.max(320, Kirigami.Units.gridUnit * 18)
    Layout.preferredWidth: Math.max(380, Kirigami.Units.gridUnit * 21)
    Layout.minimumHeight: Math.max(400, Kirigami.Units.gridUnit * 23)
    Layout.preferredHeight: Math.max(460, Kirigami.Units.gridUnit * 27)

    implicitWidth: Layout.preferredWidth
    implicitHeight: Layout.preferredHeight

    property var plasmoidItem: null
    property bool showingFavourites: false

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 12

        // Header
        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 8

            Kirigami.Icon {
                source: root.showingFavourites ? "bookmarks" : "accessories-text-editor"
                Layout.preferredWidth: 20
                Layout.preferredHeight: 20
                color: Kirigami.Theme.highlightColor
            }

            Kirigami.Heading {
                text: root.showingFavourites ? i18n("Favourite Prompts") : i18n("Journal Prompt")
                font.pointSize: Kirigami.Theme.defaultFont.pointSize + 1
                Layout.alignment: Qt.AlignVCenter
            }

            Item { Layout.fillWidth: true }

            PlasmaComponents.Button {
                icon.name: root.showingFavourites ? "view-refresh" : "view-refresh"
                text: root.showingFavourites ? i18n("Back") : i18n("New")
                flat: true
                Layout.preferredHeight: 28
                onClicked: {
                    if (root.showingFavourites) {
                        root.showingFavourites = false;
                    } else {
                        plasmoidItem.nextPrompt();
                    }
                }
            }
        }

        Kirigami.Separator {
            Layout.fillWidth: true
        }

        // Favourites list view
        PlasmaComponents.ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: root.showingFavourites
            clip: true

            ListView {
                id: favList
                width: parent.width
                spacing: 6
                model: favouritesModel
                delegate: Rectangle {
                    width: parent.width
                    implicitHeight: 52
                    radius: 8
                    color: ListView.isCurrentItem
                           ? Qt.rgba(Kirigami.Theme.highlightColor.r, Kirigami.Theme.highlightColor.g, Kirigami.Theme.highlightColor.b, 0.12)
                           : (mouseArea.containsMouse
                              ? Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.06)
                              : Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.04))
                    border.color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.10)
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 4

                        Text {
                            text: modelData.text
                            font.pointSize: Kirigami.Theme.defaultFont.pointSize
                            color: Kirigami.Theme.textColor
                            wrapMode: Text.WordWrap
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                            maximumLineCount: 2
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            Text {
                                text: modelData.category
                                font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 2, 8)
                                color: Kirigami.Theme.textColor
                                opacity: 0.7
                                Layout.alignment: Qt.AlignLeft
                            }
                            Item { Layout.fillWidth: true }
                            Text {
                                text: modelData.difficulty
                                font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 2, 8)
                                color: Kirigami.Theme.highlightColor
                                opacity: 0.8
                                Layout.alignment: Qt.AlignRight
                            }
                        }
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            plasmoidItem.currentPrompt = modelData;
                            plasmoidItem.promptText = modelData.text;
                            plasmoidItem.promptCategory = modelData.category;
                            plasmoidItem.promptDifficulty = modelData.difficulty;
                            plasmoidItem.promptId = modelData.id;
                            plasmoidItem.isFavourite = Storage.isFavorite(plasmoid, modelData.id);
                            root.showingFavourites = false;
                        }
                    }
                }
            }
        }

        // Single prompt view (default)
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: !root.showingFavourites

            ColumnLayout {
                anchors.fill: parent
                spacing: 12

                // Category & difficulty chips (neutral, no overlap)
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 6

                    Rectangle {
                        id: catChip
                        radius: 10
                        color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.08)
                        border.color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.14)
                        border.width: 1

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 6
                            spacing: 4

                            Text {
                                text: root.plasmoidItem.promptCategory
                                font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 2, 8)
                                font.weight: Font.DemiBold
                                color: Kirigami.Theme.textColor
                                Layout.alignment: Qt.AlignVCenter
                            }
                        }
                    }

                    Rectangle {
                        id: diffChip
                        radius: 10
                        color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.08)
                        border.color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.14)
                        border.width: 1

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 6
                            spacing: 4

                            Text {
                                text: root.plasmoidItem.promptDifficulty
                                font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 2, 8)
                                font.weight: Font.Medium
                                color: Kirigami.Theme.textColor
                                opacity: 0.85
                                Layout.alignment: Qt.AlignVCenter
                            }
                        }
                    }

                    Item { Layout.fillWidth: true }

                    PlasmaComponents.Button {
                        icon.name: root.plasmoidItem.isFavourite ? "starred" : "star"
                        text: root.plasmoidItem.isFavourite ? i18n("Favourited") : i18n("Favourite")
                        flat: true
                        Layout.preferredHeight: 28
                        onClicked: plasmoidItem.toggleFav()
                    }
                }

                // Prompt text — large and centred
                Text {
                    id: promptDisplay
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    text: root.plasmoidItem.promptText || i18n("No prompt yet.")
                    font.pointSize: Kirigami.Theme.defaultFont.pointSize + 4
                    font.weight: Font.Light
                    color: Kirigami.Theme.textColor
                    horizontalAlignment: Text.AlignHCenter
                    elide: Text.ElideNone
                }

                Item { Layout.fillHeight: true }

                // Action buttons
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    PlasmaComponents.Button {
                        text: i18n("Mark Done")
                        icon.name: "dialog-ok-apply"
                        highlighted: true
                        Layout.fillWidth: true
                        Layout.preferredHeight: 36
                        onClicked: plasmoidItem.toggleDone()
                    }

                    PlasmaComponents.Button {
                        text: i18n("Copy")
                        icon.name: "edit-copy"
                        flat: true
                        Layout.preferredHeight: 36
                        onClicked: {
                            var clipboard = Qt.application.clipboard;
                            clipboard.text = root.plasmoidItem.promptText;
                        }
                    }
                }
            }
        }
    }

    // Favourites model
    property var favouritesModel: []

    function refreshFavourites() {
        var all = Data.getInitialPrompts();
        var favIds = Storage.getFavourites(plasmoid);
        var model = [];
        for (var i = 0; i < favIds.length; i++) {
            var p = Storage.getPromptById(all, favIds[i]);
            if (p) model.push(p);
        }
        root.favouritesModel = model;
    }

    Connections {
        target: plasmoid.configuration
        function onFavouritePromptIdsChanged() {
            if (root.showingFavourites) root.refreshFavourites();
        }
    }

    Component.onCompleted: {
        if (typeof plasmoid !== "undefined" && plasmoid.configuration) {
            // nothing extra
        }
    }
}
