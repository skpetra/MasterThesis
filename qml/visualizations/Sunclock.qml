import QtQuick 2.11
import QtQuick.Shapes 1.0
import Qt5Compat.GraphicalEffects

// Sunclock.qml element je kružni animirani prikaz podataka o izlasku i zalasku sunca.
// Ostvaren je na način da puni krug predstavlja 24 sata u danu, a ovisno o dobivenim
// podacima iscrtava se vrijeme od izlaska sunca (180°) do zalaska u smijetu kazaljke na satu.
Item {

    id: sunClockItem

    // --- public properties ---
    property string sunsetString
    property string sunriseString
    property int timezoneSec


    // Puni statični krug
    CircularArc {
        width: Math.min(parent.width, parent.height) * 0.8
        height: Math.min(parent.width, parent.height) * 0.8
        itemWidth: 5
        begin: 0
        end: 360
    }

    // Animirani kružni luk koji predstavlja period od izlaska do zalaska sunca.
    CircularArc {
        width: Math.min(parent.width, parent.height) * 0.8
        height: Math.min(parent.width, parent.height) * 0.8
        itemWidth: 5
        itemColor: "yellow"
        begin: -180
        end: setSunset()
        speed: 2000
    }

    Text {
        text: getSunriseTime()
    }

    // --- private functions ---

    // Funkcija na temelju podataka o vremenu izlaska i zalaska sunca
    function setSunset() {
        // datetime oblika Mon Dec 13 12:45:28 2021 GMT+0100
        var sunsetDateTime = new Date(sunsetString)
        var sunriseDateTime = new Date(sunriseString)

        // sat, 12
        var sunsetHour = parseInt(Qt.formatDateTime(new Date(sunsetDateTime), "hh"))
        var sunriseHour = parseInt(Qt.formatDateTime(new Date(sunriseDateTime), "hh"))

        // lokalno vrijeme, uračunata je vremenska zona
        var sunsetHourLocal = parseInt(Qt.formatDateTime(new Date(sunsetDateTime), "hh")) + timezoneSec / 60 / 60
        var sunriseHourLocal = parseInt(Qt.formatDateTime(new Date(sunriseDateTime), "hh")) + timezoneSec / 60 /60

        // puni krug 360° predstavlja 24 sata, 1 sat = 15°
        console.log((sunsetHourLocal - sunriseHourLocal) * 15)
        return (sunsetHourLocal - sunriseHourLocal) * 15
    }

    function getSunriseTime() {
        var sunriseDateTime = new Date(sunriseString)
        // set local time - dodajem sate ovisno o vremenskoj zoni
        sunriseDateTime.setTime(sunriseDateTime.getTime() + (timezoneSec*1000))
        var sunriseTime = Qt.formatDateTime(new Date(sunriseDateTime), "hh:mm:ss")

        return sunriseTime
    }

    function getSunsetTime() {
        var sunsetDateTime = new Date(sunsetString)
        // set local time - dodajem sate ovisno o vremenskoj zoni
        sunsetDateTime.setTime(sunsetDateTime.getTime() + (timezoneSec*1000))
        var sunsetTime = Qt.formatDateTime(new Date(sunsetDateTime), "hh:mm:ss")

        return sunsetTime
    }

    Component.onCompleted: {
       // console.log(sunClockItem.width + " " + sunClockItem.height)
    }
}
