import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasmoid
import "shared" as Shared
import "../js/capture-storage.js" as Storage

Item {
    id: root

    Layout.minimumWidth: Math.max(340, Kirigami.Units.gridUnit * 20)
    Layout.preferredWidth: Math.max(360, Kirigami.Units.gridUnit * 22)
    Layout.minimumHeight: Math.max(460, Kirigami.Units.gridUnit * 26)
    Layout.preferredHeight: Math.max(500, Kirigami.Units.gridUnit * 29)

    implicitWidth: Layout.preferredWidth
    implicitHeight: Layout.preferredHeight
    property string activeSearch: ""
    property string activeFilter: "all" // all | active | processed | pinned
    property string activeCategoryFilter: "All"
    property string selectedNewCategory: typeof plasmoid !== "undefined" && plasmoid.configuration && plasmoid.configuration.defaultCategory ? plasmoid.configuration.defaultCategory : "Idea"
    property string statusMessage: ""
    property var entriesList: []

    function reloadData() {
        if (typeof plasmoid === "undefined") return;
        var raw = Storage.loadEntries(plasmoid);
        root.entriesList = Storage.filterEntries(
            raw,
            root.activeSearch,
            root.activeFilter,
            root.activeCategoryFilter,
            plasmoid.configuration.maxDisplayCount || 30
        );
        if (root.parent && root.parent.unprocessedCount !== undefined) {
            root.parent.unprocessedCount = Storage.countUnprocessed(plasmoid);
        }
    }

    function doSave() {
        if (typeof plasmoid === "undefined") return;
        var txt = inputField.text.trim();
        if (!txt) return;

        Storage.addEntry(plasmoid, txt, root.selectedNewCategory);
        inputField.text = "";
        plasmoid.configuration.draftText = "";
        root.reloadData();
        root.showFeedback(i18n("Saved!"));
        inputField.forceActiveFocus();
    }

    function showFeedback(msg) {
        root.statusMessage = msg;
        feedbackTimer.restart();
    }

    Timer {
        id: feedbackTimer
        interval: 2200
        repeat: false
        onTriggered: root.statusMessage = ""
    }

    Component.onCompleted: {
        if (typeof plasmoid !== "undefined" && plasmoid.configuration) {
            if (plasmoid.configuration.draftText) {
                inputField.text = plasmoid.configuration.draftText;
            }
        }
        root.reloadData();
        inputField.forceActiveFocus();
    }

    Connections {
        target: typeof plasmoid !== "undefined" ? plasmoid.configuration : null
        function onEntriesDataChanged() {
            root.reloadData();
        }
        function onMaxDisplayCountChanged() {
            root.reloadData();
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        // Top Navigation / Header Bar
        Shared.HeaderBar {
            title: i18n("Quick Capture")
            subtitle: i18n("Fast brain dump for your thoughts")
            iconName: "document-edit"
            Layout.fillWidth: true

            Shared.MetricBadge {
                text: root.statusMessage !== "" ? root.statusMessage : i18n("%1 pending", root.parent && root.parent.unprocessedCount !== undefined ? root.parent.unprocessedCount : 0)
                badgeColor: root.statusMessage !== "" ? "#27ae60" : Kirigami.Theme.highlightColor
                subtle: root.statusMessage === ""
            }

            PlasmaComponents.Button {
                text: i18n("Clear All")
                icon.name: "edit-clear-all"
                visible: root.entriesList.length > 0
                flat: true
                Layout.preferredHeight: 28
                onClicked: {
                    Storage.clearAllEntries(plasmoid);
                    root.reloadData();
                    root.showFeedback(i18n("All cleared"));
                }
            }

            PlasmaComponents.Button {
                text: i18n("+ Note")
                icon.name: "list-add"
                highlighted: true
                Layout.preferredHeight: 28
                onClicked: inputField.forceActiveFocus()
            }
        }

        // Capture Input Section
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: captureBox.implicitHeight + 16
            radius: 8
            color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.04)
            border.color: inputField.activeFocus
                          ? Kirigami.Theme.highlightColor
                          : Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.12)
            border.width: 1

            ColumnLayout {
                id: captureBox
                anchors.fill: parent
                anchors.margins: 8
                spacing: 8

                PlasmaComponents.TextArea {
                    id: inputField
                    Layout.fillWidth: true
                    Layout.minimumHeight: 64
                    placeholderText: i18n("What's on your mind? (Enter to save, Shift+Enter for newline)")
                    wrapMode: TextEdit.WordWrap
                    font.pointSize: Kirigami.Theme.defaultFont.pointSize
                    selectByMouse: true
                    background: Item {}

                    onTextChanged: {
                        if (typeof plasmoid !== "undefined" && plasmoid.configuration) {
                            plasmoid.configuration.draftText = text;
                        }
                    }

                    Keys.onReturnPressed: function(event) {
                        var quickEnter = typeof plasmoid !== "undefined" && plasmoid.configuration ? plasmoid.configuration.quickSaveWithEnter : true;
                        if (quickEnter && !(event.modifiers & Qt.ShiftModifier)) {
                            event.accepted = true;
                            root.doSave();
                        } else {
                            event.accepted = false;
                        }
                    }
                }

                // Category selection chips & Save button row
                RowLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 6

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                        spacing: 4

                        Repeater {
                            model: Storage.CATEGORIES
                            delegate: Rectangle {
                                id: chip
                                property bool isSelected: modelData === root.selectedNewCategory
                                implicitWidth: chipText.implicitWidth + 14
                                implicitHeight: 22
                                radius: 11
                                color: isSelected
                                       ? Storage.CATEGORY_COLORS[modelData]
                                       : (chipMouse.containsMouse
                                          ? Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.12)
                                          : Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.05))

                                border.color: isSelected ? "transparent" : Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.15)
                                border.width: 1

                                Text {
                                    id: chipText
                                    anchors.centerIn: parent
                                    text: modelData
                                    color: chip.isSelected ? "#ffffff" : Kirigami.Theme.textColor
                                    font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 3, 8)
                                    font.weight: chip.isSelected ? Font.DemiBold : Font.Normal
                                }

                                MouseArea {
                                    id: chipMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.selectedNewCategory = modelData
                                }
                            }
                        }
                    }

                    PlasmaComponents.Button {
                        text: i18n("Save")
                        icon.name: "document-save"
                        highlighted: true
                        Layout.alignment: Qt.AlignVCenter
                        enabled: inputField.text.trim().length > 0
                        onClicked: root.doSave()
                    }
                }
            }
        }

        // Search and Filter Header
        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 6

            Shared.SearchInput {
                id: searchInput
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                placeholderText: i18n("Search notes...")
                onTextChanged: {
                    root.activeSearch = text;
                    root.reloadData();
                }
                onCleared: {
                    root.activeSearch = "";
                    root.reloadData();
                }
            }

            // Quick Status Filter
            RowLayout {
                Layout.alignment: Qt.AlignVCenter
                spacing: 2
                Repeater {
                    model: [
                        { label: i18n("All"), value: "all" },
                        { label: i18n("Active"), value: "active" },
                        { label: i18n("Done"), value: "processed" },
                        { label: i18n("Pinned"), value: "pinned" }
                    ]
                    delegate: PlasmaComponents.Button {
                        text: modelData.label
                        flat: root.activeFilter !== modelData.value
                        Layout.preferredHeight: 28
                        Layout.alignment: Qt.AlignVCenter
                        font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 2, 8)
                        onClicked: {
                            root.activeFilter = modelData.value;
                            root.reloadData();
                        }
                    }
                }
            }
        }

        // Entries List
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Shared.EmptyState {
                visible: root.entriesList.length === 0
                anchors.centerIn: parent
                title: root.activeSearch.length > 0 ? i18n("No matching entries") : i18n("No captures yet")
                description: root.activeSearch.length > 0
                             ? i18n("Try a different search query.")
                             : i18n("Type above and press Enter to save your first idea!")
                iconName: "document-edit"
            }

            PlasmaComponents.ScrollView {
                anchors.fill: parent
                visible: root.entriesList.length > 0
                clip: true

                ListView {
                    id: listView
                    width: parent.width
                    spacing: 6
                    model: root.entriesList

                    delegate: EntryRow {
                        width: listView.width
                        height: implicitHeight
                        entryData: modelData

                        onToggledProcessed: function(id) {
                            Storage.toggleProcessed(plasmoid, id);
                            root.reloadData();
                        }

                        onToggledPin: function(id) {
                            Storage.togglePin(plasmoid, id);
                            root.reloadData();
                        }

                        onDeleted: function(id) {
                            Storage.deleteEntry(plasmoid, id);
                            root.reloadData();
                            root.showFeedback(i18n("Deleted"));
                        }

                        onUpdated: function(id, newText, newCat) {
                            Storage.updateEntry(plasmoid, id, newText, newCat);
                            root.reloadData();
                            root.showFeedback(i18n("Updated"));
                        }

                        onCopied: function(txt) {
                            root.showFeedback(i18n("Copied to clipboard!"));
                        }
                    }
                }
            }
        }
    }
}
