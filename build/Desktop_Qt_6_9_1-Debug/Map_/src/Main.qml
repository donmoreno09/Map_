import QtQuick
import QtLocation
import QtPositioning
import QtQuick.Controls
import "../components"
import "../models"

Window {
    id: window
    width: 640
    height: 480
    visible: true
    title: qsTr("Ship Tracking System")

    Plugin {
        id: mapPlugin
        name: "osm"
    }

    Dialogs {
            id: dialogs
        }


    Map {
        id: map
        anchors.fill: parent
        plugin: mapPlugin
        center: QtPositioning.coordinate(12.87, 121.47)
        zoomLevel: 6

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

        // Port markers
        MapItemView {
            model: PortModel {}
            delegate: PortMarker {
                latitude: model.latitude
                longitude: model.longitude
                name: model.name
                mapRef: map
                dialogsRef: dialogs
            }
        }




        // Ship markers
        MapItemView {
            model: ShipModel {}
            delegate: ShipMarker {
                latitude: model.latitude
                longitude: model.longitude
                name: model.name
                status: model.status
                speed: model.speed
                destination: model.destination
                mapRef: map
                dialogsRef: dialogs
            }
        }

    }

    Button {
        text: "☰"
        anchors {
            left: parent.left
            top: parent.top
            margins: 10
        }
        onClicked: drawer.open()
        z: 10
    }

    Sidebar {
        id: drawer
        map: map
        shipModel: ShipModel {}
        shipInfoDialog: dialogs
    }
}
