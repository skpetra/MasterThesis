import QtQuick 6.0
import "../basic"

// Thunderstorm.qml prikazuje Thunderstorm grupu vremenskih uvijeta koja uvijek sadrži broken clouds ikonu
// zajedno sa treptajućom munjom, dok kišu prikazuje ovisno o uvjetima i jačini.
// Predviđeni omjer širine i visine elementa je: visina = širina * 0.6.
Item {
    id: thunderstormGroupItem

    implicitWidth: 100
    implicitHeight: 60

    property string precipitationType
    property int precipitationIntensity

    Loader {
        id: precipitationLoader
    }

    Clouds {
        id: brokenClouds
        brokenClouds: true
        width: parent.width // prilagođavanje veličine oblaka vanjskom elementu u kojeg ga stavljamo
        height: parent.height
    }

    Image{
        id: thunderboltImage
        x: parent.width * 0.15
        y: parent.width * 0.8 * 0.6 * 0.75 // 75% visine oblaka koja će biti postavljena
        height: parent.width * 0.8 * 0.6
        width: parent.width * 0.2
        source: "../../resources/icons/thunderbolt.png"

        Component.onCompleted: thunderboltAnimation.start()

        // pauza između 2 munje = interval - thunderboltAnimation.duration
        Timer {
            interval: 1300
            running: true
            repeat: true
            onTriggered: thunderboltAnimation.running ? thunderboltAnimation.stop() : thunderboltAnimation.start()
        }

        NumberAnimation  {
            id: thunderboltAnimation
            target: thunderboltImage
            property: 'opacity'
            from: 0
            to: 1
            duration: 700
            loops: Animation.Infinite
        }
    }

    Component.onCompleted: {
        if (precipitationType){
            precipitationLoader.setSource("../basic/Precipitation.qml",
                                          { type: precipitationType,
                                            intensity: precipitationIntensity,
                                            width: thunderstormGroupItem.width,
                                            height: thunderstormGroupItem.height - thunderstormGroupItem.width * 0.8 * 0.6 - thunderstormGroupItem.width * 0.8 * 0.6 * 0.16, // duljina puta na y osi na kojem se zadržavaju padaline = visina itema - visina koju zauzimaju oblaci (visina prvog oblaka + pomak y od 16%)
                                            cloudBottom: thunderstormGroupItem.width * 0.8 * 0.6 // visina oblaka = širina  *  0.6 = drizzleGroupItem.width * 0.8 * 0.6
                                          })
        }
    }
}
