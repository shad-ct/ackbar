import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import "shared" as Shared

Rectangle {
    id: root

    property bool isEditing: false
    property string editHabitId: ""
    property string selectedIcon: "user-identity"
    property string selectedColor: "#27ae60"
    property string selectedFrequency: "daily"

    signal saved(var habitData)
    signal cancelled()

    radius: 8
    color: Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, 0.96)
    border.color: Kirigami.Theme.highlightColor
    border.width: 1

    function openForNew() {
        isEditing = false;
        editHabitId = "";
        nameField.text = "";
        descField.text = "";
        selectedIcon = "user-identity";
        selectedColor = "#27ae60";
        selectedFrequency = "daily";
        visible = true;
        nameField.forceActiveFocus();
    }

    function openForEdit(habit) {
        if (!habit) return;
        isEditing = true;
        editHabitId = habit.id;
        nameField.text = habit.name || "";
        descField.text = habit.description || "";
        selectedIcon = habit.icon || "user-identity";
        selectedColor = habit.color || "#27ae60";
        selectedFrequency = habit.frequencyType || "daily";
        visible = true;
        nameField.forceActiveFocus();
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8

        Text {
            text: root.isEditing ? i18n("Edit Habit") : i18n("Create New Habit")
            font.pointSize: Kirigami.Theme.defaultFont.pointSize
            font.weight: Font.DemiBold
            color: Kirigami.Theme.textColor
        }

        PlasmaComponents.TextField {
            id: nameField
            Layout.fillWidth: true
            placeholderText: i18n("Habit name (e.g. Morning Jog)")
            font.pointSize: Kirigami.Theme.defaultFont.pointSize
        }

        PlasmaComponents.TextField {
            id: descField
            Layout.fillWidth: true
            placeholderText: i18n("Description (optional)")
            font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 1, 9)
        }

        // Frequency Selector
        RowLayout {
            Layout.fillWidth: true
            spacing: 6

            Text {
                text: i18n("Frequency:")
                font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 2, 8)
                color: Kirigami.Theme.textColor
            }

            Repeater {
                model: [
                    { label: i18n("Daily"), val: "daily" },
                    { label: i18n("Weekdays"), val: "weekdays" },
                    { label: i18n("3x / Week"), val: "weekly_target" }
                ]
                delegate: PlasmaComponents.Button {
                    text: modelData.label
                    flat: root.selectedFrequency !== modelData.val
                    Layout.preferredHeight: 24
                    font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 2, 8)
                    onClicked: root.selectedFrequency = modelData.val
                }
            }
        }

        // Color Presets
        RowLayout {
            Layout.fillWidth: true
            spacing: 6

            Text {
                text: i18n("Color:")
                font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 2, 8)
                color: Kirigami.Theme.textColor
            }

            Repeater {
                model: ["#27ae60", "#3498db", "#9b59b6", "#e67e22", "#1abc9c", "#e74c3c"]
                delegate: Rectangle {
                    width: 20
                    height: 20
                    radius: 10
                    color: modelData
                    border.color: root.selectedColor === modelData ? Kirigami.Theme.textColor : "transparent"
                    border.width: 2

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.selectedColor = modelData
                    }
                }
            }
        }

        // Buttons
        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignRight
            spacing: 8

            PlasmaComponents.Button {
                text: i18n("Cancel")
                onClicked: {
                    root.visible = false;
                    root.cancelled();
                }
            }

            PlasmaComponents.Button {
                text: i18n("Save")
                highlighted: true
                enabled: nameField.text.trim().length > 0
                onClicked: {
                    var data = {
                        id: root.editHabitId,
                        name: nameField.text.trim(),
                        description: descField.text.trim(),
                        icon: root.selectedIcon,
                        color: root.selectedColor,
                        frequencyType: root.selectedFrequency,
                        frequencyDays: root.selectedFrequency === "weekdays" ? [1, 2, 3, 4, 5] : [0, 1, 2, 3, 4, 5, 6],
                        weeklyTarget: root.selectedFrequency === "weekly_target" ? 3 : 7,
                        targetCount: 1
                    };
                    root.saved(data);
                    root.visible = false;
                }
            }
        }
    }
}

