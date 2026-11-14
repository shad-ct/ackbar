import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import "shared" as Shared

Shared.CardContainer {
    id: root

    property var challenge: null
    property bool isFav: false
    property bool isDaily: false

    signal completeClicked()
    signal nextClicked()
    signal skipClicked()
    signal deleteClicked()
    signal favoriteToggled()

    interactive: false
    contentPadding: 12
    contentSpacing: 10

    // Header badge row
    RowLayout {
        Layout.fillWidth: true
        spacing: 6

        Shared.MetricBadge {
            visible: root.isDaily
            text: i18n("Today's Mission")
            iconName: "rating"
            badgeColor: "#e67e22"
            subtle: false
        }

        Shared.MetricBadge {
            text: root.challenge ? root.challenge.category : ""
            iconName: "help-contents"
            badgeColor: Kirigami.Theme.highlightColor
        }

        Shared.MetricBadge {
            text: root.challenge ? root.challenge.difficulty : ""
            badgeColor: {
                if (!root.challenge) return Kirigami.Theme.highlightColor;
                if (root.challenge.difficulty === "Beginner") return "#27ae60";
                if (root.challenge.difficulty === "Intermediate") return "#3498db";
                return "#9b59b6";
            }
        }

        Shared.MetricBadge {
            text: (root.challenge ? root.challenge.duration : 15) + "m"
            iconName: "preferences-system-time"
            badgeColor: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.7)
            subtle: true
        }

        Item { Layout.fillWidth: true }

        PlasmaComponents.Button {
            id: favBtn
            icon.name: root.isFav ? "favorite" : "rating"
            Layout.preferredWidth: 26
            Layout.preferredHeight: 26
            flat: true
            QQC2.ToolTip.text: root.isFav ? i18n("Remove from favorites") : i18n("Add to favorites")
            QQC2.ToolTip.visible: favBtn.hovered
            onClicked: root.favoriteToggled()
        }
    }

    // Title
    Text {
        text: root.challenge ? root.challenge.title : ""
        font.pointSize: Kirigami.Theme.defaultFont.pointSize + 2
        font.weight: Font.DemiBold
        color: Kirigami.Theme.textColor
        wrapMode: Text.WordWrap
        Layout.fillWidth: true
    }

    // Description
    Text {
        text: root.challenge ? root.challenge.description : ""
        font.pointSize: Kirigami.Theme.defaultFont.pointSize
        color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.85)
        wrapMode: Text.WordWrap
        lineHeight: 1.25
        Layout.fillWidth: true
    }

    // Buttons
    RowLayout {
        Layout.fillWidth: true
        spacing: 8

        PlasmaComponents.Button {
            text: i18n("Skip")
            icon.name: "media-seek-forward"
            flat: true
            onClicked: root.skipClicked()
        }

        PlasmaComponents.Button {
            text: i18n("Delete")
            icon.name: "edit-delete"
            flat: true
            onClicked: root.deleteClicked()
        }

        PlasmaComponents.Button {
            text: i18n("Another")
            icon.name: "view-refresh"
            onClicked: root.nextClicked()
        }

        Item { Layout.fillWidth: true }

        PlasmaComponents.Button {
            text: i18n("Mark Complete")
            icon.name: "task-complete"
            highlighted: true
            onClicked: root.completeClicked()
        }
    }
}

