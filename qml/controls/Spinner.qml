import QtQuick 6.0
import "../../js/utils.js" as Utils

// "Busy indicator" element za označavanje učitavanja podataka na stranicu.
Item {

    id: pageLoader

    // --- public properties ---
    property int radius: 80
    property bool running: false
    property color color: "white"

    // --- private properties ---
    property int _innerRadius: radius * 0.7
    property int _circleRadius: (radius - _innerRadius) * 0.5

    width: radius * 2
    height: radius * 2

    opacity: running ? 1 : 0
    Behavior on opacity { OpacityAnimator { duration: 50 } }

    onRunningChanged: {
        if (running === false) {
            for (var i = 0; i < repeater.model; i++) {
                if (repeater.itemAt(i)) {
                    repeater.itemAt(i).stopAnimation();
                }
            }
        }
        else {
            for (var i = 0; i < repeater.model; i++) {
                if (repeater.itemAt(i)) {
                    repeater.itemAt(i).playAnimation();
                }
            }
        }
    }

    Repeater {
        id: repeater
        model: 10
        delegate: Component {
            Rectangle {
                id: rect
                // --- private properties ---
                property int _currentAngle: _getStartAngle()

                width: _getWidth()
                height: width
                radius: width
                x: pageLoader.getPositionOnCircle(_currentAngle).x
                y: pageLoader.getPositionOnCircle(_currentAngle).y
                color: pageLoader.color
                transformOrigin: Item.Center
                antialiasing: true

                SequentialAnimation {
                    id: anim
                    loops: Animation.Infinite

                    NumberAnimation {
                        target: rect
                        property: "_currentAngle"
                        duration: 1800
                        from: rect._getStartAngle()
                        to: 360 + rect._getStartAngle()
                        easing.type: Easing.OutQuad
                    }

                    PauseAnimation { duration: 500 }
                }

                // --- public functions ---

                function playAnimation() {
                    if (anim.running == false) {
                        anim.start()
                    }
                    else if (anim.paused) {
                        anim.resume()
                    }
                }

                function stopAnimation() {
                    if (anim.running) {
                        anim.pause()
                    }
                }

                // --- private functions ---

                function _getStartAngle() {
                    return index < 5 ? 90 : 270
                }

                function _getWidth() {
                    return (pageLoader._circleRadius) * 0.5 * ((repeater.model / 2) - Math.abs(repeater.model / 2 - index))
                }
            }
        }
    }

    Timer {
        id: timer
        // --- private properties ---
        property int _circleIndex: 0

        interval: 100
        repeat: true
        running: true
        onTriggered: {
            var maxIndex = repeater.model / 2
            if (_circleIndex === maxIndex) {
                stop()
                _circleIndex = 0
            }
            else {
                repeater.itemAt(_circleIndex).playAnimation()
                repeater.itemAt(repeater.model - _circleIndex - 1).playAnimation()
                _circleIndex++
            }
        }
    }

    // --- private functions ---

    function getPositionOnCircle(angleInDegree) {
        var centerX = pageLoader.width / 2
        var centerY = pageLoader.height / 2
        var posX = 0
        var posY = 0

        posX = centerX + pageLoader._innerRadius * Math.cos(Utils.convertToRadian(angleInDegree))
        posY = centerY - pageLoader._innerRadius * Math.sin(Utils.convertToRadian(angleInDegree))

        return Qt.point(posX, posY)
    }
}
