import QtQuick 2.2
import "../basic"

// Rain grupa vremenskih uvijeta prikazuje kišu zajedno sa poluoblačnim (sunce ili mjesec), oblačnim (broen clouds) vremenom ili ledenom kišom.
// Jačina kiše ovisi o intenzitetu i veličini kapljica.
// Predviđeni omjer širine i visine elementa je: visina = širina.
Item {

    id: rainGroupItem

    property string timeOfDay // d ili n - ako je timeOfDay bitan odnosno prikazuje se sunce ili mjesec bit ce settan, inace nista
    property int rainIntensity
    property string dropOfRainSize // small ili big
    property bool isFreezingRain

    Precipitation {
        type: "rain"
        intensity: rainIntensity
        particlesSize: dropOfRainSize === "small" ? width * 0.08 : width * 0.1
        width: parent.width
        height: parent.height - parent.width * 0.8 * 0.6 - parent.width * 0.8 * 0.6 * 0.16 // duljina puta na y osi na kojem se zadržavaju padaline = visina itema - visina koju zauzimaju oblaci (visina prvog oblaka + pomak y od 16%)
        cloudBottom: parent.width * 0.8 * 0.6 // visina oblaka = širina * 0.6 = rainGroupItem.width * 0.8 * 0.6
    }

    Loader {
        id: freezingRainLoader
    }

    Loader {
        id: cloudLoader
    }

    Component.onCompleted: {
        if (timeOfDay == 'd' || timeOfDay == 'n') {
            cloudLoader.setSource("Clouds.qml",
                                 { timeOfDay: timeOfDay,
                                   width: rainGroupItem.width,
                                   height: rainGroupItem.height
                                 })
        }
        else {
            cloudLoader.setSource("/Clouds.qml",
                                 { brokenClouds: true,
                                   width: rainGroupItem.width,
                                   height: rainGroupItem.height
                                 })
        }

        if (isFreezingRain){
            freezingRainLoader.setSource("../basic/Precipitation.qml",
                                        {   type: "snow",
                                            intensity: 2,
                                            particlesSize: rainGroupItem.width * 0.06,
                                            width: rainGroupItem.width,
                                            height: rainGroupItem.height - rainGroupItem.width * 0.8 * 0.6 - rainGroupItem.width * 0.8 * 0.6 * 0.16, // duljina puta na y osi na kojem se zadržavaju padaline = visina itema - visina koju zauzimaju oblaci (visina prvog oblaka + pomak y od 16%)
                                            cloudBottom: rainGroupItem.width * 0.8 * 0.6 // visina oblaka = širina * 0.6 = rainGroupItem.width * 0.8 * 0.6
                                        })
        }
    }
}
