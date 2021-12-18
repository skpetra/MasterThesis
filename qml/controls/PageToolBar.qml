import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts

// Toolbar na svim stranicama osim početne. Sadrži elemente koji omogućuju povratak na početnu stranicu,
// odabir trenutne ili tjedne vremenske prognoze, odabir novog grada za prikaz vremenske prognoze
// te promjenu mjerne jedinice temperature.
ToolBar {
    id: toolBar

    signal unitsButtonToggled(string units)

    RowLayout {
        anchors.fill: parent

        ToolButton {
            id: homeItem

            Image{
                height: homeItem.height
                width: homeItem.width
                source: "qrc:/resources/icons/home.png"
                opacity: 0.2
            }
            onClicked: {
                pageStack.pop(null) //To explicitly unwind to the bottom of the stack, it is recommended to use pop (null), although any non-existent item will do.
            }
        }

        // Toolbar pa time i buttoni "Today" i "Week" se prikazuju kad nije otvorena stranica MenuPage,
        // a u svakom takvom slučaju stranica odnosno currentItem ima cityName, longitude i latitude.

        Button {
            id: currentWeatherButton

            text: qsTr("Today")
            Layout.alignment: Qt.AlignLeft

            onClicked: {
                console.log("pageStack: " + pageStack.currentItem.objectName)

                if (pageStack.currentItem.objectName !== "CurrentWeatherPage") {
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

            onClicked: {
                console.log("pageStack: " + pageStack.currentItem.objectName)

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

        CitiesSuggestionBox {
            id: citiesSuggestionBox

            x: unitsToggleButton.x - width - 10
            width: parent.width / 3
            height: parent.height
        }

        UnitsToggleButton {
            id: unitsToggleButton
            Layout.alignment: Qt.AlignRight

            onToggled: function (units) { toolBar.unitsButtonToggled(units) }
        }
    }
}
