import QtQuick 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.15

import "../../js/utils.js" as Utils
import "../../js/config.js" as Config

import "../controls"
import "../visualizations"
import "../visualizations/weather_conditions"
import "../visualizations/widgets"

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

    signal unitsButtonToggled(string units)

    title: cityName
    clip: true


    onUnitsButtonToggled: function(units) {
        sevenDaysWeatherPage.units = units
        updateTemperatureData(cityName)
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
            requestWeatherData(cityName)
        }
    }


    // --- private functions ---

    // Funkcija za dohvat podataka o vremenskoj prognozi na dan i idućih sedam dana preko JSON formata.
    // Dohvaćeni podaci dodaju se u ListModel koji se prikazuje u ListViewu.
    function requestWeatherData(cityName) {
        var xhr = new XMLHttpRequest;
        xhr.open("GET", "https://api.openweathermap.org/data/2.5/onecall?lat=" + latitude + "&lon=" + longitude + "&appid=" + Config.api_key + "&exclude=current,minutely,hourly,alerts" + ( units ? "&units=" + Utils.encodeUnits(units) : ""));
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                console.log(xhr.responseText); // ispisuje dohvaćeni json tekst
                var obj = JSON.parse(xhr.responseText);

                for (var i in obj.daily) {
                    sevenDaysListModel.append({
                                     weekDayModel: Utils.getWeekDay(obj.daily[i].dt),
                                     dateModel: Utils.getDate(obj.daily[i].dt),
                                     weatherCodeModel: obj.daily[i].weather[0].id,
                                     weatherIconModel: obj.daily[i].weather[0].icon,
                                     temperatureMinModel: Math.floor(obj.daily[i].temp.min) + "°", // pretvorit int????
                                     temperatureMaxModel: Math.floor(obj.daily[i].temp.max) + "°",
                                     sunsetModel: obj.daily[i].sunset,
                                     sunriseModel: obj.daily[i].sunrise,
                                     windSpeedModel: obj.daily[i].wind_speed,
                                     windDirectionModel: obj.daily[i].wind_deg,
                                     windGustModel: obj.daily[i].wind_gust,
                                     humidityModel: parseInt(obj.daily[i].humidity),
                                     dewModel: parseInt(obj.daily[i].dew_point)
                                 })
                }
            }
        }
        xhr.send();
    }

    // Funkcija za dohvat podataka o temperaturi. Poziva se pritiskom na UnitsToggleButton
    // i služi za ažuriranje temperaturnih podataka ovisno o mjernoj jedinici.
    function updateTemperatureData(cityName) {
        var xhr = new XMLHttpRequest;
        xhr.open("GET", "https://api.openweathermap.org/data/2.5/onecall?lat=" + latitude + "&lon=" + longitude + "&appid=" + Config.api_key + "&exclude=current,minutely,hourly,alerts" + ( units ? "&units=" + Utils.encodeUnits(units) : ""));
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                var obj = JSON.parse(xhr.responseText);

                for (var i in obj.daily) {
                    sevenDaysListModel.setProperty(i, "temperatureMinModel", Math.floor(obj.daily[i].temp.min) + "°")
                    sevenDaysListModel.setProperty(i, "temperatureMaxModel", Math.floor(obj.daily[i].temp.max) + "°")

                }
            }
        }
        xhr.send();
    }
}
