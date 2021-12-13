import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Shapes 1.2

import "../visualizations"
import "../visualizations/basic"
import "../visualizations/weather_conditions"


import "../controls"
import "../visualizations/widgets"


Page {

    property string cityName
    property double longitude
    property double latitude

    BackButton  { }


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

    MouseArea {
        height: 200
        width: 100
        y: 100
        Text {
            id: textt
            height: 100
            width: 100
            text: "seven days weather page " + cityName + "  "
        }
        onClicked: {
            pageStack.push("qrc:/qml/pages/SevenDaysWeatherPage.qml",
                           {
                               cityName: cityName,
                               longitude : longitude,
                               latitude : latitude
                           })
        }
    }

    Component.onCompleted: {
        console.log("Longitude=" + longitude + ", latitude=" + latitude)
    }

}
