import QtQuick 2.0
import Sailfish.Silica 1.0
import QtWebKit 3.0

Page {
    allowedOrientations: Orientation.Portrait
        Row{
            id: bullets
            width: 100
            height: 30
            z: 10
            spacing: 20
            anchors.top: parent.top;
            anchors.left: parent.left
            anchors.topMargin: 30
            anchors.leftMargin: 30
            Switch{
                width: 20
                height: 20
                opacity: .5
                onClicked: myPager.goToPage(0)
            }
            Switch{
                width: 20
                height: 20
                checked: true
                opacity: .5
                onClicked: myPager.goToPage(1)
            }
            Switch{
                width: 20
                height: 20
                opacity: .5
                onClicked: myPager.goToPage(2)
            }
        }
        MouseArea{
            id: captureClicks
            anchors.fill: bullets
            onClicked: mouse.accepted = true
            preventStealing: true
            z:10
        }

    Pager {
        property bool firstTime : true
        id: myPager
        isHorizontal: true
        anchors.fill: parent
        model: pagesModel
        color: "transparent"
        enableKeys: true
        focus: true
        indicator: bullets
        startIndex: 1
        Timer {
            id: pagertimer
            interval: 100; running: false; repeat: false
            onTriggered: {
                if (parent.index==1) {
                    if (parent.firstTime) parent.firstTime = false; else mn.setNumbers()
//                    tf.forceActiveFocus()
                }
                if (parent.index==0) mn.setABC()
            }
        }
        onIndexChanged: {
            pagertimer.running = true
        }
    }

    VisualItemModel {
        id: pagesModel
///////////////////////////////page 1
        Rectangle {
            width: wn.width
            height: wn.height
            color: "transparent"
            Rectangle{
                id: header1
                height: 72
                anchors.top: parent.top
                width: parent.width
                color: "transparent"
                Text {
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.rightMargin: 20
                    anchors.topMargin: 17
                    text: "functions&constants"
                    font.pixelSize: 44
                    color: "#86e1ff"
                }
            }
            TextField{
                id: searchFunctions
                placeholderText: "search"
                inputMethodHints: Qt.ImhNoPredictiveText;
                width: parent.width
                anchors.top: header1.bottom
                anchors.horizontalCenter: parent.horizontalCenter
            }
            ListView{
                id: funcsnconsts
                clip: true
                width: parent.width
                anchors.top: searchFunctions.bottom
                anchors.bottom: parent.bottom
                model: {eval(mn.getFunctions(searchFunctions.text))}
                delegate: Rectangle{
                    property bool isCurrentItem: ListView.isCurrentItem
                    color: "transparent"
                    height: 50
                    width: parent.width
                    Text{
                        id:textitem
                        color: "white"
                        text:modelData.name
                        width: parent.width -40
                        font.pixelSize: 30
                        font.weight: parent.isCurrentItem ?Font.Bold: Font.Light
                        anchors.centerIn: parent
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                funcsnconsts.currentIndex = index;
                                var parenthesis = modelData.func?"()":""
                                tf.text = tf.text + modelData.val + parenthesis
                                if (modelData.func) tf.cursorPosition = tf.text.length -1
                                myPager.goToPage(1)
                            }
                        }
                    }
                }
            }
        }
///////////////////////////////page 2
        Rectangle{
            width: wn.width
            height: wn.height
            color: "transparent"
            Column{
                anchors.fill: parent
                anchors.margins: 10
                ListModel{
                    id: resultsList
                }
                Rectangle{
                    height: 70
                    width: parent.width
                    color: "transparent"
                }

                Rectangle{
                    height: 380
                    width: parent.width
                    color: "transparent"
                    ListView{
                        clip: true
                        id: resultsView
                        snapMode: "SnapOneItem"
                        height: 380
                        width: parent.width
                        model: resultsList
                        delegate: MouseArea{
                            height: 40
                            width: parent.width
                            Text{
                                id: li
                                text:model.text
                                color: "white"
                                font.pixelSize: 30
                            }
                            onClicked: {
                                if (mouse.wasHeld)
                                    tf.text = tf.text + model.value
                                else
                                    tf.text = tf.text + "(" +model.steps + ")"
                                mouse.accepted = true;
//                                tf.forceActiveFocus()
                            }
                        }
                    }
                    ScrollDecorator{
                        flickable: resultsView
                    }
                }
                Text{
                    id: result
                    color: "white"
                    font.pointSize: 30
                    height: 70
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 30
                    anchors.rightMargin: 30
                }
                Item{
                    width: parent.width
                    height: tf.height
                    TextField{
                        id: tf
                        anchors.left: parent.left
                        anchors.right: clearText.left
                        inputMethodHints:  Qt.ImhPreferNumbers;//Qt.ImhNoPredictiveText;
                        placeholderText: "expression"
                        Keys.onReturnPressed: { go();}
//                        Rectangle{
//                            anchors.left:parent.left
//                            anchors.top:parent.top
//                            anchors.leftMargin: tf.positionToRectangle(4).x
//                            anchors.topMargin: tf.positionToRectangle(4).y
//                            height: 20
//                            width:20
//                            color: "blue"
//                        }
                        onTextChanged: {
                            if (mn.autoCalc(text)!=="NaN") {
                                wn.latestResult = result.text= mn.autoCalc(text)
                            }
                        }
                        //focus: visible//myPager.index==0
                    }
                    Image {
                        anchors { top: tf.top; topMargin: 20; right: goButton.left}
                        id: clearText
                        fillMode: Image.PreserveAspectFit
                        smooth: true;
                        visible: tf.text
                        source: "clear.png"
                        height: 20
                        width: 20
                        MouseArea {
                            id: clear
                            anchors.fill: parent
                            z: 10
                            onClicked: {
                                tf.text = ""
//                                  tf.forceActiveFocus()
                            }
                        }
                        z: 10
                    }
                    Button {
                        id: goButton
                        text: "Go"
                        anchors.top: tf.top
                        anchors.topMargin: -10
                        anchors.right: parent.right
                        width: 70
                        onClicked: { go();  }
                    }
                }
                Pager {
                    property bool firstTime : true
                    id: buttonsPager
                    isHorizontal: true
                    color: "transparent"
                    enableKeys: false
                    focus: false
                    z: 10
                    startIndex: 0
                    spacing: 20
                    height : 400
                    indicator: pageIndicatorBars
                    width: parent.width
                    model: VisualItemModel {
                        // Page 1
                        Grid{
                            id: buttonsPage0
                            columns: 5
                            rows: 4
                            width: parent.parent.width
                            spacing: 15
                            height: parent.height
                            CalcButton {text: "7"}
                            CalcButton {text: "8"}
                            CalcButton {text: "9"}
                            CalcButton {text: "+"}
                            Backspace {}
                            CalcButton {text: "4"}
                            CalcButton {text: "5"}
                            CalcButton {text: "6"}
                            CalcButton {text: "-"}
                            CalcButton {text: "("}
                            CalcButton {text: "1"}
                            CalcButton {text: "2"}
                            CalcButton {text: "3"}
                            CalcButton {text: "*"}
                            CalcButton {text: ")"}
                            CalcButton {text: "."}
                            CalcButton {text: "0"}
                            CalcButton {text: "000"}
                            CalcButton {text: "/"}
                            CalcButton {text: "^"}
                        }
                        //Page 2
                        Grid{
                            columns: 5
                            rows: 4
                            width: buttonsPage0.width
                            spacing: 15
                            height: parent.height
                            CalcButton {text: "sin"; isFunction: true }
                            CalcButton {text: "cos"; isFunction: true}
                            CalcButton {text: "tan"; isFunction: true}
                            CalcButton {text: "pi"}
                            Backspace {}
                            CalcButton {text: "asin"; isFunction: true}
                            CalcButton {text: "acos"; isFunction: true}
                            CalcButton {text: "atan"; isFunction: true}
                            CalcButton {text: "√"; value: "sqrt()"}
                            CalcButton {image: "cube_root.png"; /*text: "∛"; */ value:"^-3"; onCallback: {tf.cursorPosition -= 3}}
                            CalcButton {text: "("}
                            CalcButton {text: "!"}
                            CalcButton {text: "e"}
                            CalcButton {text: "%"}
                            CalcButton {text: ")"}
                            CalcButton {text: "x="}
                            CalcButton {text: "home"
                                        special: true
                                        onRunFunction: tf.cursorPosition = 0
                                        }
                            CalcButton {text: "←"
                                        special: true
                                        onRunFunction: {
//                                            tf.forceActiveFocus();
//                                            mn.hideKeyboard();
                                            tf.cursorPosition--
                                        }}
                            CalcButton {text: "→";
                                        special: true
                                        onRunFunction: {
//                                            tf.forceActiveFocus();
//                                            mn.hideKeyboard();
                                            tf.cursorPosition++
                                        }}
                            CalcButton {text: "end"
                                        special: true
                                        onRunFunction: {
//                                            tf.forceActiveFocus();
                                            mn.hideKeyboard();
                                            tf.cursorPosition = tf.text.length
                                        }}
                            //←↑→↓
                        }

                        }
                    }
//                    Button {
//                        anchors.horizontalCenter: parent.horizontalCenter
//                        width: 400
//                        text: "clear till"
//                        onClicked: resultsList.clear()
//                    }
//                    Button {
//                        anchors.horizontalCenter: parent.horizontalCenter
//                        width: 400
//                        text: "copy result"
//                        enabled: result.text.length
//                        onClicked: mn.setClipboard(result.text)
//                    }
            }
            Row{
                id: pageIndicatorBars
                width: childrenRect.width
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 20
                height: 10
                z: 10
                spacing: 10
                Switch{
                    width: 20
                    height: 20
                    opacity: .5
                    enabled: false;
                }
                Switch{
                    width: 20
                    height: 20
                    opacity: .5
                    enabled: false;
                }
            }
        }
//////////////////////////////////////// page 3
        Rectangle {
            width: wn.width
            height: wn.height
            color: "transparent"
            Column {
                anchors.fill: parent
                Rectangle{
                    height: 90
                    width: parent.width
                    color: "transparent"
                    Text {
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.rightMargin: 20
                        anchors.topMargin: 17
                        text: "settings&help"
                        font.pixelSize: 44
                        color: "#86e1ff"
                    }
                }
                Column{
                    anchors.horizontalCenter: parent.horizontalCenter
                    Switch{
                        id: angleUnits
                        onClicked: {
                            if (checked){
                                mn.setAngleModeDegree()
                                result.text= mn.autoCalc(tf.text)
                                console.log(mn.getAngleMode()=='d')
                            } else {
                                mn.setAngleModeRadian()
                                result.text= mn.autoCalc(tf.text)
                            }
                        }
                        checked: {return (mn.getAngleMode() == 'd')}
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Label{
                        text: angleUnits.checked?"degrees":"radians"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
                Rectangle{
                    color: "transparent"
                    height: 40
                    width: parent.width
                }

                Text{
                    text: "Tips:"
                    width: parent.width - 60
                    color: "white"
                    font.pixelSize: 40
                    anchors.left: parent.left;
                    anchors.leftMargin: 30
                }
                Text{
                    text: "Swipe left/right on the keypad for more functions."
                    color: "white"
                    width: parent.width - 90
                    font.pixelSize: 30
                    wrapMode: "WordWrap"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Text{
                    text: "Tap on the expression to edit it with the full keyboard, for advanced formulas."
                    color: "white"
                    width: parent.width - 90
                    font.pixelSize: 30
                    wrapMode: "WordWrap"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Text{
                    text: "When you want to go back to basic mode, slide the keyboard down."
                    width: parent.width - 90
                    font.pixelSize: 30
                    wrapMode: "WordWrap"
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Rectangle{
                    color: "transparent"
                    height: 20
                    width: parent.width
                }
                Text{
                    text: "Tap on any function in the functions page to insert it to the running expression."
                    color: "white"
                    width: parent.width - 90
                    font.pixelSize: 30
                    wrapMode: "WordWrap"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Rectangle{
                    color: "transparent"
                    height: 20
                    width: parent.width
                }
                Text{
                    text: "Tap on any result on the till to insert it to the running expression."
                    width: parent.width - 90
                    font.pixelSize: 30
                    wrapMode: "WordWrap"
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Rectangle{
                    color: "transparent"
                    height: 20
                    width: parent.width
                }
            }
        }
    }
    Component.onCompleted: {
//        tf.forceActiveFocus();

    }

    function go(){
        if (mn.calc(tf.text) !== "")
            resultsList.append({"text": tf.text + " = " + mn.calc(tf.text), "value" : mn.calc(tf.text), "steps" : tf.text})
        else
            resultsList.append({"text": tf.text, "value" : tf.text, "steps": tf.text})
//        tf.forceActiveFocus()
        resultsView.positionViewAtEnd()
    }

}

