import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

Rectangle {
    id: leftNavigation
    property var app: null
    Layout.preferredWidth: 66; Layout.fillHeight: true; color: "#eceeef"
    Column { anchors.top: parent.top; anchors.topMargin: 17; spacing: 6
        NavIcon { app: leftNavigation.app
            iconSource: "icons/testing.svg"
            menu: "testing"
        }

        NavIcon { app: leftNavigation.app
            iconSource: "icons/users.svg"
            menu: "users"
        }

        NavIcon { app: leftNavigation.app
            iconSource: "icons/tasks.svg"
            menu: "tasks"
        }

        NavIcon { app: leftNavigation.app
            iconSource: "icons/documents.svg"
            menu: "documents"
        }

        NavIcon { app: leftNavigation.app
            iconSource: "icons/upload.svg"
            menu: "upload"
        }

        NavIcon { app: leftNavigation.app
            iconSource: "icons/messages.svg"
            menu: "messages"
        }
    }
    Image {
        id: sidebarToggleIcon

        width: 17
        height: 17
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 20
        source: "icons/sidebar-toggle.svg"
        fillMode: Image.PreserveAspectFit
        smooth: true
        sourceSize.width: 20
        sourceSize.height: 20
    }
}
