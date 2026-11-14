import QtQuick
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import "../js/capture-storage.js" as Storage

PlasmoidItem {
    id: plasmoidRoot

    property int unprocessedCount: 0

    Plasmoid.icon: "document-edit"
    Plasmoid.backgroundHints: PlasmaCore.Types.DefaultBackground

    preferredRepresentation: Plasmoid.formFactor === PlasmaCore.Types.Planar ? fullRepresentation : null

    compactRepresentation: CompactRepresentation {
        plasmoidItem: plasmoidRoot
        unprocessedCount: plasmoidRoot.unprocessedCount
    }

    fullRepresentation: FullRepresentation {
    }

    Component.onCompleted: {
        plasmoidRoot.unprocessedCount = Storage.countUnprocessed(plasmoid);
    }

    Connections {
        target: plasmoid.configuration
        function onEntriesDataChanged() {
            plasmoidRoot.unprocessedCount = Storage.countUnprocessed(plasmoid);
        }
    }
}
