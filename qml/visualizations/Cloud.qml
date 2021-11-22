import QtQuick 2.0

Item {
    id: cloudItem

    implicitWidth: 100
    implicitHeight: 60

    property string cloudColor: "lightgray"

    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: parent.height * 0.55
        radius: height * 0.9
        color: cloudColor
    }

    Rectangle {
        x: parent.width*0.15
        width: parent.width*0.5
        height: parent.width*0.5
        radius: height * 0.9
        color: cloudColor
    }

    Rectangle {
        x: parent.width*0.53
        y: parent.height*0.2
        width: parent.width*0.3
        height: parent.width*0.3
        radius: height * 0.9
        color: cloudColor
    }
}
