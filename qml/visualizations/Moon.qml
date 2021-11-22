import QtQuick
import QtQuick3D

Item {
    id: moonItem
    implicitWidth: 200
    implicitHeight: 200

    View3D {
        anchors.fill: parent

        PerspectiveCamera { z: 400 }

        SpotLight {
            z: 300
            brightness: 10
            ambientColor: Qt.rgba(0.1, 0.1, 0.1, 1.0)
        }

        Model {
            source: "#Sphere"
            //scale: Qt.vector3d(2, 2, 2)
            materials: PrincipledMaterial {
                baseColor: "dimgray"
                roughness: 0.01
            }
        }
    }
}
