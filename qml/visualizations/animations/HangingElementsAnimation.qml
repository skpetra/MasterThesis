import QtQuick 2.7

import "../weather_conditions"
import "../basic"

// Animacija visećih oblaka.
Item {
    id: hangingElementsAnimation

    width: parent.width * 0.8
    height: 300
    anchors.horizontalCenter: parent.horizontalCenter
    state: "up"

    // viseći oblaci različitih veličina
    HangingElement {
        id: hangingElement1

        Component.onCompleted: {
            hangingElement.setSource("qrc:/qml/visualizations/basic/Cloud.qml", { width: 180 })
        }
    }
    HangingElement {
        id: hangingElement6
        x: 70

        Component.onCompleted: {
            hangingElement.setSource("qrc:/qml/visualizations/basic/Cloud.qml", { width: 90 })
        }
    }
    HangingElement {
        id: hangingElement2
        x: 150

        Component.onCompleted: {
            hangingElement.setSource("qrc:/qml/visualizations/weather_conditions/Clouds.qml",
                                     {
                                        brokenClouds: true,
                                        width: 150
                                     })
        }
    }
    HangingElement {
        id: hangingElement3
        x: 400

        Component.onCompleted: {
            hangingElement.setSource("qrc:/qml/visualizations/basic/Cloud.qml", { width: 110 } )
        }
    }
    HangingElement {
        id: hangingElement4
        x: 550

        Component.onCompleted: {
            hangingElement.setSource("qrc:/qml/visualizations/basic/Cloud.qml", { width: 120 })
        }
    }
    HangingElement {
        id: hangingElement5
        x: 650

        Component.onCompleted: {
            hangingElement.setSource("qrc:/qml/visualizations/weather_conditions/Clouds.qml",
                                     {
                                        brokenClouds: true,
                                        width: 100
                                     })
        }
    }

    states: [
        State {
            name: "up"
            PropertyChanges { target: hangingElement1; y: - hangingElement1.height * 1.1}
            PropertyChanges { target: hangingElement2; y: - hangingElement2.height * 1.1}
            PropertyChanges { target: hangingElement3; y: - hangingElement3.height * 1.1}
            PropertyChanges { target: hangingElement4; y: - hangingElement4.height * 1.1}
            PropertyChanges { target: hangingElement5; y: - hangingElement5.height * 1.1}
            PropertyChanges { target: hangingElement6; y: - hangingElement6.height * 1.1}
        },
        State {
            name: "down"
            PropertyChanges { target: hangingElement1; y: - hangingElement1.height * 0.3 }
            PropertyChanges { target: hangingElement2; y: - hangingElement2.height * 0.8 }
            PropertyChanges { target: hangingElement3; y: - hangingElement3.height * 0.4 }
            PropertyChanges { target: hangingElement4; y: - hangingElement4.height * 0.6 }
            PropertyChanges { target: hangingElement5; y: - hangingElement5.height * 0.5 }
            PropertyChanges { target: hangingElement6; y: - hangingElement6.height * 0.65 }
        }
    ]

    transitions: [
        Transition {
            to: "down"
            SequentialAnimation {
                NumberAnimation { properties: "y"; target: hangingElement1; easing.type: Easing.OutBack; duration: 700 }
                ParallelAnimation {
                    NumberAnimation { properties: "y"; target: hangingElement3; easing.type: Easing.OutBack; duration: 800 }
                    NumberAnimation { properties: "y"; target: hangingElement2; easing.type: Easing.OutBack; duration: 800 }
                }
                NumberAnimation { properties: "y"; target: hangingElement4; easing.type: Easing.OutBack; duration: 700 }
                ParallelAnimation{
                    NumberAnimation { properties: "y"; target: hangingElement5; easing.type: Easing.OutBack; duration: 900 }
                    NumberAnimation { properties: "y"; target: hangingElement6; easing.type: Easing.OutBack; duration: 900 }
                }
            }
        },
        Transition {
            to: "up"
            NumberAnimation { properties: "y"; easing.type: Easing.Bezier; duration: 600 }
        }
    ]

    Timer {
        interval: 100
        running: true
        repeat: false
        onTriggered: {
            hangingElementsAnimation.state = hangingElementsAnimation.state === "up" ? "down" : "up"
        }
    }
}
