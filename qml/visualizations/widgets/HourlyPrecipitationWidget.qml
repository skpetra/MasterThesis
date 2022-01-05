import QtQuick 2.0
import QtQuick.Controls
import QtCharts 2.15

import "qrc:/js/utils.js" as Utils

// Element prikazuje postotak vlažnosti zraka po satima na stupčastom grafu.
Item {
    id: hourlyPrecipitationWidget

    // --- public properties ---
    property var weatherData

    // naslov grafičkog prikaza
    Text {
        text: qsTr("Probability of precipitation")
        width: parent.width
        font.bold: true
        color: "dimgray"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignBottom
        height: 20
    }

    ChartView {
        id: windChart
        width: parent.width
        height: parent.height
        backgroundColor: "transparent"

        antialiasing: true
        animationOptions: ChartView.SeriesAnimations
        animationDuration: 2000

        anchors {
            fill: parent
            leftMargin: 20
            rightMargin: 20
            topMargin: 0
            bottomMargin: -20
        }
        legend.visible: false

        // stupčasti graf
        BarSeries {
            id: barSeries

            labelsPosition: AbstractBarSeries.LabelsOutsideEnd
            labelsFormat: "@value%"
            labelsVisible: true

            axisX: BarCategoryAxis {
                id: xValueAxis
                color: "dimgray"
                labelsColor: "dimgray"
                gridVisible: false
            }

            axisY: ValuesAxis {
                id: yValueAxis
                min: 0
                max: 120 // prikaz postotka iznad stupca
                visible: false
                gridVisible: false
                labelsVisible: false
            }

            BarSet {
                id: barSet
                color: "lightgray"
                borderColor: "dimgray"
                labelColor: "dimgray"
                labelFont.pixelSize: 8
            }
        }
    }

    // Inicijalizacija osi koordinatnog sustava i postotka kojeg stupci prikazuju dobivenim podacima.
    Component.onCompleted: {
        var stringList = []
        for (var i in weatherData.hourly) {
            if (Number(i) > 0 && Number(i) <= 24){
                stringList.push(Utils.getLocalTime(weatherData.hourly[Number(i)].dt, weatherData.timezone_offset, "hh") + "") // x os
                barSet.append(weatherData.hourly[Number(i)].pop * 100) // postotak
            }
        }
        xValueAxis.categories = stringList
    }
}
