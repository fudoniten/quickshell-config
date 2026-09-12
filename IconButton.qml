import QtQuick

Rectangle {
  id: root

  required property string icon
  property bool active: false
  property int size: Theme.fontSize

  signal clicked()

  implicitWidth: size * 1.5
  implicitHeight: size * 1.5
  radius: Theme.iconRadius

  color: "transparent"

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
