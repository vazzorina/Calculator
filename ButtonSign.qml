import QtQuick

Rectangle {
    id: root
    property var customAction: null

    property string text: ""
    property string iconSource: ""
    property color baseColorBack: "#0889A6"        // Цвет по умолчанию
    property color pressedColorBack: "#F7E425"     // Цвет при нажатии

    signal clicked()
    signal longPressed()

    width: 60
    height: 60
    radius: 30
    color: tapArea.pressed ? pressedColorBack : baseColorBack

    antialiasing: true

    // Контент: Иконка + Текст
    Row {
        anchors.centerIn: parent
        Image {
            source: root.iconSource
            width: 30; height: 30
            visible: root.iconSource !== ""
            fillMode: Image.PreserveAspectFit
        }
    }

    // Обработка нажатий
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
            if (!window.isBracket) {
                if (output.text === "") {
                    output.text = input.text + text
                } else {
                    output.text += input.text + text
                }
            } else {
                if (output.text !== "") {
                    output.text += text
                }
            }
            input.text = "0"
            window.isFloatNumber = false
            window.isBracket = false
        }
    }
}
