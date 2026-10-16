import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

Rectangle {
    id: navItem
    property var app: null

    property string glyph: ""
    property string menu: ""
    property string iconSource: ""
    width: 48
    height: 48
    radius: 9
    color: app.activeMenu === menu ? "#D2F0F1" : "transparent"
    // Active selection indicator
    Rectangle {
        visible: app.activeMenu === navItem.menu
        width: 3
        height: parent.height
        color: "#008C95"
        anchors.left: parent.left
    }

    Image {
        anchors.centerIn: parent
        width: 21
        height: 21
        source: navItem.iconSource
        fillMode: Image.PreserveAspectFit
        sourceSize.width: 42
        sourceSize.height: 42
        smooth: true
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            app.activeMenu = navItem.menu
        }
    }
}
