import QtQuick 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import "../models"
import "../visualizations"
import "../visualizations/weather_conditions"
import "../../js/utils.js" as Utils
import "../controls"

// Stranica za prikaz osnovne trenutne vremenske prognoze.
Page {

    id: currentWeatherPage

    // --- public properties ---
    property string cityName

    property var units: { "celsius": "°C", "fahrenheit": "°F" }

    title: cityName

    BackButton  { }

    UnitsToggleButton {
        anchors.top: parent.top
        anchors.right: parent.right

        onToggled: function(units) { currentWeatherXmlModel.units = units }
    }

    CurrentWeatherXmlModel {
        id: currentWeatherXmlModel
        city: cityName
    }

    ObjectModel {} /// OVO UMJESTO DELEGATA Sunclock ...


    // može ovo jer ću --- uvijek imat jedan element --- pa u delegatu mogu prilagodit izgled kako zelim
    ListView {
        id: currentWeatherXmlListView

        z: -1 // da strelica za nazad bude poviše listviewa
        anchors.fill: parent
        model: currentWeatherXmlModel

        delegate: Item {

            Sunclock {

                width: currentWeatherPage.width
                height: currentWeatherPage.height
                anchors.centerIn: currentWeatherPage
                sunsetString: sunset
                sunriseString: sunrise
                timezoneSec: timezone
            }
                ColumnLayout {

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
                    width: 200
                    height: 200

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

                    console.log("page: " + currentWeatherXmlListView.width + " " + currentWeatherXmlListView.height)
                    console.log(weather_code + " " + weather_icon)
                    Utils.setWeatherAnimation(weatherAnimationLoader, weather_code, weather_icon, weatherAnimationItem.width, weatherAnimationItem.height)  // will trigger the onLoaded code when complete.


                }
            }}
        }
}


