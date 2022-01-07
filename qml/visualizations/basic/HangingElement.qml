import QtQuick 2.7

import "../weather_conditions"

// Element se sastoji od linije i elementa koji visi na njoj. Element se učitava dinamički.
Item {
    id: hangingElement

    property alias hangingElement: hangingElementLoader
    property real lineOffsetX: 0.443

    height: hung.height + hangingElementLoader.height
    y: - height

    Image {
        id: hung
        width: hung.sourceSize.width * 0.5
        height: hung.sourceSize.height * 1.5
        source: "qrc:/resources/icons/line.png"
        anchors.left: hangingElementLoader.left
        anchors.leftMargin: hangingElementLoader.width * lineOffsetX
        smooth: true
        antialiasing: true
        mipmap: true
    }

    Loader {
        id: hangingElementLoader
        anchors.top: hung.bottom
        anchors.leftMargin: - width / 2
    }
}
