import QtQuick 2.0
import QtQuick.Layouts 1.2

import "qrc:/js/utils.js" as Utils

// Widget za prikaz liste elemenata koji sadrže podatke o vremenskoj prognozi po satima
// (sat, vremensku animaciju i temperaturu) unutar sljedećih 24 sata počevši od narednog
// sata trenutnog lokalnog vremena.
Rectangle {

    id: oneHourWidget

    // --- public properties ---
    property string hour
    property string weatherCode
    property string weatherIcon
    property string temperature

    implicitWidth: 60
    implicitHeight: 120
    color: "transparent"


    ColumnLayout {
        spacing: 5

        Text {
            text: hour
            font.pixelSize: 15
            color: "#252525"
            Layout.alignment: Qt.AlignHCenter
            horizontalAlignment: Text.AlignHCenter
        }

        Rectangle {
            id: weatherAnimationItem
            width: oneHourWidget.width
            height: width
            color: "transparent"
            Layout.alignment: Qt.AlignCenter

            Loader {
                id: weatherAnimationLoader
            }
        }

        Text {
            text: temperature
            font.pixelSize: 25
            color: "#252525"
            Layout.alignment: Qt.AlignCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }

    Component.onCompleted: {        
        Utils.setWeatherAnimation(weatherAnimationLoader, weatherCode, weatherIcon, weatherAnimationItem.width, weatherAnimationItem.height)  // will trigger the onLoaded code when complete.
    }
}
