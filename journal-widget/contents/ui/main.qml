import QtQuick
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import "../js/journal-data.js" as Data
import "../js/journal-storage.js" as Storage

PlasmoidItem {
    id: plasmoidRoot

    Plasmoid.icon: "accessories-text-editor"
    Plasmoid.backgroundHints: PlasmaCore.Types.DefaultBackground

    preferredRepresentation: Plasmoid.formFactor === PlasmaCore.Types.Planar ? fullRepresentation : null

    property string promptText: i18n("Loading today's prompt…")
    property string promptCategory: ""
    property string promptDifficulty: ""
    property string promptId: ""
    property var currentPrompt: null
    property bool isFavourite: false

    compactRepresentation: CompactRepresentation {
        plasmoidItem: plasmoidRoot
    }

    fullRepresentation: FullRepresentation {
        plasmoidItem: plasmoidRoot
    }

    Component.onCompleted: {
        plasmoidRoot.refreshPrompt();
    }

    function refreshPrompt() {
        var all = Data.getInitialPrompts();
        var chosen = Storage.selectPrompt(plasmoid, all);
        if (chosen) {
            plasmoidRoot.currentPrompt = chosen;
            plasmoidRoot.promptText = chosen.text;
            plasmoidRoot.promptCategory = chosen.category;
            plasmoidRoot.promptDifficulty = chosen.difficulty;
            plasmoidRoot.promptId = chosen.id;
            plasmoidRoot.isFavourite = Storage.isFavorite(plasmoid, chosen.id);
        }
    }

    function nextPrompt() {
        // Force a new prompt by clearing the stored date/id so a fresh one is selected
        if (plasmoid && plasmoid.configuration) {
            plasmoid.configuration.lastPromptDate = "";
            plasmoid.configuration.lastPromptId = "";
            if (typeof plasmoid.configuration.writeConfig === "function") {
                plasmoid.configuration.writeConfig();
            }
        }
        plasmoidRoot.refreshPrompt();
    }

    function toggleDone() {
        if (!plasmoidRoot.promptId) return;
        Storage.markDone(plasmoid, plasmoidRoot.promptId);
        plasmoidRoot.nextPrompt();
    }

    function toggleFav() {
        if (!plasmoidRoot.promptId) return;
        plasmoidRoot.isFavourite = Storage.toggleFavorite(plasmoid, plasmoidRoot.promptId);
    }

    Connections {
        target: plasmoid.configuration
        function onLastPromptDateChanged() {
            plasmoidRoot.refreshPrompt();
        }
    }
}
