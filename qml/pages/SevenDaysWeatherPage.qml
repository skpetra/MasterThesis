import QtQuick 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.15

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
    // api za sedam dana ne može dohvatiti prognozu preko imena grada
    // kao current prognoza pa su potrebne lon i lat da se preko njih dohvaća
    property double longitude
    property double latitude
    property string units: "celsius"
    // weatherData svojstvo je objekt dobiven iz stringa podataka u JSON formatu
    property var weatherData

    signal unitsButtonToggled(string units)

    title: cityName
    clip: true

    onUnitsButtonToggled: function(units) {
        sevenDaysWeatherPage.units = units
        updateTemperatureData()
    }

    ListModel {
        id: sevenDaysListModel
    }

    ListView {

        id: sevenDaysListView

        anchors.fill: parent
        model: sevenDaysListModel
        snapMode: ListView.SnapToItem

        delegate: Component {
            id: sevenDaysDelegate

            LongTermDayWidget {
                width: sevenDaysListView.width
                // - mainItem -
                weekDay: weekDayModel
                date: dateModel
                weatherIcon: weatherIconModel
                weatherCode: weatherCodeModel
                temperatureMin: temperatureMinModel
                temperatureMax: temperatureMaxModel
                // - WindWidget -
                windSpeed: windSpeedModel
                windDirection: windDirectionModel
                windGust: windGustModel
                // - HumidityWidget -
                humidity: humidityModel
                dew: dewModel
            }
        }

        spacing: 8
        anchors.margins: 10

        Component.onCompleted: {
            setWeatherData()
        }
    }

    // --- private functions ---

    // Funkcija za postavljanje svojstava elemenata za prikaz prognoze na dan i idućih sedam dana.
    // Podaci se iščitavaju iz weatherData svojstva dobivenog od prethodne CurrentWeatherPage stranice.
    // Dohvaćeni podaci dodaju se u ListModel koji se prikazuje u ListViewu.
    function setWeatherData() {

        for (var i in weatherData.daily) {
            sevenDaysListModel.append({
                 weekDayModel: Utils.getWeekDay(weatherData.daily[i].dt),
                 dateModel: Utils.getDate(weatherData.daily[i].dt),
                 weatherCodeModel: weatherData.daily[i].weather[0].id,
                 weatherIconModel: weatherData.daily[i].weather[0].icon,
                 temperatureMinModel: Math.floor(Utils.convertTo(units, weatherData.daily[i].temp.min)) + "°", // todo: pretvorit int????
                 temperatureMaxModel: Math.floor(Utils.convertTo(units, weatherData.daily[i].temp.max)) + "°",
                 sunsetModel: weatherData.daily[i].sunset,
                 sunriseModel: weatherData.daily[i].sunrise,
                 windSpeedModel: weatherData.daily[i].wind_speed,
                 windDirectionModel: weatherData.daily[i].wind_deg,
                 windGustModel: weatherData.daily[i].wind_gust,
                 humidityModel: parseInt(weatherData.daily[i].humidity),
                 dewModel: parseInt(weatherData.daily[i].dew_point)
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
