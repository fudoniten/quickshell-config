import QtQuick

Rectangle {
  id: root

  required property string icon
  property bool active: false
  signal clicked()

  implicitWidth: 28
  implicitHeight: 28
  radius: Theme.iconRadius

  color: active ? Theme.accent : mouse.containsMouse ? Theme.surface : "transparent"

  Text {
    anchors.centerIn: parent
    
    text: root.icon
    color: root.active ? Theme.bg : Theme.fg

    font.family: Theme.fontIcon
    font.pixelSize: Theme.fontSize
  }

  MouseArea {
    id: mouse
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: root.clicked()
  }
}
