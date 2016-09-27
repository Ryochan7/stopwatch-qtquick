import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import SortFilterProxyModel 0.1

ApplicationWindow {
    id: applicationWindow1
    visible: true
    width: 640
    height: 480
    title: qsTr("Test Stopwatch")

    property date passedTime: new Date()
    property int passedMs: 0

    function pad(num, len) {
        var result = num.toString()
        while (result.length < len) {
            result = "0" + result;
        }

        return result;
    }

    function timeItemFormat(num) {
        var result = ""
        if (num < testModel.timeLimt)
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
        font.pointSize: 28
        anchors.top: parent.top
        anchors.topMargin: 40
        anchors.horizontalCenter: parent.horizontalCenter
    }

    ListView {
        id: lapTimeView
        model: filteredLapModel

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 50
        anchors.rightMargin: 50

        anchors.top: label1.bottom
        anchors.topMargin: 20
        anchors.bottom: controlSwitcherView.top

        delegate: Row {
            spacing: 50

            Label {
                id: indexLabel
                text: (lapIndex + 1) + " "
                font.bold: true
                width: 50
            }

            Label {
                id: timeLabel
                text: timeItemFormat(lapTime)
            }

            Label {
                id: diffTimeLabel
                text: timeItemFormat(diffTime)
                font.pointSize: 12
            }
        }
    }

    SortFilterProxyModel {
        id: filteredLapModel
        sourceModel: testModel
        sortOrder: Qt.DescendingOrder
        sortRoleName: "lapTime"
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

    // Using a StackView for non-page component switching would not work well
    // on Android. Replace with ListView and ObjectModel later?
    StackView {
        id: controlSwitcherView
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.topMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        height: 60

        initialItem: startButtons

        // Disable transition.
        delegate: StackViewDelegate {
        }

        Component {
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
                        controlSwitcherView.replace(runningButtons)

                        refreshTimer.start()
                        lapTimeView.visible = true
                    }
                }
            }
        }

        Component {
            id: runningButtons

            RowLayout {
                Button {
                    id: stopButton
                    Layout.fillWidth: true
                    text: qsTr("Stop")

                    onClicked: {
                        refreshTimer.stop();
                        controlSwitcherView.replace(stoppedButtons)
                    }
                }

                Button {
                    id: lapButton
                    Layout.fillWidth: true
                    text: qsTr("Lap")

                    onClicked: {
                        var currentTime = new Date();
                        passedMs += new Date() - passedTime;
                        if (passedMs > testModel.timeLimt)
                        {
                            passedMs = testModel.timeLimt;
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

        Component {
            id: stoppedButtons

            RowLayout {
                Button {
                    id: restartButton
                    Layout.fillWidth: true
                    text: qsTr("Restart")

                    onClicked: {
                        passedTime = new Date();
                        controlSwitcherView.replace(runningButtons);
                        refreshTimer.restart();
                    }
                }

                Button {
                    id: reset1Button
                    Layout.fillWidth: true
                    text: qsTr("Reset")

                    onClicked: {
                        label1.text = qsTr("00:00:00");
                        passedMs = 0;
                        passedTime = new Date();
                        refreshTimer.stop();
                        lapTimeView.visible = false;
                        testModel.clear();
                        controlSwitcherView.replace(startButtons);
                    }
                }
            }
        }
    }
}

