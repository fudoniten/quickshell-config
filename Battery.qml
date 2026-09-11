import Quickshell
import Quickshell.Services.UPower
import QtQuick

// Hides itself entirely on machines without a battery, which is why system7
// shows nothing here. It exists so the same config can move to a laptop
// unchanged.
Text {
    id: root

    // Same top-alignment default as Volume -- see the comment there. You
    // haven't seen this one misbehave yet only because it's invisible on a
    // desktop with no battery; it would show the identical bug the moment
    // it became visible on a laptop.
    anchors.verticalCenter: parent.verticalCenter

    readonly property var battery: UPower.displayDevice ?? null

    visible: !!battery && battery.isLaptopBattery === true

    text: visible ? "bat " + Math.round(battery.percentage * 100) + "%" : ""

    color: {
        if (!root.visible)
            return Theme.fg;
        if (root.battery.state === UPowerDeviceState.Charging)
            return Theme.ok;
        if (root.battery.percentage < 0.15)
            return Theme.critical;
        if (root.battery.percentage < 0.30)
            return Theme.warning;
        return Theme.fg;
    }

    font.family: Theme.fontSans
    font.pixelSize: Theme.fontSize
}
