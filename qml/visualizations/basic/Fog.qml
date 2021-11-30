import QtQuick 2.0

// Fog.qml predstavlja jednu animiranu crtu koja
// će biti dio magle u prikazu vremenskih uvjeta.
// Objekt fogItem sadrži svojstva animationDuration, lineLength i lineHeight
// što omogućava postavljanje određenih svojstava crte i animacije.
Item {

    id: fogItem

    // --- public properties ---
    property int lineLength
    property int lineHeight
    property int animationDuration

    Rectangle {
        height: lineHeight
        radius: 10
        color: "dimgray"
        NumberAnimation on width {
            from: 0
            to: lineLength
            duration: animationDuration
        }
    }
}
