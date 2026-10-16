import QtQuick
import QtQuick.Layouts

Rectangle {
    id: headerBar
    property color edgeColor: "#d9dee2"
    implicitHeight: 61
    height: 61
    color: "#eceeef"

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 16
        anchors.rightMargin: 32
        spacing: 14

        Image {
            source: "icons/header-grid.svg"
            Layout.preferredWidth: 17
            Layout.preferredHeight: 17
            fillMode: Image.PreserveAspectFit
        }
        Text {
            textFormat: Text.RichText
            text: "<b>test<span style='color:#ec2029'>X</span>pert</b>"
            font.family: "Segoe UI"
            font.pixelSize: 18
            color: "#111111"
        }
        Text {
            textFormat: Text.RichText
            text: "Level  <font color='#ed2028'>/</font>  Level  <font color='#ed2028'>/</font>  Level"
            font.family: "Segoe UI"
            font.pixelSize: 12
            color: "#3D4043"
            Layout.leftMargin: 20
            visible: headerBar.width >= 850
        }
        Item { Layout.fillWidth: true }

        Image {
            source: "icons/header-shield-off.svg"
            Layout.preferredWidth: 27
            Layout.preferredHeight: 27
            fillMode: Image.PreserveAspectFit
        }
        Rectangle { Layout.preferredWidth: 1; Layout.preferredHeight: 26; color: edgeColor }
        Image {
            source: "icons/header-bell.svg"
            Layout.preferredWidth: 20
            Layout.preferredHeight: 20
            fillMode: Image.PreserveAspectFit
        }
        Image {
            source: "icons/header-settings.svg"
            Layout.preferredWidth: 22
            Layout.preferredHeight: 22
            fillMode: Image.PreserveAspectFit
        }
        Rectangle { Layout.preferredWidth: 1; Layout.preferredHeight: 26; color: edgeColor }
        Rectangle {
            Layout.preferredWidth: 25
            Layout.preferredHeight: 25
            radius: 13
            color: "#367ff5"
            Text {
                anchors.centerIn: parent
                text: "RS"
                font.family: "Segoe UI"
                font.pixelSize: 10
                font.bold: true
                color: "white"
            }
        }
        Rectangle { Layout.preferredWidth: 1; Layout.preferredHeight: 26; color: edgeColor }
        Text {
            textFormat: Text.RichText
            text: "<b>Zwick<span style='color:#ec2029;font-size:21px'>/</span>Roell</b>"
            font.family: "Segoe UI"
            font.pixelSize: 15
            color: "#111111"
        }
    }
}
