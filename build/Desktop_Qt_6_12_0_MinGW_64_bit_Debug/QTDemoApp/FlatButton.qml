import QtQuick
import QtQuick.Controls

Button {
    id: fb
    property bool primary: false
    font.family: "Segoe UI"
    font.pixelSize: 14
    font.weight: Font.DemiBold
    implicitHeight: 44
    padding: 10
    hoverEnabled: false
    background: Rectangle {
        radius: 7
        color: fb.primary ? "#1A8080" : "#FFFFFF"
        border.color: "#1A8080"
        border.width: 1
        opacity: 1.0
    }
    contentItem: Text {
        text: fb.text
        font: fb.font
        color: fb.primary ? "#FFFFFF" : "#1A8080"
        opacity: 1.0
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
}
