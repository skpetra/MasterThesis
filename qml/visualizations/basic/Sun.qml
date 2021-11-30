import QtQuick 2.2


// Element prikazuje sunce sa zrakama koje trepere oko njega.
Item {

    // --- public properties ---
    property int radius: 30
    property color itemColor: "gold"

    // --- private properties ---
    property int _innerRadius: radius * 0.7
    property int _currentIndex: 0

    id: sunItem
    width: radius * 2
    height: radius * 2

    // unutarnji krug
    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        y: _getPosOnCircle(148).y
        width: sunItem.radius
        height: sunItem.radius
        radius: sunItem.radius/2
        color: itemColor
    }

    Repeater {
        id: repeater
        model: 8
        delegate: Component {
            Rectangle {
                id: rectangleRepeater
                // --- private properties ---
                property int _rotation: (360 / repeater.model) * index
                property int _maxIndex: sunItem._currentIndex + 1
                property int _minIndex: sunItem._currentIndex - 1

                width: sunItem.width - (sunItem._innerRadius * 2)
                height: width * 0.45
                x: _getPosOnCircle(_rotation).x
                y: _getPosOnCircle(_rotation).y
                radius: 20
                color: itemColor
                opacity: (index >= _minIndex && index <= _maxIndex) || (index === 0 && sunItem._currentIndex + 1 > 7) ? 1 : 0.3
                transform: Rotation {
                    angle: 360 - _rotation
                    origin {
                        x: 0
                        y: height / 2
                    }
                }
                transformOrigin: Item.Center

                Behavior on opacity { NumberAnimation { duration: 200 } }
            }
        }
    }

    Timer {
        id: timer
        interval: 80
        repeat: true
        running: true
        onTriggered: {
            if (sunItem._currentIndex === 7) {
                sunItem._currentIndex = 0;
            }
            else {
                sunItem._currentIndex++;
            }
        }
    }

    // --- private functions ---

    function _toRadian(degree) {
        return (degree * 3.14159265)/180
    }

    function _getPosOnCircle(angleInDegree) {
        var centerX = sunItem.width/2
        var centerY = sunItem.height/2
        var posX = 0
        var posY = 0

        posX = centerX + sunItem._innerRadius * Math.cos(_toRadian(angleInDegree))
        posY = centerY - sunItem._innerRadius * Math.sin(_toRadian(angleInDegree))

        return Qt.point(posX, posY)
    }
}
