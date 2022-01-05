import QtQuick 2.11
import QtQuick.Shapes 1.0
import Qt5Compat.GraphicalEffects

import "qrc:/js/utils.js" as Utils

// Sunclock.qml element je kružni animirani prikaz podataka o izlasku i zalasku sunca.
// Ostvaren je na način da puni krug predstavlja 24 sata u danu, a ovisno o dobivenim
// podacima iscrtava se vrijeme od izlaska sunca (180°) do zalaska u smijetu kazaljke na satu.
Item {

    id: sunclockItem

    // --- public properties ---
    property string sunsetString
    property string sunriseString
    property int timezoneSec
    property bool isVisible

    property alias sunsetDegree: sunsetCircularArc.end

    implicitWidth: 200
    implicitHeight: 200

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
        id: sunsetCircularArc

        width: Math.min(parent.width, parent.height) * 0.8
        height: Math.min(parent.width, parent.height) * 0.8
        itemWidth: 5
        itemColor: "yellow"
        begin: -180
//        end: 100//setSunset()
//        speed: 2000
    }

    onSunriseStringChanged: {
        sunsetCircularArc.end = setSunset()
        sunsetCircularArc.speed = 2000
    }


    Text {
        text: "dd" //Utils.getTime(parseInt(sunriseString), "hh")
    }

    // --- private functions ---

    // Funkcija na temelju podataka o vremenu izlaska i zalaska sunca
    function setSunset() {

//        function getTime(unix_timestamp) {
//            console.log("pretvaram unix_timestamp " +  unix_timestamp )
//            var dateTime = new Date(unix_timestamp * 1000);
////            console.log(time)
//            return dateTime.getUTCHours() //+ ":" + dateTime.getUTCMinutes() + ":" + dateTime.getUTCSeconds();
//        }
//        var set = parseInt(sunsetString) + timezoneSec
//        var rise = parseInt(sunriseString) + timezoneSec
//        var sunsetHourLocal = getTime(set)
//        var sunriseHourLocal = getTime(rise)

//        console.log("sunsetHourLocal: " + sunsetString + " " + sunsetHourLocal)
//        console.log("sunriseHourLocal: " + sunriseString + " " + sunriseHourLocal)


//        console.log("(sunsetHourLocal - sunriseHourLocal)" + (sunsetHourLocal - sunriseHourLocal))

        //console.log("sunrise: " + Utils.getTime(parseInt(sunriseString) + timezoneSec, "hh"))
        //console.log("sunset: " + Utils.getTime(parseInt(sunsetString) + timezoneSec, "hh"))
        // puni krug 360° predstavlja 24 sata, 1 sat = 15°

//        sunsetCircularArc.begin = -180
//        sunsetCircularArc.end = (sunsetHourLocal - sunriseHourLocal) * 15
//        sunsetCircularArc.speed = 2000

        //return (sunsetHourLocal - sunriseHourLocal) * 15
        return 130
    }

//    function getSunriseTime() {
//        // console.log(sunriseString)
//        //console.log(typeof sunriseString)
//        var sunriseDateTime = new Date(+sunriseString)
//        //console.log("sunriseTime: " + sunriseDateTime)
//        // set local time - dodajem sate ovisno o vremenskoj zoni
//        sunriseDateTime.setTime(sunriseDateTime.getTime() + (timezoneSec*1000))
//        var sunriseTime = Qt.formatDateTime(new Date(sunriseDateTime), "hh:mm:ss")

//    console.log("sunriseTime" + sunriseTime)
//        return sunriseTime
//    }

//    function getSunsetTime() {
//        var sunsetDateTime = new Date(sunsetString)
//        // set local time - dodajem sate ovisno o vremenskoj zoni
//        sunsetDateTime.setTime(sunsetDateTime.getTime() + (timezoneSec*1000))
//        var sunsetTime = Qt.formatDateTime(new Date(sunsetDateTime), "hh:mm:ss")

//        //console.log("sunsetTime: " + sunsetTime)
//        return sunsetTime
//    }

    Component.onCompleted: {
       // console.log(sunclockItem.width + " " + sunclockItem.height)
        //setSunset()
    }
}
