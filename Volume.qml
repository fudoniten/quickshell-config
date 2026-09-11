import Quickshell
import Quickshell.Services.Pipewire
import QtQuick

// Default sink volume. Click to toggle mute.
Text {
  id: root
  
  anchors.verticalCenter: parent.verticalCenter

  // Row (the parent, in Bar.qml) only manages the horizontal axis -- every
  // child defaults to y: 0 (top-aligned) unless it says otherwise. Without
  // this, Volume sits pinned to the top of whichever sibling is tallest
  // (Tray's or MprisPlayer's 18px icons) instead of centered in the bar.
  anchors.verticalCenter: parent.verticalCenter

  readonly property var sink: Pipewire.defaultAudioSink
  readonly property bool ready: !!sink && !!sink.audio

  // PipeWire objects are not bound (and their properties stay stale) until
  // something tracks them. Without this the volume simply never updates.
  PwObjectTracker {
    objects: root.sink ? [root.sink] : []
  }

  text: !root.ready ? "vol --" : root.sink.audio.muted ? "muted" : "vol " + Math.round(root.sink.audio.volume * 100) + "%"

  color: root.ready && root.sink.audio.muted ? Theme.muted : Theme.fg
  font.family: Theme.fontMono
  font.pixelSize: Theme.fontSize

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    onClicked: {
      if (root.ready)
        root.sink.audio.muted = !root.sink.audio.muted;
    }
  }
}
