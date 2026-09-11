import QtQuick

Rectangle {
  id: root

  required property string icon
  property bool active: false
  property int size: Theme.fontSize

  signal clicked()

  implicitWidth: size
  implicitHeight: size
  radius: Theme.iconRadius

  color: active ? Theme.muted : (mouse.containsMouse ? Theme.accent : Theme.muted)

  Text {
    anchors.centerIn: parent
    
    text: root.icon
    color: root.active ? Theme.fg : Theme.muted

    font.family: Theme.fontIcon
    font.pixelSize: size
  }

  MouseArea {
    id: mouse
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: root.clicked()
  }
}
