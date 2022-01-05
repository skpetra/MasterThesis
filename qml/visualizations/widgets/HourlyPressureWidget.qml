import QtQuick 2.0
import QtQuick.Controls
import QtCharts

import "qrc:/js/utils.js" as Utils

// Element prikazuje tlak zraka po satima na linijskom grafu gdje je os x vremenska,
// odnosno prikazuje podatke o satu, a na osi y prikazan tlak zraka.
Item {

    id: hourlyPressureWidget

    // --- public properties ---
    property var weatherData

    // naslov grafičkog prikaza
    Text {
        id: chartTitle
        text: qsTr("Air pressure (hPa)")
        width: parent.width
        height: 20
        font.bold: true
        color: "dimgray"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignBottom
    }

    ChartView {
        id: pressureChart
        width: parent.width
        height: parent.height

        antialiasing: true
        backgroundColor: "transparent"
        backgroundRoundness: 0
        anchors {
            fill: parent
            leftMargin: 20
            rightMargin: 20
            topMargin: 0
            bottomMargin: -20
        }
        legend.visible: false

        // graf
        LineSeries {
            id: lineSeries
            width: 2
            color: "lightgray"

            pointLabelsVisible: true
            pointLabelsFormat: "@yPoint"
            pointLabelsColor: "dimgray"

            axisX: DateTimeAxis { // min i max se postavljaju dinamički ovisno o trenutnom satu koji je ujedno i minimum x vrijednosti
                id: xDateTimeAxis
                tickCount: 27 // od (sad-1sat) do (+24sata+1)
                format: "hh"
                color: "dimgray"
                labelsColor: "dimgray"
                gridVisible: false
            }

            axisY: ValuesAxis { // min i max se postavljaju dinamički ovisno minimalnom i maksimalnom tlaku zraka u narednih 24 sata
                id: yValueAxis
                visible: false
                gridVisible: false
                labelsVisible: false
            }
        }

        // Točke na grafu koje će se prikazivati.
        ScatterSeries {
            id: scatterSeries
            axisX: lineSeries.axisX
            axisY: lineSeries.axisY
            markerSize: 5
            color: "gold"
            borderWidth: 0
            borderColor: "gold"
        }
    }

    // Inicijalizacija osi koordinatnog sustava i točki koje će biti prikazane na grafu.
    Component.onCompleted: {

        // postavljanje min i max svojstava osi koordinatnog sustava ovisno o podacima koji se prikazuju
        xDateTimeAxis.min = Utils.getDateTime(weatherData.hourly[0].dt + weatherData.timezone_offset - 3600) // trenutno vrijeme - 1h
        xDateTimeAxis.max = Utils.getDateTime(weatherData.hourly[24].dt + weatherData.timezone_offset + 3600) // trenutno vrijeme + 24h + 1h
        // pronalazak min i max vrijednosti tlaka zraka u narednih 24 sata koja se prikazuju
        yValueAxis.max = weatherData.hourly[0].pressure
        yValueAxis.min = weatherData.hourly[0].pressure
        for (var i in weatherData.hourly) {
           if (Number(i) > 0 && Number(i) <= 25) { // podaci se prikazuju od sljedećeg sata (Number(i) > 0) pa narednih 24 sata
               if (yValueAxis.max < weatherData.hourly[Number(i)].pressure)
                    yValueAxis.max = weatherData.hourly[Number(i)].pressure
               if (yValueAxis.min > weatherData.hourly[Number(i)].pressure)
                    yValueAxis.min = weatherData.hourly[Number(i)].pressure
            }
        }
        yValueAxis.max += 5
        yValueAxis.min -= 1

        // Dodavanje podataka potrebnih za iscrtavanje grafa.
        for (var j in weatherData.hourly) {
           if (Number(i) > 0 && Number(i) <= 25) { // podaci se prikazuju od sljedećeg sata (Number(i) > 0) pa narednih 24 sata
               lineSeries.append(Utils.getDateTime(weatherData.hourly[Number(j)].dt + weatherData.timezone_offset), weatherData.hourly[Number(j)].pressure)
               scatterSeries.append(Utils.getDateTime(weatherData.hourly[Number(j)].dt + weatherData.timezone_offset), weatherData.hourly[Number(j)].pressure)
           }
        }
    }
}
