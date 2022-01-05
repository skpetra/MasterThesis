import QtQuick 2.0
import QtQuick.Controls.Material 2.2

// Toggle button za odabir temperaturne mjerne jedinice u kojoj će se prikazivati svi podaci o temperaturi na stranici.
Pane {
    id: unitsToggleButton

    // --- public properties ---
    property bool celsius: true // false = fahrenheit

    signal toggled(string units)

    Material.elevation: 6
    contentHeight: 30
    contentWidth: contentHeight * 2
    padding: 0

    // glavni pravokutnik
    Rectangle {
        id: unitsToggleButtonRect
        radius: height * 0.05
        anchors.fill: parent
        color: "gray"

        Text {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.15
            font.pixelSize: 14
            color: "white"
            text: "°C"
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: parent.width * 0.15
            font.pixelSize: 14;
            color: "white"
            text: "°F"
        }

        // klizni pravokutnik
        Rectangle {
            anchors.fill: parent
            anchors.leftMargin: celsius ? 0 : (parent.width * 0.5)
            anchors.rightMargin: celsius ? (parent.width * 0.5) : 0
            radius: unitsToggleButtonRect.radius
            color: "lightgray"
            Text {
                id: text;
                anchors.centerIn: parent;
                font.pixelSize: 14;
                font.bold: true
                color: "dimgray"
                text: celsius ? "°C" : "°F"
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                celsius = !celsius
                unitsToggleButton.toggled(celsius ? "celsius" : "fahrenheit")
            }
        }
    }
}
