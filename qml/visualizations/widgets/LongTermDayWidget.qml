import QtQuick 2.2
import QtQuick.Layouts 1.15

import "qrc:/js/utils.js" as Utils

// LongTermDayWidget.qml element prikazuje podatke o vremenskoj prognozi za jedan dan u sedmodnevnom vremenskom prikazu.
// Element je "collapsible", i sastoji se od 2 dijela, gornjeg pravokutnika koji prikazuje osnovne podatke - dan,
// vremensku animaciju i min-max dnevnu temperaturu, te donjeg pravokutnika s detaljima koji se otvara na klik gornjeg pravokutnika.
// Detalji sadrže zasebne elemente s podacima o vjetru, vlažnosti zraka, padalinama...
Rectangle {

    id: longTermDayWidget

    // --- public properties ---
    property int mainItemHeight: 150 // visina osnovnog elementa bez prikaza detalja
    // - mainItem -
    property string weekDay
    property string date
    property string weatherIcon
    property string weatherCode
    property string temperatureMin
    property string temperatureMax
    // - WindWidget -
    property string windSpeed
    property string windDirection
    property string windGust
    // - HumidityWidget -
    property int humidity
    property int dew

    height: mainItemHeight
    border.width: 0.5

    // element prikazuje osnovne podatke o vremenu na određeni dan
    // - dan, datum, vremensku animaciju i min-max dnevnu temperaturu
    Item {

        id: mainItem

        width: parent.width
        height: mainItemHeight
        anchors.top: parent.top

        // dan i datum vremenske prognoze
        Column {
            anchors.verticalCenter: parent.verticalCenter
            Text { text: weekDay }
            Text { text: date }
        }

        // animacija vremenskih uvjeta
        Rectangle {

            id: weatherAnimationItem

            width: mainItemHeight - 2 * anchors.margins
            height: mainItemHeight - 2 * anchors.margins
            anchors.centerIn: parent
            anchors.margins: mainItemHeight * 0.05
            color: "transparent"

            Loader {
                id: weatherAnimationLoader

                Component.onCompleted: {
                    Utils.setWeatherAnimation(weatherAnimationLoader, weatherCode, weatherIcon, weatherAnimationItem.width, weatherAnimationItem.height)
                }
            }
        }

        // min-max temperatura
        GridLayout {
            columns: 2
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right

            Text {
                text: temperatureMax
                Layout.column: 0
                Layout.row: 0
                Layout.alignment: Qt.AlignCenter
            }

            Text {
                text: "High"
                Layout.column: 0
                Layout.row: 1
                Layout.alignment: Qt.AlignCenter
            }

            Text {
                text: temperatureMin
                Layout.column: 1
                Layout.row: 0
                Layout.alignment: Qt.AlignCenter
            }

            Text {
                text: "Low"
                Layout.column: 1
                Layout.row: 1
                Layout.alignment: Qt.AlignCenter
            }
        }
    }

    Image{
        id: arrowDown
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        height: 8
        width: 8
        source: "qrc:/resources/icons/triangleBottomIcon.png"
        opacity: 0.2

        Behavior on rotation {
             NumberAnimation { duration: 250 }
        }

    }

    // element prikazuje detaljnije podatke o vremenu na određeni dan
    // vjetar, vlaga,
    Item {
        id: detailsItem

        width: mainItem.width
        height: 0
        anchors.top: mainItem.bottom

        opacity: 0 // detalji na početnu nisu vidljivi
        anchors.topMargin: 10 // razmak između elemenata liste je 10 pa se gornja margina postavlja da element ne viri između elemenata liste

        WindWidget {
            id: windWidget
            height: longTermDayWidget.mainItemHeight - detailsItem.anchors.topMargin
            width: longTermDayWidget.mainItemHeight * 1.5

            speed: windSpeed
            direction: windDirection
            gust: windGust
            isVisible: false // na početku su svi detalji skriveni

        }

        HumidityWidget {
            id: humidityWidget
            anchors.left: windWidget.right

            percent: humidity
            dewPoint: dew // todo - dodaj u prikaz
            isVisible: false // na početku su svi detalji skriveni
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            longTermDayWidget.state = longTermDayWidget.state === 'Details' ? '' : 'Details'
            // zaustavljanje vjetrenjača kad element nije vidljiv
            windWidget.isVisible = longTermDayWidget.state === 'Details' ? true : false
            // odgađanje pokretanja animacije koja prikazuje postotak vlažnosti dok element ne postane vidljiv
            humidityWidget.isVisible = longTermDayWidget.state === 'Details' ? true : false
        }
    }

    states: State {
        name: "Details"
        // Make details visible
        PropertyChanges { target: detailsItem; opacity: 1 }
        PropertyChanges { target: detailsItem; height: longTermDayWidget.mainItemHeight }
        // "otvaranje" pravokutnika za prikaz detalja
        PropertyChanges { target: longTermDayWidget; height: mainItemHeight * 2 }
        PropertyChanges { target: arrowDown; rotation: 180 }
    }

    transitions: Transition {
        //Make the state changes smooth
        NumberAnimation { duration: 250; property: "height" } // ili 300 mozda bolje - // "otvaranje" pravokutnika za prikaz detalja
        NumberAnimation { duration: 250; property: "opacity" }

    }
}
