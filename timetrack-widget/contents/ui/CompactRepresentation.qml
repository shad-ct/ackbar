import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid

Item {
    id: compactRoot

    property var plasmoidItem: typeof plasmoidRoot !== "undefined" ? plasmoidRoot : null

    property bool inPanel: plasmoidItem
                           ? (plasmoidItem.location === Plasmoid.TopEdge ||
                              plasmoidItem.location === Plasmoid.BottomEdge ||
                              plasmoidItem.location === Plasmoid.LeftEdge ||
                              plasmoidItem.location === Plasmoid.RightEdge)
                           : true

    property bool isVertical: plasmoidItem
                              ? (plasmoidItem.location === Plasmoid.LeftEdge ||
                                 plasmoidItem.location === Plasmoid.RightEdge)
                              : false

    Layout.minimumWidth: isVertical ? 24 : 85
    Layout.minimumHeight: 24
    Layout.preferredWidth: isVertical ? Kirigami.Units.gridUnit * 2 : 85
    Layout.preferredHeight: Kirigami.Units.gridUnit * 2

    RowLayout {
        anchors.fill: parent
        spacing: 5
        anchors.margins: 2

        Kirigami.Icon {
            source: "office-chart-line"
            Layout.preferredWidth: Kirigami.Units.iconSizes.small
            Layout.preferredHeight: Kirigami.Units.iconSizes.small
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            visible: !compactRoot.isVertical
            text: compactRoot.plasmoidItem ? compactRoot.plasmoidItem.activeFormatted : "0m"
            color: Kirigami.Theme.textColor
            font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 1, 9)
            font.weight: Font.Medium
            Layout.alignment: Qt.AlignVCenter
            elide: Text.ElideRight
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        property bool wasExpanded: false

        onPressed: {
            var item = compactRoot.plasmoidItem || (typeof plasmoidRoot !== "undefined" ? plasmoidRoot : null) || plasmoid;
            wasExpanded = item ? item.expanded : (typeof Plasmoid !== "undefined" ? Plasmoid.expanded : false);
        }

        onClicked: {
            var item = compactRoot.plasmoidItem || (typeof plasmoidRoot !== "undefined" ? plasmoidRoot : null) || plasmoid;
            if (item) {
                item.expanded = !wasExpanded;
            }
            if (typeof Plasmoid !== "undefined") {
                Plasmoid.expanded = !wasExpanded;
            }
        }
    }
}
