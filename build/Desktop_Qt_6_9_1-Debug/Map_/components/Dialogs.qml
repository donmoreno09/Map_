import QtQuick
import QtQuick.Controls

Item {
    id: dialogs

    function openShipInfo(name, status, speed, destination, xPos, yPos) {
        shipInfoDialog.name = name;
        shipInfoDialog.status = status;
        shipInfoDialog.speed = speed;
        shipInfoDialog.destination = destination;
        shipInfoDialog.x = xPos - shipInfoDialog.width / 2;
        shipInfoDialog.y = yPos - shipInfoDialog.height - 10;
        shipInfoDialog.open();
    }

    function openPortInfo(name, xPos, yPos) {
        portInfoDialog.name = name;
        portInfoDialog.x = xPos - portInfoDialog.width / 2;
        portInfoDialog.y = yPos - portInfoDialog.height - 10;
        portInfoDialog.open();
    }

    Popup {
        id: shipInfoDialog
        width: 250
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        property string name
        property string status
        property string speed
        property string destination

        contentItem: Rectangle {
            width: parent.width
            color: "white"
            border.color: "gray"
            radius: 10

            Column {
                padding: 10
                spacing: 10
                Text {
                    text: "Name: " + shipInfoDialog.name
                }
                Text {
                    text: "Status: " + shipInfoDialog.status
                }
                Text {
                    text: "Speed: " + shipInfoDialog.speed
                }
                Text {
                    text: "Destination: " + shipInfoDialog.destination
                }
            }
        }
    }

    Popup {
        id: portInfoDialog
        width: 250
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        property string name

        contentItem: Rectangle {
            width: parent.width
            color: "white"
            border.color: "gray"
            radius: 10

            Column {
                spacing: 10
                Text {
                    text: "Port: " + portInfoDialog.name
                    padding: 10
                }
            }
        }
    }
}
