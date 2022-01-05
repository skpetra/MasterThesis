import QtQuick 2.0
import QtQuick.Controls 2.0
import "../controls" //CitiesSuggestionBox

Page {
    id: menuPage
    objectName: "MenuPage"

    Rectangle {
        anchors.fill: parent
        color: "#4682b4" //"slateblue"
    }

    CitiesSuggestionBox {
//        width: citiesListPage / 2
//        height: 35
        x: 150
        y: 100

        // focus?
    }
}
