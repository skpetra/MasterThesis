import QtQuick 2.0
import QtQuick.Shapes 1.15

// Element prikazuje vjetrenjaču koja se rotira brzinom ovisno o jačini vjetra.
// Predviđeni omjer širine i visine elementa je: visina = širina.
Rectangle {

    id: windmillItem

    // --- public properties ---
    property bool isActive: true // svojstvo služi da vjetrenjača nije aktivna kad nije vidljiva na stranici

    // intenzitet: 0-4
    // Prema dobivenom intenzitetu se određuje brzina rotiranja na način
    // da intenzitet utječe na duljinu trajanja jednog punog kruga animacije
    // duration: intensity == 0 ? 0 : 6000 - intensity * 1000
    // 0 - vjetrenjača se ne vrti
    // 1 - vjetrenjača u 6000 - 1*1000 sekundi napravi puni krug
    // ...
    property int intensity // 0, 1, 2, 3 ili 4

    implicitWidth: 100
    implicitHeight: 100

    color: "transparent"
    antialiasing: true

    // središnji krug vjetrenjače
    Rectangle {
        width: parent.width * 0.08
        height: parent.height * 0.08
        radius: width / 2

        x: parent.width * 0.41
        y: parent.height * 0.41

        color: "dimgray"
        antialiasing: true
    }

    // stub
    Rectangle {
        width:  parent.width * 0.03
        height: parent.height * 0.49
        radius: parent.width

        x: parent.width * 0.435
        y: parent.width * 0.51

        color: "dimgray"
    }

    // pinwheel
    Image{
        width: parent.width * 0.9
        height: parent.height * 0.9
        source: "qrc:/resources/icons/pinwheel.png"

        PropertyAnimation on rotation {
            id: anim
            from: 0
            to: 360
            running: isActive
            duration: intensity == 0 ? 0 : 6000 - intensity * 1000
            loops: Animation.Infinite
        }
    }
}
