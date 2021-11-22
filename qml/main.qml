import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import "../qml/pages"


ApplicationWindow {

    readonly property alias pageStack: stackView

    width: 640
    height: 480
    visible: true
    title: qsTr("Weather")


    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: CitiesListPage {}
    }
}
