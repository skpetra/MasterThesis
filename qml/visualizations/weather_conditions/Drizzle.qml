import QtQuick 2.0
import "../basic"

// Grupa vremenskih uvjeta Drizze uvijek se prikazuje ikonom brokenClouds a jačina
// ovog uvjeta dočarana je intenzitetom i veličinom kapljica.
// Predviđeni omjer širine i visine elementa je: visina = širina * 0.6.
Item {
    id: drizzleGroupItem

    implicitWidth: 120 //100+20
    implicitHeight: 70 //60+10

    property int rainIntensity
    property string dropOfRainSize: "small"

    Clouds {
        id: brokenClouds
        brokenClouds: true
        width: parent.width // prilagođavanje veličine oblaka vanjskom elementu u kojeg ga stavljamo
        height: parent.height
    }

    Precipitation {
        type: "rain"
        intensity: rainIntensity
        particlesSize: dropOfRainSize === "small" ? width * 0.08 : width * 0.1 // veličina kapljica ovisi o jačini kiše i veličini itema i koji je smješten oblak
        width: parent.width
        height: parent.height - parent.width * 0.8 * 0.6 - parent.width * 0.8 * 0.6 * 0.16 // duljina puta na y osi na kojem se zadržavaju padaline = visina itema - visina koju zauzimaju oblaci (visina prvog oblaka + pomak y od 16%)
        cloudBottom: parent.width * 0.8 * 0.6 // visina oblaka = širina * 0.6 = drizzleGroupItem.width*0.8 * 0.6
    }
}
