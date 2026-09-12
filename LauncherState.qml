pragma Singleton

import Quickshell

// Shared visibility flag for CornerLauncher, so the bar icon (in-process,
// same as CurrentPlayer's IPC/click unification) and CornerLauncher's own
// IpcHandler (out-of-process, for the Hyprland keybind) always agree on
// whether it's open.
Singleton {
  property bool cornerVisible: false
}
