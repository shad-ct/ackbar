import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2

Rectangle {
    id: root

    property string startDate: ""
    property string endDate: ""
    property string activePreset: "today"
    property var earliestDate: "2026-10-05"
    property var latestDate: "2026-11-14"

    signal rangeChanged(string start, string end, string preset)

    implicitHeight: 46
    Layout.fillWidth: true
    radius: 10
    color: "#1e1e26"
    border.color: "#323242"
    border.width: 1

    function computePresetDates(preset) {
        var now = new Date();
        var y = now.getFullYear();
        var m = now.getMonth();
        var d = now.getDate();

        function fmt(dt) {
            var year = dt.getFullYear();
            var mon = String(dt.getMonth() + 1).padStart(2, '0');
            var day = String(dt.getDate()).padStart(2, '0');
            return year + "-" + mon + "-" + day;
        }

        var s, e;
        e = fmt(now);

        if (preset === "today") {
            s = e;
        } else if (preset === "yesterday") {
            var yday = new Date(y, m, d - 1);
            s = fmt(yday);
            e = s;
        } else if (preset === "7days") {
            var d7 = new Date(y, m, d - 6);
            s = fmt(d7);
        } else if (preset === "30days") {
            var d30 = new Date(y, m, d - 29);
            s = fmt(d30);
        } else if (preset === "this_month") {
            s = fmt(new Date(y, m, 1));
        } else if (preset === "prev_month") {
            s = fmt(new Date(y, m - 1, 1));
            e = fmt(new Date(y, m, 0));
        } else if (preset === "90days") {
            var d90 = new Date(y, m, d - 89);
            s = fmt(d90);
        } else if (preset === "this_year") {
            s = fmt(new Date(y, 0, 1));
        } else if (preset === "all_time") {
            s = root.earliestDate || "2026-10-05";
            e = root.latestDate || fmt(now);
        } else {
            s = root.startDate;
            e = root.endDate;
        }

        root.startDate = s;
        root.endDate = e;
        root.activePreset = preset;
        root.rangeChanged(s, e, preset);
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 8

        Text {
            text: "📅"
            font.pixelSize: 14
        }

        // Horizontal scrollable presets
        Flickable {
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentWidth: presetRow.implicitWidth
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            RowLayout {
                id: presetRow
                anchors.verticalCenter: parent.verticalCenter
                spacing: 6

                Repeater {
                    model: [
                        { id: "today", label: "Today" },
                        { id: "yesterday", label: "Yesterday" },
                        { id: "7days", label: "Last 7 Days" },
                        { id: "30days", label: "Last 30 Days" },
                        { id: "this_month", label: "This Month" },
                        { id: "prev_month", label: "Prev Month" },
                        { id: "90days", label: "Last 90 Days" },
                        { id: "this_year", label: "This Year" },
                        { id: "all_time", label: "All Time" }
                    ]

                    delegate: Rectangle {
                        implicitHeight: 28
                        implicitWidth: btnLabel.implicitWidth + 18
                        radius: 14
                        color: root.activePreset === modelData.id
                               ? "#3498db"
                               : (pMouse.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : Qt.rgba(255, 255, 255, 0.03))
                        border.color: root.activePreset === modelData.id ? "#3498db" : Qt.rgba(255, 255, 255, 0.1)
                        border.width: 1

                        Text {
                            id: btnLabel
                            anchors.centerIn: parent
                            text: modelData.label
                            font.pixelSize: 11
                            font.weight: root.activePreset === modelData.id ? Font.DemiBold : Font.Normal
                            color: root.activePreset === modelData.id ? "#ffffff" : "#a4b0be"
                        }

                        MouseArea {
                            id: pMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.computePresetDates(modelData.id)
                        }
                    }
                }
            }
        }

        // Active date range indicator pill
        Rectangle {
            implicitHeight: 28
            implicitWidth: rangeText.implicitWidth + 20
            radius: 6
            color: Qt.rgba(52/255, 152/255, 219/255, 0.12)
            border.color: Qt.rgba(52/255, 152/255, 219/255, 0.3)
            border.width: 1

            Text {
                id: rangeText
                anchors.centerIn: parent
                text: root.startDate === root.endDate
                      ? root.startDate
                      : root.startDate + "  ➔  " + root.endDate
                font.pixelSize: 11
                font.family: "monospace"
                font.weight: Font.Medium
                color: "#74b9ff"
            }
        }
    }

    Component.onCompleted: {
        if (!root.startDate) {
            root.computePresetDates("today");
        }
    }
}

