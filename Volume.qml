import Quickshell
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts

// Default sink volume. Click to open the volume/output-device dropdown.
RowLayout {
  id: root

  anchors.verticalCenter: parent.verticalCenter

  readonly property var sink: Pipewire.defaultAudioSink
  readonly property bool ready: !!sink && !!sink.audio

  // PipeWire objects are not bound (and their properties stay stale) until
  // something tracks them. Without this the volume simply never updates.
  PwObjectTracker {
    objects: root.sink ? [root.sink] : []
  }

  VolumePopup {
    id: volumePopup
    anchorItem: root
  }

  Text {
    text: !root.ready ? "vol --" : root.sink.audio.muted ? "muted" : "vol " + Math.round(root.sink.audio.volume * 100) + "%"

    color: root.ready && root.sink.audio.muted ? Theme.muted : Theme.fg
    font.family: Theme.fontMono
    font.pixelSize: Theme.fontSize

    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.PointingHandCursor
      onClicked: volumePopup.expanded ? volumePopup.closePopup() : volumePopup.openPopup()
    }
  }
}
