pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import QtQml

Singleton {
  id: root

  property var current: pickFallback()

  function pickFallback() {
    return Mpris.players.values.find(p => p.isPlaying) ?? Mpris.players.values[0] ?? null;
  }

  Connections {
    target: Mpris.players
    
    function onValuesChanged() {
      if (!Mpris.players.values.includes(root.current))
        root.current = root.pickFallback();
    }
  }

  Instantiator {
    model: Mpris.players
    delegate: Connections {
      required property var modelData
      target: modelData
      function onIsPlayingChanged() {
        if (modelData.isPlaying) root.current = modelData;
      }
    }
  }

  IpcHandler {
    target: "mpris"
    function playPause(): void { root.current?.togglePlaying(); }
    function next(): void {root.current?.next(); }
    function previous(): void { root.current?.previous(); }
  }
}
