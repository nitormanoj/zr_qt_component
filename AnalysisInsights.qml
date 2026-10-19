pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

ScrollView {
    id: insights
    objectName: "analysisInsights"
    clip: true
    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
    readonly property var metrics: [
        {badge: "Successful test", title: "Pass Rate", value: "93.8%", detail: "in last month", tint: "#dcfce7", ink: "#168847"},
        {badge: "Failed tests", title: "Failed Due To Overload", value: "3", detail: "vs, previous 7 days", tint: "#fff0dc", ink: "#e36b27"},
        {badge: "78% since last month", title: "Failed Due To Overload", value: "3", detail: "vs, previous 7 days", tint: "#ffe2e5", ink: "#e34047"},
        {badge: "Success", title: "Test Duration", value: "02:34:24", detail: "last test", tint: "#dcfce7", ink: "#168847"}
    ]
    readonly property var alerts: [
        {title: "Material consistency", detail: "Specimens span 2 materials (Copper CW004A, Aluminum EN AW-6082). Normalise results before aggregating statistics across material types.", tint: "#f0fcf4", ink: "#168847", kind: 0},
        {title: "Info", detail: "Additional material and specimen information is available to help validate and compare test outcomes", tint: "#eff6ff", ink: "#3478ff", kind: 1},
        {title: "Break force variability", detail: "Average Break N across selected specimens is 790.82 with standard deviation 227.70 (CV = 28.8%). High variation \u2014 process may be unstable.", tint: "#fff7ed", ink: "#d18a00", kind: 2},
        {title: "1 specimen failed acceptance criteria", detail: "1 of 2 specimens failed (50%). Investigate the failed specimens before approving the batch.", tint: "#fff2f3", ink: "#f0444c", kind: 3}
    ]
    ColumnLayout {
        width: Math.min(insights.availableWidth, Math.min(620, Math.max(480, insights.availableWidth*0.5)))
        spacing: 12
        Text { text: "Key KPIs"; color: "#292d31"; font.family: "Segoe UI"; font.pixelSize: 12; font.weight: Font.DemiBold }
        GridLayout {
            Layout.fillWidth: true; columns: 2; columnSpacing: 10; rowSpacing: 10
            Repeater {
                model: insights.metrics
                delegate: Rectangle {
                    id: card
                    required property var modelData
                    objectName: "insightCard" + index
                    required property int index
                    Layout.fillWidth: true; Layout.preferredHeight: 118
                    color: "white"; radius: 6; border.color: "#d6dae0"
                    Rectangle { z: -1; x: 1; y: 3; width: parent.width; height: parent.height; radius: 6; color: "#0c000000" }
                    ColumnLayout {
                        anchors.fill: parent; anchors.margins: 9; spacing: 5
                        Rectangle {
                            implicitWidth: badge.implicitWidth+23; implicitHeight: 18; radius: 3; color: card.modelData.tint
                            Canvas {
                                x: 4; anchors.verticalCenter: parent.verticalCenter; width: 10; height: 10
                                onPaint: {
                                    var ctx=getContext("2d"); ctx.strokeStyle=card.modelData.ink; ctx.lineWidth=1
                                    ctx.beginPath()
                                    if(card.index===1) {ctx.moveTo(5,1);ctx.lineTo(9,9);ctx.lineTo(1,9);ctx.closePath();ctx.moveTo(5,4);ctx.lineTo(5,6);ctx.moveTo(5,7.5);ctx.lineTo(5,7.7)}
                                    else {ctx.moveTo(5,9);ctx.lineTo(5,1);ctx.moveTo(2,4);ctx.lineTo(5,1);ctx.lineTo(8,4)}
                                    ctx.stroke()
                                }
                            }
                            Text { id: badge; x: 16; anchors.verticalCenter: parent.verticalCenter; text: card.modelData.badge; color: card.modelData.ink; font.family: "Segoe UI"; font.pixelSize: 9 }
                        }
                        Text { Layout.fillWidth: true; text: card.modelData.title; color: "#292d31"; font.family: "Segoe UI"; font.pixelSize: 12; wrapMode: Text.WordWrap }
                        Text { text: card.modelData.value; color: "#42474b"; font.family: "Segoe UI"; font.pixelSize: 26; font.weight: Font.Bold }
                        Text { text: card.modelData.detail; color: "#626975"; font.family: "Segoe UI"; font.pixelSize: 10 }
                    }
                }
            }
        }
        Text { text: "Alerts"; color: "#292d31"; font.family: "Segoe UI"; font.pixelSize: 12; font.weight: Font.DemiBold; Layout.topMargin: 4 }
        Repeater {
            model: insights.alerts
            delegate: Rectangle {
                id: alert
                required property var modelData
                required property int index
                objectName: "insightAlert" + index
                Layout.fillWidth: true; implicitHeight: alertBody.implicitHeight+20
                color: modelData.tint
                Rectangle { width: 1; height: parent.height; color: alert.modelData.ink }
                Canvas {
                    x: 10; y: 12; width: 12; height: 12
                    onPaint: {
                        var ctx=getContext("2d"); ctx.strokeStyle=alert.modelData.ink; ctx.lineWidth=1.2; ctx.lineCap="round"
                        ctx.beginPath()
                        if(alert.modelData.kind===0) {ctx.moveTo(2,6);ctx.lineTo(5,9);ctx.lineTo(10,3)}
                        else if(alert.modelData.kind===2) {ctx.moveTo(6,1);ctx.lineTo(11,10);ctx.lineTo(1,10);ctx.closePath();ctx.moveTo(6,4);ctx.lineTo(6,6);ctx.moveTo(6,8);ctx.lineTo(6,8.2)}
                        else {ctx.arc(6,6,5,0,Math.PI*2);if(alert.modelData.kind===1){ctx.moveTo(6,5);ctx.lineTo(6,8);ctx.moveTo(6,3);ctx.lineTo(6,3.2)}else{ctx.moveTo(4,4);ctx.lineTo(8,8);ctx.moveTo(8,4);ctx.lineTo(4,8)}}
                        ctx.stroke()
                    }
                }
                ColumnLayout {
                    id: alertBody
                    anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top
                    anchors.leftMargin: 28; anchors.rightMargin: 12; anchors.topMargin: 10
                    spacing: 6
                    Text { Layout.fillWidth: true; text: alert.modelData.title; color: alert.modelData.ink; font.family: "Segoe UI"; font.pixelSize: 11; font.weight: Font.DemiBold; wrapMode: Text.WordWrap }
                    Text { Layout.fillWidth: true; text: alert.modelData.detail; color: "#405574"; font.family: "Segoe UI"; font.pixelSize: 10; wrapMode: Text.WordWrap }
                }
            }
        }
 }
}
