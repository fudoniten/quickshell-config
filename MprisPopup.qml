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
  implicitWidth: 700
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

    ColumnLayout {
      anchors.centerIn: parent
      spacing: Theme.bigGap

      Rectangle {
        Layout.preferredWidth: 300
        Layout.preferredHeight: 300
        Layout.alignment: Qt.AlignHCenter
        
        radius: Theme.radius
        color: Theme.fg

        Image {
          source: player?.trackArtUrl ?? ""
          anchors.fill: parent
          fillMode: Image.PreserveAspectCrop
          clip: true
          sourceSize: Qt.size(Layout.preferredWidth, Layout.preferredHeight)
          asynchronous: true
        }
      }

      RowLayout {
        Text {
          text: player ? (player.trackArtist ? (player.trackArtist + " - " + player.trackTitle) : player.trackTitle) : ""
          Layout.maximumWidth: 500
          elide: Text.ElideRight
          color: Theme.fg
          font.family: Theme.fontSans
          font.pixelSize: Theme.fontSize
        }
      }

      RowLayout {
        Layout.alignment: Qt.AlignHCenter
        spacing: Theme.bigGap

        IconButton {
          icon: "⏪︎"
          onClicked: player.previous()
          active: player?.canGoPrevious
          size: Theme.fontSize * 2
        }

        IconButton {
          icon: player.isPlaying ? "⏸" : "▶"
          onClicked: player.isPlaying = !player.isPlaying
          active: player?.isPlaying
          size: Theme.fontSize * 2
        }

        IconButton {
          icon: "⏩︎"
          onClicked: player.next()
          active: player?.canGoNext
          size: Theme.fontSize * 2
        }
      }
    }
    
    Behavior on height {
      NumberAnimation {
        id: heightAnimation
        
        duration: 150
        easing.type: Easing.OutExpo

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
  }
}
