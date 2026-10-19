pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

Popup {
    id: popup
    width: 310; padding: 12
    property var selectedPrograms: []
    property var programs: [
        {name: "Bansal wire industries ltd_Tensile Test_Program", count: 47},
        {name: "Admire Researchcenter_7469/2_PH-Best", count: 18},
        {name: "Advartest_KK_Ueberpruefung_020725", count: 9},
        {name: "Brakes India Limited_Tensile test_804.6", count: 27},
        {name: "New India Limited_Tensile test_804.6", count: 27}
    ]
    signal selectionChanged(string name, bool selected)
    function toggle(name) {
        var values = selectedPrograms.slice(), at = values.indexOf(name)
        if (at < 0) values.push(name)
        else values.splice(at, 1)
        selectedPrograms = values
        selectionChanged(name, at < 0)
    }
    function matches(program) { return program.name.toLowerCase().indexOf(search.text.toLowerCase()) >= 0 }
    onAboutToShow: search.clear()
    background: Rectangle { radius: 5; color: "white"; border.color: "#d0d6df" }
    contentItem: ColumnLayout {
        spacing: 10
        TextField {
            id: search; objectName: "programSearch"
            Layout.fillWidth: true; implicitHeight: 32
            placeholderText: "Search"; leftPadding: 30
            font.family: "Segoe UI"; font.pixelSize: 12
            background: Rectangle { radius: 3; color: "white"; border.color: search.activeFocus ? "#00858b" : "#d0d6df" }
            Canvas {
                x: 9; anchors.verticalCenter: parent.verticalCenter; width: 14; height: 14
                onPaint: { var ctx = getContext("2d"); ctx.strokeStyle = "#626975"; ctx.lineWidth = 1.3; ctx.beginPath(); ctx.arc(5.5,5.5,4,0,Math.PI*2); ctx.moveTo(8.5,8.5); ctx.lineTo(13,13); ctx.stroke() }
            }
        }
        ScrollView {
            Layout.fillWidth: true; Layout.preferredHeight: 365
            clip: true
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            Column {
                width: parent.width; spacing: 3
                Text { text: "Recommended"; height: 26; font.family: "Segoe UI"; font.pixelSize: 11; color: "#42474e" }
                Repeater {
                    model: popup.programs.slice(0, 3)
                    delegate: ProgramOption { required property var modelData; program: modelData }
                }
                Rectangle { width: parent.width; height: 1; color: "#e6ebf1" }
                Repeater {
                    model: popup.programs
                    delegate: ProgramOption { required property var modelData; program: modelData }
                }
                Text { visible: popup.programs.filter(popup.matches).length === 0; text: "No programs found"; height: 32; font.family: "Segoe UI"; font.pixelSize: 12; color: "#626975" }
            }
        }
    }
    component ProgramOption: CheckBox {
        id: option
        required property var program
        width: popup.availableWidth; height: visible ? 34 : 0
        visible: popup.matches(program)
        checked: popup.selectedPrograms.indexOf(program.name) >= 0
        leftPadding: 20; rightPadding: 28
        onClicked: popup.toggle(program.name)
        indicator: Rectangle {
            width: 13; height: 13; y: (option.height - height) / 2; radius: 2
            color: option.checked ? "#188588" : "white"; border.color: option.checked ? "#188588" : "#ccd3dc"
            Text { anchors.centerIn: parent; text: "\u2713"; visible: option.checked; color: "white"; font.family: "Segoe UI"; font.pixelSize: 11 }
        }
        contentItem: Text { text: option.program.name; elide: Text.ElideRight; verticalAlignment: Text.AlignVCenter; font.family: "Segoe UI"; font.pixelSize: 11; color: "#42474e" }
        Text { anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter; text: "(" + option.program.count + ")"; font.family: "Segoe UI"; font.pixelSize: 10; color: "#78808a" }
        background: Rectangle { radius: 3; color: option.hovered ? "#f0f6f6" : "transparent" }
    }
}
