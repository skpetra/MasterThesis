import QtQuick 2.2
import QtQuick.Controls 2.4
import QtQuick.Layouts

import "../models"
import "../visualizations"
import "../visualizations/weather_conditions"
import "../visualizations/widgets"
import "../controls"

import "qrc:/js/utils.js" as Utils
import "qrc:/js/config.js" as Config

// Stranica za prikaz dostupnih podataka trenutne vremenske prognoze.
Page {

    id: currentWeatherPage
    objectName: "CurrentWeatherPage"

    // --- public properties ---
    property string cityName
    // api za sedam dana ne može dohvatiti prognozu preko imena grada
    // kao current prognoza pa su potrebne lon i lat da se preko njih dohvaća
    property double longitude
    property double latitude
    property string units: "celsius"
    // weatherData svojstvo je objekt dobiven iz stringa podataka u JSON formatu
    // svojstvo se inicijalizira na Component.onCompleted stranice
    property var weatherData

    signal unitsButtonToggled(string units)

    title: cityName

    onUnitsButtonToggled: function(units) {
        currentWeatherPage.units = units
        updateTemperatureData()
    }

    // scrollanje stranice
    ScrollView {
        id: scrollView

        anchors.fill: parent
        contentHeight: parent.height
        clip: true
        ScrollBar.vertical.policy : ScrollBar.AlwaysOn
        ScrollBar.vertical.opacity: 0
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

        CurrentWeatherWidget {
            id: currentWeatherWidget

            width: currentWeatherPage.width
            y: currentWeatherPage.height * 0.1
            //height: currentWeatherPage.height / 3
            widgetHeight: currentWeatherPage.height / 3
            cityName: currentWeatherPage.cityName

            onStateChanged: {
                //console.log("currentWeatherWidget.height: " + currentWeatherWidget.height)

                if(state === 'Details'){
                    scrollView.contentHeight += widgetHeight
                }
                else
                    scrollView.contentHeight -= widgetHeight
            }
        }

        Rectangle {
            id: listViewBox

            anchors.top: currentWeatherWidget.bottom
            width: parent.width * 0.9
            height: 120 //oneHourWidget.width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: parent.height * 0.02

            color: "transparent"

            ListModel {
                id: hourlyListModel
            }

            // scrollanje listviewa pomoću miša
            MouseArea {
                anchors.fill: parent
                onWheel: function (wheel) {
                    currentWeatherHourlyListView.flick(wheel.angleDelta.y * 6, 0)
                }
            }

            ListView {
                id: currentWeatherHourlyListView

                model: hourlyListModel
                anchors.fill: parent
                anchors.leftMargin: 15
                spacing: 10

                orientation: ListView.LeftToRight
                flickableDirection: Flickable.HorizontalFlick
                clip:true

                delegate: Rectangle {
                    width: 90 // 10 veće od oneHourWidget zbog nekih elemenata npr sunca
                    height: 140
                    color: "transparent"

                    OneHourWidget {
                        id: oneHourWidget

                        hour: formattedHour
                        temperature: temp
                        weatherCode: code
                        weatherIcon: icon
                    }
                }
            }
        }

    //    Rectangle {
    //        id: rectSeparator
    //        anchors.top: listViewBox.bottom
    //        //anchors.topMargin: parent.height * 0.03
    //        //anchors.horizontalCenter: currentWeatherPage.horizontalCenter
    //        width: currentWeatherPage.width * 0.9
    //        height: 1
    //        color: "blue"
    //    }

        Component.onCompleted: {
            //console.log("CURRENT WEATHER " + longitude + " " + latitude)
        }
    }

    // Component.onCompleted is an attached signal handler.
    // It is often used to execute some JavaScript code when its creation process is complete.
    Component.onCompleted: {

        // Podaci o vremenu (current, hourly, daily) za jedan grad dohvaćaju se samo jednom po odabranom gradu na suggestionboxu za odabir grada.
        // inače se prikazuju već prije dohvaćeni podaci (npr. koji su bili poslani stranici SevenDaysWeatherPage).
        if (typeof weatherData === "undefined") {
            console.log("Dohvaćam nove podatke: " + "https://api.openweathermap.org/data/2.5/onecall?lat=" + latitude + "&lon=" + longitude + "&appid=" + Config.api_key + "&units=metric")

            var xhr = new XMLHttpRequest;
            xhr.open("GET", "https://api.openweathermap.org/data/2.5/onecall?lat=" + latitude + "&lon=" + longitude + "&appid=" + Config.api_key + "&units=metric");
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    var obj = JSON.parse(xhr.responseText);
                    weatherData = obj
                    setWeatherData(obj)
                }
            }
            xhr.send();
        }
        else
            setWeatherData(weatherData)

    }


    // --- private functions ---

    // Postavljanje svih svojstava objekata na CurrentWeatherPage stranici koji ovise o dohvaćenim podacima.
    // Podaci se dohvaćaju odnosno šalju na Component.onCompleted CurrentWeatherPage stranice.
    function setWeatherData(obj){

        // ---------- currentWeatherWidget ----------
        currentWeatherWidget.temperature = Math.floor(Utils.convertTo(units, obj.current.temp)) + "°"
        currentWeatherWidget.feelsLike = Math.floor(Utils.convertTo(units, obj.current.feels_like)) + "°"
        Utils.setWeatherAnimation(currentWeatherWidget.weatherAnimation, obj.current.weather[0].id + "", obj.current.weather[0].icon, currentWeatherWidget.weatherAnimationDimensions, currentWeatherWidget.weatherAnimationDimensions)  // will trigger the onLoaded code when complete.


        // ---------- hourlyListModel -----------
        var x = new Date()
        var UTCseconds = (Math.floor(x.getTime()/1000) + x.getTimezoneOffset()*60) // current UTC
        UTCseconds += obj.timezone_offset // local utc
        //var curentHourLocal =  Utils.getTime(Math.floor(UTCseconds), "h")
        for (var i in obj.hourly) {
               if (Number(i) <= 24){
                    hourlyListModel.append({
                         formattedHour: Utils.getTime(obj.hourly[Number(i)].dt + obj.timezone_offset, "hh"),
                         code: obj.hourly[Number(i)].weather[0].id + "",
                         icon: obj.hourly[Number(i)].weather[0].icon + "",
                         temp: Math.floor(Utils.convertTo(units, obj.hourly[Number(i)].temp)) + "°"
                    })
                }
        }
    }

    // Podaci o temperaturi se ažuriraju ovisno o mjernoj jedinici pozivanjem funkcije za preračunavanje °C u °F.
    // Izvorno se podaci dohvaćaju u °C pa je funkcija convertTo(units, value) implementirana u skladu s tim.
    // Poziva se pritiskom na gumb UnitsToggleButton.
    function updateTemperatureData() {

        // ------ currentWeatherWidget ------
        currentWeatherWidget.temperature = Math.floor(Utils.convertTo(units, weatherData.current.temp)) + "°"
        currentWeatherWidget.feelsLike = Math.floor(Utils.convertTo(units, weatherData.current.feels_like)) + "°"

        // ------ hourlyListModel ------
        for (var i in weatherData.hourly) {
            if(Number(i) <= 24)
                hourlyListModel.setProperty(Number(i), "temp", Math.floor(Utils.convertTo(units, weatherData.hourly[Number(i)].temp)) + "°")
        }
    }
}


