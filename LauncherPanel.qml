import Quickshell
import QtQuick

// The launcher's search box + results list. This is the part shared between
// Launcher.qml (full-screen, centered) and CornerLauncher.qml (docked
// top-left) -- they differ only in how the window around this is anchored
// and framed.
Rectangle {
  id: panel

  property int boxWidth: 700
  property int boxHeight: 500

  signal closeRequested()

  width: boxWidth
  height: boxHeight
  radius: Theme.radius
  color: Theme.bg

  // Catch clicks here so they don't fall through to a click-outside-closes
  // MouseArea in whichever window hosts this panel.
  MouseArea { anchors.fill: parent }

  readonly property var filtered: {
    const q = searchField.text.toLowerCase();
    return DesktopEntries.applications.values
                         .filter(a => !a.noDisplay)
                         .filter(a => q === "" ||
                                 a.name.toLowerCase().includes(q) ||
                                 a.keywords.some(k => k.toLowerCase().includes(q)))
                         .sort((a, b) => a.name.localeCompare(b.name));
  }

  function launch(entry) {
    entry.execute();
    requestClose();
  }

  // Clears the search box and tells the hosting window to hide itself.
  function requestClose() {
    reset();
    panel.closeRequested();
  }

  // Just clears the search box, with no signal -- for a window that's
  // already decided to hide itself and wants the panel reset for next time.
  function reset() {
    searchField.text = "";
  }

  function focusSearch() {
    searchField.forceActiveFocus();
  }

  Column {
    anchors.fill: parent
    anchors.margins: Theme.bigGap
    spacing: Theme.bigGap

    TextInput {
      id: searchField
      width: parent.width
      color: Theme.fg
      font.family: Theme.fontSans
      font.pixelSize: Theme.fontSize
      Keys.onEscapePressed: panel.requestClose()
      Keys.onReturnPressed: if (panel.filtered.length > 0)
        panel.launch(panel.filtered[0])
    }

    ListView {
      width: parent.width
      height: parent.height - searchField.height - Theme.bigGap
      clip: true
      model: panel.filtered

      delegate: Rectangle {
        required property var modelData
        width: ListView.view.width
        height: 40
        radius: Theme.radius
        color: hover.containsMouse ? Theme.surface : "transparent"

        Text {
          anchors.verticalCenter: parent.verticalCenter
          anchors.left: parent.left
          anchors.margins: Theme.bigGap
          text: modelData.name
          color: Theme.fg
          font.family: Theme.fontSans
        }

        MouseArea {
          id: hover
          anchors.fill: parent
          hoverEnabled: true
          onClicked: panel.launch(modelData)
        }
      }
    }
  }
}
