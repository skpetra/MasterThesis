import QtQuick 2.0
import QtQuick.Particles 2.0

Item {

    id: precipitationItem

    property string type: "" // tip padalina - rain ili snow
    property int intensity: 2 // intenzitet padalina

    implicitWidth: 100
    implicitHeight: 120 // 60 cloud + 40 padaline
    z: -1


    // So first we declare a ParticleSystem that paints the particles and runs the emitters:
    ParticleSystem {
        id: particles
    }

    // Then we add a ParticleImage type that visualizes logical particles using an image.
    // In our case, the image should correspond to a snow particle.
    // We also specify the system whose particles should be visualized
    ImageParticle {
        system: particles
        source: "../../resources/icons/" + type + ".png"
    }

    // To emit particles, we add an Emitter type that emits our snow particles from the top window
    // down to the bottom using an velocity: PointDirection
    Emitter {
        y: 50; z: 0
        width: parent.width/2
        height: 0 // emiter je smjesten na dnu oblaka, a width i height su takvi da s te površine ***kreću padati*** pahulje - zato je kraći nego ukupno područje po kojem padaju pahulje
        anchors.horizontalCenter: parent.horizontalCenter
        system: particles

        emitRate: intensity // Number of particles emitted per second.
        lifeSpan: 900 // trajanje čestice u ms
        velocity: PointDirection {
            y: 60;
            yVariation: 10;
        }
        //acceleration: PointDirection { y: 4 }
        size: 15
        endSize: {
            if (type === "rain")
                return -1 // ako je kiša veličina kapljica se ne smanjuje
            else if (type === "snow")
                return 10 // ako je snijeg pahulje se tope
        }
        sizeVariation: 5
    }
}
