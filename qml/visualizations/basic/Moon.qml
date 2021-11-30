import QtQuick
import Qt5Compat.GraphicalEffects

// Moon.qml predstavlja mjesec u prikazu vremenskih uvjeta.
Rectangle {

    id: moonItem

    implicitWidth: 100
    height: width
    radius: width/2

    transform: Scale {
        origin.x: width/2
        origin.y: width/2
        xScale: 0.5
        yScale: 0.5
    }

    RadialGradient {
        anchors.fill: moonItem
        source: moonItem
        gradient: Gradient {
            GradientStop { position: 0.0; color: "lightgray" }
            GradientStop { position: 0.5; color: "gray" }
        }
    }
}
