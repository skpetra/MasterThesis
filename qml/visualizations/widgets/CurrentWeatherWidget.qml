import QtQuick 2.0
import QtQuick.Layouts
import QtQuick.Controls.Material

import "qrc:/js/utils.js" as Utils
import "qrc:/js/config.js" as Config

import ".."

// Centralni collapsible element za prikaz podataka o trenutnoj vremenskoj prognozi.
// Logički je podijeljen je na dva dijela, osnovne podatke - ime grada, animacija trenutnog vremena,
// trenutna i feels like temperatura, te dio s detaljima (izlazak/zalazak sunca, vlažnost zraka, vjetar, uv indeks) koji je inicijalno skriven.
// Klikom na osnovne podatke otvara se prikaz detalja kojeg je nakon pregleda moguće sakriti.
Item {

    id: currentWeatherWidget

    // --- public properties ---
    property string cityName
    property int widgetHeight // dobivena visina potrebna da visina detalja ne ovisi o visini osnovnih podataka
    // - mainItem -
    property alias temperature: currentTemperatureText.text
    property alias feelsLike: feelsLikeTemperatureText.text
    property alias weatherAnimation: weatherAnimationLoader
    property alias weatherAnimationDimensions: weatherAnimationItem.width
    // - detailsItem -
    property alias windDetails: windDetailsWidget
    property alias humidityDetails: humidityDetailsWidget
    property alias uviDetails: uviWidget
    property alias sunDetails: sunWidget

    height: widgetHeight

    // --- osnovni podaci ---
    RowLayout{
        id: mainItem
        width: parent.width * 0.9
        height: widgetHeight
        anchors.horizontalCenter: parent.horizontalCenter

        // ime grada
        Text {          
            text: qsTr(cityName)
            height: parent.height
            font.bold: true           
            font.pixelSize: 50
            fontSizeMode: Text.Fit
            color: "#252525"
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            Layout.preferredWidth: mainItem.width / 3
            //Layout.maximumWidth: rowLayout.width / 3 // todo
        }

        // animacija vremenskih uvjeta
        Rectangle {
            height: mainItem.height
            color: "transparent"
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: mainItem.width / 3

            Rectangle {
                id: weatherAnimationItem

                width: mainItem.height
                height: width
                color: "transparent"
                anchors.centerIn: parent

                Loader {
                    id: weatherAnimationLoader
                }
            }
        }

        // trenutna i feels like temperatura
        Rectangle {
            id: temperatureGroupBox
            height: mainItem.height
            color: "transparent"
            Layout.preferredWidth: mainItem.width / 3

            Text {
                id: currentTemperatureText
                width: temperatureGroupBox.width / 2
                font.bold: true
                font.pixelSize: 50
                color: "#252525"
                fontSizeMode: Text.Fit
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                horizontalAlignment: Text.AlignRight
            }

            Text {
                id: feelsLikeTemperatureText
                font.bold: true
                font.pixelSize: 25
                fontSizeMode: Text.Fit
                color: "gold"
                width: temperatureGroupBox.width / 2
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
            }
        }
    }

    // strelica za otvaranje detalja
    Image{
        id: arrowDown
        source: "qrc:/resources/icons/triangleBottomIcon.png"
        height: 8
        width: 8
        z: 2
        anchors.right: currentWeatherWidget.right
        anchors.rightMargin: (currentWeatherWidget.width - mainItem.width) / 2
        anchors.bottom: currentWeatherWidget.bottom
        anchors.bottomMargin: 5

        Behavior on rotation {
             NumberAnimation { duration: 500 }
        }
    }

    // ------- -------

    // --- detalji ---
    Rectangle {
        id: detailsItem
        width: mainItem.width
        height: 0
        opacity: 0
        color: "transparent"
        anchors.top: mainItem.bottom
        anchors.horizontalCenter: mainItem.horizontalCenter

        Pane {
            id: panel
            padding: 0
            Material.elevation: 6
            anchors.fill: parent
            clip: true

            RowLayout {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                Layout.margins: 0
                Layout.fillWidth: true
                spacing: detailsItem.width * 0.05

                SunsetSunriseWidget {
                    id: sunWidget
                }

                HumidityWidget {
                    id: humidityDetailsWidget
                }

                DailyWindWidget {
                    id: windDetailsWidget
                }

                UVIndexWidget {
                    id: uviWidget
                }
           }
        }
    }

    // ------- -------

    // separator elemenata
    Pane {
        id: rectSeparator
        width: mainItem.width
        height: 3
        anchors.bottom: currentWeatherWidget.bottom
        anchors.horizontalCenter: mainItem.horizontalCenter
        Material.elevation: 6
        Material.background: "gold"
    }

    // klikabilno područje za prikaz odnosno skrivanje detalja
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            currentWeatherWidget.state = currentWeatherWidget.state === 'Details' ? '' : 'Details'
            // zaustavljanje vjetrenjača kad element nije vidljiv
            windDetailsWidget.isVisible = currentWeatherWidget.state === 'Details' ? true : false
            // odgađanje pokretanja animacije koja prikazuje postotak vlažnosti dok element ne postane vidljiv
            humidityDetails.isVisible = currentWeatherWidget.state === 'Details' ? true : false
        }
    }

    states: State {
        name: "Details"
        PropertyChanges { target: detailsItem; opacity: 1 }
        // "otvaranje" pravokutnika za prikaz detalja
        PropertyChanges { target: detailsItem; height: widgetHeight * 0.8 }
        PropertyChanges { target: currentWeatherWidget; height: widgetHeight * 1.8 }
        PropertyChanges { target: arrowDown; rotation: 180 }
    }

    transitions: Transition {
        //Make the state changes smooth
        NumberAnimation { duration: 500; property: "height" }
        NumberAnimation { duration: 500; property: "opacity" }
    }
}
