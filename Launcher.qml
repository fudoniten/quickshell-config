import Quickshell
import Quickshell.Io
import QtQuick

PanelWindow {
  id: launcher

  visible: false
  focusable: true

  anchors { top: true; bottom: true; left: true; right: true }
  color: "#80000000"

  property string searchText: ""

  readonly property var filtered: {
    const q = searchText.toLowerCase();
    return DesktopEntries.applications.values
                         .filter(a => !a.noDisplay)
                         .filter(a => q === "" ||
                                 a.name.toLowerCase().includes(q) ||
                                 a.keywords.some(k => k.toLowerCase().includes(q)))
                         .sort((a, b) => a.name.localeCompare(b.name));
  }

  function launch(entry) {
    entry.execute();
    close();
  }

  function close() {
    launcher.visible = false;
    searchText = "";
  }

  IpcHandler {
    target: "launcher"
    function toggle(): void {
      launcher.visible = !launcher
      if (launcher.visible) searchField.forceActiveFocus();
    }
  }

  // Clicks outside the window will close it
  MouseArea {
    anchors.fill: parent
    onClicked: launcher.close()
  }

  Rectangle {
    id: box
    anchors.centerIn: parent
    width: 700
    height: 500
    radius: Theme.radius
    color: Theme.bg

    // Catch in-window clicks so we don't close (see above)
    MouseArea { anchors.fill: parent }

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
        text: launcher.searchText
        onTextChanged: launcher.searchText = text
        Keys.onEscapePressed: launcher.close()
        Keys.onReturnPressed: if (launcher.filtered.length > 0)
          launcher.launch(launcher.filtered[0])
      }

      ListView {
        width: parent.width
        height: parent.height - searchField.height - Theme.bigGap
        clip: true
        model: launcher.filtered

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
            onClicked: launcher.launch(modelData)
          }
        }
      }
    }
  }
}
