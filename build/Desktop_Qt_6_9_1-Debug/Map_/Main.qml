import QtQuick
import QtLocation
import QtPositioning
import QtQuick.Controls

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Map Test")

    ListModel {
        id: portModel
        ListElement { name: "Manila Port"; latitude: 14.583; longitude: 120.970 }
        ListElement { name: "Batangas Port"; latitude: 13.757; longitude: 121.058 }
        ListElement { name: "Cebu Port"; latitude: 10.307; longitude: 123.933 }
    }

    ListModel {
        id: shipModel
        ListElement {name: "MV Pioneer"; latitude: 14.2; longitude: 121.0; heading: 45; speed: "12 knots"; destination: "Cebu Port"}
        ListElement {name: "SS Voyager"; latitude: 13.8; longitude: 120.7; heading: 90; speed: "15 knots"; destination: "Manila Port"}
    }

    Plugin {
        id: mapPlugin
        name: "osm"
    }

    Map {
        id: map
        anchors.fill: parent
        plugin: mapPlugin
        center: QtPositioning.coordinate(12.87, 121.47)
        zoomLevel: 5
        property geoCoordinate startCentroid

            PinchHandler {
                id: pinch
                target: null
                onActiveChanged: if (active) {
                    map.startCentroid = map.toCoordinate(pinch.centroid.position, false)

                }
                onScaleChanged: (delta) => {
                    map.zoomLevel += Math.log2(delta)
                    map.alignCoordinateToPoint(map.startCentroid, pinch.centroid.position)
                }
                onRotationChanged: (delta) => {
                    map.bearing -= delta
                    map.alignCoordinateToPoint(map.startCentroid, pinch.centroid.position)
                }
                grabPermissions: PointerHandler.TakeOverForbidden
            }
            WheelHandler {
                id: wheelandler
                acceptedDevices: Qt.platform.pluginName === "cocoa" || Qt.platform.pluginName === "wayland"
                                 ? PointerDevice.Mouse | PointerDevice.TouchPad
                                 : PointerDevice.Mouse
                rotationScale: 1/120
                property: "zoomLevel"
            }
            DragHandler {
                id: drag
                target: null
                onTranslationChanged: (delta) => map.pan(-delta.x, -delta.y)
            }
            Shortcut {
                enabled: map.zoomLevel < map.maximumZoomLevel
                sequence: StandardKey.ZoomIn
                onActivated: map.zoomLevel = Math.round(map.zoomLevel + 1)
            }
            Shortcut {
                enabled: map.zoomLevel > map.minimumZoomLevel
                sequence: StandardKey.ZoomOut
                onActivated: map.zoomLevel = Math.round(map.zoomLevel - 1)
            }
            Repeater {
                model: portModel
                delegate: MapQuickItem {
                    coordinate: QtPositioning.coordinate(latitude, longitude)
                    anchorPoint.x: 12
                    anchorPoint.y: 12
                    sourceItem: Rectangle {
                        width: 24
                        height: 24
                        color: "blue"
                        border.color: "white"
                        radius: 12
                        Text {
                            anchors.centerIn: parent
                            text: "\u26F4"  // Anchor symbol
                            font.pixelSize: 14
                            color: "white"
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                var portCoords = map.fromCoordinate(QtPositioning.coordinate(latitude, longitude))
                                portInfoDialog.currentIndex = index
                                portInfoDialog.x = portCoords.x - portInfoDialog.width / 2
                                portInfoDialog.y = portCoords.y - portInfoDialog.height - 10
                                portInfoDialog.open()
                            }
                        }
                    }
                }
            }
            Repeater {
                model: shipModel
                delegate: MapQuickItem {
                    coordinate: QtPositioning.coordinate(latitude, longitude)
                    anchorPoint.x: 12
                    anchorPoint.y: 12
                    sourceItem: Rectangle {
                        width: 24
                        height: 24
                        color: "red"
                        border.color: "white"
                        radius: 12

                        Text
                        {
                            anchors.centerIn: parent
                            text: "\u2693"
                            font.pixelSize: 14
                            color: white
                        }
                        MouseArea
                        {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                var shipCoords = map.fromCoordinate(QtPositioning.coordinate(latitude, longitude))
                                shipInfoDialog.currentIndex = index
                                shipInfoDialog.x = shipCoords.x - shipInfoDialog.width / 2
                                shipInfoDialog.y = shipCoords.y - shipInfoDialog.height - 10
                                shipInfoDialog.open()
                            }
                        }
                    }
                }
            }

    }

    Dialog {
        id: shipInfoDialog
        modal: true
        title: "Ship Informations"
        // visible: false

        contentItem: Column {
            spacing: 10
            padding: 10
            Text {
                text: "Name: " + shipModel.get(shipInfoDialog.currentIndex).name
            }
            Text {
                text: "Speed: " + shipModel.get(shipInfoDialog.currentIndex).speed
            }
            Text {
                text: "Destination: " + shipModel.get(shipInfoDialog.currentIndex).destination
            }
        }

        property int currentIndex: -1

    }

    Dialog {
        id: portInfoDialog
        modal: true
        title:"Port Informations"
        // visible: false

        contentItem: Column {
            spacing: 10
            padding: 10

            Text {
                text: "Name: " + portModel.get(portInfoDialog.currentIndex).name
            }
            Text {
                text: "Latitude: " + portModel.get(portInfoDialog.currentIndex).latitude
            }
            Text {
                text: "Longitude: " + portModel.get(portInfoDialog.currentIndex).longitude
            }

        }

        property int currentIndex: -1
    }

    Drawer {
            id: sidebar
            width: 240
            edge: Qt.LeftEdge
            visible: true

            Column {
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
                        shipListView.model = filterShips(filterComboBox.currentText);
                    }
                }

                ListView {
                    id: shipListView
                    width: parent.width
                    height: parent.height
                    model: shipModel
                    delegate: Rectangle {
                        width: parent.width
                        height: 60
                        color: "lightgray"
                        border.color: "gray"
                        radius: 5

                        Row {
                            spacing: 10
                            anchors.fill: parent
                            anchors.margins: 5

                            Text {
                                text: model.name
                                font.pixelSize: 14
                                font.bold: true
                            }
                            Text {
                                text: "Status: " + model.status
                                font.pixelSize: 12
                            }
                            Text {
                                text: "Destination: " + model.destination
                                font.pixelSize: 12
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                map.center = QtPositioning.coordinate(model.latitude, model.longitude);
                                sidebar.visible = false;  // Hide the sidebar after selecting the ship
                            }
                        }
                    }
                }
            }
        }

        // Function to filter ships based on status
        function filterShips(status) {
            if (status === "All") {
                return shipModel;  // Show all ships
            }

            var filteredModel = Qt.createQmlObject('import QtQuick 2.0; ListModel {}', sidebar);
            for (var i = 0; i < shipModel.count; i++) {
                var ship = shipModel.get(i);
                if (ship.status === status) {
                    filteredModel.append(ship);
                }
            }
            return filteredModel;
        }
}
