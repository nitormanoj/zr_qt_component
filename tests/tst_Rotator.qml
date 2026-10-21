import QtQuick
import QtTest
import ".."

Item {
    width: 1440; height: 900
    Main { id: app; visible: true; width: 1440; height: 900; screen: "setup" }
    TestCase {
        name: "ResponsiveRotator"
        when: windowShown
        function findCard(index) {
            var orbit = findChild(app, "sensorOrbit")
            for (var i = 0; i < orbit.children.length; ++i)
                if (orbit.children[i].objectName === "sensorCard" + index) return orbit.children[i]
            fail("Missing sensor card " + index)
        }
        function checkSeparation() {
            var orbit = findChild(app, "sensorOrbit")
            var machine = findChild(app, "rotatorMachineImage")
            var surface = findChild(app, "rotatorCanvas")
            var navigation = findChild(app, "rotatorSectionNavigation")
            compare(orbit.y, 0)
            compare(orbit.height, surface.height)
            compare(navigation.mapToItem(surface, 0, 0).y, 12)
            compare(navigation.height, surface.height - 24)
            var innerGap = orbit.arcX(0.5, 1) - orbit.arcX(0.5, 0)
            var outerGap = orbit.arcX(0.5, 2) - orbit.arcX(0.5, 1)
            verify(outerGap > innerGap * 1.5)
            verify(machine.width > 0 && machine.height > 0)
            verify(orbit.width * orbit.scale < machine.x)
            for (var i = 0; i < 3; ++i) {
                var card = findCard(i)
                if (card.opacity < 0.01) continue
                var right = card.mapToItem(surface, card.width, 0).x
                verify(right < machine.x, "Card overlaps machine at width " + app.width)
                verify(card.x > orbit.arcX(card.curveProgress))
                var dx = card.orbitX - orbit.centerX
                var dy = card.orbitY - orbit.height / 2
                verify(Math.abs(dx * dx + dy * dy - orbit.radius * orbit.radius) < 0.01)
            }
        }
        function test_resizeAndRotate() {
            var sizes = [[1440,900], [1100,705], [900,610], [900,1000], [1920,610], [1920,1080]]
            for (var s = 0; s < sizes.length; ++s) {
                app.width = sizes[s][0]; app.height = sizes[s][1]
                app.sensorIndex = 1
                wait(700)
                checkSeparation()
                for (var target = 0; target <= 2; ++target) {
                    var card = findCard(target)
                    mouseClick(card)
                    compare(app.sensorIndex, target)
                    for (var frame = 0; frame < 14; ++frame) {
                        wait(50)
                        checkSeparation()
                    }
                    tryCompare(card, "curveProgress", 0.5)
                }
            }
        }
    }
}
