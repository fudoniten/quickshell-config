import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris

RowLayout {
  id: mprisRow
  
  anchors.verticalCenter: parent.verticalCenter
  
  readonly property var player: Mpris.players.values.find(p => p.isPlaying) ??
    Mpris.players.values[0] ??
    null

  required property var window

  spacing: Theme.gap

  Rectangle {
    id: mediaButton
    implicitWidth: 18
    implicitHeight: 18
    radius: Theme.iconRadius

    color: Theme.surface
    
    Image {
      source: player?.trackArtUrl ?? ""

      anchors.fill: parent
      Layout.preferredWidth: 18
      Layout.preferredHeight: 18
      fillMode: Image.PreserveAspectCrop
      clip: true
      sourceSize: Qt.size(Layout.preferredWidth, Layout.preferredHeight)
      
      asynchronous: true
    }

    MouseArea {
      id: mouse
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: mprisPopup.expanded ? mprisPopup.closePopup() : mprisPopup.openPopup()
    }
  }

  MprisPopup {
    id: mprisPopup
    anchorItem: mprisRow
  }

  Text {
    text: player ? (player.trackArtist ? (player.trackArtist + " - " + player.trackTitle) : player.trackTitle) : ""
    Layout.maximumWidth: 500
    elide: Text.ElideRight
    color: Theme.fg
    font.family: Theme.fontSans
    font.pixelSize: Theme.fontSize
  }

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
