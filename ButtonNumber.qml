import QtQuick

Rectangle {
    id: root
    property var customAction: null

    property string text: ""
    property string iconSource: ""
    property color baseColorBack: "#B0D1D8"        // Цвет по умолчанию
    property color pressedColorBack: "#04BFAD"     // Цвет при нажатии
    property color baseColorText: "#024873"        // Цвет по умолчанию
    property color pressedColorText: "#FFFFFF"     // Цвет при нажатии

    signal clicked()
    signal longPressed()

    width: 60
    height: 60
    radius: 30
    color: tapArea.pressed ? pressedColorBack : baseColorBack

    antialiasing: true

    Row {
        anchors.centerIn: parent
        Text {
            text: root.text
            color: tapArea.pressed ? pressedColorText : baseColorText
            font.pixelSize: 24
            font.family: "Open Sans"
            font.weight: Font.SemiBold
            font.letterSpacing: 1
            lineHeight: 30
            lineHeightMode: Text.FixedHeight
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    MouseArea {
        id: tapArea
        anchors.fill: parent
        onClicked: root.clicked()
        onPressAndHold: root.longPressed()
    }

    onClicked: {
        if (customAction !== null) {
            customAction()
        } else {
            if (input.text === "0") {
                input.text = text
            } else if (!window.isBracket){
                input.text += text
            }
        }
    }
}
