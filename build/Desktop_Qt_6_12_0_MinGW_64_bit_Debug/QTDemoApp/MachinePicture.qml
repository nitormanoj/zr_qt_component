import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

Item {
    id: mp
    property string sourcePath: ""
    Image { id: pic; anchors.fill: parent; source: mp.sourcePath; fillMode: Image.PreserveAspectFit; asynchronous: true }
    // Fallback only when the user has not added the original machine images.
    Rectangle {
        visible: pic.status !== Image.Ready
        width: Math.min(parent.width*0.55, 120); height: Math.min(parent.height*0.76, 205)
        anchors.centerIn: parent; color: "transparent"
        Rectangle { x: 9; y: 9; width: parent.width-18; height: 10; color: "#34383d" }
        Rectangle { x: 9; y: 6; width: parent.width-18; height: 4; color: "#e32636" }
        Rectangle { x: 12; y: 19; width: 9; height: parent.height-37; color: "#a2a7ac" }
        Rectangle { x: parent.width-21; y: 19; width: 9; height: parent.height-37; color: "#a2a7ac" }
        Rectangle { x: 20; y: parent.height*0.5; width: parent.width-40; height: 12; color: "#44494f" }
        Rectangle { anchors.horizontalCenter: parent.horizontalCenter; y: parent.height*0.5+12; width: 5; height: 33; color: "#3283b9" }
        Rectangle { x: 2; y: parent.height-19; width: parent.width-4; height: 17; radius: 3; color: "#383c42" }
    }
}
