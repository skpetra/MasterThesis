import QtQuick 2.0
import QtQuick.Controls 2.0

Page {

    property string cityName

    MouseArea {
        id: itemBack
        anchors.top: parent.top
        anchors.left: parent.left
        height: 20
        width: 20
        Image{
            id: iconBack
            height: itemBack.height
            width: itemBack.width
            source: "../../resources/icons/back.png"
            opacity: 0.2
        }
        onClicked: pageStack.pop()
    }

//    Text {
//        id: name
//        text: cityName
//    }
}
