import QtQuick 2.12
import QtQuick.Controls 2.12

Rectangle {

    id: suggestionBox

    // properties
    property bool isEmpty: true

    width: parent.width/2
    height: 35


    // polje za unos teksta
    TextField {
        id: cityTextField

        implicitWidth: parent.width
        implicitHeight: parent.height
        placeholderText: qsTr("Enter city")

        // uređivanje polja
        background: Rectangle {
            border.color: cityTextField.activeFocus ? "gray" : "darkgray"
            radius: 2
        }

        // -- ikona povećala
        Item {
            id: itemMagnifier
            anchors.top: cityTextField.top
            anchors.left: cityTextField.left
            anchors.margins: cityTextField.height*0.2 // margine oko povećala su 20% visine polja za unos texta
            height: suggestionBox.height - 2*anchors.margins
            width: suggestionBox.height - 2*anchors.margins
            Image{
                id: iconMagnifier
                height: parent.height
                width: parent.width
                source: "../resources/icons/magnifier.png"
                opacity: 0.2
            }
        }

        // text pomaknut nakon ikone povećala
        leftPadding: itemMagnifier.width + 2*itemMagnifier.anchors.margins
        // centriranje teksta
        topPadding: (height-contentHeight)/2

        // brisanje unesenog teksta
        MouseArea {
            height: suggestionBox.height - 2*anchors.margins
            width: suggestionBox.height - 2*anchors.margins
            anchors.top: cityTextField.top
            anchors.right: cityTextField.right
            anchors.margins: cityTextField.height*0.15

            opacity: isEmpty ? 0 : 1
            Accessible.role: Accessible.Button
            Accessible.name: qsTr("Clear")

            // backspace ikona
            Image {
                anchors.centerIn: parent
                source: "../resources/icons/backspace.png"
                height: parent.height
                width: parent.width
                opacity: 0.2
            }
            onClicked: cityTextField.text = ""

            Behavior on opacity { NumberAnimation{} }
        }

        onTextChanged: {
            isEmpty = (text === "")
            setSuggestionBoxState(text)
        }
    }

    function setSuggestionBoxState(text){
        if(isEmpty){
            suggestionBox.state = ""
        }
        else{
            filterModel.setFilterString(text)

            if (filterModel.rowCount() !== 0){
                suggestionBox.state = "dropDown"
                dropDown.height = setDropDownHeight()
            }
            else
                suggestionBox.state = ""
        }
    }


    Rectangle {
        id: dropDown
        width: suggestionBox.width
        height: 0
        clip: true
        radius: 2
        anchors.top: cityTextField.bottom
        anchors.margins: 2
        color: "lightgray"

        ListView {
            id: listView
            width: parent.width
            height: parent.height
            snapMode: ListView.SnapToItem // kraj poravnava s najbližim elementom

            model: filterModel
            currentIndex: 0

            delegate: Item {
                id: listViewItem
                width: suggestionBox.width
                height: suggestionBox.height * 0.7 // visina ponuđenog grada u listi je 70% textfielda za unos grada

                Rectangle{
                    id: listViewItemRectangle
                    width: parent.width
                    height: parent.height
                    color: "lightgray"

                    Text {
                        text: city + ", " + country
                        anchors.fill: parent
                        anchors.leftMargin: itemMagnifier.anchors.margins
                        verticalAlignment: Text.AlignVCenter
                    }

                    MouseArea {
                        anchors.fill: parent;
                        hoverEnabled: true

                        onEntered: listViewItemRectangle.color = "gray"
                        onExited: listViewItemRectangle.color = "lightgray"


                        onClicked: {
                            suggestionBox.state = "";
                            listView.currentIndex = index;

                            // Column is always zero as it's a list
                            var column_number = 0;
                            // get `QModelIndex` od elementa u filter modelu
                            var q_model_index = filterModel.index(index, column_number);
                            // filterModel.getCityName(q_model_index)------- dobij ime grada iz QModelIndexa
                            requestWeatherData(filterModel.getCityName(q_model_index))

                            // cityTextField.text = filterModel.getCityName(q_model_index) ---- kad se vratim sa sljedeće stranice na ovu s BACK da ostane upisan traženi grad
                            cityTextField.text = ""
                            pageStack.push("qrc:/qml/pages/CityMenuPage.qml", { cityName: filterModel.getCityName(q_model_index)})
                        }
                    }
                }
            }

            ScrollBar.vertical: ScrollBar {
                id: verticalScrollBar
                orientation: Qt.Vertical
                active: pressed || listView.moving
//                opacity: active ? 1:0
//                Behavior on opacity { NumberAnimation { duration: 500 } }

//                 background: Rectangle {
//                 }
//                ILI
//               contentItem: Rectangle {
//                   implicitWidth: 2
//                   radius:10
//                   //color: accentColor
//               }
           }
        }
    }

    states: State {
        name: "dropDown"
        PropertyChanges {
            target: dropDown
            height: setDropDownHeight()
        }
    }

    // dropDown prikazuje do 5 elemenata
    function setDropDownHeight(){
        if (filterModel.rowCount() > 5)
            return 5*suggestionBox.height*0.7

        return filterModel.rowCount()*suggestionBox.height*0.7
    }

    transitions: Transition {
        NumberAnimation {
            target: dropDown
            properties: "height"
            easing.type: Easing.OutExpo
            duration: 1000
        }
    }


    function requestWeatherData(cityName) {
        var xhr = new XMLHttpRequest;
        xhr.open("GET", "https://api.openweathermap.org/data/2.5/weather?q=" + cityName + "&appid=394bb9ce78287e8504f6c5456b49757a");
        xhr.onreadystatechange = function() {
            if (xhr.readyState == XMLHttpRequest.DONE) {
                console.log(xhr.responseText); // ispisuje dohvaćeni json tekst
                var a = JSON.parse(xhr.responseText);
            }
        }
        xhr.send();
    }
}
