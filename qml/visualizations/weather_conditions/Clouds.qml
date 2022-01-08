import QtQuick 6.0
import "../basic"

// Grupa vremenskih uvijeta koja prikazuje poluoblačno i oblačno vrijeme ovisno o dobu dana.
// Predviđeni omjer širine i visine elementa je: visina = širina * 0.7.
Item {
    id: cloudsGroupItem

    // ova dva svojstva se međusobno isključuju
    property bool brokenClouds
    property string timeOfDay

    implicitWidth: 100
    height: width * 0.7

    Loader {
        id: timeOfDayLoader
    }

    Cloud { // straznji oblak
        x: width * 0.2
        cloudColor: "dimgray"
        width: setWidth()
        height: width * 0.6
        visible: brokenClouds ? true : false
    }

    Cloud {
        id: mainCloud
        width: setWidth()
        height: width * 0.6
        y: setY(height)
    }

    Component.onCompleted: {
        if (timeOfDay == 'd')
            timeOfDayLoader.setSource("../basic/Sun.qml", { radius: mainCloud.width * 0.2, x: mainCloud.width * 0.7 })
        else if (timeOfDay == 'n')
            timeOfDayLoader.setSource("../basic/Moon.qml", { width: mainCloud.width * 0.6, x: mainCloud.width * 0.55, y: -mainCloud.width * 0.05 })
    }

    // --- private functions ---

    // funkcija koja postavlja y svojstvo glavnog oblaka ovisno o prikazu koji se postavlja
    function setY(cloudHeight) {
        if (brokenClouds)
            return cloudHeight * 0.16 // spustam prednji za 16%
        else if (timeOfDay)
            return cloudHeight * 0.05 // spustam prednji za 5%
        return 0 // inace ga ostavljam na početnoj poziciji
    }

    // ovisno o ukupnoj veličini prikaza postavljam veličinu oblaka da ostane mjesta za sunce/mjesec/drugi oblak ili ne ostavljam u slučaju prikaza samog oblaka
    function setWidth(){
        if (brokenClouds)
            return cloudsGroupItem.width * 0.8
        else if (timeOfDay)
            return cloudsGroupItem.width * 0.9
        return cloudsGroupItem.width
    }
}
