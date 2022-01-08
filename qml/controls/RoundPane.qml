import QtQuick 6.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12

// Element predstavlja uzdignuti panel (elevation) sa zaobljenim rubovima.
Pane {

    id: control

    property int radius: 2
    Material.elevation: 6

    background: Rectangle {
        color: control.Material.backgroundColor
        radius: control.Material.elevation > 0 ? control.radius : 0

        layer.enabled: control.enabled && control.Material.elevation > 0
        layer.effect: ElevationEffect {
            elevation: control.Material.elevation
        }
    }
}
