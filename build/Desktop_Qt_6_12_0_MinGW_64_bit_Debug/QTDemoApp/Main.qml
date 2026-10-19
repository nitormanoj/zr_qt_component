import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: appWindow
    width: 1440
    height: 705
    minimumWidth: 900
    minimumHeight: 610
    property bool compactMode: width < 1150
    property bool smallHeight: height < 750
    property real uiScale: Math.min(1,Math.max(0.75, width / 1440))
    visible: true; title: "testXpert - ZwickRoell"; color: "#eceeef";font.family: "Segoe UI"
    property color teal: "#1a8080"
    property color ink: "#202a31"
    property color edge: "#d9dee2"
    property string screen: "landing"
    property string activeMenu: "testing"
    property var analysisSpecimens: []
    property string targetType: "Tensile Test"
    property string selectedStandard: "zwickroell"
    property string testingLabel: "Tensile Test - G3467"
    property var sections: ["Force", "Crosshead", "Strain", "Grips", "Transverse", "Temperature"]
    property string activeSection: "Strain"
    property int sensorIndex: 1
    property string strainPattern: "Pattern"
    property bool capabilitiesExpanded: false
    property string setupMessage: ""
    property var sensors: [
        {id:"video-2",name:"VideoXtens 2",model:"VideoXtens01",serial:"SN 243509",image:"images/tensile.png",linked:true,warning:""},
        {id:"video-hp",name:"VideoXtens 2-120 HP",model:"VideoXtens01",serial:"SN 243508",image:"images/round-specimen.png",linked:true,warning:"In use · Calibration expiring"},
        {id:"clip-on",name:"Clip-On Extensometer",model:"MakroXtens II",serial:"SN 243506",image:"images/compression.png",linked:false,warning:""}
    ]

    // Functions
    function startSetup() {
        if (!createPopup.setupNameValue.trim()) return
        testingLabel = createPopup.setupNameValue.trim()
        targetType = createPopup.tensileChecked ? "Tensile Test" : "Compression Test"
        selectedStandard = ["zwickroell","iso-6892","astm-e8","iso-527","iso-7500"][createPopup.standardIndex]
        activeSection = "Strain"; sensorIndex = 1; setupMessage = ""
        createPopup.close(); screen = "setup"
    }
    function chooseSensor(i) { sensorIndex = i; setupMessage = "" }
    function previousSection() {
        var i = sections.indexOf(activeSection)
        if (i > 0) { activeSection = sections[i-1]; setupMessage = "" }
        else { screen = "landing"; setupMessage = "" }
    }
    function nextSection() {
        console.log("Applied", activeSection, sensors[sensorIndex].id, rotator.gaugeValue, rotator.fieldViewValue, strainPattern)
        var i = sections.indexOf(activeSection)
        if (i < sections.length-1) { activeSection = sections[i+1]; setupMessage = "" }
        else setupMessage = "Configuration completed (demo only)."
    }
    function openCreateDialog() {
        createPopup.tensileChecked = true
        createPopup.compressionChecked = false
        createPopup.standardIndex = 0
        createPopup.setupNameValue = "Tensile Test - G3467"
        createPopup.open()
    }
    header: HeaderNav { edgeColor: appWindow.edge; documentsMode: appWindow.screen === "documents" || appWindow.screen === "analysis" }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        LeftNav {
            visible: appWindow.screen !== "analysis"
            app: appWindow
            Layout.preferredWidth: 66
            Layout.fillHeight: true
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Landing {
                anchors.fill: parent
                app: appWindow
                visible: appWindow.screen === "landing"
            }
            Documents {
                anchors.fill: parent
                visible: appWindow.screen === "documents"
                onAnalyseRequested: function(specimens) { appWindow.analysisSpecimens = specimens; analysisView.activeTab = 0; appWindow.screen = "analysis" }
            }
            AnalysisWorkspace {
                id: analysisView
                anchors.fill: parent
                visible: appWindow.screen === "analysis"
                specimens: appWindow.analysisSpecimens
                onBackRequested: appWindow.screen = "documents"
            }
            Rotator {
                id: rotator
                anchors.fill: parent
                app: appWindow
                visible: appWindow.screen === "setup"
            }
        }
    }

    SetupDialog  {
        id: createPopup
        app: appWindow
    }
}
