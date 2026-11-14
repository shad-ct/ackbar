import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Item {
    id: compactRoot

    property var plasmoidItem: null
    property int doneCount: 0
    property int totalCount: 0

    Layout.fillHeight: true
    Layout.preferredWidth: pillRow.implicitWidth + 20
    implicitWidth: pillRow.implicitWidth + 20
    implicitHeight: Kirigami.Units.gridUnit * 2

    Rectangle {
        id: pillBg
        anchors.fill: parent
        anchors.topMargin: 3
        anchors.bottomMargin: 3
        anchors.leftMargin: 2
        anchors.rightMargin: 2
        radius: height / 2
        color: mouseArea.containsMouse
               ? Qt.rgba(Kirigami.Theme.highlightColor.r, Kirigami.Theme.highlightColor.g, Kirigami.Theme.highlightColor.b, 0.22)
               : (compactRoot.doneCount >= compactRoot.totalCount && compactRoot.totalCount > 0
                  ? Qt.rgba(0.15, 0.68, 0.38, 0.18)
                  : Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.08))
        border.color: mouseArea.containsMouse
                      ? Kirigami.Theme.highlightColor
                      : (compactRoot.doneCount >= compactRoot.totalCount && compactRoot.totalCount > 0
                         ? "#27ae60"
                         : Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.15))
        border.width: 1

        Behavior on color { ColorAnimation { duration: 150 } }

        RowLayout {
            id: pillRow
            anchors.centerIn: parent
            spacing: 6

            Kirigami.Icon {
                source: "user-identity"
                Layout.preferredWidth: 16
                Layout.preferredHeight: 16
                Layout.alignment: Qt.AlignVCenter
            }

            Text {
                text: compactRoot.totalCount > 0
                      ? compactRoot.doneCount + "/" + compactRoot.totalCount + " " + i18n("Habits")
                      : i18n("Habits")
                font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 2, 8)
                font.weight: Font.Medium
                color: compactRoot.doneCount >= compactRoot.totalCount && compactRoot.totalCount > 0 ? "#27ae60" : Kirigami.Theme.textColor
                Layout.alignment: Qt.AlignVCenter
                elide: Text.ElideRight
                Layout.maximumWidth: 150
            }
        }
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
