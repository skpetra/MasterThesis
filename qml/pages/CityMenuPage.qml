import QtQuick 2.0
import QtQuick.Controls 2.0

import "../visualizations"
import "../visualizations/basic"

Page {

    property string cityName

    MouseArea {
        id: itemBack
        anchors.top: parent.top
        anchors.left: parent.left
        height: 20
        width: 15
        Image{
            id: iconBack
            height: itemBack.height
            width: itemBack.width
            source: "../../resources/icons/back2.png"
            opacity: 0.2
        }
        onClicked: pageStack.pop()
    }


    MouseArea {
        height: 100
        width: 100
        y: 50
        Text {
            id: cityNameText
            height: 100
            width: 100
            text: "current weather page " + cityName
        }
        onClicked: {
            pageStack.push("qrc:/qml/pages/CurrentWeatherPage.qml", { cityName: cityName })
        }
    }
}
