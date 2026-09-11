import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris

RowLayout {
  // Same fix as Volume/Battery/Tray: rightSection's Row (in Bar.qml) leaves
  // every child's vertical position alone, defaulting to top-aligned.
  anchors.verticalCenter: parent.verticalCenter

  readonly property var player: Mpris.players.values.find(p => p.isPlaying) ??
    Mpris.players.values[0] ??
    null

  spacing: Theme.gap

  Image {
    source: player?.trackArtUrl ?? ""
    width: 18
    height: 18
    fillMode: Image.PreserveAspectCrop
    clip: true
    sourceSize: Qt.size(width, height)
    asynchronous: true
  }

  Text {
    text: player ? (player?.trackArtist + " - " + player?.trackTitle) : ""
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
