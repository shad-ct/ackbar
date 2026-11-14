import QtQuick
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import "../js/task-goal-storage.js" as Storage
import "../js/progress-calculator.js" as Calc

PlasmoidItem {
    id: plasmoidRoot

    property int pendingCount: 0

    Plasmoid.icon: "view-calendar-tasks"
    Plasmoid.backgroundHints: PlasmaCore.Types.DefaultBackground

    preferredRepresentation: Plasmoid.formFactor === PlasmaCore.Types.Planar ? fullRepresentation : null

    compactRepresentation: CompactRepresentation {
        plasmoidItem: plasmoidRoot
        pendingCount: plasmoidRoot.pendingCount
    }

    fullRepresentation: FullRepresentation {
    }

    Component.onCompleted: {
        var tasks = Storage.loadTasks(plasmoid);
        var goals = Storage.loadGoals(plasmoid);
        var metrics = Calc.computeDashboardMetrics(tasks, goals);
        plasmoidRoot.pendingCount = metrics.pendingCount;
    }

    Connections {
        target: plasmoid.configuration
        function onTasksDataChanged() {
            var tasks = Storage.loadTasks(plasmoid);
            var goals = Storage.loadGoals(plasmoid);
            var metrics = Calc.computeDashboardMetrics(tasks, goals);
            plasmoidRoot.pendingCount = metrics.pendingCount;
        }
    }
}
