import QtQuick 6.0
import "../basic"

// Atmosphere.qml predstavlja grupu vremenskih uvjeta koja prikazuje jačinu vidljivosti.
// Svojstvo fogIntensity regulira broj animiranih 'crtica' uz oblak, dok je manja vidljivost
// prikazana bez oblaka regulirana svojstvom intensity.
// Predviđeni omjer širine i visine elementa je: visina = širina.
Item {
    id: atmosphereGroupItem

    property bool fogIntensity: false // koliko je jačina magle (3 ili 4 crte)
    property bool intensity: false // jačina "Atmosphere"

    implicitHeight: 100
    implicitWidth: 100
    // visina i širina prikaza regulira se "izvana" ovisno o stranici na kojoj se animacija prikazuje
    // utils.js u funkciji setWeatherAnimation() prima visinu i širinu Itema koji sadrži animaciju

    Cloud {
        id: cloudItem
        width: parent.width // visina i širina oblaka također je regulirana "izvana"
        height: width * 0.6
        visible: intensity ? false : true
    }

    Fog {
        x: parent.width * 0.25
        y: cloudItem.visible ? cloudItem.height - cloudItem.height * 0.25 : parent.height * 0.3
        animationDuration: 1100
        lineLength: cloudItem.visible ? cloudItem.width * 0.3 : parent.width * 0.5
        lineHeight: cloudItem.visible ? cloudItem.height * 0.08 : parent.height * 0.05
    }

    Fog {
        x: parent.width * 0.1
        y: cloudItem.visible ? cloudItem.height - cloudItem.height * 0.1 : parent.height * 0.4
        lineLength: cloudItem.visible ? cloudItem.width * 0.6 : parent.width * 0.8
        lineHeight: cloudItem.visible ? cloudItem.height * 0.08 : parent.height * 0.05
        animationDuration: 1400
    }

    Fog {
        x: parent.width * 0.2
        y: cloudItem.visible ? cloudItem.height + cloudItem.height * 0.05 : parent.height * 0.5
        lineLength: cloudItem.visible ? cloudItem.width * 0.4 : parent.width * 0.6
        lineHeight: cloudItem.visible ? cloudItem.height * 0.08 : parent.height * 0.05
        animationDuration: 1500
    }

    Fog {
        x: parent.width * 0.3
        y: cloudItem.visible ? cloudItem.height + cloudItem.height * 0.2 : parent.height * 0.6
        lineLength: cloudItem.visible ? cloudItem.width * 0.25 : parent.width * 0.4
        lineHeight: cloudItem.visible ? cloudItem.height * 0.08 : parent.height * 0.05
        animationDuration: 1200
        visible: fogIntensity ? true : false
    }
}
