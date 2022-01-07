import QtQuick 2.2
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts

import "../visualizations"
import "../visualizations/weather_conditions"
import "../visualizations/widgets"
import "../controls"

import "qrc:/js/utils.js" as Utils
import "qrc:/js/config.js" as Config

// Stranica za prikaz dostupnih podataka trenutne vremenske prognoze.
// Stranica se logički sastoji od 4 dijela
//      - toolbar sa mogućnostima povratka na HomePage, odabira prikaza trenutne ili sedmodnevne prognoze, odabira novog grada preko searchboxa te promjenu tepmetaturne jedinice (°C/°F)
//      - collapsible područje za prikaz trenutnih vremenskih značajki (ime grada, animacija vremenskih uvjeta, trenutna i feels like temperatura)
//        i detalja trenutne prognoze (izlazak/zalazak sunca, vlaga, vjetar, uvi)
//      - listview element za prikaz temperature i vremenskih uvjeta po satima
//      - panel za prikaz grafa koji prikazuje detalje o vjetru, padalinama i tlaku zraka po satima ovisno o odabiru
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

    Rectangle {
        id: backgroundRectangle
        anchors.fill: parent
        color: "#4682b4"
    }

    Spinner {
        anchors.centerIn: parent
        running: typeof currentWeatherPage.weatherData === "undefined"

        onRunningChanged: {
            if (running === true)
                parent.opacity = 0.9
            else
                parent.opacity = 1
        }
    }
    Behavior on opacity { OpacityAnimator { duration: 50 } }

    // scrollanje stranice
    ScrollView {
        id: scrollView

        anchors.fill: parent
        contentHeight: parent.height
        clip: true
        ScrollBar.vertical.policy : ScrollBar.AlwaysOn
        ScrollBar.vertical.visible: false
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

        CurrentWeatherWidget {
            id: currentWeatherWidget
            width: currentWeatherPage.width
            y: currentWeatherPage.height * 0.1
            widgetHeight: currentWeatherPage.height / 3.9
            cityName: currentWeatherPage.cityName

            // resizeanje animacije vremenskih uvjeta ovisno o veličini prozora
            onWidgetHeightChanged: {
                if (typeof weatherData !== "undefined")
                    Utils.setWeatherAnimation(currentWeatherWidget.weatherAnimation, weatherData.current.weather[0].id + "", weatherData.current.weather[0].icon, Math.min(currentWeatherWidget.widgetHeight, currentWeatherWidget.width), Math.min(currentWeatherWidget.widgetHeight, currentWeatherWidget.width))
            }
            onWidthChanged: {
                if (typeof weatherData !== "undefined")
                    Utils.setWeatherAnimation(currentWeatherWidget.weatherAnimation, weatherData.current.weather[0].id + "", weatherData.current.weather[0].icon, Math.min(currentWeatherWidget.widgetHeight, currentWeatherWidget.width), Math.min(currentWeatherWidget.widgetHeight, currentWeatherWidget.width))
            }

            onStateChanged: {
                if(state === 'Details')
                    scrollView.contentHeight += widgetHeight
                else
                    scrollView.contentHeight -= widgetHeight
            }            
        }

        // element za prikaz liste temperature i vremenskih uvjeta po satima
        Rectangle {
            id: listViewBox
            anchors.top: currentWeatherWidget.bottom
            width: parent.width * 0.9
            height: 120 //oneHourWidget.width // todo
            color: "transparent"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: parent.height * 0.055  // bottom margin - HourlyDetailsWidget.topMargin

            // scrollanje listviewa pomoću miša
            MouseArea {
                anchors.fill: parent
                onWheel: function (wheel) {
                    currentWeatherHourlyListView.flick(wheel.angleDelta.y * 6, 0)
                }
            }

            ListModel {
                id: hourlyListModel
            }

            ListView {
                id: currentWeatherHourlyListView

                model: hourlyListModel
                anchors.fill: parent
                anchors.leftMargin: 15
                spacing: 10

                orientation: ListView.LeftToRight
                flickableDirection: Flickable.HorizontalFlick
                clip: true

                delegate: Rectangle {
                    width: 90 // 10 veće od oneHourWidget zbog nekih elemenata npr sunca // todo
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

        HourlyDetailsWidget {
            id: hourlyDetailsWidget
            width: parent.width * 0.9
            height: 200 // fiksne visine
            anchors.top: listViewBox.bottom
            anchors.topMargin: parent.height * 0.055
            anchors.horizontalCenter: parent.horizontalCenter

            onWidgetTabChanged: function (_tab) { setChartData(_tab) }
        }
    }

    // Component.onCompleted is an attached signal handler.
    // It is often used to execute some JavaScript code when its creation process is complete.
    Component.onCompleted: {

        // Podaci o vremenu (current, hourly, daily) za jedan grad dohvaćaju se samo jednom po odabranom gradu na suggestionboxu za odabir grada.
        // inače se prikazuju već prije dohvaćeni podaci (npr. koji su bili poslani stranici SevenDaysWeatherPage).
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


    // --- private functions ---

    // Postavljanje svih svojstava objekata na CurrentWeatherPage stranici koji ovise o dohvaćenim podacima.
    // Podaci se dohvaćaju odnosno šalju na Component.onCompleted CurrentWeatherPage stranice.
    function setWeatherData(obj){

        // ---------- CurrentWeatherWidget ----------
        currentWeatherWidget.temperature = Math.floor(Utils.convertTo(units, obj.current.temp)) + "°"
        currentWeatherWidget.feelsLike = Math.floor(Utils.convertTo(units, obj.current.feels_like)) + "°"
        Utils.setWeatherAnimation(currentWeatherWidget.weatherAnimation, obj.current.weather[0].id + "", obj.current.weather[0].icon, currentWeatherWidget.weatherAnimationDimensions, currentWeatherWidget.weatherAnimationDimensions)  // will trigger the onLoaded code when complete.
        // --- DailyWindWidget na CurrentWeatherWidget ---
        currentWeatherWidget.windDetails.speed = obj.current.wind_speed
        currentWeatherWidget.windDetails.direction = obj.current.wind_deg
        // --- HumidityWidget na CurrentWeatherWidget ---
        currentWeatherWidget.humidityDetails.percent = obj.current.humidity
        // --- UVIndexWidget na CurrentWeatherWidget ---
        currentWeatherWidget.uviDetails.uvi = obj.current.uvi
        // --- SunsetSunriseWidget na CurrentWeatherWidget ---
        currentWeatherWidget.sunDetails.sunrise = Utils.getLocalTime(obj.current.sunrise, obj.timezone_offset, "hh:mm:ss") // šalje se unaprijed izračunato lokalno vrijeme izlaska sunca
        currentWeatherWidget.sunDetails.sunset = Utils.getLocalTime(obj.current.sunset, obj.timezone_offset, "hh:mm:ss") // šalje se unaprijed izračunato lokalno vrijeme zalaska sunca

        // ---------- HourlyListModel -----------
        for (var i in obj.hourly) {
            if (Number(i) > 0 && Number(i) <= 25) { // podaci se prikazuju od sljedećeg sata (Number(i) > 0) pa narednih 24 sata
                hourlyListModel.append({
                    formattedHour: Utils.getLocalTime(obj.hourly[Number(i)].dt, obj.timezone_offset, "hh"),
                    code: obj.hourly[Number(i)].weather[0].id + "",
                    icon: obj.hourly[Number(i)].weather[0].icon + "",
                    temp: Math.floor(Utils.convertTo(units, obj.hourly[Number(i)].temp)) + "°"
                })
            }
        }

        // učitavanje pripadnog grafa ovisno o selektiranom tabu
        setChartData(hourlyDetailsWidget._tab)
    }

    // Funkcija učitava graf sa željenim podacima ovisno o selektiranom tabu
    function setChartData(tab) {
        // ---------- HourlyWindWidget ----------
        if (tab === "wind")
            hourlyDetailsWidget.loader.setSource("qrc:/qml/visualizations/widgets/HourlyWindWidget.qml",
                                                {
                                                    weatherData: currentWeatherPage.weatherData
                                                })
        // ---------- HourlyPrecipitationWidget ----------
        else if (tab === "precipitation")
            hourlyDetailsWidget.loader.setSource("qrc:/qml/visualizations/widgets/HourlyPrecipitationWidget.qml",
                                                {
                                                    weatherData: currentWeatherPage.weatherData
                                                })
        // ---------- HourlyPressureWidget ----------
        else if (tab === "pressure")
            hourlyDetailsWidget.loader.setSource("qrc:/qml/visualizations/widgets/HourlyPressureWidget.qml",
                                                {
                                                    weatherData: currentWeatherPage.weatherData
                                                })
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
            if(Number(i) > 0 && Number(i) <= 25) // podaci se prikazuju od sljedećeg sata (Number(i) > 0) pa narednih 24 sata
                hourlyListModel.setProperty(Number(i)-1, "temp", Math.floor(Utils.convertTo(units, weatherData.hourly[Number(i)].temp)) + "°") // podaci u listi kreću od 0 (Number(i)-1)
        }
    }
}
