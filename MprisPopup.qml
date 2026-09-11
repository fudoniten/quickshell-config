import Quickshell
import QtQuick

PopupWindow {
  id: mprisPopup
  
  required property var barWindow
  required property var mprisPlayer
  
  anchor.window: barWindow
  anchor.rect.x: window.width - mprisPlayer.x - mprisPlayer.width - 500
  anchor.rect.y: barWindow.height
  implicitWidth: 500
  implicitHeight: 500
  visible: false

  Item {
    id: content
    anchors.fill: parent
    clip: true
    height: mprisPopup.visible ? parent.height : 0

    Behavior on height {
      NumberAnimation { duration: 100; easing.type: Easing.OutCubic }
    }        
  }
}
