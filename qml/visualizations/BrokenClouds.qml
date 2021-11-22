import QtQuick 2.0

Item {
    id: brokenCloudsItem

    implicitWidth: 120 //100+20
    implicitHeight: 70 //60+10

    Cloud {
        x: 20
        cloudColor: "dimgray"
    }

    Cloud { y: 10 }
}
