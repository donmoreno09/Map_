import QtQuick

ListModel {
    id: shipModel
    ListElement { name: "MV Pioneer"; latitude: 14.2; longitude: 121.0; status: "En Route"; speed: "12 knots"; destination: "Cebu Port" }
    ListElement { name: "SS Voyager"; latitude: 13.8; longitude: 120.7; status: "Arrived"; speed: "15 knots"; destination: "Manila Port" }
    ListElement { name: "Ocean Explorer"; latitude: 14.5; longitude: 120.9; status: "Delayed"; speed: "10 knots"; destination: "Batangas Port" }
}
