import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Window {
    id: window
    property bool isFloatNumber: false
    property bool isClosedBracket: false
    property bool isBracket: false

    width: 360
    height: 640
    //minimumWidth: width; maximumWidth: width
    //minimumHeight: height; maximumHeight: height
    visible: true
    title: qsTr("Калькулятор")
    color: "#024873"


    Rectangle {
        id: mainLabel
        width: 360
        height: 156
        color: "#04BFAD"
        radius: 24
        antialiasing: true
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        Rectangle {
            width: parent.width
            height: parent.radius
            color: parent.color
            anchors.top: parent.top
        }

        Label {
            id: output
            width: 280
            anchors.bottom: input.top
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.rightMargin: 41
            anchors.leftMargin: 39
            anchors.bottomMargin: 8

            text: ""
            lineHeight: 30
            lineHeightMode: Text.FixedHeight
            font.pixelSize: 20
            font.family: "Open Sans"
            font.weight: Font.SemiBold
            font.letterSpacing: 0.5
            color: "#FFFFFF"
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
        }

        TextField {
            id: input
            background: null
            readOnly: true
            selectByMouse: false
            activeFocusOnTab: false
            focus: false
            cursorVisible: false
            onCursorPositionChanged: cursorPosition = text.length

            width: 281
            height: 60
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.rightMargin: 40
            anchors.leftMargin: 39
            anchors.bottomMargin: 14

            maximumLength: 25

            padding: 0
            topPadding: 0
            bottomPadding: 0
            leftPadding: 0
            rightPadding: 0

            text: "0"
            font.pixelSize: 50
            font.family: "Open Sans"
            font.weight: Font.SemiBold
            font.letterSpacing: 0.5
            color: "#FFFFFF"
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
        }
    }

    GridLayout {
        id: buttons
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: mainLabel.bottom
        anchors.margins: 24
        columns: 4
        rows: 5
        columnSpacing: 24
        rowSpacing: 24

        //Row 1
        ButtonSign {
            text: !window.isClosedBracket ? "(" : ")"
            iconSource: "rsc/icons/bkt.svg"
            customAction: function() {
                if (output.text === "" && !window.isClosedBracket){
                    output.text = text
                    window.isClosedBracket = true
                } else {
                    if (window.isClosedBracket ) {
                        output.text += input.text + text
                        window.isBracket = true
                        window.isClosedBracket = false
                    } else {
                        if (!window.isBracket) {
                            output.text += text
                            window.isClosedBracket = true
                        }
                    }
                }
                input.text = "0"
            }
        }
        ButtonSign {
            iconSource: "rsc/icons/plus_minus.svg"
        }
        ButtonSign {
            text: "%"
            iconSource: "rsc/icons/percent.svg"
        }
        ButtonSign {
            text: "/"
            iconSource: "rsc/icons/division.svg"
        }

        //Row 2
        ButtonNumber {
            text: "7"
        }
        ButtonNumber {
            text: "8"
        }
        ButtonNumber {
            text: "9"
        }
        ButtonSign {
            text: "*"
            iconSource: "rsc/icons/multiplication.svg"
        }

        //Row 3
        ButtonNumber {
            text: "4"
        }
        ButtonNumber {
            text: "5"
        }
        ButtonNumber {
            text: "6"
        }
        ButtonSign {
            text: "-"
            iconSource: "rsc/icons/minus.svg"
        }

        //Row 4
        ButtonNumber {
            text: "1"
        }
        ButtonNumber {
            text: "2"
        }
        ButtonNumber {
            text: "3"
        }
        ButtonSign {
            text: "+"
            iconSource: "rsc/icons/plus.svg"
        }

        //Row 5
        ButtonNumber {
            baseColorBack: "#edb1af"
            pressedColorBack: "#F25E5E"
            baseColorText: "#FFFFFF"
            pressedColorText: "#FFFFFF"
            text: "C"
            customAction: function() {
                input.text = "0"
                output.text = ""
                window.isFloatNumber = false
                window.isClosedBracket = false
            }
        }
        ButtonNumber {
            text: "0"
        }
        ButtonNumber {
            text: "."
            customAction: function() {
                if (!window.isFloatNumber) {
                    if (input.text === "0"){
                        input.text = "0" + text
                    } else {
                        input.text += text
                    }
                    window.isFloatNumber =  true
                }
            }
        }
        ButtonSign {
            text: "="
            iconSource: "rsc/icons/equal.svg"
        }
    }
}
