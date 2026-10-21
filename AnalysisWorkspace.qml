pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

Rectangle {
    id: workspace
    objectName: "analysisWorkspace"
    color: "white"
    property var specimens: []
    property int activeTab: 0
    property bool showGrid: true
    property bool showMarkers: true
    property var xAxisSettings: ({})
    property var yAxisSettings: ({})
    signal backRequested()
    ColumnLayout {
        anchors.fill: parent; anchors.margins: 16; spacing: 14
        RowLayout {
            Layout.fillWidth: true; spacing: 8
            ToolButton {
                id: backButton
                objectName: "analysisBackButton"
                implicitWidth: 24; implicitHeight: 34
                text: "\u2190"; font.pixelSize: 20; palette.buttonText: "#626975"
                Accessible.name: "Back to Documents"
                background: Rectangle { radius: 3; color: backButton.hovered ? "#f1f5f6" : "transparent" }
                onClicked: workspace.backRequested()
            }
            Column {
                spacing: 2
                Text { text: "Analysis Workspace"; font.family: "Segoe UI"; font.pixelSize: 16; font.weight: Font.DemiBold; color: "#292d31" }
                Text { text: "Manage test data efficiently with our material testing software."; font.family: "Segoe UI"; font.pixelSize: 10; color: "#626975" }
            }
            Item { Layout.fillWidth: true }
        }
        Rectangle {
            Layout.fillWidth: true; Layout.preferredHeight: 34
            color: "transparent"
            Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: "#d9dee2" }
            Row {
                anchors.fill: parent; spacing: 8
                Repeater {
                    model: ["Curve Graph And Statistics", "Insights"]
                    delegate: Button {
                        id: tabButton
                        required property int index
                        required property string modelData
                        height: 34; leftPadding: 10; rightPadding: 10
                        contentItem: Text { text: tabButton.modelData; color: workspace.activeTab===tabButton.index ? "#00858b" : "#626975"; font.family: "Segoe UI"; font.pixelSize: 12; verticalAlignment: Text.AlignVCenter }
                        background: Item { Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: "#00858b"; visible: workspace.activeTab===tabButton.index } }
                        onClicked: workspace.activeTab=index
                    }
                }
            }
        }
        ScrollView {
            id: scroll
            visible: workspace.activeTab===0
            Layout.fillWidth: true; Layout.fillHeight: true
            clip: true
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ColumnLayout {
                width: scroll.availableWidth; spacing: 16
                visible: workspace.activeTab===0
                RowLayout {
                    Layout.fillWidth: true
                    Text { text: "Curve Graph"; font.family: "Segoe UI"; font.pixelSize: 12; font.weight: Font.DemiBold; color: "#292d31" }
                    Item { Layout.fillWidth: true }
                    ToolButton {
                        id: gearButton
                        objectName: "graphSettingsButton"
                        implicitWidth: 28; implicitHeight: 28
                        contentItem: Image { source: "icons/header-settings.svg"; fillMode: Image.PreserveAspectFit; sourceSize.width: 20; sourceSize.height: 20 }
                        Accessible.name: "Graph settings"
                        background: Rectangle { radius: 16; color: graphSettings.opened || gearButton.hovered ? "#e8f4f4" : "transparent" }
                        onClicked: {
                            var point=gearButton.mapToItem(workspace,0,gearButton.height+5)
                            graphSettings.x=workspace.width-graphSettings.width-16
                            graphSettings.y=point.y
                            graphSettings.open()
                        }
                    }
                }
                RowLayout {
                    id: chartRow
                    Layout.fillWidth: true; spacing: 30
                    readonly property real chartHeight: Math.max(360, Math.min(520, workspace.height*0.65))
                    Layout.preferredHeight: chartHeight
                    Layout.minimumHeight: chartHeight
                    Layout.maximumHeight: chartHeight
                    ColumnLayout {
                        Layout.preferredWidth: 168; Layout.minimumWidth: 168; Layout.maximumWidth: 168
                        Layout.fillHeight: true; spacing: 18
                        Column {
                            spacing: 2
                            Text { text: "Specimens"; font.family: "Segoe UI"; font.pixelSize: 12; font.weight: Font.DemiBold; color: "#292d31" }
                            Text { text: workspace.specimens.length + " Selected"; font.family: "Segoe UI"; font.pixelSize: 11; color: "#626975" }
                        }
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.minimumHeight: 0
                            Layout.preferredHeight: 32 + workspace.specimens.length * 31
                            Layout.maximumHeight: 32 + workspace.specimens.length * 31
                            color: "white"; radius: 5; border.color: "#d2d8e1"; clip: true
                                Rectangle {
                                    id: legendHeader
                                    anchors.top: parent.top
                                    width: parent.width; height: 32; color: "#e9ebed"
                                    Row { anchors.fill: parent; leftPadding: 22
                                        Text { width: 50; height: 32; text: "No."; verticalAlignment: Text.AlignVCenter; font.family: "Segoe UI"; font.pixelSize: 10; color: "#405574" }
                                        Text { height: 32; text: "Name"; verticalAlignment: Text.AlignVCenter; font.family: "Segoe UI"; font.pixelSize: 10; color: "#405574" }
                                    }
                                }
                                ListView {
                                    id: specimenLegend
                                    objectName: "analysisSpecimenLegend"
                                    anchors.top: legendHeader.bottom
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.bottom: parent.bottom
                                    clip: true
                                    boundsBehavior: Flickable.StopAtBounds
                                    ScrollBar.vertical: ScrollBar {}
                                    model: workspace.specimens
                                    delegate: Rectangle {
                                        id: legendRow
                                        required property var modelData
                                        width: specimenLegend.width; height: 31; color: "white"
                                        Row {
                                            anchors.fill: parent; anchors.leftMargin: 14; spacing: 10
                                            Rectangle { anchors.verticalCenter: parent.verticalCenter; width: 10; height: 10; radius: 5; color: legendRow.modelData.color }
                                            Text { width: 25; height: 31; text: legendRow.modelData.number; verticalAlignment: Text.AlignVCenter; color: "#405574"; font.family: "Segoe UI"; font.pixelSize: 10 }
                                            Text { height: 31; text: legendRow.modelData.name; verticalAlignment: Text.AlignVCenter; color: "#405574"; font.family: "Segoe UI"; font.pixelSize: 10 }
                                        }
                                        Rectangle { anchors.bottom: parent.bottom; height: 1; width: parent.width; color: "#e6ebf1" }
                                    }
                                }
                        }
                        Item { Layout.fillHeight: true }
                    }
                    AnalysisCurveGraph {
                        objectName: "analysisCurveGraph"
                        Layout.fillWidth: true; Layout.fillHeight: true
                        Layout.minimumWidth: 400
                        specimens: workspace.specimens; showGrid: workspace.showGrid; showMarkers: workspace.showMarkers
                        xAxis: workspace.xAxisSettings; yAxis: workspace.yAxisSettings
                    }
                }
                Text { text: "Statistics"; font.family: "Segoe UI"; font.pixelSize: 12; font.weight: Font.DemiBold; color: "#292d31"; Layout.topMargin: 6 }
                AnalysisStatistics { objectName: "analysisStatistics"; Layout.fillWidth: true; specimens: workspace.specimens }
 }
        }
        AnalysisInsights {
            visible: workspace.activeTab===1
            Layout.fillWidth: true; Layout.fillHeight: true
        }
    }
    GraphSettingsPopup {
        id: graphSettings
        parent: workspace
        onApplied: function(xSettings,ySettings) { workspace.xAxisSettings=xSettings; workspace.yAxisSettings=ySettings }
    }
}
