import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

        RowLayout {
    id: rotator
    property var app: null
    property color ink: "#202a31"
    property color edge: "#d9dee2"
    property alias gaugeValue: gauge.text
    property alias fieldViewValue: fieldView.text
            anchors.fill: parent; anchors.rightMargin: 15; spacing: 10;
            Rectangle {
                Layout.fillWidth: true; Layout.fillHeight: true; color: "white"; radius: 12; clip: true
                ColumnLayout {
                    anchors.fill: parent; spacing: 0
                    Rectangle {
                        Layout.fillWidth: true; Layout.preferredHeight: 59; color: "white"
                        RowLayout { anchors.fill: parent; anchors.leftMargin: 17; anchors.rightMargin: 17
                            Text { text: "New Test Setup - " + app.targetType; font.pixelSize: 16; font.bold: true; color: ink ; font.family: "Segoe UI"}
                            Item { Layout.fillWidth: true }
                            Text { text: "Add to a testing method"; font.pixelSize: 12; color: "#007b81" ; font.family: "Segoe UI"
                                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor }
                            }
                        }
                        Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: edge }
                    }
                    Item {
                        id: canvas; Layout.fillWidth: true; Layout.fillHeight: true; clip: true
                        // Shared orbit coordinates for line, dots and cards.
                        function arcX(t) { return 70 + 600 * t * (1 - t) }
                        function arcY(t) { return height * t }

                        Rectangle {
                            anchors.fill: parent
                            color: "#FFFFFF"
                        }

                        // Background fills between the existing arcs.
                        // These use the same curve geometry.
                        // They do not modify the actual arc lines.
                        Shape {
                            id: orbitBandBackground
                            anchors.fill: parent

                            // Existing first-to-second and second-to-third offsets.
                            // Change these only if your current arc positions differ.
                            property real secondOffset: 120
                            property real thirdOffset: 240

                            // Background between FIRST and SECOND arc
                            ShapePath {
                                strokeColor: "transparent"
                                fillColor: "#F5FAFA"

                                startX: 70
                                startY: 0

                                PathQuad {
                                    x: 70
                                    y: canvas.height
                                    controlX: 370
                                    controlY: canvas.height / 2
                                }

                                PathLine {
                                    x: 70 + orbitBandBackground.secondOffset
                                    y: canvas.height
                                }

                                PathQuad {
                                    x: 70 + orbitBandBackground.secondOffset
                                    y: 0
                                    controlX: 370 + orbitBandBackground.secondOffset
                                    controlY: canvas.height / 2
                                }

                                PathLine {
                                    x: 70
                                    y: 0
                                }
                            }

                            // Background between SECOND and THIRD arc
                            ShapePath {
                                strokeColor: "transparent"
                                fillColor: "#FAFDFD"

                                startX: 70 + orbitBandBackground.secondOffset
                                startY: 0

                                PathQuad {
                                    x: 70 + orbitBandBackground.secondOffset
                                    y: canvas.height
                                    controlX: 370 + orbitBandBackground.secondOffset
                                    controlY: canvas.height / 2
                                }

                                PathLine {
                                    x: 70 + orbitBandBackground.thirdOffset
                                    y: canvas.height
                                }

                                PathQuad {
                                    x: 70 + orbitBandBackground.thirdOffset
                                    y: 0
                                    controlX: 370 + orbitBandBackground.thirdOffset
                                    controlY: canvas.height / 2
                                }

                                PathLine {
                                    x: 70 + orbitBandBackground.secondOffset
                                    y: 0
                                }
                            }
                        }



                        // Restored outlines, drawn above the background bands.
                        // Coordinates are identical to orbitBandBackground.
                        Shape {
                            id: orbitShape
                            anchors.fill: parent
                            z: 2

                            ShapePath {
                                strokeColor: "#1A8080"
                                strokeWidth: 2
                                fillColor: "transparent"
                                startX: 70
                                startY: 0
                                PathQuad {
                                    x: 70
                                    y: canvas.height
                                    controlX: 370
                                    controlY: canvas.height / 2
                                }
                            }

                            ShapePath {
                                strokeColor: "#CCE9E9"
                                strokeWidth: 1.4
                                fillColor: "transparent"
                                startX: 70 + orbitBandBackground.secondOffset
                                startY: 0
                                PathQuad {
                                    x: 70 + orbitBandBackground.secondOffset
                                    y: canvas.height
                                    controlX: 370 + orbitBandBackground.secondOffset
                                    controlY: canvas.height / 2
                                }
                            }

                            ShapePath {
                                strokeColor: "#CCE9E9"
                                strokeWidth: 1.4
                                fillColor: "transparent"
                                startX: 70 + orbitBandBackground.thirdOffset
                                startY: 0
                                PathQuad {
                                    x: 70 + orbitBandBackground.thirdOffset
                                    y: canvas.height
                                    controlX: 370 + orbitBandBackground.thirdOffset
                                    controlY: canvas.height / 2
                                }
                            }
                        }

                        Item {
                            id: selectedOrbitDot
                            width: 34
                            height: 34
                            x: canvas.arcX(0.5) - width / 2
                            y: canvas.arcY(0.5) - height / 2
                            z: 20
                            // Outer teal ring
                            Rectangle {
                                anchors.centerIn: parent
                                width: 34
                                height: 34
                                radius: width / 2
                                color: "#FFFFFF"
                                border.color: "#1A8080"
                                border.width: 1
                            }

                            // Second teal ring
                            Rectangle {
                                anchors.centerIn: parent
                                width: 27
                                height: 27
                                radius: width / 2
                                color: "#FFFFFF"
                                border.color: "#1A8080"
                                border.width: 2
                            }

                            // Inner teal circle
                            Rectangle {
                                anchors.centerIn: parent
                                width: 19
                                height: 19
                                radius: width / 2
                                color: "#1A8080"
                            }

                            // White center
                            Rectangle {
                                anchors.centerIn: parent
                                width: 12
                                height: 12
                                radius: width / 2
                                color: "#FFFFFF"
                            }
                        }

                        Rectangle { visible: app.sensorIndex>0; x: canvas.arcX(0.2) - width / 2; y: canvas.arcY(0.2) - height / 2; width: 12; height: 12; radius: 6; color: "#1A8080"; z: 20 }
                        Rectangle { visible: app.sensorIndex<2; x: canvas.arcX(0.8) - width / 2; y: canvas.arcY(0.8) - height / 2; width: 12; height: 12; radius: 6; color: "#1A8080"; z: 20 }
                        Rectangle {
                            x: 11; y: 12; width: 61; height: canvas.height-24; radius: 12; color: "#eef0f2"
                            ColumnLayout { anchors.fill: parent; anchors.margins: 5; spacing: 0
                                Repeater { model: app.sections
                                    delegate: Rectangle {
                                        required property string modelData
                                        Layout.fillWidth: true; Layout.fillHeight: true; radius: 8
                                        color: app.activeSection === modelData ? "#cdecee" : "transparent"
                                        Text { anchors.centerIn: parent; rotation: -90; text: modelData; font.pixelSize: 12; font.bold: true; color: app.activeSection === modelData ? "#173c3e" : "#646b70" }
                                        Rectangle { visible: app.activeSection === modelData; anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter; width: 2; height: parent.height-18; color: "#00898c" }
                                        MouseArea {
                                            anchors.fill: parent
                                            enabled: false
                                            cursorShape: Qt.ArrowCursor
                                        }
                                    }
                                }
                            }
                        }
                        // Cards animate to their new orbit positions when selection changes.
                        Repeater {
                            model: 3
                            delegate: Rectangle {
                                id: sensorCard
                                required property int index
                                // Stable sensor identity; only its orbit progress changes.
                                // -1: previous, 0: selected, +1: next.
                                property int offset: index - app.sensorIndex
                                property real targetProgress: 0.50 + 0.30 * offset
                                property real curveProgress: targetProgress
                                property bool selected: offset === 0

                                // Match the first painted PathQuad:
                                // start (70,0), control (370,H/2), end (70,H).
                                // The whole card travels along the curved path.
                                property real orbitX: canvas.arcX(curveProgress)
                                property real orbitY: canvas.arcY(curveProgress)

                                // Keep every card fully to the RIGHT of the teal arc, as in the reference.
                                x: orbitX + 24
                                y: orbitY - height / 2

                                width: Math.min(235, canvas.width * 0.31)
                                height: 92
                                radius: 6
                                color: "white"
                                border.width: selected ? 2 : 1
                                border.color: selected ? "#00878b" : "#c7d0d4"

                                // Fade out beyond the top/bottom endpoints.
                                // Do NOT bind visible to offset: that instantly
                                // removes a card before it can animate away.
                                visible: true
                                // Keep the card surface opaque at all three stops.
                                // Only fade the entire card while entering/leaving the orbit.
                                opacity: {
                                    var t = curveProgress
                                    if (t <= 0.0 || t >= 1.0) return 0.0
                                    if (t < 0.20) return t / 0.20
                                    if (t > 0.80) return (1.0 - t) / 0.20
                                    return 1.0
                                }
                                z: 10 - Math.abs(curveProgress - 0.5)

                                // One animated scalar drives x, y, and opacity,
                                // guaranteeing motion along the curved line.
                                Behavior on curveProgress {
                                    NumberAnimation {
                                        duration: 650
                                        easing.type: Easing.InOutCubic
                                    }
                                }
                                Behavior on border.color {
                                    ColorAnimation { duration: 200 }
                                }
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 9
                                    spacing: 8
                                    // Dim content, not the white card surface.
                                    opacity: sensorCard.selected ? 1.0 : 0.65
                                    MachinePicture { Layout.preferredWidth: 53; Layout.fillHeight: true; sourcePath: app.sensors[index].image }
                                    ColumnLayout { Layout.fillWidth: true; spacing: 3
                                        Text { text: app.sensors[index].name; font.pixelSize: 12; font.bold: true; color: "#333"; elide: Text.ElideRight; Layout.fillWidth: true }
                                        Text { text: app.sensors[index].model + " · " + app.sensors[index].serial; font.pixelSize: 8; color: "#92979b"; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: app.sensors[index].warning ? "⚠ " + app.sensors[index].warning : (app.sensors[index].linked ? "✓ Linked" : "Link"); font.pixelSize: 9; color: app.sensors[index].warning ? "#bc692e" : "#33915c"; wrapMode: Text.WordWrap; Layout.fillWidth: true }
                                    }
                                }
                                MouseArea { anchors.fill: parent; enabled: sensorCard.opacity > 0.10; cursorShape: Qt.PointingHandCursor; onClicked: { if (index !== app.sensorIndex) app.chooseSensor(index) } }
                            }
                        }
                        MachinePicture {
                            id: machineImage

                            property real imageScale: app.uiScale

                            width: Math.min(
                                canvas.width * 0.36,
                                330 * imageScale
                            )

                            height: Math.min(
                                canvas.height * 0.82,
                                500 * imageScale
                            )

                            x: canvas.width - width - 12
                            y: (canvas.height - height) / 2

                            sourcePath: "images/testing-machine.png"
                        }
                    }
                }
            }
            Rectangle {
                Layout.preferredWidth: Math.min(350, Math.max(280, app.width*0.25)); Layout.fillHeight: true; radius: 12; color: "white"; clip: true
                ColumnLayout { anchors.fill: parent; spacing: 0
                    Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 59; color: "white"
                        RowLayout { anchors.fill: parent; anchors.leftMargin: 17; anchors.rightMargin: 16
                            Text { text: app.activeSection; font.pixelSize: 16; font.bold: true; color: ink }
                            Item { Layout.fillWidth: true }
                            Text { text: "×"; font.pixelSize: 26; color: "#59626b"; MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: { app.screen = "landing"; app.setupMessage = "" } } }
                        }
                        Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: edge }
                    }
                    ScrollView { Layout.fillWidth: true; Layout.fillHeight: true; clip: true; ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                        ColumnLayout { width: Math.max(260, parent.width-25); anchors.left: parent.left; anchors.leftMargin: 16; spacing: 12
                            Item { Layout.preferredHeight: 5 }

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 10

                                // Read-only sensor dropdown
                                Rectangle {
                                    id: sensorDropdown

                                    Layout.fillWidth: true
                                    Layout.minimumWidth: 0
                                    Layout.preferredHeight: 34
                                    radius: 5
                                    color: "#F7F8F9"
                                    border.color: "#CBD2D6"
                                    border.width: 1
                                    opacity: 1.0
                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.leftMargin: 8
                                        anchors.rightMargin: 10
                                        spacing: 6
                                        Text {
                                            Layout.fillWidth: true
                                            text: app.sensorIndex >= 0 &&
                                                  app.sensorIndex < app.sensors.length
                                                  ? app.sensors[app.sensorIndex].name
                                                  : ""
                                            font.family: "Segoe UI"
                                            font.pixelSize: 12
                                            color: "#4B5359"
                                            verticalAlignment: Text.AlignVCenter
                                            elide: Text.ElideRight
                                        }

                                        // Dropdown arrow - visual only
                                        Canvas {
                                            Layout.preferredWidth: 14
                                            Layout.preferredHeight: 10
                                            onPaint: {
                                                var ctx = getContext("2d")
                                                ctx.clearRect(0, 0, width, height)

                                                ctx.beginPath()
                                                ctx.moveTo(1, 2)
                                                ctx.lineTo(7, 8)
                                                ctx.lineTo(13, 2)

                                                ctx.strokeStyle = "#4B5359"
                                                ctx.lineWidth = 1.3
                                                ctx.lineCap = "round"
                                                ctx.lineJoin = "round"
                                                ctx.stroke()
                                            }
                                        }
                                    }
                                }

                                // Configure button
                                FlatButton {
                                    text: "Configure"
                                    primary: false
                                    Layout.preferredWidth: 94
                                    Layout.preferredHeight: 34
                                    font.family: "Segoe UI"
                                    font.pixelSize: 12
                                    onClicked: {
                                        if (app.sensorIndex >= 0 &&
                                            app.sensorIndex < app.sensors.length) {
                                            app.setupMessage =
                                                "Configure " +
                                                app.sensors[app.sensorIndex].name +
                                                " (demo action)."
                                        }
                                    }
                                }
                            }


                            Rectangle {
                                id: sensorWarningCard
                                Layout.fillWidth: true
                                Layout.preferredHeight: !visible ? 0 :
                                                        app.sensorIndex === 1 ? 90 : 76
                                radius: 7
                                color: "#FFF7ED"
                                border.color: "#EA580C"
                                border.width: 1
                                visible: app.sensorIndex === 1 ||
                                         (app.sensorIndex === 2 &&
                                          !app.sensors[2].linked)

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: 11
                                    anchors.rightMargin: 11
                                    anchors.topMargin: 10
                                    anchors.bottomMargin: 10
                                    spacing: 7
                                    // Warning triangle icon
                                    Canvas {
                                        id: warningIcon
                                        Layout.preferredWidth: 15
                                        Layout.preferredHeight: 15
                                        Layout.alignment: Qt.AlignTop

                                        onPaint: {
                                            var ctx = getContext("2d")
                                            ctx.clearRect(0, 0, width, height)

                                            ctx.strokeStyle = "#EA580C"
                                            ctx.fillStyle = "#EA580C"
                                            ctx.lineWidth = 1.3
                                            ctx.lineJoin = "round"
                                            ctx.lineCap = "round"

                                            // Triangle outline
                                            ctx.beginPath()
                                            ctx.moveTo(7.5, 1.5)
                                            ctx.lineTo(14, 13)
                                            ctx.lineTo(1, 13)
                                            ctx.closePath()
                                            ctx.stroke()

                                            // Exclamation line
                                            ctx.beginPath()
                                            ctx.moveTo(7.5, 5)
                                            ctx.lineTo(7.5, 9)
                                            ctx.stroke()

                                            // Exclamation dot
                                            ctx.beginPath()
                                            ctx.arc(7.5, 11, 0.7, 0, Math.PI * 2)
                                            ctx.fill()
                                        }
                                    }

                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        Layout.alignment: Qt.AlignTop

                                        spacing: 5

                                        Text {
                                            text: app.sensorIndex === 1
                                                ? "Calibration expires in 21 days"
                                                : "Not Linked"

                                            font.family: "Segoe UI"
                                            font.pixelSize: 13
                                            font.weight: Font.DemiBold

                                            color: "#C2410C"
                                        }

                                        Text {
                                            text: app.sensorIndex === 1
                                                ? "Valid for this test.\nRecalibrate before 21st October 2026 to stay compliant."
                                                : "Link this device to calibrate it"

                                            font.family: "Segoe UI"
                                            font.pixelSize: 11

                                            color: "#475569"

                                            Layout.fillWidth: true
                                            wrapMode: Text.WordWrap
                                        }
                                    }
                                }
                            }

                            RowLayout { Layout.fillWidth: true; Layout.topMargin: 10
                                Text { text: "Initial gauge length L₀"; font.pixelSize: 11; color: ink; Layout.fillWidth: true; font.family: "Segoe UI" }
                                Rectangle { width: 92; height: 32; radius: 5; color: "#f8f9fa"; border.color: edge
                                    RowLayout { anchors.fill: parent; anchors.margins: 4; spacing: 2
                                        TextField { id: gauge;color : "black"; text: "50"; validator: DoubleValidator { bottom: 0 } font.pixelSize: 11; Layout.fillWidth: true; background: Item {} }
                                        Text { text: "mm"; font.pixelSize: 10; color: "#8a9197" }
                                    }
                                }
                            }
                            Rectangle { Layout.fillWidth: true; height: 1; color: edge }
                            RowLayout { Layout.fillWidth: true
                                Text { text: "Field of View"; font.pixelSize: 11; color: ink; Layout.fillWidth: true; font.family: "Segoe UI" }
                                Rectangle { width: 92; height: 32; radius: 5; color: "#f8f9fa"; border.color: edge
                                    RowLayout { anchors.fill: parent; anchors.margins: 4; spacing: 2
                                        TextField { id: fieldView;color : "black"; text: "120"; validator: DoubleValidator { bottom: 0 } font.pixelSize: 11; Layout.fillWidth: true; background: Item {} }
                                        Text { text: "mm"; font.pixelSize: 10; color: "#8a9197";  }
                                    }
                                }
                            }
                            Rectangle { Layout.fillWidth: true; height: 1; color: edge }
                            Text { text: "Target Type"; font.pixelSize: 11; color: ink ;font.family: "Segoe UI"}
                            RowLayout { Layout.fillWidth: true; spacing: 5

                                Repeater {
                                    model: ["Pattern", "Dot", "Line"]
                                    delegate: RadioButton {
                                        id: patternRadio
                                        required property string modelData
                                        text: modelData
                                        checked: app.strainPattern === modelData
                                        implicitHeight: 28
                                        implicitWidth: 80
                                        spacing: 7
                                        padding: 0
                                        font.family: "Segoe UI"
                                        font.pixelSize: 12
                                        font.weight: Font.Normal
                                        hoverEnabled: true
                                        indicator: Rectangle {
                                            implicitWidth: 15
                                            implicitHeight: 15
                                            x: 0
                                            y: (patternRadio.height - height) / 2
                                            radius: width / 2
                                            color: patternRadio.checked? "#005B58": "#FFFFFF"
                                            border.color: patternRadio.checked
                                                          ? "#005B58"
                                                          : "#CBD2D6"
                                            border.width: 1

                                            Rectangle {
                                                anchors.centerIn: parent
                                                width: 5
                                                height: 5
                                                radius: width / 2
                                                color: "#FFFFFF"
                                                visible: patternRadio.checked
                                            }
                                        }

                                        contentItem: Text {
                                            text: patternRadio.text
                                            font: patternRadio.font
                                            color: "#3D4043"
                                            verticalAlignment: Text.AlignVCenter
                                            leftPadding: patternRadio.indicator.width
                                                         + patternRadio.spacing
                                        }

                                        onClicked: {
                                            app.strainPattern = modelData
                                        }
                                    }
                                }

                            }
                            Rectangle { Layout.fillWidth: true; height: 1; color: edge }

                            RowLayout {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 48
                                spacing: 8
                                Text {
                                    text: "System Capabilities"
                                    font.family: "Segoe UI"
                                    font.pixelSize: 12
                                    font.weight: Font.DemiBold
                                    color: "#202A31"
                                    Layout.fillWidth: true
                                    verticalAlignment: Text.AlignVCenter
                                }

                                // Disabled + icon
                                Text {
                                    text: "+"
                                    font.family: "Segoe UI"
                                    font.pixelSize: 22
                                    font.weight: Font.Normal
                                    color: "#202A31"
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    Layout.preferredWidth: 24
                                    Layout.preferredHeight: 24
                                }
                            }

                            Text { visible: app.capabilitiesExpanded; text: "Supported system capabilities"; font.pixelSize: 11; color: "#64717b";font.family: "Segoe UI" }
                            Rectangle { Layout.fillWidth: true; height: 1; color: edge }
                            Text { visible: app.setupMessage.length > 0; text: app.setupMessage; wrapMode: Text.WordWrap; Layout.fillWidth: true; font.pixelSize: 11; color: "#126c70" }
                        }
                    }
                    Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 67; color: "white"; border.color: "#e0e4e6"; border.width: 1
                        RowLayout { anchors.fill: parent; anchors.margins: 13; spacing: 9
                            Item { Layout.fillWidth: true }

                            FlatButton {
                                id: previousButton
                                text: "Previous"
                                primary: false
                                Layout.preferredWidth: 106
                                Layout.preferredHeight: 36
                                implicitWidth: 106
                                implicitHeight: 36
                                padding: 0
                                font.family: "Segoe UI"
                                font.pixelSize: 12
                                font.weight: Font.DemiBold
                                onClicked: app.previousSection()
                            }


                            FlatButton {
                                text: "Apply and Go Next"
                                primary: true
                                Layout.preferredWidth: 156
                                Layout.preferredHeight: 36
                                font.family: "Segoe UI"
                                font.pixelSize: 12
                                font.weight: Font.DemiBold
                                onClicked: app.nextSection()
                            }

                        }
                    }
                }
            }
        }
