import QtQuick 2.11
import QtQuick.Shapes 1.0
import "../basic"

// Element predstavlja komponentu koja prikazuje podatak o vlažnosti zraka.
// Sastoji se od kružnog luka od 300° koji učitava postotak vlažnosti zraka.
// Predviđeni omjer širine i visine elementa je: visina = širina * 0.85.
Rectangle {

    id: humidityWidget

    // --- public properties ---
    property int percent // dobiveni postotak vlažnosti zraka    
    property bool isVisible // svojstvo služi da se postotak krene učitavati tek nakon što je komponenta vidljiva

    implicitWidth: 150
    implicitHeight: 130

    color: "transparent"

    // naslov widgeta
    Item {
        id: widgetTitle
        width: parent.width
        height: parent.height * 0.2

        Text {
            text: qsTr("Humidity")
            font.bold: true
            color: "dimgray"
            anchors.centerIn: parent
        }
    }

    // element za prikaz vlažnosti zraka
    Item {
        width: parent.width
        height: humidityWidget.height - widgetTitle.height
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        // postotak vlažnosti
        Text {
            id: percentText
            text: "0%"
            color: "dimgray"
            font.pixelSize: 15
            anchors.centerIn: parent
        }

        // statični luk
        CircularArc {
            itemColor: "dimgray"
            itemWidth: 5
            begin: 120
            end: 300
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // animirani luk koji prikazuje postotak vlažnosti zraka
        CircularArc {
            // Budući da se postotak prikazuje u luku od 300°, a vlažnost se mjeri do 100%,
            // krajnji kut se računa kao (percent * 3), a postotak u nekom trenutku
            // kao trenutni kut podijeljen s 3.

            itemColor: "gold"
            itemWidth: 5
            begin: 120
            end: percent * 3
            speed: 2000

            anchors.horizontalCenter: parent.horizontalCenter
            isVisible: humidityWidget.isVisible

            // Pri promjeni kuta ispisuje se postotak učitane vlažnosti u percentText.
            onAngleChanged: function(angle) { percentText.text = Math.floor(angle / 3) + "%" }
        }
    }
}
