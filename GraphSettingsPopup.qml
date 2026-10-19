pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

Popup {
    id: panel
    objectName: "graphSettingsPopup"
    width: 240; padding: 14
    property var xAxis: ({})
    property var yAxis: ({})
    signal applied(var xSettings, var ySettings)
    function load() { xEditor.load(xAxis); yEditor.load(yAxis); error.text = "" }
    function clearAll() { xEditor.load({}); yEditor.load({}); error.text = "" }
    function applySettings() {
        if (!xEditor.valid() || !yEditor.valid()) { error.text = "Enter valid limits: lower must be less than upper."; return }
        xAxis = xEditor.settings(); yAxis = yEditor.settings()
        applied(xAxis, yAxis); close()
    }
    onAboutToShow: load()
    background: Rectangle { radius: 4; color: "white"; border.color: "#d2d8e1" }
    contentItem: ColumnLayout {
        spacing: 10
        AxisEditor { id: xEditor; objectName: "xAxisEditor"; Layout.fillWidth: true; title: "X Axis"; defaultUnit: "m"; defaultName: "Height"; expanded: true; onExpandedChanged: if (expanded && yEditor) yEditor.expanded=false }
        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: "#d9dee2" }
        AxisEditor { id: yEditor; objectName: "yAxisEditor"; Layout.fillWidth: true; title: "Y Axis"; defaultUnit: "kN"; defaultName: "Force"; onExpandedChanged: if (expanded && xEditor) xEditor.expanded=false }
        Text { id: error; Layout.fillWidth: true; visible: text.length>0; wrapMode: Text.WordWrap; color: "#c13939"; font.family: "Segoe UI"; font.pixelSize: 10 }
        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: "#d9dee2" }
        RowLayout {
            Layout.fillWidth: true; spacing: 8
            Button {
                text: "Clear All"; flat: true; Layout.fillWidth: true; implicitHeight: 32
                contentItem: Text { text: "Clear All"; color: "#00858b"; font.family: "Segoe UI"; font.pixelSize: 11; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                background: Rectangle { color: "transparent" }
                onClicked: panel.clearAll()
            }
            Button {
                objectName: "applyGraphSettings"
                Layout.fillWidth: true; implicitHeight: 32
                background: Rectangle { radius: 3; color: "#188588" }
                contentItem: Text { text: "Apply"; color: "white"; font.family: "Segoe UI"; font.pixelSize: 11; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                onClicked: panel.applySettings()
            }
        }
    }
    component Arrow: Canvas {
        implicitWidth: 10; implicitHeight: 6
        onPaint: { var ctx=getContext("2d"); ctx.strokeStyle="#527078"; ctx.lineWidth=1.2; ctx.beginPath(); ctx.moveTo(1,1); ctx.lineTo(5,5); ctx.lineTo(9,1); ctx.stroke() }
    }
    component Field: TextField {
        id: field
        implicitHeight: 28; padding: 6
        font.family: "Segoe UI"; font.pixelSize: 10; color: "#42474e"
        background: Rectangle { radius: 3; color: "white"; border.color: field.activeFocus ? "#00858b" : "#d0d6df" }
    }
    component Caption: Text { font.family: "Segoe UI"; font.pixelSize: 10; color: "#555c65" }
    component Select: ComboBox {
        id: select
        implicitHeight: 28; leftPadding: 6; rightPadding: 24
        font.family: "Segoe UI"; font.pixelSize: 10
        contentItem: Text { text: select.displayText; font: select.font; color: "#626975"; verticalAlignment: Text.AlignVCenter; elide: Text.ElideRight }
        background: Rectangle { radius: 3; color: "white"; border.color: select.popup.visible || select.activeFocus ? "#00858b" : "#d0d6df" }
        indicator: Arrow { x: select.width-width-8; y: (select.height-height)/2; rotation: select.popup.visible ? 180 : 0 }
        delegate: ItemDelegate {
            id: option
            required property int index
            required property var modelData
            width: select.popup.width-8; height: 27; padding: 6
            highlighted: select.highlightedIndex===index
            contentItem: Text { text: String(option.modelData); font: select.font; color: "#42474e"; verticalAlignment: Text.AlignVCenter; elide: Text.ElideRight }
            background: Rectangle { radius: 2; color: option.index===select.currentIndex ? "#cce9eb" : option.hovered || option.highlighted ? "#edf6f6" : "white" }
        }
        popup: Popup {
            y: select.height+2; width: select.width; padding: 4
            implicitHeight: Math.min(list.contentHeight+8,180)
            contentItem: ListView { id: list; clip: true; implicitHeight: contentHeight; model: select.popup.visible ? select.delegateModel : null; currentIndex: select.highlightedIndex; ScrollBar.vertical: ScrollBar {} }
            background: Rectangle { radius: 3; color: "white"; border.color: "#d0d6df" }
        }
    }
    component AxisEditor: ColumnLayout {
        id: editor
        required property string title
        required property string defaultUnit
        required property string defaultName
        property bool expanded: false
        spacing: 8
        function load(settings) {
            logarithmic.checked = settings.logarithmic || false
            units.currentIndex = Math.max(0, units.model.indexOf(settings.unit || defaultUnit))
            axisName.text = settings.name === undefined ? defaultName : settings.name
            scaling.currentIndex = Math.max(0, scaling.model.indexOf(settings.scaling || "Select"))
            lower.text = settings.lower === undefined || settings.lower === null ? "" : String(settings.lower)
            upper.text = settings.upper === undefined || settings.upper === null ? "" : String(settings.upper)
        }
        function valid() {
            if(lower.text.trim() && !isFinite(Number(lower.text))) return false
            if(upper.text.trim() && !isFinite(Number(upper.text))) return false
            return !lower.text.trim() || !upper.text.trim() || Number(lower.text)<Number(upper.text)
        }
        function settings() { return {logarithmic: logarithmic.checked, unit: units.currentText, name: axisName.text, scaling: scaling.currentText, lower: lower.text.trim() ? Number(lower.text) : null, upper: upper.text.trim() ? Number(upper.text) : null} }
        Button {
            id: sectionButton
            Layout.fillWidth: true; implicitHeight: 24; padding: 0
            contentItem: Text { text: editor.title; color: "#343b43"; font.family: "Segoe UI"; font.pixelSize: 12; verticalAlignment: Text.AlignVCenter }
            background: Item {}
            Arrow { anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter; rotation: editor.expanded ? 180 : 0 }
            onClicked: editor.expanded=!editor.expanded
        }
        ColumnLayout {
            visible: editor.expanded; Layout.fillWidth: true; spacing: 7
            CheckBox {
                id: logarithmic
                text: "Logarithmic"; implicitHeight: 24; leftPadding: 19
                font.family: "Segoe UI"; font.pixelSize: 10
                indicator: Rectangle {
                    width: 12; height: 12; y: (logarithmic.height-height)/2; radius: 2
                    color: logarithmic.checked ? "#188588" : "white"; border.color: logarithmic.checked ? "#188588" : "#d0d6df"
                    Text { anchors.centerIn: parent; visible: logarithmic.checked; text: "\u2713"; color: "white"; font.family: "Segoe UI"; font.pixelSize: 10 }
                }
            }
            Caption { text: "Unit" }
            Select { id: units; Layout.fillWidth: true; model: editor.title==="X Axis" ? ["m","mm","cm","s"] : ["kN","N","MPa"] }
            Caption { text: "Name" }
            Field { id: axisName; Layout.fillWidth: true }
            Caption { text: "Auto Scaling" }
            Select { id: scaling; objectName: editor.title==="X Axis" ? "xAutoScaling" : "yAutoScaling"; Layout.fillWidth: true; model: ["Select", "Auto", "Extension to fit", "Manual"] }
            Caption { text: "Limit" }
            RowLayout {
                Layout.fillWidth: true; spacing: 10
                Field { id: lower; Layout.fillWidth: true; Layout.preferredWidth: 90; placeholderText: "Lower"; validator: DoubleValidator {} }
                Field { id: upper; Layout.fillWidth: true; Layout.preferredWidth: 90; placeholderText: "Upper"; validator: DoubleValidator {} }
            }
        }
    }
}
