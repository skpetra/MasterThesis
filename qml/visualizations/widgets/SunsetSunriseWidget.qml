import QtQuick 2.1
import QtQuick.Layouts 1.15 // The module is new in Qt 5.1 and requires Qt Quick 2.1.

// Element prikazuje podatke o izlasku i zalasku sunca.
// Sastoji se od naslova widgeta, te tekstualnih podataka o vremenu izlaska i zalaska sunca i njihovih ikona posloženih u grid.
// Predviđeni omjer širine i visine elementa je: visina = širina * 0.85.
Item {

    id: sunsetSunriseWidget

    // --- public properties ---
    property string sunset
    property string sunrise

    implicitWidth: 150
    implicitHeight: 130

    // naslov widgeta
    Item {
        id: widgetTitle
        width: parent.width
        height: parent.height * 0.2

        Text {
            text: qsTr("Sunrise and Sunset")
            font.bold: true
            color: "dimgray"
            anchors.centerIn: parent
        }
    }

    // ikone i podaci
    GridLayout {
        width: parent.width
        height: parent.height - widgetTitle.height
        columns: 2
        anchors.bottom: parent.bottom

        Rectangle {
            id: sunriseIcon
            width: Math.min(parent.height, parent.width) / 3.5
            height: width
            radius: width / 2
            color: "gold"
            Layout.leftMargin: 25
            Layout.rightMargin: -15
            Layout.topMargin: 10

            Image{
                height: parent.height / 1.5
                width: parent.width / 1.5
                source: "qrc:/resources/icons/topArrow.png"
                anchors.centerIn: parent
            }
        }

        Text {
            id: sunriseText
            text: sunrise
            font.pixelSize: 15
            color: "dimgray"
            Layout.topMargin: 10
        }

        Rectangle {
            id: sunsetIcon
            width: Math.min(parent.height, parent.width) / 3.5
            height: width
            radius: width / 2
            color: "gold"
            Layout.leftMargin: 25
            Layout.rightMargin: -15

            Image{
                height: parent.height / 1.5
                width: parent.width / 1.5
                source: "qrc:/resources/icons/bottomArrow.png"
                anchors.centerIn: parent
            }
        }

        Text {
            id: sunsetText
            text: sunset
            font.pixelSize: 15
            color: "dimgray"
        }
    }
}
