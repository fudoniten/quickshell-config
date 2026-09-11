import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris

RowLayout {
  anchors.verticalCenter: parent.verticalCenter
  
  readonly property var player: Mpris.players.values.find(p => p.isPlaying) ??
    Mpris.players.values[0] ??
    null

  required property var window

  spacing: Theme.gap

  Image {
    source: player?.trackArtUrl ?? ""
    
    Layout.preferredWidth: 18
    Layout.preferredHeight: 18
    fillMode: Image.PreserveAspectCrop
    clip: true
    sourceSize: Qt.size(Layout.preferredWidth, Layout.preferredHeight)
    
    asynchronous: true

    TapHandler {
      onTapped: window.visible = !window.visible
    }
  }

  MprisPopup {
    id: mprisPopup
    barWindow: window
  }

  Text {
    text: player ? (player.trackArtist + " - " + player.trackTitle) : ""
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
