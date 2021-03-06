import QtQuick 6.0
import QtQuick.Window 2.0
import QtQuick.Controls 6.0

import "../qml/pages"
import "../qml/controls"

// Glavni prozor aplikacije. Sadrži komponentu StackView za navigaciju.
// U headeru prozor ima ToolBar koji inicijalno na početnoj HomePage stranici nije vidljiv,
// dok je na ostalim stranicama vidljiv.
ApplicationWindow {

    id: mainWindow

    readonly property alias pageStack: stackView

    width: 900
    height: 700
    visible: true
    title: qsTr("QTher")

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
        initialItem: HomePage {}

        // Toolbar nije vidljiv na HomePage, dok je na ostalim stranicama vidljiv.
        onCurrentItemChanged: {
            console.log("OBJECT NAME CHANGED: " + pageStack.currentItem)
            if (pageStack.currentItem.objectName !== "HomePage") {
                toolBar.visible = true
            }
            else {
                toolBar.visible = false
            }
        }
    }
}
