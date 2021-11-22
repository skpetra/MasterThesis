import QtQuick 2.2

Item {
    id: thunderstormItem

    Cloud {
        x: 20
        cloudColor: "dimgray"
    }

    Cloud { y: 10 }

    Image{
        id: thunderboltImage
        x: 20
        y: 45
        height: 60
        width: 30
        source: "../../resources/icons/thunderbolt.png"

        Component.onCompleted: thunderboltAnimation.start()

        // pauza između 2 munje = interval - thunderboltAnimation.duration
        Timer {
            interval: 1300
            running: true
            repeat: true
            onTriggered: thunderboltAnimation.running ? thunderboltAnimation.stop() : thunderboltAnimation.start()
        }

        // jedna munja uvijek jednako traje - manje oluje zahtjevaju mijenjanje timera -KRIVO!!
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
}
