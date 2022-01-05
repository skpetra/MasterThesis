import QtQuick 2.0

// Cloud.qml predstavlja oblak u prikazu vremenskih uvjeta.
// Predviđeni omjer širine i visine elementa je: visina = širina * 0.6.
Item {
    id: cloudItem

    // --- public properties ---
    property string cloudColor: "lightgray"

    implicitWidth: 100
    implicitHeight: 60

    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: parent.height * 0.55
        radius: height * 0.9
        color: cloudColor
    }

    Rectangle {
        x: parent.width * 0.15
        width: parent.width * 0.5
        height: parent.width * 0.5
        radius: height * 0.9
        color: cloudColor
    }

    Rectangle {
        x: parent.width * 0.53
        y: parent.height * 0.2
        width: parent.width * 0.3
        height: parent.width * 0.3
        radius: height * 0.9
        color: cloudColor
    }
}
