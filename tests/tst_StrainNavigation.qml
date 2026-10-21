import QtQuick
import QtTest
import ".."

Item {
    width: 1440; height: 900
    Main { id: app; visible: true; width: 1440; height: 900 }
    TestCase {
        name: "StrainNavigation"
        when: windowShown

        function test_closeOnNavigation_data() {
            return [
                { tag: "homepage", property: "screen", value: "landing" },
                { tag: "documents", property: "screen", value: "documents" },
                { tag: "leftNavigation", property: "activeMenu", value: "users" },
                { tag: "setupSection", property: "activeSection", value: "Force" }
            ]
        }

        function test_closeOnNavigation(data) {
            app.screen = "setup"
            app.activeMenu = "testing"
            app.activeSection = "Strain"
            var drawer = findChild(app, "strainConfigDrawer")
            verify(drawer !== null)
            drawer.open()
            tryCompare(drawer, "opened", true)
            app[data.property] = data.value
            tryCompare(drawer, "visible", false)
            app.screen = "landing"
            app.screen = "setup"
            compare(drawer.visible, false)
        }
    }
}
