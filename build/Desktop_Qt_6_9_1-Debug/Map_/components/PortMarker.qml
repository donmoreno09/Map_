import QtQuick
import QtLocation
import QtPositioning
import QtQuick.Controls

MapQuickItem {
    id: portMarker
    coordinate: QtPositioning.coordinate(latitude, longitude)
    anchorPoint.x: 12
    anchorPoint.y: 12

    property string name
    property real latitude
    property real longitude
    property var mapRef
    property var dialogsRef // Riferimento al componente Dialogs

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
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            var portPixelCoords = mapRef.fromCoordinate(QtPositioning.coordinate(latitude, longitude));
            dialogsRef.openPortInfo(name, portPixelCoords.x, portPixelCoords.y);
        }
    }
}
