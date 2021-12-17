import QtQuick 2.11
import QtQuick.Shapes 1.0
import "../"

// Element predstavlja komponentu koja prikazuje podatak o vlažnosti zraka.
// Sastoji se od kružnog luka od 300° koji učitava postotak vlažnosti zraka.
// Predviđeni omjer širine i visine elementa je: visina = širina.
Rectangle {

    id: humidityWidget

    // --- public properties ---
    property int percent // dobiveni postotak vlažnosti zraka
    property int dewPoint // zasad ne prikazujem
    // svojstvo služi da se postotak krene učitavati tek nakon što je komponenta vidljiva
    property bool isVisible

    implicitWidth: 100
    implicitHeight: 100

    Text {
        id: percentText
        text: "0%"
        anchors.centerIn: parent
    }

    // statični luk
    CircularArc {
        itemColor: "lightgray"
        itemWidth: 5
        begin: 120
        end: 300
    }

    // animirani luk koji prikazuje postotak vlažnosti zraka
    CircularArc {
        // Budući da se postotak prikazuje u luku od 300°, a vlažnost se mjeri do 100%,
        // krajnji kut se računa kao (percent * 3), a postotak u nekom trenutku
        // kao trenutni kut podijeljen s 3.

        itemColor: "blue"
        itemWidth: 5
        begin: 120
        end: percent * 3
        speed: 2000

        isVisible: humidityWidget.isVisible

        // Pri promjeni kuta ispisuje se postotak učitane vlažnosti u percentText.
        onAngleChanged: function(angle) { percentText.text = Math.floor(angle / 3) + "%" }
    }
}
