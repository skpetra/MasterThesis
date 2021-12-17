import QtQuick 2.2
import QtQuick.Controls 2.4
import QtQuick.Layouts
import "../models"
import "../visualizations"
import "../visualizations/weather_conditions"
import "../visualizations/widgets"
import "qrc:/js/utils.js" as Utils
import "qrc:/js/config.js" as Config
import "../controls"

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
            // ostala svojstva postavlja funkcija requestCurrentWeatherData()

                    //        weatherCode: weather_code
                    //        weatherIcon: weather_icon

                    //        currentTemperature: Math.floor(temperature) + "°"
                    //        feelsLikeTemperature: Math.floor(feels_like) + "°"

    //        Component.onCompleted: {
    //            requestCurrentWeatherData()
    //        }


            onStateChanged: {
                console.log("currentWeatherWidget.height: " + currentWeatherWidget.height)

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

                Component.onCompleted: {
                    requestWeatherData()
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

    }

    // --- private functions ---

    function updateTemperatureData() {
        var xhr = new XMLHttpRequest;
        xhr.open("GET", "https://api.openweathermap.org/data/2.5/onecall?lat=" + latitude + "&lon=" + longitude + "&appid=" + Config.api_key + "&exclude=daily,minutely,alerts" + ( units ? "&units=" + Utils.encodeUnits(units) : ""));
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                var obj = JSON.parse(xhr.responseText);

                currentWeatherWidget.temperature = Math.floor(obj.current.temp) + "°"
                currentWeatherWidget.feelsLike = Math.floor(obj.current.feels_like) + "°"

                for (var i in obj.hourly) {

                    if(Number(i) <= 24)
                        hourlyListModel.setProperty(Number(i), "temp", Math.floor(obj.hourly[Number(i)+1].temp) + "°")
                }

            }
        }
        xhr.send();
    }



    function requestWeatherData() {
        var xhr = new XMLHttpRequest;

        console.log("ŠIRINA: " + longitude + " " + latitude)
        xhr.open("GET", "https://api.openweathermap.org/data/2.5/onecall?lat=" + latitude + "&lon=" + longitude + "&appid=" + Config.api_key + "&exclude=current,minutely,daily,alerts" + ( units ? "&units=" + Utils.encodeUnits(units) : ""));
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                //console.log(xhr.responseText); // ispisuje dohvaćeni json tekst
                var obj = JSON.parse(xhr.responseText);

                var x = new Date()
                var UTCseconds = (Math.floor(x.getTime()/1000) + x.getTimezoneOffset()*60) // current UTC

                //console.log(UTCseconds)

                UTCseconds += obj.timezone_offset // local utc

                console.log(UTCseconds)

               console.log("UTCseconds2", Utils.getTime(Math.floor(UTCseconds), "h"))
                var curentHourLocal =  Utils.getTime(Math.floor(UTCseconds), "h")

                console.log("curentHourLocal " + curentHourLocal)

                var br = 0
                for (var i in obj.hourly) {
                    console.log(Number(i) + "  " + Utils.getTime(obj.hourly[Number(i)].dt + obj.timezone_offset, "hh") + " " + curentHourLocal )
                       if (Number(i) <= 24){ // samo za 24 sata, obj.hourly[0] je 01 sat, i->i+1 sat
                           //++br
                           console.log(Utils.getTime(obj.hourly[i].dt, "hh"))
                            hourlyListModel.append({
                                             formattedHour: Utils.getTime(obj.hourly[Number(i)].dt + obj.timezone_offset, "hh"), // +1 jer od ljedećeg sata idu po satima
                                             code: obj.hourly[Number(i)].weather[0].id + "",
                                             icon: obj.hourly[Number(i)].weather[0].icon + "",
                                             temp: Math.floor(obj.hourly[Number(i)].temp) + "°"
                                         })
                    }
                }


            }

            console.log(currentWeatherHourlyListView.contentWidth)
        }
        xhr.send();
    }

}


