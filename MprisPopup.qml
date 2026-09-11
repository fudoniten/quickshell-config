import Quickshell
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts
import QtQml

PopupWindow {
  id: mprisPopup

  readonly property var player: CurrentPlayer.current  
  required property var anchorItem
  property bool expanded: false

  anchor.item: anchorItem
  anchor.edges: Edges.Bottom | Edges.Right
  anchor.gravity: Edges.Bottom | Edges.Left
  implicitWidth: 500
  implicitHeight: 500
  visible: false

  color: "transparent"

  function openPopup() {
    visible = true
    expanded = true
  }

  function closePopup() {
    expanded = false
  }

  Rectangle {
    id: popupBody
    
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top

    width: parent.width
    height: mprisPopup.expanded? 500 : 0
    radius: Theme.radius
    
    color: Theme.bg
    clip: true

    Rectangle {
      width: 250
      height: 250
      radius: Theme.radius
      color: Theme.fg
      anchors.centerIn: parent

      Image {
        source: player?.trackArtUrl ?? ""
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        clip: true
        sourceSize: Qt.size(Layout.preferredWidth, Layout.preferredHeight)
        asynchronous: true
      }

      RowLayout {

        IconButton {
          icon: "⏪︎"
          onClicked: player.previous()
          active: player?.canGoPrevious
        }

        IconButton {
          icon: player.isPlaying ? "⏸" : "▶"
          onClicked: player.isPlaying = !player.isPlaying
          active: player?.isPlaying
        }

        IconButton {
          icon: "⏩︎"
          onClicked: player.next()
          active: player?.canGoNext
        }
      }
    }
    
    Behavior on height {
      NumberAnimation {
        id: heightAnimation
        
        duration: 150
        easing.type: Easing.OutBounce

        onFinished: {
          if (!mprisPopup.expanded)
            mprisPopup.visible = false
        }
      }
    }

    onHeightChanged: {
      if (!mprisPopup.expanded && height == 0)
        mprisPopup.visible = false
    }

    Connections {
      target: player

      function onTrackChange() {
        console.log("ART:", player.trackArtUrl)
      }
    }
  }
}
