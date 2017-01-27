import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.3
import SortFilterProxyModel 0.1

ApplicationWindow {
    id: applicationWindow1
    visible: true
    width: 640
    height: 480
    title: qsTr("Test Stopwatch")

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
        if (num < testModel.timeLimit)
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


    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            /*MenuItem {
                text: qsTr("&Open")
                onTriggered: console.log("Open action triggered");
            }
            */

            MenuItem {
                text: qsTr("Exit")
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

    ScrollView {
        anchors.top: label1.bottom
        anchors.topMargin: 20
        anchors.bottom: controlSwitcherView.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 50
        anchors.rightMargin: 50

        ListView {
            id: lapTimeView
            model: filteredLapModel
            anchors.fill: parent

            delegate: Row {
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
    }



    SortFilterProxyModel {
        id: filteredLapModel
        sourceModel: testModel
        sortRoleName: "lapTime"
        sortOrder: Qt.DescendingOrder
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
                        if (passedMs > testModel.timeLimit)
                        {
                            passedMs = testModel.timeLimit;
                        }

                        passedTime = new Date();
                        refreshTimer.restart();

                        if (testModel.canAddLapItem(passedMs))
                        {
                            testModel.addLapItem(passedMs);
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
                        testModel.clear();
                        controlSwitcherView.currentIndex =
                                controlSwitcherView.componentIndexMap["startButtons"];
                    }
                }
            }
        }
    }
}

