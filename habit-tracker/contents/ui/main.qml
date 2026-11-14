import QtQuick
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import "../js/habit-storage.js" as Storage
import "../js/streak-calculator.js" as StreakCalc

PlasmoidItem {
    id: plasmoidRoot

    property int doneCount: 0
    property int totalCount: 0

    Plasmoid.icon: "user-identity"
    Plasmoid.backgroundHints: PlasmaCore.Types.DefaultBackground

    preferredRepresentation: Plasmoid.formFactor === PlasmaCore.Types.Planar ? fullRepresentation : null

    compactRepresentation: CompactRepresentation {
        plasmoidItem: plasmoidRoot
        doneCount: plasmoidRoot.doneCount
        totalCount: plasmoidRoot.totalCount
    }

    fullRepresentation: FullRepresentation {
    }

    Component.onCompleted: {
        var list = Storage.loadHabits(plasmoid);
        var stats = StreakCalc.calculateGlobalStats(list);
        plasmoidRoot.doneCount = stats.todayDone;
        plasmoidRoot.totalCount = stats.todayTotal;
    }

    Connections {
        target: plasmoid.configuration
        function onHabitsDataChanged() {
            var list = Storage.loadHabits(plasmoid);
            var stats = StreakCalc.calculateGlobalStats(list);
            plasmoidRoot.doneCount = stats.todayDone;
            plasmoidRoot.totalCount = stats.todayTotal;
        }
    }
}
