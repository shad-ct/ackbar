import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as Plasma5Support

PlasmoidItem {
    id: root

    preferredRepresentation: fullRepresentation

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

    property string queryCmd: "python3 " + Qt.resolvedUrl("../../backend/widget_data.py").toString().replace("file://", "")

    function refreshData() {
        execSource.connectSource(root.queryCmd);
    }

    function openDashboard() {
        var dashPath = Qt.resolvedUrl("../../timetrack-dashboard").toString().replace("file://", "");
        execSource.connectSource("setsid " + dashPath + " >/dev/null 2>&1 &");
    }

    Plasma5Support.DataSource {
        id: execSource
        engine: "executable"
        connectedSources: []

        onNewData: function(sourceName, data) {
            disconnectSource(sourceName);
            if (sourceName === root.queryCmd && data.stdout) {
                try {
                    var parsed = JSON.parse(data.stdout.trim());
                    root.activeFormatted = parsed.active_formatted || "0m";
                    root.onlineFormatted = parsed.online_formatted || "0m";
                    root.activeSeconds = parsed.active_seconds || 0;
                    root.onlineSeconds = parsed.online_seconds || 0;
                    root.currentApp = parsed.current_app || "Idle";
                    root.currentDurationFormatted = parsed.current_duration_formatted || "0s";
                    root.topApp = parsed.top_app || "None";
                    root.topAppDuration = parsed.top_app_duration || "0s";
                    root.sparklineData = parsed.sparkline || [];
                    root.isTrackerRunning = (parsed.current_app !== "Tracker Offline");
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
        onTriggered: root.refreshData()
    }

    compactRepresentation: CompactRepresentation {
        id: compactRep
        plasmoidItem: root
    }

    fullRepresentation: FullRepresentation {
        id: fullRep
        plasmoidItem: root
    }
}
