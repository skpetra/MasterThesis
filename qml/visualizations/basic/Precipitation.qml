import QtQuick 6.0
import QtQuick.Particles 2.0

// Preticipation.qml predstavlja padaline u prikazu vremenskih uvjeta.
// Mogući tipovi padalina su 'rain' ili 'snow', a preko svojstva intensity
// postavljamo koliko će se čestita emitirati u jednoj sekudni, dok
// particlesSize svojstvo služi za određivanje početne veličine čestica.
// Predviđeni omjer širine i visine elementa je: visina = širina * 0.6.
Item {

    id: precipitationItem

    // --- public properties ---
    property string type: "" // tip padalina - rain ili snow
    property int intensity: 2 // intenzitet padalina
    property int particlesSize: width * 0.08 // veličina čestica
    property int cloudBottom // početna visina padalina

    implicitWidth: 100
    implicitHeight: 60
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
        source: "../../../resources/icons/" + type + ".png"
    }

    // To emit particles, we add an Emitter type that emits our snow particles from the top window
    // down to the bottom using an velocity: PointDirection
    Emitter {
        id: emmiter
        y: cloudBottom
        z: 0
        width: parent.width/2
        height: 0 // emiter je smjesten na dnu oblaka, a width i height su takvi da s te površine ***kreću padati*** pahulje - zato je kraći nego ukupno područje po kojem padaju pahulje
        anchors.horizontalCenter: parent.horizontalCenter
        system: particles

        emitRate: intensity // Number of particles emitted per second.
        lifeSpan: 900 // trajanje čestice u ms
        velocity: PointDirection {
            y: precipitationItem.height // kolika je visina itema
            yVariation: 10
        }
        size: particlesSize
        endSize: {
            if (type === "rain")
                return -1 // ako je kiša veličina kapljica se ne smanjuje
            else if (type === "snow")
                return particlesSize * 0.5 // ako je snijeg pahulje se tope
        }
        sizeVariation: 5
    }
}
