import QtQuick
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import "../js/challenge-engine.js" as Engine

PlasmoidItem {
    id: plasmoidRoot

    property int completedCount: 0

    Plasmoid.icon: "games-solve"
    Plasmoid.backgroundHints: PlasmaCore.Types.DefaultBackground

    preferredRepresentation: Plasmoid.formFactor === PlasmaCore.Types.Planar ? fullRepresentation : null

    compactRepresentation: CompactRepresentation {
        plasmoidItem: plasmoidRoot
        completedCount: plasmoidRoot.completedCount
    }

    fullRepresentation: FullRepresentation {
    }

    Component.onCompleted: {
        var stats = Engine.calculateStatistics(plasmoid);
        plasmoidRoot.completedCount = stats.totalCompleted;
    }

    Connections {
        target: plasmoid.configuration
        function onCompletedHistoryChanged() {
            var stats = Engine.calculateStatistics(plasmoid);
            plasmoidRoot.completedCount = stats.totalCompleted;
        }
    }
}
