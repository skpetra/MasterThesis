import QtQuick 2.0
import QtQuick.Controls
import QtCharts
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 2.12

// Element za odabir i prikaz detaljnih informacija o vjetru, padalinama i tlaku zraka po satima.
// Detalji su prikazani na grafu, a ovisno ovdje o odabranom elementu prikazuje se windChart, precipitationChart ili pressureChart.
Item {

    id: hourlyDetailsWidget

    // --- public ---
    property alias loader: hourlyDetailsChartLoader
    signal widgetTabChanged(string tabName)

    // --- private properties ---
    property string _tab: "wind"

    // ToolBar za odabir koje vrste informacija koje će se prikazivati na grafu (wind, precipitation ili pressure).
    ToolBar {
        id: selectPanel
        width: parent.width
        height: 40 // fiksne visine
        z: 2
        padding: 0
        Material.background: "dimgray"

        Button{
            id: windButton
            width: selectPanel.height
            height: width
            Material.background: "dimgray" // ovaj gumb je početno selektiran
            anchors.right: precipitationButton.left            
            anchors.rightMargin: parent.width * 0.05

            Image {
                width: parent.width * 0.7
                height: parent.height * 0.7
                source: "qrc:/resources/icons/wind.png"
                anchors.centerIn: parent
            }

            onClicked: {
                // isticanje stisnutog gumba
                Material.background = "dimgray"
                precipitationButton.Material.background = "transparent"
                pressureButton.Material.background = "transparent"
                // trenutno otvoreni tab
                _tab = "wind"
                hourlyDetailsWidget.widgetTabChanged(_tab)
            }
        }


        Button{
            id: precipitationButton
            width: selectPanel.height
            height: width
            anchors.horizontalCenter: parent.horizontalCenter
            Material.background: "transparent"

            Image {
                width: parent.width * 0.9
                height: parent.height * 0.9
                source: "qrc:/resources/icons/umbrella.png"
                anchors.centerIn: parent
            }

            onClicked: {
                // isticanje stisnutog gumba
                Material.background = "dimgray"
                windButton.Material.background = "transparent"
                pressureButton.Material.background = "transparent"
                // trenutno otvoreni tab
                _tab = "precipitation"
                hourlyDetailsWidget.widgetTabChanged(_tab)
            }
        }

        Button{
            id: pressureButton
            width: selectPanel.height
            height: width
            anchors.left: precipitationButton.right
            anchors.leftMargin: parent.width * 0.05
            Material.background: "transparent"

            Image {
                width: parent.width * 0.6
                height: parent.height * 0.6
                source: "qrc:/resources/icons/pressure.png"
                anchors.centerIn: parent
            }

            onClicked: {
                // isticanje stisnutog gumba
                Material.background = "dimgray"
                windButton.Material.background = "transparent"
                precipitationButton.Material.background = "transparent"
                // trenutno otvoreni tab
                _tab = "pressure"
                hourlyDetailsWidget.widgetTabChanged(_tab)
            }
        }
    }

    // Panel za učitavanje grafa detaljnih informacija po satima.
    Pane {
        id: hourlyDetailsChartItem
        width: parent.width
        height: parent.height - selectPanel.height
        anchors.bottom: parent.bottom
        Material.background: "white"
        Material.elevation: 6
        padding: 0

        Loader {
            id: hourlyDetailsChartLoader
            anchors.fill: parent
        }
    }
}
