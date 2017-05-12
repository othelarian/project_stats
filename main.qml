import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.1
import QtQuick.Dialogs 1.2
import QtQuick.LocalStorage 2.0

import PStypes 1.0

import "stats.js" as Stats

Window {
    id: mainwin
    visible: true
    width: 640
    height: 480
    minimumWidth: 640
    minimumHeight: 480
    title: "Project Stats"
    property var localdb
    property bool onrun: false
    property color btnscol: "#0088ff"
    Component.onCompleted: Stats.initSettings()
    Shortcut {
        sequence: StandardKey.Open
        enabled: !mainwin.onrun
        onActivated: selectDialog.open()
    }
    Shortcut {
        sequence: "Ctrl+R"
        enabled: (!mainwin.onrun && repos.count > 0)? true : false
        onActivated: Stats.run("all")
    }
    Shortcut {
        sequence: "Ctrl+Shift+R"
        enabled: (!mainwin.onrun && repos.count > 0)? true : false
        onActivated: Stats.run(repoListView.currentIndex)
    }
    Shortcut {
        sequence: StandardKey.Close
        enabled: (repoListView.currentIndex > -1)? true : false
        onActivated: Stats.remRepo(repoListView.currentIndex)
    }
    Shortcut {
        sequence: "Ctrl+?"
        onActivated: helpwin.show()
    }
    ListView {
        id: repoListView
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: actionsZone.top
        anchors.margins: 0
        model: repos.list
        width: 240
        delegate: Item {
            height: 30
            width: repoListView.width
            clip: true
            property bool hover: false
            Rectangle {
                id: repoBack
                anchors.fill: parent
                color: (repoListView.currentIndex == index)? "#0088ff" : (parent.hover ? "#77ccff" : "white")
            }
            Rectangle {
                visible: running
                id: genIndicator
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 5
                width: 22; height: 22; radius: 11
                border.color: "white"
                border.width: 1
                color: "#77ccff"
                RotationAnimator {
                    target: genIndicator
                    loops: Animation.Infinite
                    from: 0; to: 360; duration: 1000; running: repos.list[index].running
                }
                Text {
                    text: "\u21bb"
                    color: "white"
                    font.pointSize: 18
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            Label {
                anchors.left: parent.left
                anchors.leftMargin: (running)? 30 : 10
                anchors.verticalCenter: parent.verticalCenter
                color: (repoListView.currentIndex == index)? "white" : "black"
                text: name
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.hover = true
                onExited: parent.hover = false
                onClicked: repoListView.currentIndex = index
            }
            CustomButton {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 32
                width: 22; height: 22
                text: "\u2192"
                hoverEnabled: true
                reversed: (repoListView.currentIndex == index)? true : false
                enabled: !mainwin.onrun
                onHoveredChanged: parent.hover = hovered
                onClicked: Stats.run(index)
            }
            CustomButton {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 5
                width: 22; height: 22
                text: "\u2716"
                hoverEnabled: true
                reversed: (repoListView.currentIndex == index)? true : false
                enabled: !mainwin.onrun
                onHoveredChanged: parent.hover = hovered
                onClicked: Stats.remRepo(index)
            }
        }
    }
    Rectangle {
        id: actionsZone
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: repoListView.width
        height: 40
        color: "white"
        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 0
            height: 1
            color: "black"
        }
        Row {
            anchors.centerIn: parent
            spacing: 20
            CustomButton {
                width: 30; height: 30
                enabled: !mainwin.onrun
                text: "+"
                onClicked: selectDialog.open()
            }
            CustomButton {
                width: 30; height: 30
                enabled: (mainwin.onrun || repos.count == 0)? false : true
                text: "\u21c9"
                onClicked: Stats.run("all")
            }
            CustomButton {
                width: 30; height: 30
                text: "?"
                onClicked: helpwin.show()
            }
        }
    }
    Rectangle {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: repoListView.right
        anchors.margins: 0
        color: "white"
        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 0
            width: 1
            color: "black"
        }
        Label {
            visible: repos.count == 0 ? true : false
            anchors.centerIn: parent
            font.pointSize: 20
            text: "No project available"
        }
        Label {
            visible: repos.count == 0 ? false : true
            //
            // TODO : title of the project
            //
        }
        Label {
            visible: repos.count == 0 ? false : true
            //
            // TODO : path of the project
            //
        }
        ListView {
            //
            visible: repos.count == 0 ? false : true
            //
            model: ListModel {
                //
            }
            delegate: Item {
                //
            }
        }
        StackView {
            visible: repos.count == 0 ? false : true
            //
            //
        }
    }
    FileDialog {
        id: selectDialog
        title: "Choose the project:"
        visible: false
        selectMultiple: false
        selectExisting: true
        selectFolder: false
        folder: shortcuts.home
        nameFilters: ["Project file (*.pro)"]
        onAccepted: Stats.addRepo(selectDialog.fileUrl)
    }
    Dialog {
        id: existDialog
        visible: false
        title: "Project already listed!"
        standardButtons: Dialog.Ok
        Label {
            text: "This project is already listed!"
            anchors.centerIn: parent
        }
    }
    Window {
        id: helpwin
        visible: false
        modality: Qt.ApplicationModal
        width: 600
        height: 500
        minimumWidth: helpwin.width
        maximumWidth: helpwin.width
        minimumHeight: helpwin.height
        maximumHeight: helpwin.height
        Label {
            id: helpTitle
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 20
            font.bold: true
            text: "Help window"
        }
        ListView {
            id: helpListView
            anchors.top: helpTitle.bottom
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.margins: 20
            width: 120
            clip: true
            interactive: false
            model: ListModel {
                ListElement { title: "Shortcuts" }
                ListElement { title: "Bar" }
                ListElement { title: "Side List" }
                //ListElement { title: "Infos" }
            }
            delegate: Item {
                width: helpListView.width
                height: 30
                property bool hover: false
                Rectangle {
                    anchors.fill: parent
                    color: (helpListView.currentIndex == index)? "#0088ff" : (parent.hover ? "#77ccff" : "white")
                }
                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    color: (helpListView.currentIndex == index)? "white" : "black"
                    text: title
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: parent.hover = true
                    onExited: parent.hover = false
                    onClicked: {
                        helpListView.currentIndex = index
                        var item
                        switch (title) {
                        case "Shortcuts": item = shortcutsHelp; break
                        case "Bar": item = barHelp; break
                        case "Side List": item = listHelp; break
                        case "Infos": item = infosHelp; break
                        }
                        helpStack.replace(item)
                    }
                }
            }
        }
        StackView {
            id: helpStack
            anchors.top: helpTitle.bottom
            anchors.bottom: parent.bottom
            anchors.left: helpListView.right
            anchors.right: parent.right
            anchors.margins: 20
            initialItem: shortcutsHelp
            Transition {
                id: enterAnim
                YAnimator { from: helpStack.height; to: 0; duration: 300; easing.type: Easing.OutCubic }
            }
            Transition {
                id: exitAnim
                YAnimator { from: 0; to: helpStack.height; duration: 300; easing.type: Easing.OutCubic }
            }
            replaceEnter: enterAnim; replaceExit: exitAnim
            Item {
                id: shortcutsHelp
                visible: false
                Label {
                    id: shortcutsHelpTitle
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.margins: 10
                    font.bold: true
                    text: "Shortcuts:"
                }
                ListView {
                    id: shortcutsHelpList
                    anchors.top: shortcutsHelpTitle.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.margins: 10
                    clip: true
                    interactive: false
                    model: ListModel {
                        ListElement { desc: "Add a project:"; cmd: "Ctrl+O" }
                        ListElement { desc: "Run the generation for all projects:"; cmd: "Ctrl+R" }
                        ListElement { desc: "Run the generation for the selected project:"; cmd: "Ctrl+Shift+R" }
                        ListElement { desc: "Remove the selected project from the list:"; cmd: "Ctrl+W" }
                        ListElement { desc: "Show the help:"; cmd: "Ctrl+?" }
                    }
                    delegate: Item {
                        width: shortcutsHelpList.width
                        height: 25
                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.margins: 10
                            text: desc
                        }
                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            anchors.margins: 10
                            horizontalAlignment: Text.AlignRight
                            text: cmd
                        }
                    }
                }
            }
            Item {
                id: barHelp
                visible: false
                Label {
                    id: barHelpTitle
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.margins: 10
                    font.bold: true
                    text: "Bar:"
                }
                Row {
                    anchors.top: barHelpTitle.bottom
                    anchors.topMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 15
                    Column {
                        spacing: 10
                        width: 100
                        Rectangle {
                            width: 30; height: 30; radius: 15
                            color: "#0088ff"
                            anchors.horizontalCenter: parent.horizontalCenter
                            Text {
                                color: "white"
                                font.pointSize: 18
                                text: "+"
                                anchors.centerIn: parent
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                        Label {
                            text: "Add a\nproject"
                            horizontalAlignment: Text.AlignHCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                    Column {
                        spacing: 10
                        width: 100
                        Rectangle {
                            width: 30; height: 30; radius: 15
                            color: "#0088ff"
                            anchors.horizontalCenter: parent.horizontalCenter
                            Text {
                                color: "white"
                                font.pointSize: 18
                                text: "\u21c9 "//"\u21db"
                                anchors.centerIn: parent
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                        Label {
                            text: "Run for all\nproject"
                            horizontalAlignment: Text.AlignHCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                    Column {
                        spacing: 10
                        width: 100
                        Rectangle {
                            width: 30; height: 30; radius: 15
                            color: "#0088ff"
                            anchors.horizontalCenter: parent.horizontalCenter
                            Text {
                                color: "white"
                                font.pointSize: 18
                                text: "?"
                                anchors.centerIn: parent
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                        Label {
                            text: "Show help"
                            horizontalAlignment: Text.AlignHCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }
            Item {
                id: listHelp
                visible: false
                Label {
                    id: listHelpTitle
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.margins: 10
                    font.bold: true
                    text: "List:"
                }
                Column {
                    spacing: 10
                    Row {
                        spacing: 10
                        height: 30
                        Rectangle {
                            width: 180; height: 30
                            color: "#0088ff"
                            Rectangle {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 5
                                width: 22; height: 22; radius: 11
                                border.color: "white"
                                border.width: 1
                                color: "#77ccff"
                                Text {
                                    text: "\u21bb"
                                    color: "white"
                                    font.pointSize: 18
                                    anchors.centerIn: parent
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }
                            Label {
                                anchors.left: parent.left
                                anchors.leftMargin: 30
                                anchors.verticalCenter: parent.verticalCenter
                                color: "white"
                                text: "Project Stats"
                            }
                            Rectangle {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right
                                anchors.rightMargin: 32
                                width: 22; height: 22; radius: 11
                                color: "white"
                                border.color: "white"
                                border.width: 1
                                Text {
                                    color: "black"
                                    font.pointSize: 18
                                    anchors.centerIn: parent
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    text: "\u2192"
                                }
                            }
                            Rectangle {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right
                                anchors.rightMargin: 5
                                width: 22; height: 22; radius: 11
                                color: "white"
                                border.color: "white"
                                border.width: 1
                                Text {
                                    color: "black"
                                    font.pointSize: 18
                                    anchors.centerIn: parent
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    text: "\u2716"
                                }
                            }
                        }
                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Selected project"
                        }
                    }
                    Row {
                        spacing: 10
                        height: 30
                        Rectangle {
                            width: 180; height: 30
                            color: "white"
                            Label {
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                                anchors.verticalCenter: parent.verticalCenter
                                color: "black"
                                text: "Project Stats"
                            }
                            Rectangle {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right
                                anchors.rightMargin: 32
                                width: 22; height: 22; radius: 11
                                color: "#0088ff"
                                border.color: "white"
                                border.width: 1
                                Text {
                                    color: "white"
                                    font.pointSize: 18
                                    anchors.centerIn: parent
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    text: "\u2192"
                                }
                            }
                            Rectangle {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right
                                anchors.rightMargin: 5
                                width: 22; height: 22; radius: 11
                                color: "#0088ff"
                                border.color: "white"
                                border.width: 1
                                Text {
                                    color: "white"
                                    font.pointSize: 18
                                    anchors.centerIn: parent
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    text: "\u2716"
                                }
                            }
                        }
                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Unselected project"
                        }
                    }
                    Row {
                        height: 30
                        Rectangle { color: "white"; height: 30; width: 100 }
                    }
                    Row {
                        spacing: 10
                        height: 30
                        Rectangle {
                            anchors.verticalCenter: parent.verticalCenter
                            width: 22; height: 22; radius: 11
                            border.color: "white"
                            border.width: 1
                            color: "#77ccff"
                            Text {
                                text: "\u21bb"
                                color: "white"
                                font.pointSize: 18
                                anchors.centerIn: parent
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Generation in progress indicator"
                        }
                    }
                    Row {
                        spacing: 10
                        height: 30
                        Rectangle {
                            anchors.verticalCenter: parent.verticalCenter
                            width: 22; height: 22; radius: 11
                            color: "#0088ff"
                            border.color: "white"
                            border.width: 1
                            Text {
                                color: "white"
                                font.pointSize: 18
                                anchors.centerIn: parent
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                text: "\u2192"
                            }
                        }
                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Run the generation for the project"
                        }
                    }
                    Row {
                        spacing: 10
                        height: 30
                        Rectangle {
                            anchors.verticalCenter: parent.verticalCenter
                            width: 22; height: 22; radius: 11
                            color: "#0088ff"
                            border.color: "white"
                            border.width: 1
                            Text {
                                color: "white"
                                font.pointSize: 18
                                anchors.centerIn: parent
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                text: "\u2716"
                            }
                        }
                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Remove the project from the list"
                        }
                    }
                }
            }
            Item {
                id: infosHelp
                visible: false
                Label {
                    id: infosHelpTitle
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.margins: 10
                    font.bold: true
                    text: "Infos:"
                }
                //
                //
            }
        }
    }
}
