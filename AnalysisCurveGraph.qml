pragma ComponentBehavior: Bound
import QtQuick

Item {
    id: graph
    property var specimens: []
    property bool showGrid: true
    property bool showMarkers: true
    property var xAxis: ({})
    property var yAxis: ({})
    readonly property var xBounds: bounds(xAxis, true)
    readonly property var yBounds: bounds(yAxis, false)
    readonly property var months: ["January", "February", "March", "April", "May", "June", "July"]
    readonly property var curves: [
        [[0,-900],[1,940],[2,400],[3,80],[4,-100],[5,-340],[6,440]],
        [[0,-800],[1.22,260],[2.45,970],[3.67,790],[4.9,-620],[6,-340]],
        [[0,-590],[1.22,-360],[2.44,510],[3.67,340],[4.9,1000],[6,-100]],
        [[0,-900],[1,-460],[2,-680],[3,-510],[4,-200],[5,-540],[6,0]],
        [[0,-890],[1.2,-580],[2.44,520],[3.66,-140],[4.88,40],[6,-830]]
    ]
    property real leftEdge: 62
    property real rightEdge: width - 25
    property real topEdge: 14
    property real bottomEdge: height - 40
    function bounds(axis, horizontal) {
        var low=horizontal ? 0 : -1000, high=horizontal ? 6 : 1000
        if ((axis.scaling==="Auto" || axis.scaling==="Extension to fit") && specimens.length) {
            low=Infinity; high=-Infinity
            for(var s=0;s<specimens.length;s++) for(var p=0;p<curves[s%curves.length].length;p++) {
                var v=curves[s%curves.length][p][horizontal ? 0 : 1]
                low=Math.min(low,v); high=Math.max(high,v)
            }
            if(axis.scaling==="Extension to fit") { var padding=(high-low)*0.05; low-=padding; high+=padding }
        }
        if(axis.lower!==undefined && axis.lower!==null) low=axis.lower
        if(axis.upper!==undefined && axis.upper!==null) high=axis.upper
        if(high<=low) high=low+1
        return [low,high]
    }
    // Signed logarithmic transform preserves the negative values in the demo curves.
    function scaleValue(value, axis) { return axis.logarithmic ? (value<0 ? -1 : 1)*Math.log(1+Math.abs(value)) : value }
    function xTick(index) { return xBounds[0]+index/6*(xBounds[1]-xBounds[0]) }
    function yTick(index) { return yBounds[1]-index/10*(yBounds[1]-yBounds[0]) }
    function plotX(value) { return leftEdge + 18 + (scaleValue(value,xAxis)-scaleValue(xBounds[0],xAxis))/(scaleValue(xBounds[1],xAxis)-scaleValue(xBounds[0],xAxis)) * (rightEdge-leftEdge-18) }
    function plotY(value) { return topEdge + (scaleValue(yBounds[1],yAxis)-scaleValue(value,yAxis))/(scaleValue(yBounds[1],yAxis)-scaleValue(yBounds[0],yAxis)) * (bottomEdge-topEdge) }
    onSpecimensChanged: canvas.requestPaint()
    onShowGridChanged: canvas.requestPaint()
    onShowMarkersChanged: canvas.requestPaint()
    onXAxisChanged: canvas.requestPaint()
    onYAxisChanged: canvas.requestPaint()
    Canvas {
        id: canvas
        anchors.fill: parent
        antialiasing: true
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0,0,width,height)
            if (graph.showGrid) {
                ctx.strokeStyle = "#d4d8de"; ctx.lineWidth = 1
                ctx.beginPath()
                for (var tick=0; tick<=10; tick++) { var y=graph.plotY(graph.yTick(tick)); ctx.moveTo(graph.leftEdge,y); ctx.lineTo(graph.rightEdge,y) }
                for (var month=0; month<7; month++) { var x=graph.plotX(graph.xTick(month)); ctx.moveTo(x,graph.topEdge); ctx.lineTo(x,graph.bottomEdge+12) }
                ctx.stroke()
            }
            ctx.save(); ctx.beginPath(); ctx.rect(graph.leftEdge-7,graph.topEdge-7,graph.rightEdge-graph.leftEdge+14,graph.bottomEdge-graph.topEdge+14); ctx.clip()
            for (var series=0; series<graph.specimens.length; series++) {
                var points=graph.curves[series % graph.curves.length]
                var color=graph.specimens[series].color
                ctx.strokeStyle=color; ctx.lineWidth=2.8; ctx.lineJoin="round"
                ctx.beginPath()
                for (var p=0;p<points.length;p++) {
                    var px=graph.plotX(points[p][0]), py=graph.plotY(points[p][1])
                    if(p===0) ctx.moveTo(px,py); else ctx.lineTo(px,py)
                }
                ctx.stroke()
                if (graph.showMarkers) for (var dot=0;dot<points.length;dot++) {
                    ctx.beginPath(); ctx.arc(graph.plotX(points[dot][0]),graph.plotY(points[dot][1]),6,0,Math.PI*2)
                    ctx.fillStyle=Qt.lighter(color,1.3); ctx.fill(); ctx.lineWidth=1; ctx.stroke()
                }
            }
            ctx.restore()
        }
    }
    Repeater {
        model: 11
        delegate: Text {
            required property int index
            x: 0; y: graph.plotY(graph.yTick(index))-height/2
            width: 46; horizontalAlignment: Text.AlignRight
            text: graph.yTick(index).toLocaleString(Qt.locale("en_US"), "f", 0).replace(/,/g, " ")
            color: "#565c64"; font.family: "Segoe UI"; font.pixelSize: 11
        }
    }
    Repeater {
        model: graph.months
        delegate: Text {
            required property int index
            required property string modelData
            x: graph.plotX(graph.xTick(index))-width/2; y: graph.bottomEdge+21
            text: Object.keys(graph.xAxis).length ? graph.xTick(index).toFixed(1) : modelData
            color: "#565c64"; font.family: "Segoe UI"; font.pixelSize: 11
        }
    }
    Text { x: graph.leftEdge; y: -8; text: graph.yAxis.name ? graph.yAxis.name+" ("+graph.yAxis.unit+")" : ""; color: "#626975"; font.family: "Segoe UI"; font.pixelSize: 10 }
    Text { anchors.horizontalCenter: parent.horizontalCenter; anchors.bottom: parent.bottom; text: graph.xAxis.name ? graph.xAxis.name+" ("+graph.xAxis.unit+")" : ""; color: "#626975"; font.family: "Segoe UI"; font.pixelSize: 10 }
}
