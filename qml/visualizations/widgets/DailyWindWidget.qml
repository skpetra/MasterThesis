import QtQuick 6.0
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material 2.0
import "../../visualizations"
import "../../visualizations/basic"
import "../../../js/utils.js" as Utils

// Element predstavlja komponentu koja prikazuje podatke o brzini i smjeru vjetra.
// Sastoji se od dvije animirane vjetrenjače i navedenih podataka.
Rectangle {

    id: windWidget

    // --- public properties ---
    property string speed
    property string direction
    property bool isVisible: true // svojstvo služi da vjetrenjača nije aktivna kad nije vidljiva na stranici

    implicitWidth: 150
    implicitHeight: 130
    color: "transparent"

    // naslov widgeta
    Item {
        id: widgetTitle
        width: parent.width
        height: parent.height * 0.2

        Text {
            text: qsTr("Wind status")
            font.bold: true
            color: "dimgray"
            anchors.centerIn: parent
        }
    }

    // velika vjetrenjača
    Windmill {
        id: windmillItem

        width: parent.height - widgetTitle.height * 1.2
        height: parent.height - widgetTitle.height * 1.2
        anchors.bottom: parent.bottom
        x: 5

        intensity: setWindIntensity(speed)
        isActive: isVisible
    }

    // mala vjetrenjača
    Windmill {
        width: parent.height / 2.5
        height: parent.height / 2.5

        x: parent.height / 2.5
        y: parent.height / 2

        intensity: setWindIntensity(speed)
        isActive: isVisible
    }

    // podaci
    Rectangle {
        id: windDetailsText
        width: parent.width - windmillItem.width
        height: 10
        x: windmillItem.width
        color: "transparent"
        anchors.bottom: parent.bottom

        Text {
            id: windSpeedText
            font.pixelSize: 15
            color: "dimgray"
            textFormat: Text.RichText // html
            text: speed + '<font size="10px"> m/s</font>'
            anchors.bottom: windDirectionText.top
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            id: windDirectionText
            text: getWindDirection(direction)
            font.pixelSize: 10
            color: "dimgray"
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }


    // --- private functions ---

    // Funkcija određuje smjer vjetra prema dobivenim stupnjevima.
    function getWindDirection(directionDegree) {

        let directions = ['Northerly', 'North Easterly', 'Easterly', 'South Easterly',
                          'Southerly', 'South Westerly', 'Westerly', 'North Westerly']

        directionDegree += 22.5;

        if (directionDegree < 0)
            directionDegree = 360 - Math.abs(directionDegree) % 360;
        else
            directionDegree = directionDegree % 360;

        let w = parseInt(directionDegree / 45);

        return directions[w];
    }

    // Funkcija određuje intenzitet vjetra o kojem ovisi rotiranje vjetrenjače prema brzini vjetra.
    // Mogući intenzitet: 0-4.
    function setWindIntensity(windSpeed) {
        if (windSpeed === 0)
            return 0
        else if (windSpeed < 10)
            return 1
        else if (windSpeed < 20)
            return 2
        else if (windSpeed < 30)
            return 3
        else return 4
    }
}
