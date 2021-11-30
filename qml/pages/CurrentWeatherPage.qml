import QtQuick 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import "../models"
import "../visualizations"
import "../../js/utils.js" as Utils
import "../elements"

Page {

    id: currentWeatherPage

    property var units: { "celsius": "°C", "fahrenheit": "°F" }
    //property var weatherConditionGroups: { '2': "Thunderstorm", '3': "Drizzle", '5': "Precipitation", '6': "Precipitation", '7': "Atmosphere", '8': "Clouds" }
    property string cityName
    title: cityName

    property Component weatherComponent

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
            source: "../../resources/icons/back2.png"
            opacity: 0.2
        }
        onClicked: pageStack.pop()
    }

    UnitsToggleButton {
        anchors.top: parent.top
        anchors.right: parent.right

        onToggled: function(units) { currentWeatherXmlModel.units = units }
    }

    CurrentWeatherXmlModel {
        id: currentWeatherXmlModel
        city: cityName
    }

    // može ovo jer ću --- uvijek imat jedan element --- pa u delegatu mogu prilagodit izgled kako zelim
    ListView {
        id: currentWeatherXmlListView

        z: -1 // da strelica za nazad bude poviše listviewa
        anchors.fill: parent
        model: currentWeatherXmlModel
        delegate: ColumnLayout {
                anchors.centerIn: parent
                Text {
                    id: cityNameText
                    text: currentWeatherPage.title
                    font.pixelSize: 25
                    //horizontalAlignment: Text.AlignHCenter
                    Layout.alignment: Qt.AlignCenter // Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                }

                Rectangle {
                    id: weatherAnimationItem
                    Layout.alignment: Qt.AlignCenter
                    color: "transparent"
                    width: 400
                    height: 400

                    Loader {
                        id: weatherAnimationLoader
                    }
                }

                Text{
                    text: qsTr(weather)
                    Layout.alignment: Qt.AlignCenter
                }


                Text {
                    id: temperatureText
                    text: Math.floor(temperature) + units[temperature_units]
                    font.pixelSize: 35
                    Layout.alignment: Qt.AlignCenter
                }


                Text {
                    id: feelsLikeText
                    text: "Feels like: " + Math.floor(feels_like) + units[temperature_units]
                    Layout.alignment: Qt.AlignCenter
                }

                Component.onCompleted: {

                    console.log(weather_code + " " + weather_icon)
                    Utils.setWeatherAnimation(weatherAnimationLoader, weather_code, weather_icon, weatherAnimationItem.width, weatherAnimationItem.height)  // will trigger the onLoaded code when complete.
                }
            }
        }
}


