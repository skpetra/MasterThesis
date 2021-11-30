import QtQuick 2.0

Rectangle {

    id: unitsToggleButton

    property bool celsius: true

    signal toggled(string units)

    height: 30
    width: height * 2
    radius: height * 0.25
    color: "lightgray"


    Text {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.15
        font.pixelSize: 14;
        text: "°C"
    }

    Text {
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.15
        font.pixelSize: 14;
        text: "°F"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            celsius = !celsius
            unitsToggleButton.toggled(celsius ? "celsius" : "fahrenheit")
        }
    }

    Item{
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.leftMargin: celsius ? 0 : (parent.width * 0.5)
        anchors.rightMargin: celsius ? (parent.width * 0.5) : 0
        Rectangle {
            anchors.fill: parent
            radius: unitsToggleButton.height * 0.25
            color: "gray"
            Text {
                id: text;
                anchors.centerIn: parent;
                font.pixelSize: 14;
                font.bold: true
                text: celsius ? "°C" : "°F"
            }
        }
    }

}
