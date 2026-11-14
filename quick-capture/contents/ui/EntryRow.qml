import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import "shared" as Shared
import "../js/capture-storage.js" as Storage
import "../js/shared/DateUtils.js" as DateUtils

Shared.CardContainer {
    id: root

    property var entryData: null
    property bool isEditing: false

    signal toggledProcessed(string id)
    signal toggledPin(string id)
    signal deleted(string id)
    signal updated(string id, string newText, string newCategory)
    signal copied(string text)

    interactive: false
    contentPadding: 10
    contentSpacing: 6

    TextEdit {
        id: clipboardHelper
        visible: false
    }

    function doCopy() {
        if (!root.entryData) return;
        clipboardHelper.text = root.entryData.text;
        clipboardHelper.selectAll();
        clipboardHelper.copy();
        root.copied(root.entryData.text);
    }

    // Top metadata row
    RowLayout {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignVCenter
        spacing: 6

        Shared.MetricBadge {
            text: root.entryData ? root.entryData.category : ""
            iconName: root.entryData && Storage.CATEGORY_ICONS[root.entryData.category] ? Storage.CATEGORY_ICONS[root.entryData.category] : "document-edit"
            badgeColor: root.entryData && Storage.CATEGORY_COLORS[root.entryData.category] ? Storage.CATEGORY_COLORS[root.entryData.category] : Kirigami.Theme.highlightColor
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            text: root.entryData ? DateUtils.relativeTime(root.entryData.createdAt) : ""
            font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 3, 8)
            color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.55)
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            elide: Text.ElideRight
        }

        // Pin indicator
        Kirigami.Icon {
            visible: root.entryData && root.entryData.pinned && !root.isEditing
            source: "bookmark-new"
            Layout.preferredWidth: 14
            Layout.preferredHeight: 14
            Layout.alignment: Qt.AlignVCenter
            color: "#f39c12"
        }

        // Action buttons
        PlasmaComponents.Button {
            id: pinBtn
            icon.name: root.entryData && root.entryData.pinned ? "bookmark-remove" : "bookmark-new"
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
            Layout.alignment: Qt.AlignVCenter
            flat: true
            QQC2.ToolTip.text: root.entryData && root.entryData.pinned ? i18n("Unpin") : i18n("Pin to top")
            QQC2.ToolTip.visible: pinBtn.hovered
            onClicked: root.toggledPin(root.entryData.id)
        }

        PlasmaComponents.Button {
            id: processBtn
            icon.name: root.entryData && root.entryData.processed ? "edit-undo" : "task-complete"
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
            Layout.alignment: Qt.AlignVCenter
            flat: true
            QQC2.ToolTip.text: root.entryData && root.entryData.processed ? i18n("Mark as active") : i18n("Mark as processed")
            QQC2.ToolTip.visible: processBtn.hovered
            onClicked: root.toggledProcessed(root.entryData.id)
        }

        PlasmaComponents.Button {
            id: copyBtn
            icon.name: "edit-copy"
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
            Layout.alignment: Qt.AlignVCenter
            flat: true
            QQC2.ToolTip.text: i18n("Copy to clipboard")
            QQC2.ToolTip.visible: copyBtn.hovered
            onClicked: root.doCopy()
        }

        PlasmaComponents.Button {
            id: editBtn
            icon.name: root.isEditing ? "dialog-ok" : "edit-entry"
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
            Layout.alignment: Qt.AlignVCenter
            flat: true
            QQC2.ToolTip.text: root.isEditing ? i18n("Done editing") : i18n("Edit entry")
            QQC2.ToolTip.visible: editBtn.hovered
            onClicked: {
                if (root.isEditing) {
                    root.updated(root.entryData.id, editArea.text, root.entryData.category);
                    root.isEditing = false;
                } else {
                    editArea.text = root.entryData.text;
                    root.isEditing = true;
                    editArea.forceActiveFocus();
                }
            }
        }

        PlasmaComponents.Button {
            id: deleteBtn
            icon.name: "edit-delete"
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
            Layout.alignment: Qt.AlignVCenter
            flat: true
            QQC2.ToolTip.text: i18n("Delete entry")
            QQC2.ToolTip.visible: deleteBtn.hovered
            onClicked: root.deleted(root.entryData.id)
        }
    }

    // Text content display
    Text {
        id: displayLabel
        visible: !root.isEditing
        Layout.fillWidth: true
        text: root.entryData ? root.entryData.text : ""
        wrapMode: Text.WordWrap
        font.pointSize: Kirigami.Theme.defaultFont.pointSize
        font.strikeout: root.entryData ? root.entryData.processed : false
        color: root.entryData && root.entryData.processed
               ? Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.5)
               : Kirigami.Theme.textColor
        lineHeight: 1.25
    }

    // Inline edit area
    PlasmaComponents.TextArea {
        id: editArea
        visible: root.isEditing
        Layout.fillWidth: true
        wrapMode: TextEdit.WordWrap
        text: root.entryData ? root.entryData.text : ""
        font.pointSize: Kirigami.Theme.defaultFont.pointSize
        selectByMouse: true
    }
}
