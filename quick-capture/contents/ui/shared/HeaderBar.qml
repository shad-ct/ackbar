import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Item {
    id: root

    property string title: ""
    property string subtitle: ""
    property string iconName: ""
    default property alias actions: actionContainer.data

    implicitWidth: 300
    implicitHeight: Math.max(layout.implicitHeight, 36)

    RowLayout {
        id: layout
        anchors.fill: parent
        spacing: 8

        Kirigami.Icon {
            id: headerIcon
            visible: root.iconName !== ""
            source: root.iconName
            Layout.preferredWidth: 20
            Layout.preferredHeight: 20
            Layout.alignment: Qt.AlignVCenter
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 1

            Text {
                text: root.title
                font.pointSize: Kirigami.Theme.defaultFont.pointSize
                font.weight: Font.DemiBold
                color: Kirigami.Theme.textColor
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Text {
                visible: root.subtitle !== ""
                text: root.subtitle
                font.pointSize: Math.max(Kirigami.Theme.defaultFont.pointSize - 2, 8)
                color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.65)
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
        }

        RowLayout {
            id: actionContainer
            spacing: 4
            Layout.alignment: Qt.AlignVCenter
        }
    }
}
