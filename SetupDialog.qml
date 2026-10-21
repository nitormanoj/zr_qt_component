import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

Popup {
    property var app: null
    property alias setupNameValue: setupName.text
    property alias tensileChecked: tensileChoice.checked
    property alias compressionChecked: compressionChoice.checked
    property alias standardIndex: standardChoice.currentIndex
    property color ink: "#202a31"
    property color edge: "#d9dee2"
    id: createPopup
    parent: Overlay.overlay
    width: Math.min(384, parent.width-32); height: Math.min(374, parent.height-30)
    x: (parent.width-width)/2; y: (parent.height-height)/2
    modal: true; focus: true; padding: 0; closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    background: Rectangle { color: "white"; radius: 7; border.color: "#cbd3d8"; border.width: 1 }
    contentItem: ColumnLayout { spacing: 0
        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 50; color: "transparent"
            RowLayout { anchors.fill: parent; anchors.leftMargin: 10; anchors.rightMargin: 14
                Text { text: "Create A New Testing Setup";font.family: "Segoe UI"; font.pixelSize: 14; font.weight: Font.DemiBold; color: "#212324"; Layout.fillWidth: true }
                Text { text: "×"; font.pixelSize: 28; color: "#59626b"; MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: createPopup.close() } }
            }
            Rectangle { anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right; anchors.margins: 3; height: 2; color: "#1a8080" }
        }
        ColumnLayout { Layout.fillWidth: true; Layout.fillHeight: true; Layout.leftMargin: 22; Layout.rightMargin: 22; Layout.topMargin: 22; spacing: 6
            Text { text: "Target Type"; font.pixelSize: 12; color: ink ;font.family: "Segoe UI"}
            RowLayout { Layout.fillWidth: true; spacing: 16

                RadioButton {
                    id: tensileChoice

                    text: "Tensile Test"
                    checked: true
                    implicitHeight: 28
                    implicitWidth: 92
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
                        y: (tensileChoice.height - height) / 2
                        radius: width / 2
                        color: tensileChoice.checked ? "#005B58" : "#FFFFFF"
                        border.color: tensileChoice.checked ? "#005B58" : "#CBD2D6"
                        border.width: 1
                        Rectangle {
                            anchors.centerIn: parent
                            width: 5
                            height: 5
                            radius: width / 2
                            color: "#FFFFFF"
                            visible: tensileChoice.checked
                        }
                    }

                    contentItem: Text {
                        text: tensileChoice.text
                        font: tensileChoice.font
                        color: "#3D4043"
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: tensileChoice.indicator.width + tensileChoice.spacing
                    }

                    onClicked: {
                        compressionChoice.checked = false
                        setupName.text = "Tensile Test - G3467"
                    }
                }

                RadioButton {
                    id: compressionChoice

                    text: "Compression Test"
                    checked: false
                    implicitHeight: 28
                    implicitWidth: 145
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
                        y: (compressionChoice.height - height) / 2
                        radius: width / 2
                        color: compressionChoice.checked ? "#005B58" : "#FFFFFF"
                        border.color: compressionChoice.checked ? "#005B58" : "#CBD2D6"
                        border.width: 1

                        Rectangle {
                            anchors.centerIn: parent
                            width: 5
                            height: 5
                            radius: width / 2
                            color: "#FFFFFF"
                            visible: compressionChoice.checked
                        }
                    }
                    contentItem: Text {
                        text: compressionChoice.text
                        font: compressionChoice.font
                        color: "#3D4043"
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: compressionChoice.indicator.width
                                     + compressionChoice.spacing
                    }
                    onClicked: {
                        tensileChoice.checked = false
                        setupName.text = "Compression Test - G3467"
                    }
                }

            }
            Item { Layout.preferredHeight: 8 }
            Text { text: "Test Standard"; font.pixelSize: 14; color: ink ;font.family: "Segoe UI"}

            ComboBox {
                id: standardChoice

                Layout.fillWidth: true
                Layout.preferredHeight: 38

                model: [
                    "ZwickRoell (Recommended)",
                    "ISO 6892-1",
                    "ASTM E8/E8M",
                    "ISO 527-1",
                    "ISO 7500-1"
                ]

                currentIndex: 0

                font.family: "Segoe UI"
                font.pixelSize: 12
                font.weight: Font.Normal

                leftPadding: 7
                rightPadding: 34

                // Selected text appearance
                contentItem: Text {
                    text: standardChoice.displayText
                    font: standardChoice.font
                    color: "#3D4043"

                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    elide: Text.ElideRight
                }

                // Dropdown arrow

                indicator: Canvas {
                    id: dropdownArrow

                    width: 18
                    height: 12

                    x: standardChoice.width - width - 12
                    y: (standardChoice.height - height) / 2

                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.clearRect(0, 0, width, height)

                        ctx.beginPath()
                        ctx.moveTo(2, 3)
                        ctx.lineTo(9, 10)
                        ctx.lineTo(16, 3)

                        ctx.strokeStyle = "#3D4043"
                        ctx.lineWidth = 1.6
                        ctx.lineCap = "round"
                        ctx.lineJoin = "round"
                        ctx.stroke()
                    }
                }


                // Field background and border
                background: Rectangle {
                    implicitHeight: 38
                    radius: 5

                    color: "#F7F8F9"
                    border.color: "#CBD2D6"
                    border.width: 1
                }

                // Dropdown options
                delegate: ItemDelegate {
                    width: standardChoice.width
                    height: 38

                    contentItem: Text {
                        text: modelData
                        font.family: "Segoe UI"
                        font.pixelSize: 12
                        color: "#3D4043"

                        verticalAlignment: Text.AlignVCenter
                        leftPadding: 8
                    }

                    background: Rectangle {
                        color: highlighted ? "#E2F2F2" : "#FFFFFF"
                    }
                }

                // Dropdown popup
                popup: Popup {
                    y: standardChoice.height + 2
                    width: standardChoice.width

                    implicitHeight: contentItem.implicitHeight + 2
                    padding: 1

                    contentItem: ListView {
                        implicitHeight: contentHeight
                        clip: true

                        model: standardChoice.popup.visible
                               ? standardChoice.delegateModel
                               : null

                        currentIndex: standardChoice.highlightedIndex

                        ScrollIndicator.vertical: ScrollIndicator {}
                    }

                    background: Rectangle {
                        color: "#FFFFFF"
                        radius: 5
                        border.color: "#CBD2D6"
                        border.width: 1
                    }
                }
            }

            Item { Layout.preferredHeight: 8 }
            Text { text: "Label"; font.pixelSize: 14; color: ink;font.family: "Segoe UI" }

            TextField {
                id: setupName

                Layout.fillWidth: true
                Layout.preferredHeight: 38

                text: "Tensile Test - G3467"
                placeholderText: "Enter testing setup name"

                font.family: "Segoe UI"
                font.pixelSize: 12
                font.weight: Font.Normal

                color: "#3D4043"
                placeholderTextColor: "#8A9298"

                leftPadding: 7
                rightPadding: 10
                topPadding: 0
                bottomPadding: 0

                verticalAlignment: TextInput.AlignVCenter
                selectByMouse: true

                background: Rectangle {
                    implicitWidth: 200
                    implicitHeight: 38

                    radius: 5
                    color: "#F7F8F9"

                    border.color: "#CBD2D6"
                    border.width: 1
                }
            }

            Item { Layout.fillHeight: true }
        }
        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 58; color: "transparent"
            Rectangle { anchors.top: parent.top; width: parent.width; height: 1; color: edge }
            RowLayout { anchors.fill: parent; anchors.margins: 10
                Item { Layout.fillWidth: true }
                FlatButton {
                    text: "Start Setup"
                    font.family: "Segoe UI"
                    primary: true
                    Layout.preferredWidth: 105
                    Layout.preferredHeight: 38
                    implicitWidth: 105
                    implicitHeight: 38
                    enabled: setupName.text.trim().length > 0
                    onClicked: {
                         console.log("Start Setup clicked")
                        app.startSetup()}
                }
            }
        }
    }
}
