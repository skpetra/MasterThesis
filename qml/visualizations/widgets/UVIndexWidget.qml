import QtQuick 6.0

// Element predstavlja komponentu koja prikazuje podatak o UV indeksu i njegovoj jačini.
// Sastoji se od naslova komponente, pravokutnika za prikaz UV indeksa obojenog pripadajućom bojom te opisne jačine indeksa.
// Predviđeni omjer širine i visine elementa je: visina = širina * 0.85.
Item {

    id: uviWidget

    // --- public properties ---
    property int uvi // uv index

    implicitWidth: 150
    implicitHeight: 130

    // naslov widgeta
    Item {
        id: widgetTitle
        width: parent.width
        height: parent.height * 0.2

        Text {
            text: qsTr("UV Index")
            font.bold: true
            color: "dimgray"
            anchors.centerIn: parent
        }
    }

    // UV index
    Rectangle {
        width: Math.min(parent.width, parent.height) / 3.5
        height: width
        radius: 5
        color: setUVIndexColor()
        anchors.centerIn: parent

        Text{
            text: uvi
            font.bold: true
            font.pixelSize: 20
            color: "white"
            anchors.centerIn: parent
        }
    }

    // opisna jačina pripadnog UV indeksa
    Item {
        width: parent.width
        height: parent.height * 0.2
        anchors.bottom: parent.bottom

        Text {
            id: uviIntensity
            text: setUVIndexIntensity()
            anchors.centerIn: parent
            color: "dimgray"
        }
    }


    // --- private functions ---
    // Funkcije za određivanje boje i opisne jačine dobivenog UV indeksa realizirane
    // prema skali sa https://en.wikipedia.org/wiki/Ultraviolet_index.

    function setUVIndexColor() {
        if (uvi < 3)
            return "green"
        else if (uvi < 6)
            return "gold"
        else if (uvi < 8)
            return "orange"
        else if (uvi < 11)
            return "red"
        else return "violet"
    }

    function setUVIndexIntensity() {
        if (uvi < 3)
            return "Low"
        else if (uvi < 6)
            return "Moderate"
        else if (uvi < 8)
            return "High"
        else if (uvi < 11)
            return "Very High"
        else return "Extreme"
    }
}
