pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls.Basic

Rectangle {
    id: table
    property var specimens: []
    readonly property var headings: ["#", "Probe Name", "Begin of Young’s…", "m", "(C/N)^1/3", "Date and Time", "m", "Bruch kN", "Appl. Eng.", "Break N"]
    readonly property var weights: [0.05,0.11,0.11,0.05,0.08,0.14,0.05,0.15,0.16,0.10]
    implicitHeight: 34 + specimens.length * 30
    radius: 5; color: "white"; border.color: "#d2d8e1"; clip: true
    function value(row, col) {
        if(row < 0 || row >= specimens.length) return "-"
        var specimen=specimens[row]
        if(col===0) return String(specimen.number)
        if(col===1) return specimen.name
        if(col===5) return specimen.date
        if(col===7) return specimen.force
        if(col===8) return specimen.engineer
        if(col===9) return specimen.breakValue
        return "-"
    }
    Flickable {
        id: viewport
        anchors.fill: parent; anchors.margins: 1
        contentWidth: Math.max(width, 1080); contentHeight: 32 + table.specimens.length * 30; clip: true
        ScrollBar.horizontal: ScrollBar {}
        Column {
            width: viewport.contentWidth
            Rectangle {
                width: parent.width; height: 32; color: "#e9ebed"
                Row {
                    anchors.fill: parent
                    Repeater {
                        model: table.headings
                        delegate: Text {
                            required property int index
                            required property string modelData
                            width: viewport.contentWidth*table.weights[index]; height: 32
                            leftPadding: 12; text: modelData; elide: Text.ElideRight
                            verticalAlignment: Text.AlignVCenter; color: "#405574"; font.family: "Segoe UI"; font.pixelSize: 10; font.weight: Font.DemiBold
                        }
                    }
                }
            }
            Repeater {
                model: table.specimens.length
                delegate: Item {
                    id: statisticRow
                    required property int index
                    width: viewport.contentWidth; height: 30
                    Row {
                        anchors.fill: parent
                        Repeater {
                            model: 10
                            delegate: Text {
                                required property int index
                                width: viewport.contentWidth*table.weights[index]; height: 30
                                leftPadding: 12; text: table.value(statisticRow.index,index); elide: Text.ElideRight
                                verticalAlignment: Text.AlignVCenter; color: "#405574"; font.family: "Segoe UI"; font.pixelSize: 10
                            }
                        }
                    }
                    Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: "#e6ebf1" }
                }
            }
        }
    }
}
