import QtQuick 2.0
import QtQuick.Layouts
import "../../visualizations"
import "../../../js/utils.js" as Utils

// Element predstavlja komponentu koja prikazuje podatke o vjetru - brzinu, smjer i jačinu udara vjetra.
// Sastoji se od dvije animirane vjetrenjače i navedenih podataka.
// Predviđeni omjer širine i visine elementa je: visina = 2/3 * širina.
Item {

    id: windWidget

    // --- public properties ---
    property string speed
    property string direction
    property string gust

    property bool isVisible: true // svojstvo služi da vjetrenjača nije aktivna kad nije vidljiva na stranici

    implicitWidth: 150
    implicitHeight: 100

    // velika vjetrenjača
    Windmill {
        id: windmillItem

        width: parent.height
        height: parent.height

        intensity: setWindIntensity(speed)
        isActive: isVisible
    }

    // mala vjetrenjača
    Windmill {
        width: parent.height / 2
        height: parent.height / 2

        x: parent.height / 2
        y: parent.height / 2.5

        intensity: setWindIntensity(speed)
        isActive: isVisible
    }

    // podaci
    ColumnLayout {

        width: parent.width - windmillItem.width
        height: windmillItem.height

        x: windmillItem.width

        spacing: -30

        Text {
            id: speedText

            text: "Speed"
            Layout.alignment: Qt.AlignCenter
        }

        Text {
            text: speed + " m/s"
            font.pixelSize: speedText.font.pixelSize - 2
            Layout.alignment: Qt.AlignCenter
        }

        Text {
            text: "Direction"
            Layout.alignment: Qt.AlignCenter
        }

        Text {
            text: getWindDirection(direction)
            font.pixelSize: speedText.font.pixelSize - 2
            Layout.alignment: Qt.AlignCenter
        }

        Text {
            text: "Gust"
            Layout.alignment: Qt.AlignCenter
        }

        Text {
            text: gust + " m/s"
            font.pixelSize: speedText.font.pixelSize - 2
            Layout.alignment: Qt.AlignCenter
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

    // Funkcija određuje intenzitet vjetra prema brzini vjetra.
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
