import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

Rectangle {
    id: landing
    property var app: null
    property color ink: "#202a31"
    property color teal: "#1a8080"
    anchors.fill: parent; anchors.rightMargin: 15; radius: 12; color: "white"
    ListModel {
        id: recent
        ListElement { name: "My Test System For Compression Test"; imagePath: "images/compression.png"; modified: "03.06.2025; 10:27 AM" }
        ListElement { name: "My Test System For Tensile Test"; imagePath: "images/tensile.png"; modified: "03.06.2025; 10:27 AM" }
        ListElement { name: "My Test System For Metal"; imagePath: "images/metal.png"; modified: "03.06.2025; 10:27 AM" }
        ListElement { name: "My Test System For Round Specimen"; imagePath: "images/round-specimen.png"; modified: "03.06.2025; 10:27 AM" }
        ListElement { name: "My Test System For Tensile Test"; imagePath: "images/compression.png"; modified: "03.06.2025; 10:27 AM" }
    }
    Flickable {
        anchors.fill: parent; anchors.margins: 21; contentWidth: width; contentHeight: landingColumn.implicitHeight+20; clip: true
        ColumnLayout {
            id: landingColumn; width: parent.width; spacing: 14
            Text { text: "New"; font.pixelSize: 15; font.bold: true; color: ink; font.family: "Segoe UI" }
            Rectangle {
                width: 314; height: 86; Layout.preferredWidth: 314; Layout.preferredHeight: 86; radius: 7; border.color: createArea.containsMouse ? teal : "#cfd5db"; color: "white"
                Row { anchors.fill: parent; anchors.margins: 10; spacing: 26
                    Rectangle { width: 64; height: 55; radius: 7; color: "#f7f9fa"; Text { anchors.centerIn: parent; text: "+"; font.pixelSize: 31; color: "#ed1c24" } }
                    Text { anchors.verticalCenter: parent.verticalCenter; text: "Create A New Testing System"; font.pixelSize: 13; color: "#111" }
                }
                MouseArea { id: createArea; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: app.openCreateDialog() }
            }
            Text { text: "Recent"; font.pixelSize: 15; font.bold: true; color: ink; Layout.topMargin: 4;font.family: "Segoe UI" }
            GridLayout {
                Layout.fillWidth: true; columns: Math.max(1, Math.min(5, Math.floor(width / 200))); columnSpacing: 15; rowSpacing: 15
                Repeater {
                    model: recent
                    delegate: Rectangle {
                        required property string name; required property string imagePath; required property string modified
                        Layout.fillWidth: true; Layout.preferredHeight: 372; radius: 7; color: "white"; border.color: cardArea.containsMouse ? teal : "#cfd5db"
                        ColumnLayout {
                            anchors.fill: parent; anchors.margins: 10; spacing: 6
                            MachinePicture { Layout.fillWidth: true; Layout.preferredHeight: 273; sourcePath: imagePath }
                            Text { Layout.fillWidth: true; Layout.preferredHeight: 42; text: name; wrapMode: Text.WordWrap; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter; font.pixelSize: 12; color: "#171717" }
                            Text { Layout.fillWidth: true; text: "Modified: " + modified; horizontalAlignment: Text.AlignHCenter; font.pixelSize: 9; color: "#808790" }
                        }
                        MouseArea { id: cardArea; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: { app.testingLabel = name; app.activeSection = "Strain"; app.screen = "setup" } }
                    }
                }
            }
        }
    }
}
