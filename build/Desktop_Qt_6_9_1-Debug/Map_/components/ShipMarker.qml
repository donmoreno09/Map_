import QtQuick
import QtLocation
import QtPositioning
import QtQuick.Controls

MapQuickItem {
    id: shipMarker
    coordinate: QtPositioning.coordinate(latitude, longitude)
    anchorPoint.x: 12
    anchorPoint.y: 12

    property string name
    property string status
    property string speed
    property string destination
    property real latitude
    property real longitude
    property var mapRef
    property var dialogsRef // Riferimento al componente Dialogs

    sourceItem: Rectangle {
        width: 24
        height: 24
        color: "red"
        border.color: "white"
        radius: 12
        Text {
            anchors.centerIn: parent
            text: "\u2693"  // Ship anchor symbol
            font.pixelSize: 14
            color: "white"
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            var shipPixelCoords = mapRef.fromCoordinate(QtPositioning.coordinate(latitude, longitude));
            dialogsRef.openShipInfo(name, status, speed, destination, shipPixelCoords.x, shipPixelCoords.y);
        }
    }
}
