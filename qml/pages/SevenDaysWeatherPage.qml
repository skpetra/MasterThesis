import QtQuick 6.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material

import "../controls"
import "../visualizations"
import "../visualizations/weather_conditions"
import "../visualizations/widgets"

import "../../js/utils.js" as Utils
import "../../js/config.js" as Config

// Stranica za prikaz sedmodnevne vremenske prognoze. Sadrži naziv grada kao naslov te listu
// LongTermDayWidget.qml "collapsible" elemenata za prikaz dnevnih vremenskih podataka.
Page {

    id: sevenDaysWeatherPage
    objectName: "SevenDaysWeatherPage"

    // --- public properties ---
    property string cityName
    property string units: "celsius"    
    property var weatherData // weatherData svojstvo je objekt dobiven iz stringa podataka u JSON formatu
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
        id: backgroundRectangle
        anchors.fill: parent
        color: "#4682b4"
    }

    Spinner {
        anchors.centerIn: parent
        running: typeof sevenDaysWeatherPage.weatherData === "undefined"

        onRunningChanged: {
            if (running === true)
                parent.opacity = 0.9
            else
                parent.opacity = 1
        }
    }
    Behavior on opacity { OpacityAnimator { duration: 50 } }

    Text {
        id: pageTitle
        text: qsTr(title)
        width: parent.width
        color: "#002149"
        font.bold: true
        font.pixelSize: 50
        fontSizeMode: Text.Fit
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
        topPadding: parent.height * 0.05
        bottomPadding: parent.height * 0.05
    }

    Rectangle {
        id: listViewBox
        anchors.top: pageTitle.bottom
        width: parent.width * 0.9
        height: parent.height * 0.97 - pageTitle.height
        anchors.horizontalCenter: parent.horizontalCenter
        color: "transparent"

        ListModel {
            id: sevenDaysListModel
        }

        ListView {
            id: sevenDaysListView
            anchors.fill: listViewBox
            model: sevenDaysListModel
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

                    anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
                }
            }

            spacing: 10
            anchors.margins: 10

            Component.onCompleted: {

                // ukoliko je korisnik kliknuo na WEEK button prije nego su se učitali podaci na CurrentWeathetPage stranici
                if (typeof weatherData === "undefined") {
                    //console.log("Dohvaćam nove podatke: " + "https://api.openweathermap.org/data/2.5/onecall?lat=" + latitude + "&lon=" + longitude + "&appid=" + Config.api_key + "&units=metric")
                    var xhr = new XMLHttpRequest;
                    xhr.open("GET", "https://api.openweathermap.org/data/2.5/onecall?lat=" + latitude + "&lon=" + longitude + "&appid=" + Config.api_key + "&units=metric");
                    xhr.onreadystatechange = function() {
                        if (xhr.readyState === XMLHttpRequest.DONE) {
                            var obj = JSON.parse(xhr.responseText)
                            weatherData = obj
                            setWeatherData(obj)
                        }
                    }
                    xhr.send();
                }
                else
                    setWeatherData(weatherData)
            }
        }
    }


    // --- private functions ---

    // Funkcija za postavljanje svojstava elemenata za prikaz prognoze na dan i idućih sedam dana.
    // Podaci se iščitavaju iz weatherData svojstva dobivenog od prethodne CurrentWeatherPage stranice.
    // Dohvaćeni podaci dodaju se u ListModel koji se prikazuje u ListViewu.
    function setWeatherData(weatherData) {

        for (var i in weatherData.daily) {
            if (Number(i) > 0) { // današnja prognoza se ne prikazuje (weatherData.daily[0])
                sevenDaysListModel.append({
                     weekDayModel: Utils.getWeekDay(weatherData.daily[i].dt),
                     dateModel: Utils.getDate(weatherData.daily[i].dt),
                     weatherCodeModel: weatherData.daily[i].weather[0].id,
                     weatherIconModel: weatherData.daily[i].weather[0].icon,
                     temperatureMinModel: Math.floor(Utils.convertTo(units, weatherData.daily[i].temp.min)) + "°", // todo: pretvorit int????
                     temperatureMaxModel: Math.floor(Utils.convertTo(units, weatherData.daily[i].temp.max)) + "°",
                     sunsetModel: Utils.getLocalTime(weatherData.daily[i].sunset, weatherData.timezone_offset, "hh:mm:ss"),
                     sunriseModel: Utils.getLocalTime(weatherData.daily[i].sunrise, weatherData.timezone_offset, "hh:mm:ss"),
                     windSpeedModel: weatherData.daily[i].wind_speed,
                     windDirectionModel: weatherData.daily[i].wind_deg,
                     humidityModel: parseInt(weatherData.daily[i].humidity),
                     uviModel: weatherData.daily[i].uvi
                })
            }
        }
    }

    // Podaci o temperaturi se ažuriraju ovisno o mjernoj jedinici pozivanjem funkcije za preračunavanje °C u °F.
    // Izvorno se podaci dohvaćaju u °C pa je funkcija convertTo(units, value) implementirana u skladu s tim.
    // Poziva se pritiskom na gumb UnitsToggleButton.
    function updateTemperatureData() {

        for (var i in weatherData.daily) {
            if (Number(i) > 0) { // današnja prognoza se ne prikazuje (weatherData.daily[0])
                sevenDaysListModel.setProperty(i-1, "temperatureMinModel", Math.floor(Utils.convertTo(units, weatherData.daily[i].temp.min)) + "°")
                sevenDaysListModel.setProperty(i-1, "temperatureMaxModel", Math.floor(Utils.convertTo(units, weatherData.daily[i].temp.max)) + "°")
            }
        }
    }

}
