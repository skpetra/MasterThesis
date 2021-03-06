import QtQuick 6.0
import QtQuick.Controls 2.15

// Search bar za odabir grada za prikaz vremenske prognoze.
// Sastoji se od tekstualnog polja za unos imena grada i dropdowna za prikaz liste gradova dostupnih za odabir.
Item {

    id: suggestionBox

    // --- public properties ---
    property bool isEmpty: true
    property int fontSize: 15

    width: parent.width / 2
    height: 35

    // polje za unos teksta
    TextField {
        id: cityTextField

        implicitWidth: parent.width
        implicitHeight: parent.height // zbog cityTextField.contentHeight warninga - QML TextField: Binding loop detected for property "implicitHeight" // todo
        placeholderText: qsTr("Enter city")
        validator: RegularExpressionValidator { regularExpression: /\p{L}+/ }
        font.pixelSize: fontSize
        clip: true

        // uređivanje polja
        background: Rectangle {
            id: backgroundRectangle
            //border.color: cityTextField.activeFocus ? "gray" : "darkgray"
            radius: 2
        }

        // -- ikona povećala
        Item {
            id: itemMagnifier
            anchors.top: cityTextField.top
            anchors.left: cityTextField.left
            anchors.margins: cityTextField.height * 0.15 // margine oko povećala su 15% visine polja za unos texta
            height: suggestionBox.height - 2 * anchors.margins
            width: suggestionBox.height - 2 * anchors.margins
            Image{
                id: iconMagnifier
                height: parent.height
                width: parent.width
                source: "../../resources/icons/magnifier.png"
                smooth: true
                fillMode: Image.PreserveAspectFit
            }
        }

        // text pomaknut nakon ikone povećala
        leftPadding: itemMagnifier.width + 2 * itemMagnifier.anchors.margins
        rightPadding: itemBackspace.width + 2 * itemBackspace.anchors.margins
        // vertikalno centriranje teksta
        topPadding: (cityTextField.height - cityTextField.contentHeight) / 2


        // brisanje unesenog teksta na gumb
        MouseArea {
            id: itemBackspace
            height: suggestionBox.height - 2 * anchors.margins
            width: suggestionBox.height - 2 * anchors.margins
            anchors.top: cityTextField.top
            anchors.right: cityTextField.right
            anchors.margins: cityTextField.height * 0.15

            opacity: isEmpty ? 0 : 1
            Accessible.role: Accessible.Button
            Accessible.name: qsTr("Clear")

            // backspace ikona
            Image {
                anchors.centerIn: parent
                source: "../../resources/icons/backspace.png"
                height: parent.height
                width: parent.width
            }
            onClicked: cityTextField.text = ""

            Behavior on opacity { NumberAnimation {} }
        }

        onTextChanged: {
            isEmpty = (text === "")
            setSuggestionBoxState(text)
        }
    }

    // dropdown za prikaz liste gradova dostupnih za odabir
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
            //snapMode: ListView.SnapToItem // kraj poravnava s najbližim elementom

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
                        anchors.leftMargin: itemMagnifier.anchors.leftMargin * 1.6
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
                            // requestWeatherData(filterModel.getCityName(q_model_index))

                            // cityTextField.text = filterModel.getCityName(q_model_index) ---- kad se vratim sa sljedeće stranice na ovu s BACK da ostane upisan traženi grad
                            cityTextField.text = ""

                            pageStack.push("qrc:/qml/pages/CurrentWeatherPage.qml",
                                           {
                                               cityName: filterModel.getCityName(q_model_index),
                                               longitude: filterModel.getCityLongitude(q_model_index),
                                               latitude: filterModel.getCityLatitude(q_model_index),
                                               units: pageStack.currentItem.units ? pageStack.currentItem.units : "celsius" // ako je grad odabran na HomePage defaultno ce bit toggleButton na °C, inače se temperatura prikazuje ovisno o jedinici koja je bila odabrana na prethodnoj stranici (Current ili SevenDays page)
                                           })
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
            height: filterModel.rowCount() ? setDropDownHeight() : 0
        }
    }

    transitions: Transition {
        NumberAnimation {
            target: dropDown
            properties: "height"
            easing.type: Easing.OutExpo
            duration: 1000
        }
    }


    // --- private functions ---

    // Funkcija za postavljanje stanja suggestion box-a ovisno o unesenom tekstu.
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

    // dropDown prikazuje do 5 elemenata
    function setDropDownHeight(){
        if (filterModel.rowCount() > 5)
            return 5 * suggestionBox.height * 0.7

        return filterModel.rowCount() * suggestionBox.height * 0.7
    }
}
