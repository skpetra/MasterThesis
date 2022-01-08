import QtQuick 6.0
import QtQuick.Controls 6.0
import QtQuick.Controls.Material 6.0
import QtQuick.Layouts

// Toolbar na svim stranicama osim početne. Sadrži elemente koji omogućuju povratak na početnu stranicu,
// odabir trenutne ili tjedne vremenske prognoze, odabir novog grada za prikaz vremenske prognoze
// te promjenu mjerne jedinice temperature (°C/°F).
ToolBar {

    id: toolBar

    signal unitsButtonToggled(string units)

    Material.background: "dimgray"

    // gumb za povratak na HomePage
    ToolButton {
        id: homeItem
        x: parent.width * 0.035

        Image{
            height: homeItem.height / 2
            width: homeItem.width / 2
            anchors.centerIn: homeItem
            source: "qrc:/resources/icons/home.png"
        }

        onClicked: {
            pageStack.pop(null) //To explicitly unwind to the bottom of the stack, it is recommended to use pop (null), although any non-existent item will do.
        }
    }


    // Toolbar pa time i buttoni "Today" i "Week" se prikazuju kad nije otvorena stranica HomePage,
    // a u svakom takvom slučaju stranica odnosno currentItem ima cityName, longitude i latitude.

    Button {
        id: currentWeatherButton
        text: qsTr("Today")
        font.bold: true
        y: 2
        height: parent.height / 1.1
        anchors.left: homeItem.right
        anchors.leftMargin: parent.width * 0.1

        onClicked: {
            //console.log("pageStack: " + pageStack.currentItem.objectName) //todo
            toolBar.state = 'currentButtonOn'

            if (pageStack.currentItem.objectName !== "CurrentWeatherPage") {
//                    if (pageStack.currentItem.objectName === "SevenDaysWeatherPage") // todo
//                        pageStack.pop()
//                    else
                pageStack.push("qrc:/qml/pages/CurrentWeatherPage.qml",
                               {
                                   cityName: pageStack.currentItem.cityName,
                                   longitude : pageStack.currentItem.longitude,
                                   latitude : pageStack.currentItem.latitude,
                                   weatherData: pageStack.currentItem.weatherData,
                                   units: pageStack.currentItem.units
                               })
            }
        }
    }

    Button {
        id: weekWeatherButton
        text: qsTr("Week")
        font.bold: true
        height: parent.height / 1.1
        y: 2
        anchors.left: currentWeatherButton.right
        anchors.leftMargin: 20

        onClicked: {
            //console.log("pageStack: " + pageStack.currentItem.objectName) //todo
            toolBar.state = 'currentButtonOff'

            if (pageStack.currentItem.objectName !== "SevenDaysWeatherPage") {
                pageStack.push("qrc:/qml/pages/SevenDaysWeatherPage.qml",
                               {
                                   cityName: pageStack.currentItem.cityName,
                                   longitude : pageStack.currentItem.longitude,
                                   latitude : pageStack.currentItem.latitude,
                                   weatherData: pageStack.currentItem.weatherData,
                                   units: pageStack.currentItem.units
                               })
            }
        }
    }

    Pane {
        id: citiesSuggestionBox
        width: parent.width / 4
        height: parent.height / 1.5
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: unitsToggleButton.left
        anchors.rightMargin: parent.width * 0.01
        padding: 0
        Material.elevation: 6

        CitiesSuggestionBox {
            anchors.fill: parent
            fontSize: 12
        }
    }

    UnitsToggleButton {
        id: unitsToggleButton
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.05


        onToggled: function (units) { toolBar.unitsButtonToggled(units) }
    }

    states: [
            State {
                name: "currentButtonOff"
                PropertyChanges { target: currentWeatherButton; Material.foreground: Material.White }
                PropertyChanges { target: weekWeatherButton; Material.foreground: "dimgray" }
            },
            State {
                name: "currentButtonOn"
                PropertyChanges { target: currentWeatherButton; Material.foreground: "dimgray" }
                PropertyChanges { target: weekWeatherButton; Material.foreground: Material.White }
            }
        ]

    Component.onCompleted: {
        state = "currentButtonOn"
    }
}
