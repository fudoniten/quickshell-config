import Quickshell
import Quickshell.Io
import QtQuick

// Second launcher, docked in the top-left corner instead of covering the
// whole screen -- for trying both side by side. Opened by the bar icon
// (LauncherState.cornerVisible, a direct in-process toggle) or `$mod G`
// (IpcHandler.toggle, since a Hyprland exec bind is a separate process and
// has to go through `qs ipc call` rather than touching QML state directly).
PanelWindow {
  id: cornerLauncher

  visible: LauncherState.cornerVisible
  focusable: true

  anchors { top: true; left: true }
  margins { top: Theme.gap; left: Theme.gap }

  implicitWidth: panel.boxWidth
  implicitHeight: panel.boxHeight
  color: "transparent"

  onVisibleChanged: if (visible) panel.focusSearch()

  IpcHandler {
    target: "launcherCorner"
    function toggle(): void {
      LauncherState.cornerVisible = !LauncherState.cornerVisible;
    }
  }

  LauncherPanel {
    id: panel
    boxWidth: 400
    boxHeight: 500
    onCloseRequested: LauncherState.cornerVisible = false
  }
}
