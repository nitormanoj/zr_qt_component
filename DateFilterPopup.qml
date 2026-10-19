pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

Popup {
    id: popup
    width: 500; padding: 12
    property date today: new Date()
    property date viewedMonth: new Date(today.getFullYear(), today.getMonth() - 1, 1)
    property var appliedStart: null
    property var appliedEnd: null
    property var rangeStart: null
    property var rangeEnd: null
    property bool choosingEnd: false
    property string activePreset: ""
    signal confirmed(date start, date end)
    function day(date) { return new Date(date.getFullYear(), date.getMonth(), date.getDate()).getTime() }
    function choose(date) {
        activePreset = ""
        if (!choosingEnd) { rangeStart = date; rangeEnd = null; choosingEnd = true }
        else { if (day(date) < day(rangeStart)) { rangeEnd = rangeStart; rangeStart = date } else rangeEnd = date; choosingEnd = false }
    }
    function shiftMonth(amount) { viewedMonth = new Date(viewedMonth.getFullYear(), viewedMonth.getMonth() + amount, 1) }
    function preset(index) {
        var y = today.getFullYear(), m = today.getMonth()
        activePreset = ["Last week", "Last Month", "Last Quarter", "Last 6 Months", "Last Year"][index]
        if (index === 0) {
            const monday = new Date(y, m, today.getDate() - (today.getDay() + 6) % 7)
            rangeStart = new Date(monday.getFullYear(), monday.getMonth(), monday.getDate() - 7)
            rangeEnd = new Date(rangeStart.getFullYear(), rangeStart.getMonth(), rangeStart.getDate() + 6)
        } else if (index === 1) { rangeStart = new Date(y, m - 1, 1); rangeEnd = new Date(y, m, 0) }
        else if (index === 2) { const q = Math.floor(m / 3) * 3; rangeStart = new Date(y, q - 3, 1); rangeEnd = new Date(y, q, 0) }
        else if (index === 3) { rangeStart = new Date(y, m - 6, 1); rangeEnd = new Date(y, m, 0) }
        else { rangeStart = new Date(y - 1, 0, 1); rangeEnd = new Date(y - 1, 11, 31) }
        viewedMonth = new Date(rangeStart.getFullYear(), rangeStart.getMonth(), 1)
        choosingEnd = false
    }
    function presetDetail(index) {
        var y = today.getFullYear(), m = today.getMonth()
        if (index === 0) {
            const end = new Date(y, m, today.getDate() - (today.getDay() + 6) % 7 - 1)
            const start = new Date(end.getFullYear(), end.getMonth(), end.getDate() - 6)
            return Qt.formatDate(start, "d MMM") + " - " + Qt.formatDate(end, "d MMM")
        }
        if (index === 1) return Qt.formatDate(new Date(y,m-1,1), "MMMM yyyy")
        if (index === 2) { const q = Math.floor(m/3)*3; return Qt.formatDate(new Date(y,q-3,1),"MMM") + " - " + Qt.formatDate(new Date(y,q,0),"MMM yyyy") }
        if (index === 3) return Qt.formatDate(new Date(y,m-6,1),"MMM") + " - " + Qt.formatDate(new Date(y,m,0),"MMM yyyy")
        return "Jan - Dec " + (y-1)
    }
    function confirmRange() {
        if (!rangeStart || !rangeEnd) return
        appliedStart = rangeStart; appliedEnd = rangeEnd
        confirmed(rangeStart, rangeEnd); close()
    }
    onAboutToShow: { rangeStart = appliedStart; rangeEnd = appliedEnd; choosingEnd = false; activePreset = "" }
    background: Rectangle { radius: 5; color: "white"; border.color: "#d0d6df" }
    contentItem: ColumnLayout {
        spacing: 10
        RowLayout {
            Layout.fillWidth: true; spacing: 14
            Repeater {
                model: 2
                delegate: ColumnLayout {
                    id: monthPanel
                    required property int index
                    property date month: new Date(popup.viewedMonth.getFullYear(), popup.viewedMonth.getMonth() + index, 1)
                    Layout.fillWidth: true; spacing: 6
                    RowLayout {
                        Layout.fillWidth: true
                        Button { text: "\u2039"; flat: true; implicitWidth: 24; implicitHeight: 26; opacity: monthPanel.index === 0 ? 1 : 0; enabled: monthPanel.index === 0; onClicked: popup.shiftMonth(-1) }
                        Text { Layout.fillWidth: true; text: Qt.formatDate(monthPanel.month, "MMMM    yyyy"); horizontalAlignment: Text.AlignHCenter; color: "#405574"; font.family: "Segoe UI"; font.pixelSize: 12 }
                        Button { text: "\u203a"; flat: true; implicitWidth: 24; implicitHeight: 26; opacity: monthPanel.index === 1 ? 1 : 0; enabled: monthPanel.index === 1; onClicked: popup.shiftMonth(1) }
                    }
                    GridLayout {
                        Layout.fillWidth: true; columns: 7; columnSpacing: 0; rowSpacing: 2
                        Repeater {
                            model: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
                            delegate: Text { required property string modelData; Layout.fillWidth: true; Layout.preferredHeight: 20; text: modelData; horizontalAlignment: Text.AlignHCenter; color: "#42474e"; font.family: "Segoe UI"; font.pixelSize: 10 }
                        }
                        Repeater {
                            model: 42
                            delegate: Rectangle {
                                id: dayCell
                                required property int index
                                property date date: new Date(monthPanel.month.getFullYear(), monthPanel.month.getMonth(), 1 - monthPanel.month.getDay() + index)
                                property bool inMonth: date.getMonth() === monthPanel.month.getMonth()
                                property bool endpoint: (popup.rangeStart && popup.day(date) === popup.day(popup.rangeStart)) || (popup.rangeEnd && popup.day(date) === popup.day(popup.rangeEnd))
                                property bool inRange: popup.rangeStart && popup.rangeEnd && popup.day(date) >= popup.day(popup.rangeStart) && popup.day(date) <= popup.day(popup.rangeEnd)
                                Layout.fillWidth: true; Layout.preferredHeight: 22
                                color: inRange && inMonth ? "#e6f4f4" : "transparent"
                                Rectangle {
                                    anchors.centerIn: parent; width: 20; height: 20; radius: 10
                                    color: dayCell.endpoint && dayCell.inMonth ? "#188588" : "transparent"
                                    border.width: popup.day(dayCell.date) === popup.day(popup.today) && dayCell.inMonth ? 1 : 0; border.color: "#188588"
                                }
                                Text { anchors.centerIn: parent; text: dayCell.date.getDate(); color: !dayCell.inMonth ? "#bdc3ca" : dayCell.endpoint ? "white" : "#58616a"; font.family: "Segoe UI"; font.pixelSize: 10 }
                                MouseArea { anchors.fill: parent; enabled: dayCell.inMonth; cursorShape: Qt.PointingHandCursor; onClicked: popup.choose(dayCell.date) }
                            }
                        }
                    }
                }
            }
        }
        RowLayout {
            Layout.fillWidth: true; spacing: 6
            Repeater {
                model: ["Last week", "Last Month", "Last Quarter", "Last 6 Months", "Last Year"]
                delegate: Button {
                    id: presetButton
                    required property int index
                    required property string modelData
                    Layout.fillWidth: true; Layout.preferredWidth: 88; implicitHeight: 40; padding: 5
                    background: Rectangle { radius: 4; color: popup.activePreset === presetButton.modelData ? "#e6f4f4" : "white"; border.color: popup.activePreset === presetButton.modelData ? "#188588" : "#d0d6df" }
                    contentItem: Column {
                        spacing: 4
                        Text { text: presetButton.modelData; font.family: "Segoe UI"; font.pixelSize: 10; color: "#343b43" }
                        Text { text: popup.presetDetail(presetButton.index); font.family: "Segoe UI"; font.pixelSize: 8; color: "#626975" }
                    }
                    onClicked: popup.preset(index)
                }
            }
        }
        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: "#d9dee2" }
        RowLayout {
            Layout.fillWidth: true
            Item { Layout.fillWidth: true }
            Button { text: "Cancel"; flat: true; implicitWidth: 100; implicitHeight: 28; palette.buttonText: "#00858b"; font.family: "Segoe UI"; font.pixelSize: 11; onClicked: popup.close() }
            Button {
                id: confirmButton
                text: "Confirm"; implicitWidth: 110; implicitHeight: 28; enabled: popup.rangeStart !== null && popup.rangeEnd !== null
                background: Rectangle { radius: 4; color: confirmButton.enabled ? "#188588" : "#c9ced3" }
                contentItem: Text { text: confirmButton.text; color: "white"; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter; font.family: "Segoe UI"; font.pixelSize: 11 }
                onClicked: popup.confirmRange()
            }
        }
    }
}
