import Quickshell
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts

PopupWindow {
  id: volumePopup

  required property var anchorItem
  property bool expanded: false

  readonly property var sink: Pipewire.defaultAudioSink
  readonly property bool ready: !!sink && !!sink.audio

  // Physical output devices only -- not per-application playback streams.
  readonly property var sinks: Pipewire.nodes.values.filter(n => n.isSink && n.audio)

  anchor.item: anchorItem
  anchor.edges: Edges.Bottom | Edges.Right
  anchor.gravity: Edges.Bottom | Edges.Left
  implicitWidth: 320
  implicitHeight: 300
  visible: false

  color: "transparent"

  // PipeWire objects are not bound (and their properties stay stale) until
  // something tracks them. Without this neither the volume nor the sink
  // list ever update.
  PwObjectTracker {
    objects: volumePopup.sinks
  }

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
    height: volumePopup.expanded ? 300 : 0
    radius: Theme.radius

    color: Theme.bg
    clip: true

    ColumnLayout {
      id: content

      anchors.centerIn: parent
      width: popupBody.width - Theme.bigGap * 2
      spacing: Theme.bigGap

      RowLayout {
        Layout.fillWidth: true
        spacing: Theme.gap

        Text {
          text: !volumePopup.ready ? "🔇"
                : volumePopup.sink.audio.muted ? "🔇"
                : volumePopup.sink.audio.volume > 0.5 ? "🔊" : "🔉"

          color: volumePopup.ready && volumePopup.sink.audio.muted ? Theme.muted : Theme.fg
          font.family: Theme.fontIcon
          font.pixelSize: Theme.fontSize * 1.5

          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: if (volumePopup.ready)
              volumePopup.sink.audio.muted = !volumePopup.sink.audio.muted
          }
        }

        Item {
          id: sliderTrack

          Layout.fillWidth: true
          Layout.preferredHeight: 10

          function setVolumeFromX(x) {
            if (!volumePopup.ready)
              return;
            const ratio = Math.max(0, Math.min(1, x / sliderTrack.width));
            volumePopup.sink.audio.volume = ratio;
            if (ratio > 0 && volumePopup.sink.audio.muted)
              volumePopup.sink.audio.muted = false;
          }

          Rectangle {
            anchors.fill: parent
            radius: height / 2
            color: Theme.surface
          }

          Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            radius: height / 2
            color: Theme.accent
            width: parent.width * (volumePopup.ready ? Math.min(volumePopup.sink.audio.volume, 1.0) : 0)
          }

          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onPressed: mouse => sliderTrack.setVolumeFromX(mouse.x)
            onPositionChanged: mouse => {
              if (pressed)
                sliderTrack.setVolumeFromX(mouse.x);
            }
          }
        }
      }

      ColumnLayout {
        Layout.fillWidth: true
        spacing: 2

        Repeater {
          model: volumePopup.sinks

          delegate: Rectangle {
            id: deviceRow

            required property var modelData

            Layout.fillWidth: true
            Layout.preferredHeight: 32
            radius: Theme.iconRadius
            color: hover.containsMouse ? Theme.surface : "transparent"

            RowLayout {
              anchors.fill: parent
              anchors.leftMargin: Theme.gap
              anchors.rightMargin: Theme.gap
              spacing: Theme.gap

              Rectangle {
                implicitWidth: 14
                implicitHeight: 14
                radius: 7
                color: "transparent"
                border.width: 2
                border.color: deviceRow.modelData === volumePopup.sink ? Theme.accent : Theme.muted

                Rectangle {
                  anchors.centerIn: parent
                  implicitWidth: 6
                  implicitHeight: 6
                  radius: 3
                  color: Theme.accent
                  visible: deviceRow.modelData === volumePopup.sink
                }
              }

              Text {
                Layout.fillWidth: true
                text: deviceRow.modelData.description || deviceRow.modelData.nickname || deviceRow.modelData.name
                elide: Text.ElideRight
                color: deviceRow.modelData === volumePopup.sink ? Theme.fg : Theme.muted
                font.family: Theme.fontSans
                font.pixelSize: Theme.fontSize
              }
            }

            MouseArea {
              id: hover
              anchors.fill: parent
              hoverEnabled: true
              cursorShape: Qt.PointingHandCursor
              onClicked: Pipewire.defaultAudioSink = deviceRow.modelData
            }
          }
        }
      }
    }

    Behavior on height {
      NumberAnimation {
        duration: 150
        easing.type: Easing.OutExpo

        onFinished: {
          if (!volumePopup.expanded)
            volumePopup.visible = false
        }
      }
    }

    onHeightChanged: {
      if (!volumePopup.expanded && height == 0)
        volumePopup.visible = false
    }
  }
}
