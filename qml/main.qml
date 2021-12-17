import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

import "../qml/pages"
import "../qml/controls"

// Glavni prozor aplikacije. Sadrži komponentu StackView za navigaciju.
// U headeru prozor ima ToolBar koji inicijalno na početnoj MenuPage stranici nije vidljiv,
// dok je na ostalim stranicama vidljiv.
ApplicationWindow {

    id: mainWindow

    readonly property alias pageStack: stackView

    width: 900
    height: 600
    visible: true
    title: qsTr("Weather")

    header: PageToolBar {
        id: toolBar
        visible: false

        // PageToolBar emitira signal unitsButtonToggled na pritisak gumba za odabir
        // temperaturne mjerne jedinice.
        // Promjenjena mjerna jedinica emitira se dalje na trenutno otvorenu stranicu,
        // gdje se podaci ažururaju ovisno o jedinici.
        onUnitsButtonToggled: function(units) {
            pageStack.currentItem.unitsButtonToggled(units)
        }
    }

    StackView {

        id: stackView

        anchors.fill: parent
        initialItem: MenuPage {}

        // Toolbar nije vidljiv na MenuPage, dok je na ostalim stranicama vidljiv.
        onCurrentItemChanged: {
            console.log("OBJECT NAME CHANGED: " + pageStack.currentItem)
            if (pageStack.currentItem.objectName !== "MenuPage") {
                toolBar.visible = true
            }
            else {
                toolBar.visible = false
            }
        }

        // tranzicija između stranica
//        pushEnter: Transition {
//            PropertyAnimation {
//                property: "opacity"
//                from: 0
//                to:1
//                duration: 200
//            }
//        }
    }
}
