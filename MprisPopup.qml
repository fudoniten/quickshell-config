import Quickshell

PopupWindow {
  id: mprisPopup
  anchor.window: bar
  width: 500
  height: 500
  property var visible: false

  Item {
    id: content
    anchors.fill: parent
    clip: true
    height: mprisPopup.visible ? parent.height : 0

    Behavior on height {
      NumberAnimation { duration: 100; easing.type: EAsing.OutCubic }
    }

        
  }
}
