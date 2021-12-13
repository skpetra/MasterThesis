import QtQuick 2.2
import "../basic"

// Snow grupa vremenskih uvijeta prikazuje snijeg ili susnježicu.
// Jačina ovisi o intenzitetu i veličini pahulja.
// Predviđeni omjer širine i visine elementa je: visina = širina.
Item {

    id: snowGroupItem

    property int snowIntensity
    property string snowflakeSize
    property bool isSleet: false // je li susnježica
    property int sleetIntensity

    Precipitation {
        type: "snow"
        intensity: snowIntensity
        particlesSize: snowflakeSize === "big" ? parent.width * 0.17 : parent.width * 0.15
        width: parent.width
        height: parent.height - parent.width * 0.8 * 0.6 // duljina puta na y osi na kojem se zadržavaju padaline = visina itema - visina koju zauzimaju oblaci (visina prvog oblaka + pomak y od 16%)
        cloudBottom: parent.width * 0.8 * 0.6 // visina oblaka = širina * 0.6 = snowGroupItem.width * 0.8  *  0.6
    }

    Loader {
        id: sleetLoader
    }

    Cloud {
        width: parent.width // visina i širina oblaka također je regulirana "izvana"
        height: width * 0.6
    }

    Component.onCompleted: {
        if (isSleet){
            sleetLoader.setSource("../basic/Precipitation.qml",
                                        {   type: "rain",
                                            intensity: sleetIntensity,
                                            particlesSize: snowGroupItem.width * 0.06,
                                            width: snowGroupItem.width,
                                            height: snowGroupItem.height - snowGroupItem.width * 0.8 * 0.6, // duljina puta na y osi na kojem se zadržavaju padaline = visina itema - visina koju zauzimaju oblaci (visina prvog oblaka + pomak y od 16%)
                                            cloudBottom: snowGroupItem.width * 0.8 * 0.6 // visina oblaka = širina  *  0.6 = snowGroupItem.width * 0.8 * 0.6
                                        })
        }
    }
}
