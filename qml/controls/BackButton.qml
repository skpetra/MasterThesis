import QtQuick 2.0

// Gumb za povratak na prethodnu stranicu.
MouseArea {

    id: backItem

    anchors.top: parent.top
    anchors.left: parent.left
    height: 20
    width: 15

    Image{
        height: backItem.height
        width: backItem.width
        source: "../../resources/icons/back2.png"
        opacity: 0.2
    }

    onClicked: pageStack.pop()
}
