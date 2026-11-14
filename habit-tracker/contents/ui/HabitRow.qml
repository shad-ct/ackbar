import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import "shared" as Shared

Shared.CardContainer {
    id: root

    property var habitData: null
    property bool isCompletedToday: false
    property var streakInfo: ({ current: 0, longest: 0 })
    property bool showStreak: true

    signal toggledToday(string id)
    signal editRequested(var habit)
    signal deleteRequested(string id)

    interactive: false
    contentPadding: 8
    contentSpacing: 4

    RowLayout {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignVCenter
        spacing: 8

        // Checkbox for today
        PlasmaComponents.CheckBox {
            id: completionCheck
            checked: root.isCompletedToday
            Layout.alignment: Qt.AlignVCenter
            onToggled: root.toggledToday(root.habitData ? root.habitData.id : "")
        }

        // Habit Icon Box
        Rectangle {
            id: iconBox
            Layout.preferredWidth: 28
            Layout.preferredHeight: 28
            Layout.alignment: Qt.AlignVCenter
            radius: 6
            property color habitColor: root.habitData && root.habitData.color ? root.habitData.color : Kirigami.Theme.highlightColor
            color: root.habitData && root.habitData.color ? Qt.rgba(iconBox.habitColor.r, iconBox.habitColor.g, iconBox.habitColor.b, 0.15) : "transparent"

            Kirigami.Icon {
                anchors.centerIn: parent
                source: root.habitData && root.habitData.icon ? root.habitData.icon : "user-identity"
                width: 16
                height: 16
                color: iconBox.habitColor
            }
        }

        // Habit details
        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 2

            Text {
                text: root.habitData ? root.habitData.name : ""
                font.pointSize: Kirigami.Theme.defaultFont.pointSize
                font.weight: Font.DemiBold
                font.strikeout: root.isCompletedToday
                color: root.isCompletedToday
                       ? Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.5)
                       : Kirigami.Theme.textColor
                Layout.fillWidth: true
                elide: Text.ElideRight
            }

            Text {
                visible: root.habitData && root.habitData.description !== ""
                text: root.habitData ? root.habitData.description : ""
                font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 3, 8)
                color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.55)
                Layout.fillWidth: true
                elide: Text.ElideRight
            }
        }

        // Streak badge
        Shared.MetricBadge {
            visible: root.showStreak && root.streakInfo && root.streakInfo.current > 0
            text: (root.streakInfo ? root.streakInfo.current : 0) + "d"
            iconName: "rating"
            badgeColor: "#e67e22"
            subtle: true
            Layout.alignment: Qt.AlignVCenter
        }

        // Edit button
        PlasmaComponents.Button {
            id: editBtn
            icon.name: "edit-entry"
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
            Layout.alignment: Qt.AlignVCenter
            flat: true
            QQC2.ToolTip.text: i18n("Edit habit")
            QQC2.ToolTip.visible: editBtn.hovered
            onClicked: root.editRequested(root.habitData)
        }

        // Delete button
        PlasmaComponents.Button {
            id: deleteBtn
            icon.name: "edit-delete"
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
            Layout.alignment: Qt.AlignVCenter
            flat: true
            QQC2.ToolTip.text: i18n("Delete habit")
            QQC2.ToolTip.visible: deleteBtn.hovered
            onClicked: root.deleteRequested(root.habitData ? root.habitData.id : "")
        }
    }
}
