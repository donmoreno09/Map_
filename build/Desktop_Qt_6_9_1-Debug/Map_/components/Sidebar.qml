import QtQuick
import QtQuick.Controls
import QtPositioning

Drawer {
    id: sidebar
    edge: Qt.LeftEdge

    property var map
    property var shipModel
    property var shipInfoDialog

    Column {
        anchors.fill: parent
        spacing: 10
        padding: 10

        Text {
            text: "Ship Dashboard"
            font.pixelSize: 16
            font.bold: true
        }

        ComboBox {
            id: filterComboBox
            model: ["All", "En Route", "Arrived", "Delayed"]
            currentIndex: 0
            onCurrentIndexChanged: {
                filterShips(filterComboBox.currentText);
            }
        }

        ListView {
            id: shipListView
            width: 300
            height: 300
            spacing: 10
            model: shipModel
            delegate: Rectangle {
                width: parent.width - 20
                height: 80
                radius: 8
                color: "#f5f5f5"
                border.color: "#cccccc"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: 10

                Column {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 4

                    Text {
                        text: model.name
                        font.pixelSize: 16
                        font.bold: true
                        color: "#333"
                    }
                    Text {
                        text: "Status: " + model.status
                        font.pixelSize: 13
                        color: "#666"
                    }
                    Text {
                        text: "Destination: " + model.destination
                        font.pixelSize: 13
                        color: "#666"
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        var shipPixelCoords = map.fromCoordinate(QtPositioning.coordinate(model.latitude, model.longitude));
                        map.center = QtPositioning.coordinate(model.latitude, model.longitude);
                        sidebar.visible = false;
                        shipInfoDialog.openShipInfo(model.name, model.status, model.speed, model.destination, shipPixelCoords.x, shipPixelCoords.y);
                    }
                }
            }
        }
    }
    property var filteredModel: ListModel {
        id: filteredShipModel
    }

    function filterShips(status) {
        filteredModel.clear(); // Svuota il modello filtrato

        if (status === "All") {
            for (var i = 0; i < shipModel.count; i++) {
                filteredModel.append(shipModel.get(i));
            }
            return;
        }

        for (var j = 0; j < shipModel.count; j++) {
            var ship = shipModel.get(i);
            if (ship.status === status) {
                filteredModel.append(ship);
            }
        }
        shipListView.model = filteredModel; // Assegna il modello aggiornato
    }
}
