import QtQuick 6.0
import QtQuick.Controls
import QtCharts

import "qrc:/js/utils.js" as Utils

// Element prikazuje brzinu vjetra po satima na linijskom grafu gdje je os x vremenska, odnosno prikazuje podatke o satu,
// dok je na osi y prikazana brzina vjetra.
Item {

    id: hourlyDetailsWidget

    // --- public properties ---
    property var weatherData

    // naslov grafičkog prikaza
    Text {
        text: qsTr("Wind speed (m/s)")
        width: parent.width
        height: 20
        font.bold: true
        color: "dimgray"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignBottom
    }

    ChartView {
        id: windChart
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
            color: "dimgray"

            axisX: DateTimeAxis { // min i max se postavljaju dinamički ovisno o trenutnom satu koji je ujedno i minimum x vrijednosti
                id: xDateTimeAxis
                tickCount: 25 // sad + 24 sata
                format: "hh"
                color: "dimgray"
                labelsColor: "dimgray"
                gridVisible: false
            }

            axisY: ValuesAxis { // max se postavlja dinamički ovisno o maksimalnoj vrijednosti brzine vjetra u idućih 24 sata
                id: yValueAxis
                min: 0
                tickInterval: 1
                tickType : ValueAxis.TicksDynamic
                visible: false
                gridVisible: false
                labelsVisible: false
            }
        }

        // obojano područje ispod grafa
        AreaSeries {
            upperSeries: lineSeries
            axisX: lineSeries.axisX
            axisY: lineSeries.axisY
            color: "lightgray"
        }


        // model koji čuva potrebne podatke o točkama na grafu
        // x, y - koordinate točke na grafu
        // windDirection - smjer vjetra potreban za postavljanje strelice za prikaz smjera
        ListModel {
            id: pointsModel
        }


        // postavljanje strelica za prikaz smjera vjetra i oznake za brzinu vjetra na graf
        Repeater {

            model: pointsModel

            Rectangle{
                id: windDirectionRectangle
                width: 14
                height: 27
                color: "transparent"

                property real parentWidth: windChart.width
                property real parentHeight: windChart.height

                onParentWidthChanged: {
                    windChart.adjustPosition(this, index)
                    pointsModel.get(index).windDirection
                }
                onParentHeightChanged: windChart.adjustPosition(this, index, windDirectionRectangle.height - windDirectionImage.height / 2)
                antialiasing: true

                Text {
                    id: windSpeedText
                    width: 15
                    height: 10
                    text: pointsModel.get(index).y
                    font.pixelSize: 10
                    color: "dimgray"
                    anchors.top: parent.top
                    horizontalAlignment: Text.AlignHCenter
                }

                Image {
                    id: windDirectionImage
                    width: 14
                    height: 14
                    source: "qrc:/resources/icons/windDirection.png"
                    anchors.bottom: parent.bottom

                    transform: Rotation {
                        origin.x: windDirectionImage.width / 2
                        origin.y: windDirectionImage.height / 2

                        SequentialAnimation on angle {
                            running: true
                            NumberAnimation {
                                to: windDirection
                                duration: 1500
                            }
                        }
                    }
                }
            }
        }

        // --- private functions ---
        // Funkcije za postavljanje strelica odnosno oznake za brzinu vjetra na određenu mozciju na grafu.

        function adjustPosition(item, index, yCenterArrow) {
            let point = Qt.point(pointsModel.get(index).x, pointsModel.get(index).y)
            let position = windChart.mapToPosition(point, lineSeries)
            item.x = position.x - item.width / 2
            item.y = position.y - yCenterArrow
        }

        function adjustValue(item, index) {
            let position = Qt.point(item.x + item.width / 2, item.y + item.height / 2)
            let point = windChart.mapToValue(position, lineSeries)
            pointsModel.setProperty(index, "y", point.y)  // Change only Y-coordinate
            lineSeries.replace(lineSeries.at(index).x, lineSeries.at(index).y, // old
                               lineSeries.at(index).x, point.y)                // new
        }

    }

    // Inicijalizacija osi koordinatnog sustava i točki koje će biti prikazane na grafu.
    Component.onCompleted: {

        // postavljanje min i max svojstava osi koordinatnog sustava ovisno o podacima koji se prikazuju
        xDateTimeAxis.min = Utils.getDateTime(weatherData.hourly[0].dt + weatherData.timezone_offset) // trenutno vrijeme po lokalnom vremenu
        xDateTimeAxis.max = Utils.getDateTime(weatherData.hourly[24].dt + weatherData.timezone_offset) // trenutno vrijeme po lokalnom vremenu + 24 sata
        // pronalazak max vrijednosti brzine vjetra u narednih 24 sata koja se prikazuju
        for (var i in weatherData.hourly) {
           if (Number(i) <= 24){
               if (yValueAxis.max < weatherData.hourly[Number(i)].wind_speed.toFixed(1))
                    yValueAxis.max = weatherData.hourly[Number(i)].wind_speed.toFixed(1)
            }
        }
        yValueAxis.max += yValueAxis.max * 0.2 // povećavanje razmaka na vrhu grafa

        // Dodavanje podataka potrebnih za iscrtavanje grafa.
        // Brzina vjetra zaokružena je na jednu decimalu.
        for (var j in weatherData.hourly) {
           if (Number(j) <= 24){
               lineSeries.append(Utils.getDateTime(weatherData.hourly[Number(j)].dt + weatherData.timezone_offset), weatherData.hourly[Number(j)].wind_speed.toFixed(1))
               pointsModel.append({
                                        x: Utils.getDateTime(weatherData.hourly[Number(j)].dt + weatherData.timezone_offset),
                                        y: weatherData.hourly[Number(j)].wind_speed.toFixed(1),
                                        windDirection: weatherData.hourly[Number(j)].wind_deg
                                  })
           }
        }
    }
}
