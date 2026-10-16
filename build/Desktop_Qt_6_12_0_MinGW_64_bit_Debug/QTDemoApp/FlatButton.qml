import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

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
    onHoveredChanged: {
        console.log(
            "Button:", text,
            "Hovered:", hovered,
            "Primary:", primary,
            "Enabled:", enabled,
            "Background:", background.color
        )
         console.log("Is Primary:", fb.primary)
    }
}
