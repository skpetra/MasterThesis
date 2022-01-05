import QtQuick
import QtQuick.Shapes

// CircularArc.qml ovisno o zadanim stupnjevima (svojstva begin i end) prikazuje
// krug ili kružni luk određene boje i širine.
// Element može biti statičan ili animiran.
// Predviđeni omjer širine i visine elementa je: visina = širina.
Shape {

    id: circularArcItem

    // --- public properties ---
    property string itemColor
    property int itemWidth
    property int begin // Kut od kojeg se počinje crtati luk.
    property int end // Kut na kojem se završava crtanje luka.
    // svojstvo speed određuje brzinu animacije ukoliko je element animiran.
    // U slučaju statičnog objekta svojstvo speed je postavljeno na 0.
    property int speed: 0

    // Statični element uvijek se postavlja kao vidljiv.
    // Animirani elementi se aktiviraju tek kad postanu vidljivi.
    property bool isVisible: true

    // --- signals ---
    // Signal koji se emitira u slučaju animiranog elementa pri promjeni kuta.
    signal angleChanged(int angle)

    implicitWidth: 100
    implicitHeight: 100

    // izglađivanje rubova
    layer.enabled: true
    layer.samples: 8

    ShapePath {
        fillColor: "transparent"
        strokeColor: itemColor
        strokeWidth: itemWidth
        capStyle: ShapePath.RoundCap

        PathAngleArc {
            centerX: circularArcItem.width / 2
            centerY: circularArcItem.height / 2
            radiusX: circularArcItem.width / 2.5
            radiusY: circularArcItem.height / 2.5
            startAngle: begin

            SequentialAnimation on sweepAngle {
                running: isVisible
                NumberAnimation {
                    to: end
                    duration: speed
                }
            }
            onSweepAngleChanged: angleChanged(sweepAngle)
        }
    }
}
