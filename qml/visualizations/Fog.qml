import QtQuick 2.0

Item {

    id: fogItem

    property int intensity: 1 // 1 ili 2 - 3 ili 4 crte

    //Cloud { } // 100x60

    Rectangle {
        x: 30
        y: 45
        height: 5
        radius: 10
        color: "dimgray"
        NumberAnimation on width {
            from: 0
            to: 30
            duration: 1100
        }
    }

    Rectangle {
        x: 10
        y: 55
        height: 5
        radius: 10
        color: "dimgray"
        NumberAnimation on width {
            from: 0
            to: 60
            duration: 1400
        }
    }

    Rectangle {
        x: 20
        y: 65
        height: 5
        radius: 10
        color: "dimgray"
        NumberAnimation on width {
            from: 0
            to: 40
            duration: 1500
        }
    }

    Rectangle {
        x: 25
        y: 75
        height: 5
        radius: 10
        color: "dimgray"
        NumberAnimation on width {
            from: 0
            to: 30
            duration: 1200
        }
        visible: intensity == 1 ? false : true
    }
}
