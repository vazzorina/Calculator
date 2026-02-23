import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Window {
    id: window
    property bool isFloatNumber: false
    property bool isClosedBracket: false
    property bool isBracket: false
    property bool isResult: false
    property bool waitingForCode: false

    width: 360
    height: 640
    visible: true
    title: qsTr("Калькулятор")
    color: "#024873"

    Timer {
        id: holdTimer
        interval: 4000
        repeat: false
        onTriggered: {
            window.waitingForCode = true
            input.text = "" // Очищаем поле для ввода кода
            inputTimer.start() // Запускаем окно в 5 секунд
        }
    }

    Timer {
        id: inputTimer
        interval: 5000
        repeat: false
        onTriggered: {
            window.waitingForCode = false
            input.text = "0"
        }
    }

    Rectangle {
        id: secretMenu
        anchors.centerIn: parent
        anchors.margins: 25
        visible: false
        height: 200
        width: 300
        z: 100
        color: "#FFFFFF"
        border.color: "#F25E5E"
        border.width: 2
        radius: 15
        Label {
            text: "Секретное меню"
            color: "#F25E5E"
            font.pixelSize: 24
            font.family: "Open Sans"
            font.weight: Font.SemiBold
            font.letterSpacing: 0.5
            anchors.top: parent.top
            anchors.topMargin: 50
            anchors.horizontalCenter: parent.horizontalCenter
        }

        ButtonNumber {
            text: "Назад"
            baseColorBack: "#edb1af"
            pressedColorBack: "#F25E5E"
            baseColorText: "#FFFFFF"
            pressedColorText: "#FFFFFF"
            width: 100
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            customAction: function() {
                secretMenu.visible = false
            }
        }
    }

    function openSecretMenu() {
        secretMenu.visible = true
    }

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
            onCursorPositionChanged: {
                if (cursorPosition !== text.length) {
                    cursorPosition = text.length
                }
            }

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
            font.pixelSize: {
                if (text.length <= 10) {
                    return 50;
                } else if (text.length <= 14) {
                    return 35;
                } else if (text.length <= 20) {
                    return 24;
                } else {
                    return 19;
                }
            }
            font.family: "Open Sans"
            font.weight: Font.SemiBold
            font.letterSpacing: 0.5
            color: "#FFFFFF"
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter

            onTextChanged: {
                if (window.waitingForCode && text === "123") {
                    inputTimer.stop()
                    window.waitingForCode = false
                    openSecretMenu()
                }
            }
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
                if(isResult) { //если был выведен результат, очищаем вывод выражения
                    output.text = "";
                    window.isResult = false;
                }
                if (output.text === ""){ //если output пустой, добавляем (
                    output.text = text
                    window.isClosedBracket = true
                } else {
                    if (window.isClosedBracket ) { //если требуется ), добавляем вместе с числом в input
                        if (input.text.startsWith("-")) {
                            output.text += "(" + input.text + ")" + text
                        } else {
                            output.text += input.text + text
                        }
                        window.isBracket = true //обозначаем, что можем ввести только знак после )
                        window.isClosedBracket = false
                    } else {
                        if (!window.isBracket) { //исключаем вставку ( сразу после закрывающей )
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
            customAction: function() {
                if(isResult) {
                    output.text = "";
                    window.isResult = false;
                }

                if (input.text === "0") return;

                if (input.text.startsWith("-")) {
                    input.text = input.text.substring(1);
                } else {
                    input.text = "-" + input.text;
                }
            }
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
                window.isResult = false
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
            id: equal
            text: "="
            iconSource: "rsc/icons/equal.svg"
            color: tapArea.pressed ? pressedColorBack : baseColorBack
            customAction: function() {
                if(!isResult && !window.waitingForCode) {
                    if (!window.isBracket) { //если не было )
                        if (output.text === "") {
                            output.text = input.text
                        } else {
                            if (input.text.startsWith("-")) {
                                output.text += "(" + input.text + ")"
                            } else {
                                output.text += input.text
                            }
                        }
                    }
                    window.isFloatNumber = false
                    window.isBracket = false
                    let fullExpression = output.text;
                    let result = backend.calculate(fullExpression);
                    input.text = result;
                    isResult = true;
                }
            }
            MouseArea {
                id: tapArea
                anchors.fill: parent
                pressAndHoldInterval: 4000
                onPressAndHold: {
                    holdTimer.triggered()
                }

                onClicked: {
                    equal.customAction()
                }
            }
        }
    }
}
