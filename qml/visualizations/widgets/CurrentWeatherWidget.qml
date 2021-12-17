import QtQuick 2.0
import QtQuick.Layouts

import "qrc:/js/utils.js" as Utils
import "qrc:/js/config.js" as Config

// Centralni collapsible element za prikaz podataka o trenutnoj vremenskoj prognozi.
// Logički je podijeljen je na dva dijela, osnovne podatke - ime grada, animacija trenutnog vremena,
// trenutna i feels like temperatura, te dio s detaljima koji je inicijalno skriven.
// Klikom na osnovne podatke otvara se prikaz detalja kojeg je nakon pregleda moguće sakriti.
Item {

    id: currentWeatherWidget

    // --- public properties ---
    property alias temperature: currentTemperatureText.text
    property alias feelsLike: feelsLikeTemperatureText.text

    property string cityName
    property int widgetHeight

//    property string weatherCode
//    property string weatherIcon
//    property string currentTemperature
//    property string feelsLikeTemperature

    height: widgetHeight


    // --- osnovni podaci ---
    RowLayout{

        id: rowLayout
        width: parent.width * 0.9
        height: widgetHeight
        anchors.horizontalCenter: parent.horizontalCenter

        Text {          
            text: qsTr(cityName)
            height: parent.height
            font.bold: true
            font.pixelSize: 50
            fontSizeMode: Text.Fit
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            Layout.preferredWidth: rowLayout.width / 3
            Layout.maximumWidth: rowLayout.width / 3
        }

        Rectangle {
            height: rowLayout.height
            color: "transparent"
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: rowLayout.width / 3

            Rectangle {
                id: weatherAnimationItem

                width: rowLayout.height
                height: rowLayout.height
                color: "transparent"
                anchors.centerIn: parent

                Loader {
                    id: weatherAnimationLoader
                }
            }
        }

        Rectangle {
            id: temperatureGroupBox

            height: rowLayout.height
            color: "transparent"
            Layout.preferredWidth: rowLayout.width / 3

            Text {
                id: currentTemperatureText

                width: temperatureGroupBox.width / 2
                //text: currentTemperature
                font.bold: true
                font.pixelSize: 50
                fontSizeMode: Text.Fit
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                horizontalAlignment: Text.AlignRight
            }

            Text {
                id: feelsLikeTemperatureText

                //text: " " + feelsLikeTemperature
                font.bold: true
                font.pixelSize: 25
                fontSizeMode: Text.Fit

                color: "gray"
                width: temperatureGroupBox.width / 2
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
            }
        }
    }

    Image{
        id: arrowDown

        anchors.right: currentWeatherWidget.right
        anchors.rightMargin: (currentWeatherWidget.width - rowLayout.width) / 2
        anchors.bottom: currentWeatherWidget.bottom
        anchors.bottomMargin: 5
        height: 8
        width: 8
        source: "qrc:/resources/icons/triangleBottomIcon.png"
        opacity: 0.2

        Behavior on rotation {
             NumberAnimation { duration: 500 }
        }
    }

    // ------- -------

    // --- detalji ---
    Rectangle {
        id: detailsItem

        width: rowLayout.width
        height: 0
        opacity: 0
        color: "transparent"

        anchors.top: rowLayout.bottom
        anchors.horizontalCenter: rowLayout.horizontalCenter
    }

    // ------- -------

    Rectangle {
        id: rectSeparator
        anchors.bottom: currentWeatherWidget.bottom
        anchors.horizontalCenter: rowLayout.horizontalCenter
        width: rowLayout.width
        height: 1
        color: "blue"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            currentWeatherWidget.state = currentWeatherWidget.state === 'Details' ? '' : 'Details'
        }
    }

    states: State {
        name: "Details"
        PropertyChanges { target: detailsItem; opacity: 1 }
        // "otvaranje" pravokutnika za prikaz detalja
        PropertyChanges { target: detailsItem; height: widgetHeight * 1.5 }
        PropertyChanges { target: currentWeatherWidget; height: widgetHeight * 2.5 }
        PropertyChanges { target: arrowDown; rotation: 180 }
    }

    transitions: Transition {
        //Make the state changes smooth
        NumberAnimation { duration: 500; property: "height" }
        NumberAnimation { duration: 500; property: "opacity" }
    }

    Component.onCompleted: {
        requestCurrentWeatherData()
    }

    // --- private functions ---

    // Funkcija za dohvat podataka o trenutnoj prognozi preko JSON formata.
    // Dohvaćeni podaci pridružuju se svojstvima direktno.
    function requestCurrentWeatherData() {

        var xhr = new XMLHttpRequest;
        xhr.open("GET", "https://api.openweathermap.org/data/2.5/onecall?lat=" + latitude + "&lon=" + longitude + "&appid=" + Config.api_key + "&exclude=hourly,minutely,daily,alerts" + ( units ? "&units=" + Utils.encodeUnits(units) : ""));
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                console.log("DONE")
                var obj = JSON.parse(xhr.responseText);
                console.log( obj.current.weather[0].id+ "")
                console.log(obj.current.weather[0].icon+ "")
                // currentWeatherWidget
//                currentWeatherWidget.weatherCode = obj.current.weather[0].id + ""
//                currentWeatherWidget.weatherIcon = obj.current.weather[0].icon + ""
                currentTemperatureText.text = Math.floor(obj.current.temp) + "°"
                feelsLikeTemperatureText.text = Math.floor(obj.current.feels_like) + "°"

                Utils.setWeatherAnimation(weatherAnimationLoader, obj.current.weather[0].id + "", obj.current.weather[0].icon, weatherAnimationItem.width, weatherAnimationItem.height)  // will trigger the onLoaded code when complete.
            }
        }
        xhr.send();
    }
}