import QtQuick 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material

import "../controls"
import "../visualizations"
import "../visualizations/weather_conditions"
import "../visualizations/widgets"

import "../../js/utils.js" as Utils
import "../../js/config.js" as Config

// Stranica za prikaz sedmodnevne vremenske prognoze.
Page {

    id: sevenDaysWeatherPage
    objectName: "SevenDaysWeatherPage"

    // --- public properties ---
    property string cityName
    property string units: "celsius"
    // weatherData svojstvo je objekt dobiven iz stringa podataka u JSON formatu
    property var weatherData

    property double longitude
    property double latitude

    signal unitsButtonToggled(string units)

    title: cityName
    clip: true

    onUnitsButtonToggled: function(units) {
        sevenDaysWeatherPage.units = units
        updateTemperatureData()
    }


    Rectangle {
        anchors.fill: parent
        color: "#4682b4" //"slateblue"
    }

    Text {
        id: pageTitle
        text: qsTr(title)
        width: parent.width
        font.bold: true
        font.pixelSize: 50
        fontSizeMode: Text.Fit
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter

    }

    Rectangle {
        id: listViewBox
        anchors.top: pageTitle.bottom
        width: parent.width * 0.9
        height: parent.height * 0.867 - pageTitle.height
        anchors.horizontalCenter: parent.horizontalCenter
        color: "transparent"
        //color: "#7FB3D5"



        ListModel {
            id: sevenDaysListModel
        }

        ListView {

            id: sevenDaysListView

            anchors.fill: listViewBox
            model: sevenDaysListModel
            snapMode: ListView.SnapToItem
            clip: true

            delegate: Component {
                id: sevenDaysDelegate


                LongTermDayWidget {
                    width: sevenDaysListView.width * 0.9
                    // - mainItem -
                    weekDay: weekDayModel
                    date: dateModel
                    weatherIcon: weatherIconModel
                    weatherCode: weatherCodeModel
                    temperatureMin: temperatureMinModel
                    temperatureMax: temperatureMaxModel
                    // - SunsetSunriseWidget -
                    sunset: sunsetModel
                    sunrise: sunriseModel
                    // - DailyWindWidget -
                    windSpeed: windSpeedModel
                    windDirection: windDirectionModel
                    // - HumidityWidget -
                    humidity: humidityModel
                    // - UVIndexWidget
                    uvIndex: uviModel

                    //anchors.horizontalCenter: parent ? parent.horizontalCenter :
                }
            }

            spacing: 10
            anchors.margins: 10

            Component.onCompleted: {
                setWeatherData()
            }
        }
    }


    // --- private functions ---

    // Funkcija za postavljanje svojstava elemenata za prikaz prognoze na dan i idućih sedam dana.
    // Podaci se iščitavaju iz weatherData svojstva dobivenog od prethodne CurrentWeatherPage stranice.
    // Dohvaćeni podaci dodaju se u ListModel koji se prikazuje u ListViewu.
    function setWeatherData() {

        for (var i in weatherData.daily) {
            console.log(weatherData.daily[i].uvi)
            sevenDaysListModel.append({
                 weekDayModel: Utils.getWeekDay(weatherData.daily[i].dt),
                 dateModel: Utils.getDate(weatherData.daily[i].dt),
                 weatherCodeModel: weatherData.daily[i].weather[0].id,
                 weatherIconModel: weatherData.daily[i].weather[0].icon,
                 temperatureMinModel: Math.floor(Utils.convertTo(units, weatherData.daily[i].temp.min)) + "°", // todo: pretvorit int????
                 temperatureMaxModel: Math.floor(Utils.convertTo(units, weatherData.daily[i].temp.max)) + "°",
                 sunsetModel: Utils.getLocalTime(weatherData.daily[i].sunset, weatherData.timezone_offset),
                 sunriseModel: Utils.getLocalTime(weatherData.daily[i].sunrise, weatherData.timezone_offset),
                 windSpeedModel: weatherData.daily[i].wind_speed,
                 windDirectionModel: weatherData.daily[i].wind_deg,
                 humidityModel: parseInt(weatherData.daily[i].humidity),
                 uviModel: weatherData.daily[i].uvi
            })
        }
    }

    // Podaci o temperaturi se ažuriraju ovisno o mjernoj jedinici pozivanjem funkcije za preračunavanje °C u °F.
    // Izvorno se podaci dohvaćaju u °C pa je funkcija convertTo(units, value) implementirana u skladu s tim.
    // Poziva se pritiskom na gumb UnitsToggleButton.
    function updateTemperatureData() {

        for (var i in weatherData.daily) {
            sevenDaysListModel.setProperty(i, "temperatureMinModel", Math.floor(Utils.convertTo(units, weatherData.daily[i].temp.min)) + "°")
            sevenDaysListModel.setProperty(i, "temperatureMaxModel", Math.floor(Utils.convertTo(units, weatherData.daily[i].temp.max)) + "°")
        }
    }

}
