import QtQuick
import QtQuick.Controls 2.0
import QtQuick.Controls.Material

import "../controls" //CitiesSuggestionBox
import "../visualizations/basic"
import "../visualizations/animations"

// Početna stranica aplikacije. Sadrži naziv aplikacije, searchbox za odabir grada te prigodnu animaciju.
Page {
    id: homePage
    objectName: "HomePage"

    Rectangle {
        id: backgroundRectangle
        anchors.fill: parent
        color: "#4682b4"
    }

    // naslov aplikacije
    FontLoader {
        id: webFont
        source: "qrc:/fonts/RemachineScript.ttf"
    }
    Text {
        id: title
        text: "QTher"
        font.pixelSize: 100
        font.bold: true
        font.family: webFont.font.family
        font.weight: webFont.font.weight
        color: "white"
        anchors.bottom: citiesSuggestionBox.top
        horizontalAlignment: Text.AlignHCenter
        width: parent.width
        wrapMode: Text.WordWrap
        bottomPadding: height * 0.1

        opacity: 0
        Behavior on opacity { OpacityAnimator { duration: 800 } }

        Component.onCompleted: { opacity = 1 }
    }

    HangingElementsAnimation {
        id: hangingElementsAnimation
    }

    Pane {
        id: citiesSuggestionBox
        anchors.centerIn: parent
        width: parent.width / 2.5
        height: 40
        y: parent.height * 0.7

        padding: 0
        Material.elevation: 6

        visible: false
        opacity: 0
        Behavior on opacity { OpacityAnimator { duration: 1000 } }

        CitiesSuggestionBox {
            anchors.fill: parent
        }

        // timer postavlja vrijeme potrebno za početnu animaciju nakon kojeg će se prikazati search box za unos željenog grada
        Timer {
            interval: 3300
            running: true
            repeat: false
            onTriggered: {
                citiesSuggestionBox.visible = true
                citiesSuggestionBox.opacity = 0.9
            }
        }
    }
}
