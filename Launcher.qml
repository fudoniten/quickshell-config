import Quickshell
import Quickshell.Io
import QtQuick

// Full-screen launcher: dims the whole monitor, centers the shared
// LauncherPanel body. Toggle with `qs -c fudo ipc call launcher toggle`
// (bound to a Hyprland key, since exec binds can't touch QML properties
// directly and have to go through IPC instead).
PanelWindow {
  id: launcher

  visible: false
  focusable: true

  anchors { top: true; bottom: true; left: true; right: true }
  color: "#80000000"

  function open() {
    launcher.visible = true;
    panel.focusSearch();
  }

  function close() {
    launcher.visible = false;
    panel.reset();
  }

  IpcHandler {
    target: "launcher"
    function toggle(): void {
      if (launcher.visible) launcher.close();
      else launcher.open();
    }
  }

  // Clicks outside the panel close it.
  MouseArea {
    anchors.fill: parent
    onClicked: launcher.close()
  }

  LauncherPanel {
    id: panel
    anchors.centerIn: parent
    boxWidth: 700
    boxHeight: 500
    onCloseRequested: launcher.close()
  }
}
