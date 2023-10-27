// Copyright (C) 2017 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Imagine
import QtQuick.Window

ApplicationWindow {
    id: window
    width: 1280
    height: 720
    minimumWidth: 1180
    minimumHeight: 663
    visible: true
    title: "DeadOp's Control Center"

    readonly property color colorGlow: "#1d6d64"
    readonly property color colorWarning: "#d5232f"
    readonly property color colorMain: "#6affcd"
    readonly property color colorBright: "#ffffff"
    readonly property color colorLightGrey: "#888"
    readonly property color colorDarkGrey: "#333"

    readonly property int fontSizeExtraSmall: Qt.application.font.pixelSize * 0.8
    readonly property int fontSizeMedium: Qt.application.font.pixelSize * 1.5
    readonly property int fontSizeLarge: Qt.application.font.pixelSize * 2
    readonly property int fontSizeExtraLarge: Qt.application.font.pixelSize * 5

    Component.onCompleted: {
        x = Screen.width / 2 - width / 2
        y = Screen.height / 2 - height / 2
    }

    Shortcut {
        sequence: "Ctrl+Q"
        onActivated: Qt.quit()
    }

    Frame {
        id: frame
        anchors.fill: parent
        anchors.margins: 90

        RowLayout {
            id: mainRowLayout
            anchors.fill: parent
            anchors.margins: 24
            spacing: 36

            Container {
                id: leftTabBar

                currentIndex: 1

                Layout.fillWidth: false
                Layout.fillHeight: true

                ButtonGroup {
                    buttons: columnLayout.children
                }

                contentItem: ColumnLayout {
                    id: columnLayout
                    spacing: 3

                    Repeater {
                        model: leftTabBar.contentModel
                    }
                }

                FeatureButton {
                    id: navigationFeatureButton
                    text: qsTr("Video Feed")
                    icon.name: "navigation"
                    Layout.fillHeight: true
                }

                FeatureButton {
                    text: qsTr("Flight Control")
                    icon.name: "air-con"
                    onClicked: telloController.performDroneMovements()
                    Layout.fillHeight: true
                }



                FeatureButton {
                    text: qsTr("Connection Status")
                    icon.name: "command"
                    Layout.fillHeight: true



                }

                FeatureButton {
                    text: qsTr("Exit")
                    icon.name: "settings"
                    Layout.fillHeight: true
                }
            }

            StackLayout {
                currentIndex: leftTabBar.currentIndex

                Layout.preferredWidth: 150
                Layout.maximumWidth: 150
                Layout.fillWidth: false

                Item {}

                ColumnLayout {
                    spacing: 12

                    ButtonGroup {
                        id: viewButtonGroup
                        buttons: viewTypeRowLayout.children
                    }

                    RowLayout {
                        id: viewTypeRowLayout
                        spacing: 3

                        Layout.bottomMargin: 12

                        Button {
                            text: qsTr("Land")
                            font.pixelSize: fontSizeExtraSmall
                            checkable: true
                            checked: true

                            Layout.fillWidth: true
                        }
                        Button {
                            text: qsTr("TakeOff")
                            font.pixelSize: fontSizeExtraSmall
                            checkable: true

                            Layout.fillWidth: true
                        }
                    }

                    LargeLabel {
                        text: qsTr("DeadOp Battery %")
                        color: "white"
                        font.pixelSize: fontSizeMedium
                    }

                    Dial {
                        id: volumeDial
                        from: 0
                        value: 42
                        to: 100
                        stepSize: 1

                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredWidth: 128
                        Layout.preferredHeight: 128

                        Label {
                            text: volumeDial.value.toFixed(0)
                            color: "white"
                            font.pixelSize: Qt.application.font.pixelSize * 3
                            anchors.centerIn: parent
                        }
                    }

                    ButtonGroup {
                        id: audioSourceButtonGroup
                    }

                    RowLayout {
                        Layout.topMargin: 8

                        LargeLabel {
                            id: radioOption
                            text: qsTr("Drone Speed Presets")
                            color: "white"
                            font.pixelSize: fontSizeSmall
                            horizontalAlignment: Label.AlignLeft

                            Layout.fillWidth: true
                        }
                        LargeLabel {
                            text: qsTr("MPH")
                            color: colorLightGrey
                            font.pixelSize: fontSizeExtraMedium * 0.8
                            horizontalAlignment: Label.AlignHCenter
                            glowEnabled: false

                            Layout.alignment: Qt.AlignBottom
                            Layout.fillWidth: true
                        }

                    }

                    Frame {
                        id: stationFrame
                        leftPadding: 1
                        rightPadding: 1
                        topPadding: 1
                        bottomPadding: 1

                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.preferredHeight: 128

                        ListView {
                            id: stationListView
                            clip: true
                            anchors.fill: parent

                            ScrollIndicator.vertical: ScrollIndicator {
                                parent: stationFrame
                                anchors.top: parent.top
                                anchors.right: parent.right
                                anchors.rightMargin: 1
                                anchors.bottom: parent.bottom
                            }

                            model: ListModel {
                                ListElement { name: "Eco-Mode"; frequency: "3.3" }
                                ListElement { name: "Surveillance"; frequency: "5.8" }
                                ListElement { name: "Race"; frequency: "45.0" }
                                ListElement { name: "Target Cascade"; frequency: "29.9" }
                                ListElement { name: "Normal"; frequency: "10.8" }
                                ListElement { name: "Drive-by"; frequency: "99.1" }

                            }
                            delegate: ItemDelegate {
                                id: stationDelegate
                                width: stationListView.width
                                height: 22
                                text: model.name
                                font.pixelSize: fontSizeExtraSmall
                                topPadding: 0
                                bottomPadding: 0

                                contentItem: RowLayout {
                                    Label {
                                        text: model.name
                                        font: stationDelegate.font
                                        horizontalAlignment: Text.AlignLeft
                                        elide: Text.ElideRight

                                        Layout.fillWidth: true
                                    }
                                    Label {
                                        text: model.frequency
                                        font: stationDelegate.font
                                        horizontalAlignment: Text.AlignRight
                                        elide: Text.ElideRight

                                        Layout.fillWidth: true
                                    }
                                }
                            }
                        }
                    }

                    Frame {
                        Layout.fillWidth: true

                        ColumnLayout {
                            anchors.fill: parent

                            Label {
                                text: qsTr("Sort by")
                                font.pixelSize: fontSizeExtraSmall
                            }

                            ColumnLayout {
                                RadioButton {
                                    text: qsTr("Cascades")
                                    font.pixelSize: fontSizeExtraSmall
                                }
                                RadioButton {
                                    text: qsTr("Test Flight")
                                    font.pixelSize: fontSizeExtraSmall
                                }
                                RadioButton {
                                    text: qsTr("Users")
                                    font.pixelSize: fontSizeExtraSmall
                                    checked: true
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                color: colorMain
                implicitWidth: 1
                Layout.fillHeight: true
            }

            ColumnLayout {
                Layout.preferredWidth: 350
                Layout.fillWidth: true
                Layout.fillHeight: true

                LargeLabel {
                    id: timeLabel
                    text: qsTr("12:48")
                    font.pixelSize: fontSizeExtraLarge

                    Layout.alignment: Qt.AlignHCenter

                    LargeLabel {
                        text: qsTr("PM")
                        font.pixelSize: fontSizeLarge
                        anchors.left: parent.right
                        anchors.leftMargin: 4
                    }
                }

                Label {
                    text: qsTr("10/27/2023")
                    color: colorLightGrey
                    font.pixelSize: fontSizeMedium

                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 2
                    Layout.bottomMargin: 10
                }

                Image {
                    source: "qrc:/icons/dji.png"
                    fillMode: Image.PreserveAspectFit
                    Layout.topMargin: 20
                    Layout.bottomMargin: 100


                    Column {
                        x: parent.width * 0.88
                        y: parent.height * 0.56
                        spacing: 3

                        Image {
                            source: "qrc:/icons/warning.png"
                            anchors.horizontalCenter: parent.right

                        }

                        LargeLabel {
                            text: qsTr("Battery Low")
                            font.pixelSize: fontSizeExtraSmall
                            color: colorWarning
                            anchors.left: parent.left
                             anchors.leftMargin: 25

                                                  }
                    }
                }
            }

            Rectangle {
                color: colorMain
                implicitWidth: 1
                Layout.fillHeight: true
            }

            ColumnLayout {
                Row {
                    spacing: 8

                    Image {
                        source: "qrc:/icons/weather.png"
                    }

                    Column {
                        spacing: 8

                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter

                            LargeLabel {
                                id: outsideTempValueLabel
                                text: qsTr("71")
                                font.pixelSize: fontSizeExtraLarge
                            }

                            LargeLabel {
                                text: qsTr("°C")
                                font.pixelSize: Qt.application.font.pixelSize * 2.5
                                anchors.baseline: outsideTempValueLabel.baseline
                            }
                        }

                        Label {
                            text: qsTr("Woodland Hills, California")
                            color: colorLightGrey
                            font.pixelSize: fontSizeMedium
                        }
                    }
                }

                ColumnLayout {
                    id: airConRowLayout
                    spacing: 8

                    Layout.preferredWidth: 128
                    Layout.preferredHeight: 380
                    Layout.fillHeight: true

                    Item {
                        Layout.fillHeight: true
                    }
/*
                    SwitchDelegate {
                        text: qsTr("AC")
                        leftPadding: 0
                        rightPadding: 0
                        topPadding: 0
                        bottomPadding: 0

                        Layout.fillWidth: true
                    }

                    // QTBUG-63269
                    Item {
                        implicitHeight: temperatureValueLabel.implicitHeight
                        Layout.fillWidth: true
                        Layout.topMargin: 16

                        Label {
                            text: qsTr("Temperature")
                            anchors.baseline: temperatureValueLabel.bottom
                            anchors.left: parent.left
                        }

                        LargeLabel {
                            id: temperatureValueLabel
                            text: qsTr("24°C")
                            font.pixelSize: fontSizeLarge
                            anchors.right: parent.right
                        }
                    }

                    Slider {
                        value: 0.35
                        Layout.fillWidth: true
                    }

                    // QTBUG-63269
                    Item {
                        implicitHeight: powerValueLabel.implicitHeight
                        Layout.fillWidth: true
                        Layout.topMargin: 16

                        Label {
                            text: qsTr("Power")
                            anchors.baseline: powerValueLabel.bottom
                            anchors.left: parent.left
                        }

                        LargeLabel {
                            id: powerValueLabel
                            text: qsTr("10%")
                            font.pixelSize: fontSizeLarge
                            anchors.right: parent.right
                        }
                    }

                    Slider {
                        value: 0.25
                        Layout.fillWidth: true
                    }

                    SwitchDelegate {
                        text: qsTr("Low")
                        leftPadding: 0
                        rightPadding: 0
                        topPadding: 0
                        bottomPadding: 0

                        Layout.fillWidth: true
                        Layout.topMargin: 16
                    }

                    SwitchDelegate {
                        text: qsTr("High")
                        checked: true
                        leftPadding: 0
                        rightPadding: 0
                        topPadding: 0
                        bottomPadding: 0

                        Layout.fillWidth: true
                    }

                    SwitchDelegate {
                        text: qsTr("Defog")
                        leftPadding: 0
                        rightPadding: 0
                        topPadding: 0
                        bottomPadding: 0

                        Layout.fillWidth: true
                    }

                    SwitchDelegate {
                        text: qsTr("Recirculate")
                        leftPadding: 0
                        rightPadding: 0
                        topPadding: 0
                        bottomPadding: 0

                        Layout.fillWidth: true
                    }
*/
                    Item {
                        Layout.fillHeight: true
                    }
                }
            }

            Container {
                id: rightTabBar

                currentIndex: 1

                Layout.fillHeight: true

                ButtonGroup {
                    buttons: rightTabBarContentLayout.children
                }

                contentItem: ColumnLayout {
                    id: rightTabBarContentLayout
                    spacing: 3

                    Repeater {
                        model: rightTabBar.contentModel
                    }
                }

                Item {
                    Layout.fillHeight: true
                }

              /*  FeatureButton {
                    text: qsTr("Windows")
                    icon.name: "windows"

                    Layout.maximumHeight: navigationFeatureButton.height
                    Layout.fillHeight: true
                }
                FeatureButton {
                    text: qsTr("Air Con.")
                    icon.name: "air-con"
                    checked: true

                    Layout.maximumHeight: navigationFeatureButton.height
                    Layout.fillHeight: true
                }
                FeatureButton {
                    text: qsTr("Seats")
                    icon.name: "seats"

                    Layout.maximumHeight: navigationFeatureButton.height
                    Layout.fillHeight: true
                }
                FeatureButton {
                    text: qsTr("Statistics")
                    icon.name: "statistics"

                    Layout.maximumHeight: navigationFeatureButton.height
                    Layout.fillHeight: true
                } */
            }
        }
    }
}
