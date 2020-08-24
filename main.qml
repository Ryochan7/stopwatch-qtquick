import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import SortFilterProxyModel 0.2

import com.ryochan7.projectqmlcomponents 1.0

ApplicationWindow {
    id: applicationWindow1
    visible: true
    width: 640
    height: 480
    title: qsTr("Test Stopwatch")

    StopWatchBackend
    {
        id: watchBackend;
        property alias backendListModel: watchBackend.lapListModel
    }

    property date passedTime: new Date()
    property int passedMs: 0
    property real fontSizeMulti: Qt.platform.os !== "android" ? 1.0 : 1.33

    function pad(num, len) {
        var result = num.toString()
        while (result.length < len) {
            result = "0" + result;
        }

        return result;
    }

    function timeItemFormat(num) {
        var result = ""
        if (num < watchBackend.backendListModel.timeLimit)
        {
            var milliseconds = Math.floor(num % 1000)
            var seconds = Math.floor(num / 1000 % 60)
            var minutes = Math.floor(num / 1000 / 60);
            result = pad(minutes, 2) + ":" + pad(seconds, 2) + ":" + pad(milliseconds, 3)
        }
        else
        {
            result = "99:59:999"
        }

        return result
    }


    header: ToolBar {
        ToolButton {
            text: "..."
            font.pointSize: 14 * fontSizeMulti
            font.bold: true
            anchors.right: parent.right
            rotation: 90.0;

            onClicked: {
                optionsMenu.open();
            }
        }

        Menu {
            id: optionsMenu
            transformOrigin: Menu.TopRight
            x: parent.width - width

            MenuItem {
                font.pointSize: 14 * fontSizeMulti
                text: "Exit"
                onTriggered: Qt.quit();
            }
        }
    }

    Label {
        id: label1
        text: qsTr("00:00:00")
        font.pointSize: parseInt(28 * fontSizeMulti)
        anchors.top: parent.top
        anchors.topMargin: 40
        anchors.horizontalCenter: parent.horizontalCenter
    }


    ListView {
        id: lapTimeView
        model: filteredLapModel
        anchors.top: label1.bottom
        anchors.topMargin: 40
        anchors.bottom: controlSwitcherView.top
        anchors.bottomMargin: 40
        anchors.left: parent.left
        anchors.right: parent.right

        anchors
        {
            leftMargin: 100
            rightMargin: 100
        }

        delegate: Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 50

            Label {
                id: indexLabel
                text: (lapIndex + 1) + " "
                font.bold: true
                font.pointSize: parseInt(14 * fontSizeMulti)
                width: 50
            }

            Label {
                id: timeLabel
                text: timeItemFormat(lapTime)
                font.pointSize: parseInt(14 * fontSizeMulti)
            }

            Label {
                id: diffTimeLabel
                text: timeItemFormat(diffTime)
                font.pointSize: parseInt(16 * fontSizeMulti)
            }
        }
    }


    SortFilterProxyModel {
        id: filteredLapModel
        sourceModel: watchBackend.backendListModel
        //sortRoleName: "lapTime"
        sorters: RoleSorter {
            roleName: "lapTime"
            sortOrder: Qt.DescendingOrder
        }
        //sortOrder: Qt.DescendingOrder
    }

    Timer {
        id: refreshTimer
        interval: 50
        repeat: true

        onTriggered: {
            passedMs += new Date() - passedTime;
            passedTime = new Date();

            var elapsedTimeMs = passedMs;
            label1.text = timeItemFormat(elapsedTimeMs);
        }
    }

    StackLayout {
        id: controlSwitcherView
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.topMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Qt.platform.os !== "android" ? 20 : 60
        height: 60
        currentIndex: 0

        property var componentIndexMap: {
            "startButtons": 0,
            "runningButtons": 1,
            "stoppedButtons": 2,
        }

        Item {
            id: startButtons

            RowLayout {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                Button {
                    id: startButton
                    Layout.fillWidth: true

                    text: qsTr("Start")

                    onClicked: {
                        //console.log("Start Called")
                        passedTime = new Date();
                        passedMs = 0;
                        controlSwitcherView.currentIndex =
                                controlSwitcherView.componentIndexMap["runningButtons"];

                        refreshTimer.start()
                        lapTimeView.visible = true
                    }
                }
            }
        }

        Item {
            id: runningButtons

            RowLayout {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                Button {
                    id: stopButton
                    Layout.fillWidth: true
                    text: qsTr("&Stop")

                    onClicked: {
                        refreshTimer.stop();
                        controlSwitcherView.currentIndex =
                                controlSwitcherView.componentIndexMap["stoppedButtons"];
                    }
                }

                Button {
                    id: lapButton
                    Layout.fillWidth: true
                    text: qsTr("&Lap")

                    onClicked: {
                        var currentTime = new Date();
                        passedMs += new Date() - passedTime;
                        if (passedMs > watchBackend.backendListModel.timeLimit)
                        {
                            passedMs = watchBackend.backendListModel.timeLimit;
                        }

                        passedTime = new Date();
                        refreshTimer.restart();

                        if (watchBackend.backendListModel.canAddLapItem(passedMs))
                        {
                            watchBackend.backendListModel.addLapItem(passedMs);
                        }
                    }
                }
            }
        }

        Item {
            id: stoppedButtons

            RowLayout {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                Button {
                    id: restartButton
                    Layout.fillWidth: true
                    text: qsTr("&Restart")

                    onClicked: {
                        passedTime = new Date();
                        controlSwitcherView.currentIndex =
                                controlSwitcherView.componentIndexMap["runningButtons"];
                        refreshTimer.restart();
                    }
                }

                Button {
                    id: reset1Button
                    Layout.fillWidth: true
                    text: qsTr("Re&set")

                    onClicked: {
                        label1.text = qsTr("00:00:00");
                        passedMs = 0;
                        passedTime = new Date();
                        refreshTimer.stop();
                        lapTimeView.visible = false;
                        watchBackend.backendListModel.clear();
                        controlSwitcherView.currentIndex =
                                controlSwitcherView.componentIndexMap["startButtons"];
                    }
                }
            }
        }
    }
}

