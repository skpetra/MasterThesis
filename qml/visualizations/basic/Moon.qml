import QtQuick 6.0
import Qt5Compat.GraphicalEffects
import "../../controls"
import QtQuick.Controls.Material

// Moon.qml predstavlja mjesec u prikazu vremenskih uvjeta.
// Predviđeni omjer širine i visine elementa je: visina = širina.
RoundPane {

    id: moonItem

    implicitWidth: 100
    height: width
    radius: width / 2
    Material.background: "#8C8A90"

    transform: Scale {
        origin.x: width / 2
        origin.y: width / 2
        xScale: 0.5
        yScale: 0.5
    }
}
