import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick

// StatusNotifierItem tray. Left click activates, right click asks the app for
// its secondary action -- a full DBusMenu popup is deliberately left out of
// this first pass; see docs/quickshell.md.
Row {
    // Tray's own icons are all the same height, so this row centering
    // within itself was never visible as a bug -- but Tray as a whole is
    // also a child of rightSection's Row in Bar.qml, so without this it's
    // top-aligned there too, same as Volume/Battery.
    anchors.verticalCenter: parent.verticalCenter
    spacing: 8

    Repeater {
        model: SystemTray.items

        delegate: MouseArea {
            id: item

            required property var modelData

            implicitWidth: 18
            implicitHeight: 18
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            cursorShape: Qt.PointingHandCursor

            onClicked: mouse => {
                if (mouse.button === Qt.LeftButton)
                    item.modelData.activate();
                else
                    item.modelData.secondaryActivate();
            }

            IconImage {
                anchors.fill: parent
                source: item.modelData.icon
            }
        }
    }
}
