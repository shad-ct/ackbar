import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as Plasma5Support

PlasmoidItem {
    id: plasmoidRoot

    Plasmoid.icon: "office-chart-line"
    Plasmoid.backgroundHints: PlasmaCore.Types.DefaultBackground

    preferredRepresentation: Plasmoid.formFactor === PlasmaCore.Types.Planar ? fullRepresentation : null

    property string activeFormatted: "0m"
    property string onlineFormatted: "0m"
    property int activeSeconds: 0
    property int onlineSeconds: 0
    property string currentApp: "Idle"
    property string currentDurationFormatted: "0s"
    property string topApp: "None"
    property string topAppDuration: "0s"
    property var sparklineData: []
    property bool isTrackerRunning: true

    property string queryCmd: "python3 " + Qt.resolvedUrl("../scripts/widget_data.py").toString().replace("file://", "")
    property string launchCmd: "bash " + Qt.resolvedUrl("../scripts/launch_dashboard.sh").toString().replace("file://", "")

    function refreshData() {
        var cmd = plasmoidRoot.queryCmd;
        execSource.disconnectSource(cmd);
        execSource.connectSource(cmd);
    }

    function openDashboard() {
        var cmd = plasmoidRoot.launchCmd + " " + Date.now();
        execSource.connectSource(cmd);
    }

    Plasma5Support.DataSource {
        id: execSource
        engine: "executable"
        connectedSources: []

        onNewData: function(sourceName, data) {
            disconnectSource(sourceName);
            if (sourceName === plasmoidRoot.queryCmd && data.stdout) {
                try {
                    var parsed = JSON.parse(data.stdout.trim());
                    plasmoidRoot.activeFormatted = parsed.active_formatted || "0m";
                    plasmoidRoot.onlineFormatted = parsed.online_formatted || "0m";
                    plasmoidRoot.activeSeconds = parsed.active_seconds || 0;
                    plasmoidRoot.onlineSeconds = parsed.online_seconds || 0;
                    plasmoidRoot.currentApp = parsed.current_app || "Idle";
                    plasmoidRoot.currentDurationFormatted = parsed.current_duration_formatted || "0s";
                    plasmoidRoot.topApp = parsed.top_app || "None";
                    plasmoidRoot.topAppDuration = parsed.top_app_duration || "0s";
                    plasmoidRoot.sparklineData = parsed.sparkline || [];
                    plasmoidRoot.isTrackerRunning = (parsed.is_running !== false);
                } catch (e) {
                    console.warn("[TimeTrackWidget] Parse error:", e);
                }
            }
        }
    }

    Timer {
        id: pollTimer
        interval: 5000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: plasmoidRoot.refreshData()
    }

    compactRepresentation: CompactRepresentation {
        plasmoidItem: plasmoidRoot
    }

    fullRepresentation: FullRepresentation {
        plasmoidItem: plasmoidRoot
    }
}
