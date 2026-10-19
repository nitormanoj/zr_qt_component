import QtQuick
import QtTest
import ".."

Item {
    width: 1100; height: 850
    Main { id: app; visible: true; width: 1100; height: 850 }
    TestCase {
        name: "AnalysisNavigation"
        when: windowShown
        function test_analyseAndBack() {
            app.screen = "documents"
            app.activeMenu = "documents"
            var documents = findChild(app, "documentsScreen")
            verify(documents !== null)
            documents.selected = [0, 2, 4, 8, 9]
            mouseClick(findChild(documents, "analyseButton"))
            compare(app.screen, "analysis")
            var workspace = findChild(app, "analysisWorkspace")
            verify(workspace.visible)
            compare(workspace.specimens.length, 5)
            compare(workspace.specimens[0].name, "Probe 10.1.1")
            compare(workspace.specimens[4].number, 10)
            var graph = findChild(workspace, "analysisCurveGraph")
            tryVerify(function() { return graph.width >= 400 && graph.height >= 360 })
            compare(graph.specimens.length, 5)
            compare(graph.curves.length, 5)
            mouseClick(findChild(workspace, "graphSettingsButton"))
            var settings = findChild(workspace, "graphSettingsPopup")
            tryCompare(settings, "opened", true)
            var xEditor = findChild(settings, "xAxisEditor")
            var yEditor = findChild(settings, "yAxisEditor")
            verify(xEditor.expanded); verify(!yEditor.expanded)
            xEditor.load({name:"Length",unit:"mm",scaling:"Manual",lower:1,upper:5})
            yEditor.load({name:"Force",unit:"kN",scaling:"Manual",lower:-500,upper:1500})
            settings.applySettings()
            compare(workspace.xAxisSettings.name,"Length")
            compare(graph.xBounds[0],1); compare(graph.xBounds[1],5)
            compare(graph.yBounds[0],-500); compare(graph.yBounds[1],1500)
            settings.open()
            xEditor.load({lower:5,upper:1})
            settings.applySettings(); verify(settings.opened)
            settings.clearAll(); settings.applySettings()
            compare(graph.xBounds[0],0); compare(graph.xBounds[1],6)
            compare(graph.yBounds[0],-1000); compare(graph.yBounds[1],1000)
            verify(graph.plotY(1000) < graph.plotY(-1000))
            workspace.showMarkers = false
            compare(graph.showMarkers, false)
            var statistics = findChild(workspace, "analysisStatistics")
            compare(statistics.value(0, 1), "Probe 10.1.1")
            workspace.activeTab = 1
            var insights = findChild(workspace, "analysisInsights")
            verify(insights.visible)
            compare(insights.metrics.length, 4); compare(insights.alerts.length, 4)
            compare(insights.metrics[0].value, "93.8%")
            verify(findChild(insights, "insightCard3").width > 0)
            verify(findChild(insights, "insightAlert3").height > 0)
            workspace.activeTab = 0
            mouseClick(findChild(workspace, "analysisBackButton"))
            compare(app.screen, "documents")
            compare(documents.selected.join(","), "0,2,4,8,9")
        }
    }
}
