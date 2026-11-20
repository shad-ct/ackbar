import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Item {
    id: compactRoot

    property var plasmoidItem: null
    property string promptId: ""

    // Icon-only, compact panel size
    Layout.fillHeight: true
    Layout.preferredWidth: 26
    implicitWidth: 26
    implicitHeight: Kirigami.Units.gridUnit * 1.6

    Kirigami.Icon {
        anchors.centerIn: parent
        source: "accessories-text-editor"
        Layout.preferredWidth: 15
        Layout.preferredHeight: 15
        color: mouseArea.containsMouse ? Kirigami.Theme.highlightColor : Kirigami.Theme.textColor
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        property bool wasExpanded: false

        onPressed: {
            var item = compactRoot.plasmoidItem || (typeof plasmoidRoot !== "undefined" ? plasmoidRoot : null);
            wasExpanded = item ? item.expanded : false;
        }

        onClicked: {
            var item = compactRoot.plasmoidItem || (typeof plasmoidRoot !== "undefined" ? plasmoidRoot : null);
            if (item) {
                item.expanded = !wasExpanded;
            }
        }
    }
}
