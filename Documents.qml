pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

Item {
    id: root
    objectName: "documentsScreen"
    property color teal: "#00858b"
    property color ink: "#405574"
    property int page: 1
    property int pageSize: 10
    onPageSizeChanged: page = 1
    property var selected: [0, 2, 4]
    property var chips: ["Advartest_KK_…", "Brakes India Li…", "Advartest_KK_…", "Brakes India Li…", "Brakes India Li…", "Steel", "Glass", "Aluminium", "Last week"]
    readonly property int totalRecords: 35
    // Demo data: the nine initial criteria exclude fifteen of the records.
    // Removing criteria progressively restores those records to the table.
    readonly property int resultCount: Math.max(0, totalRecords - Math.ceil(chips.length * 15 / 9))
    readonly property int pageCount: Math.max(1, Math.ceil(resultCount / pageSize))
    readonly property int visibleRowCount: Math.max(0, Math.min(pageSize, resultCount - (page - 1) * pageSize))
    readonly property bool allResultsSelected: resultCount > 0 && selected.length === resultCount
    onResultCountChanged: {
        page = 1
        selected = (selected || []).filter(function(number) { return number < resultCount })
    }
    property var savedCriteria: []
    signal analyseRequested(var specimens)
    function analyseSelection() {
        var specimens = selected.map(function(number) {
            return {number: number + 1, name: cell(number, 1), color: dots[number % 10], date: cell(number, 5), force: cell(number, 7), engineer: cell(number, 8), breakValue: cell(number, 9)}
        })
        if (specimens.length) analyseRequested(specimens)
    }
    property string dateChip: "Last week"
    function openSpecialFilter(index, control) {
        var panel = index === 1 ? programPopup : datePopup
        if (panel.opened) { panel.close(); return }
        var point = control.mapToItem(root, 0, control.height + 5)
        var anchorX = index === 4 ? point.x + control.width - panel.width - 16 : point.x
        panel.x = Math.max(8, Math.min(anchorX, root.width - panel.width - 8))
        panel.y = point.y
        panel.open()
    }
    function removeChip(index) {
        var values = chips.slice(), name = values[index]
        values.splice(index, 1); chips = values
        programPopup.selectedPrograms = programPopup.selectedPrograms.filter(function(value) { return value !== name })
        if (name === dateChip) { dateChip = ""; datePopup.appliedStart = null; datePopup.appliedEnd = null }
    }
    function clearFilters() {
        chips = []; dateChip = ""; programPopup.selectedPrograms = []
        datePopup.appliedStart = null; datePopup.appliedEnd = null
    }
    property var names: ["Probe 10.1.1", "Probe 9.1.1", "Probe 11.1.6", "Probe 5.1.1", "Probe 11.1.6", "Probe 5.1.3", "Probe 5.1.4", "Probe 5.1.5", "Probe 11.1.6", "Probe 11.1.6"]
    property var dots: ["#eca0ff", "#ffe26b", "#8bbdff", "#79eaa7", "#79eaa7", "#c4a6ff", "#52d9e9", "#ffde55", "#ffb66c", "#52d9e9"]
    property var columns: ["No.", "Name", "Begin of Young’s…", "m", "(C/N)^1/3", "Date and Time", "m", "Bruch kN", "Appl. Eng.", "Break N"]
    property var weights: [0.06, 0.085, 0.13, 0.05, 0.09, 0.12, 0.05, 0.15, 0.15, 0.115]
    property var columnOrder: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    property int sortColumn: -1
    property bool sortAscending: true
    property var rowOrder: orderedRows(sortColumn, sortAscending, resultCount)
    property int draggingColumn: -1
    property int dropColumn: -1
    function sortBy(column) {
        sortAscending = sortColumn === column ? !sortAscending : true
        sortColumn = column
        page = 1
    }
    function sortValue(row, column) {
        if (column === 0) return row + 1
        var value = cell(row, column)
        if (value === "-") return null
        if (column === 7 || column === 9) return Number(value.replace(/,/g, ""))
        if (column === 5) {
            var parts = value.split(/[^0-9]+/)
            return new Date(Number(parts[2]), Number(parts[1]) - 1, Number(parts[0]), Number(parts[3]), Number(parts[4]), Number(parts[5])).getTime()
        }
        return value
    }
    function orderedRows(column, ascending, count) {
        var rows = []
        for (var i = 0; i < count; ++i) rows.push(i)
        if (column < 0) return rows
        rows.sort(function(a, b) {
            var av = sortValue(a, column), bv = sortValue(b, column)
            if (av === bv) return a - b
            if (av === null) return 1
            if (bv === null) return -1
            var result = typeof av === "number" ? av - bv : av.localeCompare(bv, undefined, {numeric: true, sensitivity: "base"})
            return ascending ? result : -result
        })
        return rows
    }
    function moveColumn(from, to) {
        if (from < 0 || to < 0 || from === to) return
        var order = columnOrder.slice()
        order.splice(to, 0, order.splice(from, 1)[0])
        columnOrder = order
    }
    function columnAt(x) {
        var edge = 38
        for (var i = 0; i < columnOrder.length; ++i) {
            edge += (tableColumn.width - 38) * weights[columnOrder[i]]
            if (x < edge) return i
        }
        return columnOrder.length - 1
    }
    function toggleRow(n) {
        var next = selected.slice()
        var at = next.indexOf(n)
        if (at < 0) next.push(n)
        else next.splice(at, 1)
        selected = next
    }
    function cell(n, col) {
        var i = n % 10
        if (col === 0) return String(n + 1)
        if (col === 1) return names[i]
        if (col === 5) return (i % 2 === 0 ? "12.3.2024, 15:24:47" : "13.3.2024, 10:16:19")
        if (col === 7) return i % 2 === 0 ? "425.76e-3" : "558.74e-3"
        if (col === 8) return i < 5 || i > 7 ? "Groner, Lars" : ["Chen, Wei", "Johnson, Mark", "Smith, Emily"][i - 5]
        if (col === 9) return i === 0 ? "425.68" : i % 2 ? "559.67" : "1,018.52"
        return "-"
    }
    // Draw the chevron geometrically: font baselines do not center arrow glyphs.
    component Chevron: Canvas {
        implicitWidth: 10
        implicitHeight: 6
        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            ctx.strokeStyle = "#343b43"; ctx.lineWidth = 1.5
            ctx.lineCap = "round"; ctx.lineJoin = "round"
            ctx.beginPath(); ctx.moveTo(1, 1); ctx.lineTo(width / 2, height - 1); ctx.lineTo(width - 1, 1); ctx.stroke()
        }
    }
    component StyledComboBox: ComboBox {
        id: combo
        property bool popupAbove: false
        font.family: "Segoe UI"
        font.pixelSize: 12
        hoverEnabled: true
        background: Rectangle {
            radius: 4; color: "white"
            border.color: combo.popup.visible || combo.activeFocus ? root.teal : combo.hovered ? "#8cafb8" : "#d0d6df"
        }
        delegate: ItemDelegate {
            id: option
            required property int index
            required property var modelData
            width: combo.popup.width - 8; height: 36
            highlighted: combo.highlightedIndex === index
            hoverEnabled: true
            contentItem: Text {
                text: String(option.modelData); font.family: combo.font.family; font.pixelSize: combo.font.pixelSize
                color: option.index === combo.currentIndex ? root.teal : "#42474e"
                font.weight: option.index === combo.currentIndex ? Font.DemiBold : Font.Normal
                verticalAlignment: Text.AlignVCenter; elide: Text.ElideRight
            }
            leftPadding: 12; rightPadding: 12
            background: Rectangle {
                radius: 3
                color: option.index === combo.currentIndex ? "#e0f2f3" : option.hovered || option.highlighted ? "#f0f5f6" : "white"
                Rectangle { width: 2; anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom; color: root.teal; visible: option.index === combo.currentIndex }
            }
        }
        popup: Popup {
            y: combo.popupAbove ? -implicitHeight - 4 : combo.height + 4
            width: combo.width
            padding: 4
            implicitHeight: Math.min(optionList.contentHeight + 8, 240)
            margins: 8
            contentItem: ListView {
                id: optionList
                clip: true
                implicitHeight: contentHeight
                model: combo.popup.visible ? combo.delegateModel : null
                currentIndex: combo.highlightedIndex
                boundsBehavior: Flickable.StopAtBounds
                ScrollBar.vertical: ScrollBar {}
            }
            background: Rectangle { color: "white"; radius: 4; border.color: "#d0d6df" }
        }
    }
    component PageButton: Button {
        id: pageButton
        property bool current: false
        implicitWidth: 25; implicitHeight: 28
        padding: 0
        font.pixelSize: 11
        background: Rectangle {
            color: pageButton.hovered ? "#f3f5f6" : "transparent"
            Rectangle {
                anchors.bottom: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter
                width: 20; height: 2; color: root.teal; visible: pageButton.current
            }
        }
        contentItem: Text {
            text: pageButton.text; font: pageButton.font
            color: !pageButton.enabled ? "#b8c1cb" : pageButton.current ? root.teal : root.ink
            horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
        }
    }
    component Action: Button {
        id: action
        property bool primary: false
        implicitHeight: 40
        font.pixelSize: 12
        leftPadding: 15; rightPadding: 15
        background: Rectangle { radius: 4; color: action.flat ? "transparent" : !action.enabled ? "#c9ced3" : action.primary ? "#188588" : action.hovered ? "#effafb" : "white"; border.width: action.flat ? 0 : 1; border.color: !action.enabled ? "#c9ced3" : "#39a8b7" }
        contentItem: Text { text: action.text; font: action.font; color: !action.enabled ? "#59636e" : action.primary ? "white" : root.teal; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
    }
    component TableIconButton: ToolButton {
        id: iconButton
        required property string source
        required property string description
        implicitWidth: 40; implicitHeight: 40
        padding: 10
        hoverEnabled: true
        Accessible.name: description
        background: Rectangle { radius: 4; color: iconButton.hovered ? "#f1f5f6" : "transparent" }
        contentItem: Image {
            source: iconButton.source; sourceSize.width: 40; sourceSize.height: 40
            fillMode: Image.PreserveAspectFit
        }
    }
    component SelectionBox: CheckBox {
        id: selectionBox
        padding: 0
        indicator: Rectangle {
            x: 11; y: (selectionBox.height - height) / 2
            width: 13; height: 13; radius: 3
            color: selectionBox.checked ? root.teal : "white"
            border.color: selectionBox.checked ? root.teal : "#91a5be"
            Canvas {
                anchors.fill: parent
                visible: selectionBox.checked
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)
                    ctx.strokeStyle = "white"; ctx.lineWidth = 1.8
                    ctx.beginPath(); ctx.moveTo(3, 6); ctx.lineTo(5.5, 8.5); ctx.lineTo(10, 3.5); ctx.stroke()
                }
            }
        }
        contentItem: Item {}
    }
    ColumnLayout {
        anchors.fill: parent
        anchors.leftMargin: 6; anchors.rightMargin: 15; anchors.topMargin: 10
        spacing: 10
        Rectangle {
            Layout.fillWidth: true; Layout.preferredHeight: filterColumn.implicitHeight + 30
            radius: 12; color: "white"
            ColumnLayout {
                id: filterColumn
                anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top
                anchors.margins: 16; spacing: 12
                RowLayout {
                    Layout.fillWidth: true; spacing: 14
                    Repeater {
                        model: ["Saved Criteria’s", "Test program (5)", "Material (3)", "Job Number", "Date (1)"]
                        delegate: StyledComboBox {
                            id: filter
                            objectName: "documentFilter" + index
                            required property int index
                            required property string modelData
                            Layout.fillWidth: true; Layout.preferredWidth: 170; Layout.minimumWidth: 100
                            implicitHeight: 40
                            model: index === 0 ? [modelData].concat(root.savedCriteria) : index === 1 ? [modelData, "Advartest_KK", "Brakes India Limited"] : index === 2 ? [modelData, "Steel", "Glass", "Aluminium"] : index === 3 ? [modelData, "G3467", "G3468"] : [modelData, "Last week", "Last month", "All dates"]
                            font.pixelSize: 12
                            leftPadding: 36
                            rightPadding: 28
                            property bool expanded: index === 1 ? programPopup.opened : index === 4 ? datePopup.opened : popup.visible
                            displayText: index === 1 ? "Test program" + (programPopup.selectedPrograms.length ? " (" + programPopup.selectedPrograms.length + ")" : "") : index === 4 ? "Date" + (root.dateChip ? " (1)" : "") : currentText
                            background: Rectangle { radius: 3; color: filter.expanded ? "#e6f4f4" : "white"; border.color: filter.expanded ? root.teal : "#d0d6df" }
                            contentItem: Text { text: filter.displayText; font: filter.font; color: "#42474e"; verticalAlignment: Text.AlignVCenter; elide: Text.ElideRight }
                            Image {
                                x: 10; anchors.verticalCenter: parent.verticalCenter
                                width: 18; height: 18; sourceSize.width: 36; sourceSize.height: 36
                                source: ["icons/filter-saved.svg", "icons/filter-program.svg", "icons/filter-material.svg", "icons/filter-job.svg", "icons/filter-date.svg"][filter.index]
                                fillMode: Image.PreserveAspectFit
                            }
                            indicator: Chevron { x: filter.width - width - 14; y: (filter.height - height) / 2; width: 10; height: 6; rotation: filter.expanded ? 180 : 0 }
                            MouseArea {
                                anchors.fill: parent; enabled: filter.index === 1 || filter.index === 4
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.openSpecialFilter(filter.index, filter)
                            }
                            Keys.onSpacePressed: function(event) { if (index === 1 || index === 4) { root.openSpecialFilter(index, filter); event.accepted = true } }
                            onActivated: {
                                if (currentIndex > 0 && index > 0) {
                                    var values = root.chips.slice()
                                    if (values.indexOf(currentText) < 0) values.push(currentText)
                                    root.chips = values
                                }
                            }
                        }
                    }
                    Action { text: "Show results"; primary: true; onClicked: { root.page = 1; message.text = "" } }
                    Action { text: "Save criteria"; onClicked: { root.savedCriteria = root.savedCriteria.concat(["Criteria " + (root.savedCriteria.length + 1)]); message.text = "Current criteria saved for this session." } }
                }
                Flow {
                    Layout.fillWidth: true; Layout.preferredHeight: childrenRect.height; spacing: 6
                    Repeater {
                        objectName: "filterChips"
                        model: root.chips
                        delegate: Rectangle {
                            required property string modelData
                            required property int index
                            width: chipLabel.implicitWidth + 24; height: 24; radius: 3; color: "#eceeef"
                            Text { id: chipLabel; anchors.centerIn: parent; text: modelData + "  \u2297"; font.pixelSize: 10; color: "#464b50" }
                            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.removeChip(index) }
                        }
                    }
                    Action { text: "Clear all filters"; flat: true; implicitHeight: 24; onClicked: root.clearFilters() }
                }
            }
        }
        Rectangle {
            Layout.fillWidth: true; Layout.fillHeight: true
            Layout.preferredHeight: specimensLayout.implicitHeight + 36
            Layout.maximumHeight: specimensLayout.implicitHeight + 36
            radius: 12; color: "white"
            ColumnLayout {
                id: specimensLayout
                anchors.fill: parent; anchors.margins: 18; spacing: 16
                RowLayout {
                    Layout.fillWidth: true
                    Column {
                        spacing: 2
                        Text { text: "Specimens"; font.pixelSize: 20; font.weight: Font.DemiBold; color: "#2c3033" }
                        Text { text: root.resultCount + " found based on search criteria"; font.pixelSize: 12; color: "#343b43" }
                    }
                    Item { Layout.fillWidth: true }
                    TableIconButton { source: "icons/documents-grid.svg"; description: "Specimen view" }
                    TableIconButton { source: "icons/documents-sliders.svg"; description: "Column settings" }
                    Action { text: "Export PDF" }
                    Action { objectName: "analyseButton"; text: "Analyse (" + root.selected.length + ")"; primary: true; enabled: root.selected.length > 0; onClicked: root.analyseSelection() }
                }
                Rectangle {
                    objectName: "specimenTableFrame"
                    implicitHeight: tableColumn.implicitHeight
                    Layout.fillWidth: true; Layout.fillHeight: true
                    Layout.maximumHeight: implicitHeight
                    border.color: "#d2d8e1"; radius: 5; clip: true
                    Flickable {
                        id: specimenViewport
                        objectName: "specimenViewport"
                        anchors.fill: parent; contentWidth: Math.max(width, 1200); contentHeight: tableColumn.height; clip: true
                        ScrollBar.vertical: ScrollBar {}
                        ScrollBar.horizontal: ScrollBar {}
                        Column {
                            id: tableColumn
                            topPadding: 36
                            width: specimenViewport.contentWidth
                            Rectangle {
                                objectName: "stickySpecimenHeader"
                                parent: specimenViewport
                                x: -specimenViewport.contentX; y: 0; z: 2
                                width: tableColumn.width; height: 36; color: "#e9ebed"
                                Row {
                                    id: headerRow
                                    anchors.fill: parent
                                    SelectionBox { objectName: "selectAllSpecimens"; width: 38; height: 36; enabled: root.resultCount > 0; checked: root.allResultsSelected; onClicked: root.selected = root.allResultsSelected ? [] : root.rowOrder.slice() }
                                    Repeater {
                                        model: root.columnOrder
                                        delegate: Rectangle {
                                            id: columnHeader
                                            required property int index
                                            required property int modelData
                                            objectName: "columnHeader" + modelData
                                            width: (tableColumn.width - 38) * root.weights[modelData]; height: 36
                                            color: root.dropColumn === index ? "#cfeaec" : headerMouse.containsMouse ? "#e0e6e9" : "transparent"
                                            opacity: root.draggingColumn === index ? 0.55 : 1
                                            Text {
                                                anchors.fill: parent; anchors.rightMargin: 22
                                                text: root.columns[columnHeader.modelData]; color: root.ink; font.pixelSize: 10; font.weight: Font.DemiBold
                                                verticalAlignment: Text.AlignVCenter; elide: Text.ElideRight
                                            }
                                            Text {
                                                anchors.right: parent.right; anchors.rightMargin: 8; anchors.verticalCenter: parent.verticalCenter
                                                text: root.sortColumn === columnHeader.modelData ? (root.sortAscending ? "\u2191" : "\u2193") : "\u21c5"
                                                font.pixelSize: 12; color: root.sortColumn === columnHeader.modelData ? root.teal : "#91a0b4"
                                            }
                                            Rectangle { width: 2; height: parent.height; color: root.teal; visible: root.dropColumn === columnHeader.index }
                                            MouseArea {
                                                id: headerMouse
                                                anchors.fill: parent; hoverEnabled: true; preventStealing: true
                                                cursorShape: pressed ? Qt.ClosedHandCursor : Qt.OpenHandCursor
                                                property real pressX: 0
                                                property bool moved: false
                                                onPressed: function(mouse) { pressX = mapToItem(headerRow, mouse.x, mouse.y).x; moved = false }
                                                onPositionChanged: function(mouse) {
                                                    if (!pressed) return
                                                    var point = mapToItem(headerRow, mouse.x, mouse.y)
                                                    if (Math.abs(point.x - pressX) > 6) moved = true
                                                    if (moved) {
                                                        root.draggingColumn = columnHeader.index
                                                        root.dropColumn = root.columnAt(point.x)
                                                    }
                                                }
                                                onReleased: {
                                                    var target = root.dropColumn
                                                    root.draggingColumn = -1; root.dropColumn = -1
                                                    if (moved) root.moveColumn(columnHeader.index, target)
                                                    else root.sortBy(columnHeader.modelData)
                                                }
                                                onCanceled: { root.draggingColumn = -1; root.dropColumn = -1 }
                                                ToolTip.visible: containsMouse && !pressed
                                                ToolTip.delay: 800
                                                ToolTip.text: "Click to sort; drag to move column"
                                            }
                                        }
                                    }
                                }
                            }
                            Repeater {
                                objectName: "specimenRows"
                                model: root.visibleRowCount
                                delegate: Rectangle {
                                    id: specimenRow
                                    required property int index
                                    property int number: root.rowOrder[(root.page - 1) * root.pageSize + index]
                                    width: tableColumn.width; height: 36
                                    color: root.selected.indexOf(number) >= 0 ? "#f4f6f7" : "white"
                                    Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: "#e6ebf1" }
                                    Row {
                                        anchors.fill: parent
                                        SelectionBox { width: 38; height: 36; checked: root.selected.indexOf(specimenRow.number) >= 0; onClicked: root.toggleRow(specimenRow.number) }
                                        Repeater {
                                            model: root.columnOrder
                                            delegate: Item {
                                                id: cellItem
                                                required property int index
                                                required property int modelData
                                                width: (tableColumn.width - 38) * root.weights[modelData]; height: 36
                                                Rectangle { visible: cellItem.modelData === 0; width: 12; height: 12; radius: 6; color: root.dots[specimenRow.number % 10]; anchors.verticalCenter: parent.verticalCenter }
                                                Text { anchors.fill: parent; anchors.leftMargin: cellItem.modelData === 0 ? 23 : 0; text: root.cell(specimenRow.number, cellItem.modelData); font.pixelSize: 10; color: root.ink; verticalAlignment: Text.AlignVCenter; elide: Text.ElideRight }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                RowLayout {
                    objectName: "specimenPagination"
                    Layout.fillWidth: true; spacing: 3
                    Layout.preferredHeight: 32
                    Text { text: "Showing " + root.visibleRowCount + " of " + root.resultCount + " active test probes"; font.pixelSize: 10; color: "#52636d" }
                    Item { Layout.fillWidth: true }
                    PageButton { text: "\u00ab"; enabled: root.page > 1; onClicked: root.page = 1 }
                    PageButton { text: "\u2039"; enabled: root.page > 1; onClicked: root.page-- }
                    Repeater {
                        model: root.pageCount
                        delegate: PageButton { required property int index; text: String(index + 1); current: root.page === index + 1; onClicked: root.page = index + 1 }
                    }
                    PageButton { text: "\u203a"; enabled: root.page < root.pageCount; onClicked: root.page++ }
                    PageButton { text: "\u00bb"; enabled: root.page < root.pageCount; onClicked: root.page = root.pageCount }
                    StyledComboBox {
                        id: pageSizeSelector
                        popupAbove: true
                        objectName: "pageSizeSelector"
                        model: [5, 10, 20]; currentIndex: 1; implicitWidth: 60; implicitHeight: 28
                        Layout.leftMargin: 8
                        leftPadding: 10; rightPadding: 24; font.pixelSize: 12
                        contentItem: Text { text: pageSizeSelector.displayText; font: pageSizeSelector.font; color: "#343b43"; verticalAlignment: Text.AlignVCenter }
                        indicator: Chevron { x: pageSizeSelector.width - width - 9; y: (pageSizeSelector.height - height) / 2; width: 10; height: 6 }
                        onActivated: { root.pageSize = Number(currentText); root.page = 1 }
                    }
                }
                Text { id: message; visible: text.length > 0; Layout.fillWidth: true; wrapMode: Text.WordWrap; font.pixelSize: 11; color: root.teal }
            }
        }
        Item { Layout.fillHeight: true; Layout.preferredHeight: 0 }
    }
    ProgramFilterPopup {
        id: programPopup
        objectName: "programFilterPopup"
        parent: root
        onSelectionChanged: function(name, selected) {
            var values = root.chips.filter(function(value) { return value !== name })
            if (selected) values.push(name)
            root.chips = values
        }
    }
    DateFilterPopup {
        id: datePopup
        objectName: "dateFilterPopup"
        parent: root
        onConfirmed: function(start, end) {
            var values = root.chips.filter(function(value) { return value !== root.dateChip })
            root.dateChip = Qt.formatDate(start, "dd MMM yyyy") + " - " + Qt.formatDate(end, "dd MMM yyyy")
            values.push(root.dateChip); root.chips = values; root.page = 1
        }
    }
    Popup {
        id: columnPopup
        anchors.centerIn: parent; width: 260; padding: 18
        Column { spacing: 10; Text { text: "Specimen columns"; font.bold: true } Text { text: root.columns.join("\n"); lineHeight: 1.5; color: root.ink } }
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    }
}
