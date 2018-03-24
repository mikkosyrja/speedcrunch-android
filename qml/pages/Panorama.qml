import QtQuick 2.2
import Sailfish.Silica 1.0

Page
{
	property int statusmargin: window.height / 16
	property int buttonmargin: window.width / 50
	property int helpmargin: buttonmargin * 2

	property int buttoncolumns: 5
	property int buttonrows: 5

	property int fontsizebig: statusmargin * 2 / 3
	property int fontsizesmall: statusmargin / 2
	property int fontsizetiny: statusmargin / 3
	property int lineheight: fontsizesmall * 1.3
	property int settingheight: statusmargin * 1.3

	property int resultheight: lineheight
	property int keyboardheight: (window.height == 960 ? 446 : window.height * 45 / 100)
	property int historyheight: window.height - keyboardheight - textfield.height - statusmargin - resultheight

	property int buttonwidth: (width - buttonmargin) / buttoncolumns - buttonmargin
	property int bulletwidth: window.width / 20

	allowedOrientations: Orientation.Portrait

	Row
	{
		id: header
		height: statusmargin; spacing: bulletwidth / 2
		anchors { top: parent.top; left: parent.left; leftMargin: spacing }
		z: 10
		Switch { width: bulletwidth; anchors.verticalCenter: parent.verticalCenter; onClicked: screen.goToPage(0) }
		Switch { width: bulletwidth; anchors.verticalCenter: parent.verticalCenter; checked: true; onClicked: screen.goToPage(1) }
		Switch { width: bulletwidth; anchors.verticalCenter: parent.verticalCenter; onClicked: screen.goToPage(2) }
	}
	Pager
	{
		id: screen
		color: "transparent"
		anchors.fill: parent
		isHorizontal: true
		model: pages
		enableKeys: true
		focus: true
		indicator: header
		startIndex: 1

		Timer
		{
			id: screentimer
			interval: 250; running: false; repeat: false
			onTriggered:
			{
				if ( screen.index == 1 )
				{
					textfield.softwareInputPanelEnabled = false
					textfield.forceActiveFocus()
				}
			}
		}

		onIndexChanged: { screentimer.running = true }
	}

	VisualItemModel
	{
		id: pages
		Rectangle
		{
			width: window.width; height: window.height; color: "transparent"
			Rectangle
			{
				id: header1
				width: parent.width; height: statusmargin; color: "transparent"
				Text
				{
					color: Theme.highlightColor
					anchors { right: parent.right; rightMargin: bulletwidth / 2 }
					anchors.verticalCenter: parent.verticalCenter
					text: "Functions"
					font.pixelSize: fontsizebig
				}
			}
			TextField
			{
				id: searchFunctions
				width: parent.width
				anchors { top: header1.bottom; horizontalCenter: parent.horizontalCenter }
				placeholderText: "search"
				inputMethodHints: Qt.ImhNoPredictiveText;
			}
			ListView
			{
				id: functions
				width: parent.width
				anchors { top: searchFunctions.bottom; bottom: parent.bottom }
				clip: true
				model: { eval(manager.getFunctions(searchFunctions.text)) }
				delegate: Rectangle
				{
					property bool isCurrentItem: ListView.isCurrentItem
					width: parent.width; height: lineheight; color: "transparent"
					Text
					{
						id:textitem
						width: parent.width - 40; color: "white"
						anchors.centerIn: parent
						text: modelData.name
						font { pixelSize: fontsizesmall; weight: (parent.isCurrentItem ? Font.Bold: Font.Light) }
						MouseArea
						{
							anchors.fill: parent
							onClicked:
							{
								functions.currentIndex = index;
								var value = modelData.val + (modelData.func ? "()" : "")
								var text = textfield.text
								var pos = textfield.cursorPosition
								textfield.text = text.substring(0, pos) + value + text.substring(pos, text.length)
								textfield.cursorPosition = pos + value.length
								if ( modelData.func )
									textfield.cursorPosition--
								screen.goToPage(1)
								mouse.accepted = true;
							}
						}
					}
				}
			}
		}
		Rectangle
		{
			width: window.width; height: window.height; color: "transparent"
			Column
			{
				anchors { fill: parent; margins: 10 }
				ListModel { id: resultsList }
				Rectangle
				{
					id: header2
					width: parent.width; height: statusmargin; color: "transparent"
					Text
					{
						color: Theme.highlightColor
						anchors { right: parent.right; rightMargin: bulletwidth / 2 }
						anchors.verticalCenter: parent.verticalCenter
						text: "SpeedCrunch"
						font.pixelSize: fontsizebig
					}
				}
				Item { width: parent.width; height: resultheight / 2 }
				Rectangle
				{
					width: parent.width; height: historyheight; color: "transparent"
					ListView
					{
						id: resultsview
						width: parent.width; height: parent.height
						snapMode: "SnapOneItem"
						clip: true
						model: resultsList
						delegate: Rectangle
						{
							property bool isCurrentItem: ListView.isCurrentItem
							width: parent.width; height: lineheight; color: "transparent"
							Text
							{
								id: resultitem
								width: parent.width - 40; color: "white"
								anchors.centerIn: parent
								text: model.text
								font { pixelSize: fontsizesmall; weight: (parent.isCurrentItem ? Font.Bold: Font.Light) }
								MouseArea
								{
									anchors.fill: parent
									onClicked:
									{
										var text = textfield.text
										var pos = textfield.cursorPosition
										textfield.text = text.substring(0, pos) + model.value + text.substring(pos, text.length)
										textfield.cursorPosition = pos + model.value.length
									}
									onPressAndHold: { textfield.text = model.steps }
								}
							}
						}
					}
					ScrollDecorator { flickable: resultsview }
				}
				Item { width: parent.width; height: resultheight / 2 }
				Item
				{
					width: parent.width; height: textfield.height
					TextField
					{
						id: textfield
						anchors { left: parent.left; right: cleartext.left }
//						label: ""
						inputMethodHints:  Qt.ImhPreferNumbers
						placeholderText: "expression"
						softwareInputPanelEnabled: false
						Keys.onReturnPressed: { evaluate(); }
						onClicked:
						{
							textfield.softwareInputPanelEnabled = true
							textfield.forceActiveFocus()
						}
						onFocusChanged:
						{
							if ( textfield.softwareInputPanelEnabled )
							{
								textfield.softwareInputPanelEnabled = false
								textfield.forceActiveFocus()
							}
						}
						onTextChanged:
						{
//							if (manager.autoCalc(text)!=="NaN")
//								window.latestResult = result.text= manager.autoCalc(text)
						}
					}
					Image	// clear button
					{
						id: cleartext
						width: buttonwidth / 2; height: buttonheight
						anchors { right: evaluatebutton.left; rightMargin: buttonmargin }
						anchors.verticalCenter: evaluatebutton.verticalCenter
						fillMode: Image.PreserveAspectFit
						smooth: true;
						visible: textfield.text
						source: "clear.png"
						MouseArea
						{
							id: cleararea
							anchors { fill: parent; margins: -10 }
							onClicked: { textfield.text = ""; textfield.forceActiveFocus() }
						}
					}
					Button	// evaluate button
					{
						id: evaluatebutton
						width: buttonwidth; color: Theme.highlightColor
						anchors { top: textfield.top; topMargin: buttonmargin; right: parent.right }
						text: "="
						onClicked: { evaluate(); }
					}
				}
				Pager
				{
					id: keyboard
					width: parent.width; height: keyboardheight - statusmargin; spacing: buttonmargin; color: "transparent"
					anchors.top: textfield.bottom
					isHorizontal: true
					enableKeys: false
					focus: false
					startIndex: -1
					indicator: footer
					model: VisualItemModel
					{
						Grid	// Page 1
						{
							rows: buttonrows; columns: buttoncolumns
							width: parent.parent.width; height: parent.parent.height; spacing: parent.parent.spacing

	CalcButton { text: "7" } CalcButton { text: "8" } CalcButton { text: "9" }
	CalcButton { text: "/" } CalcButton { text: "x²"; value: "^2" }
	CalcButton { id: button4; text: "4"; value: "4"; secondary: "D" }
	CalcButton { id: button5; text: "5"; value: "5"; secondary: "E" }
	CalcButton { id: button6; text: "6"; value: "6"; secondary: "F" }
	CalcButton { text: "×"; value: "*" } CalcButton { text: "√"; value: "sqrt()" }
	CalcButton { id: button1; text: "1"; value: "1"; secondary: "A" }
	CalcButton { id: button2; text: "2"; value: "2"; secondary: "B" }
	CalcButton { id: button3; text: "3"; value: "3"; secondary: "C" }
	CalcButton { text: "-" } CalcButton { text: "1/x"; value: "1/" }
	CalcButton { text: "0" } CalcButton { text: "." } CalcButton { text: ";" } CalcButton { text: "+" }
	CalcButton { id: buttonbase; text: "0x"; value: "0x"; secondary: "0b"  }

	CalcButton { text: "("; color: Theme.highlightColor } CalcButton { text: ")"; color: Theme.highlightColor }
	CalcButton { text: "←"; special: true; color: Theme.highlightColor; onRunFunction: { textfield.cursorPosition-- } }
	CalcButton { text: "→"; special: true; color: Theme.highlightColor; onRunFunction: { textfield.cursorPosition++ } }
	Backspace { color: Theme.highlightColor }

						}
						Grid	// Page 2
						{
							rows: buttonrows; columns: buttoncolumns
							width: parent.parent.width; height: parent.parent.height; spacing: parent.parent.spacing

	CalcButton { text: "sin"; isFunction: true } CalcButton { text: "cos"; isFunction: true }
	CalcButton { text: "tan"; isFunction: true } CalcButton { text: "ln"; isFunction: true }
	CalcButton { text: "^" }

	CalcButton { text: "asin"; value: "arcsin()" } CalcButton { text: "acos"; value: "arccos()" }
	CalcButton { text: "atan"; value: "arctan()" } CalcButton { text: "exp"; isFunction: true }
	CalcButton { image: "cube_root.png"; /*text: "∛"; */ value:"cbrt()" }

	CalcButton { text: "π"; value: "pi" } CalcButton { text: "e" } CalcButton { text: "x" }
	CalcButton { text: "x="; value: "="; secondary: "(x)=" } CalcButton { text: "!" }

	CalcButton { text: "&" } CalcButton { text: "|" } CalcButton { text: "<<" } CalcButton { text: ">>" } CalcButton { text: "->" }

	CalcButton { text: "("; color: Theme.highlightColor } CalcButton { text: ")"; color: Theme.highlightColor }
	CalcButton { text: "←"; special: true; color: Theme.highlightColor; onRunFunction: { textfield.cursorPosition-- } }
	CalcButton { text: "→"; special: true; color: Theme.highlightColor; onRunFunction: { textfield.cursorPosition++ } }
	Backspace { color: Theme.highlightColor }

						}
					}
					Component.onCompleted: keyboard.goToPage(0);
				}
//				Button
//				{
//					anchors.horizontalCenter: parent.horizontalCenter
//					width: 400
//					text: "clear till"
//					onClicked: resultsList.clear()
//				}
//				Button
//				{
//					anchors.horizontalCenter: parent.horizontalCenter
//					width: 400
//					text: "copy result"
//					enabled: result.text.length
//					onClicked: manager.setClipboard(result.text)
//				}
			}
			Row
			{
				id: footer
				height: statusmargin; spacing: bulletwidth / 2
				anchors { bottom: parent.bottom; left: parent.left; leftMargin: spacing }
				Switch { width: bulletwidth; anchors.verticalCenter: parent.verticalCenter; onClicked: keyboard.goToPage(0) }
				Switch { width: bulletwidth; anchors.verticalCenter: parent.verticalCenter; onClicked: keyboard.goToPage(1) }
			}
		}
		Rectangle
		{
			width: window.width; height: window.height; color: "transparent"
			Column
			{
				anchors.fill: parent
				Rectangle
				{
					id: header3
					width: parent.width; height: statusmargin; color: "transparent"
					anchors.top: parent.top
					Text
					{
						anchors { right: parent.right; rightMargin: bulletwidth / 2 }
						anchors.verticalCenter: parent.verticalCenter
						text: "Settings"
						font.pixelSize: fontsizebig
						color: Theme.highlightColor
					}
				}
				Rectangle
				{
					id: angleunitsetting
					width: parent.width; height: settingheight; color: "transparent"
					anchors.top: header3.bottom
					z: 20
					ComboBox
					{
						id: angleunitlist
						label: "Angle Unit"
						menu: ContextMenu
						{
							MenuItem { text: "Degree" }
							MenuItem { text: "Radian" }
//							MenuItem { text: "Gradian" }
						}
						onCurrentIndexChanged:
						{
							if ( currentIndex == 0 ) { manager.setAngleUnit("d") }
							else if ( currentIndex == 1 ) { manager.setAngleUnit("r") }
//							else if ( currentIndex == 2 ) { manager.setAngleUnit("g") }
						}
						function setAngleUnit(unit)
						{
							if ( unit == "d" ) currentIndex = 0
							else if ( unit == "r" ) currentIndex = 1
//							else if ( unit == "g" ) currentIndex = 2
						}
					}
				}
				Rectangle
				{
					id: resultformatsetting
					width: parent.width; height: settingheight; color: "transparent"
					anchors.top: angleunitsetting.bottom
					z: 20
					ComboBox
					{
						id: resultformatlist
						label: "Result format"
						menu: ContextMenu
						{
							MenuItem { text: "General decimal" }
							MenuItem { text: "Fixed decimal" }
							MenuItem { text: "Engineering decimal" }
							MenuItem { text: "Scientific decimal" }
							MenuItem { text: "Binary" }
							MenuItem { text: "Octal" }
							MenuItem { text: "Hexadecimal" }
						}
						onCurrentIndexChanged:
						{
							if ( currentIndex == 0 ) { manager.setResultFormat("g"); }
							else if ( currentIndex == 1 ) { manager.setResultFormat("f"); }
							else if ( currentIndex == 2 ) { manager.setResultFormat("n"); }
							else if ( currentIndex == 3 ) { manager.setResultFormat("e"); }
							else if ( currentIndex == 4 ) { manager.setResultFormat("b"); }
							else if ( currentIndex == 5 ) { manager.setResultFormat("o"); }
							else if ( currentIndex == 6 ) { manager.setResultFormat("h"); }
							setButtonLabels()
						}
						function setResultFormat(format)
						{
							if ( format == "g" ) currentIndex = 0
							else if ( format == "f" ) currentIndex = 1
							else if ( format == "n" ) currentIndex = 2
							else if ( format == "e" ) currentIndex = 3
							else if ( format == "b" ) currentIndex = 4
							else if ( format == "o" ) currentIndex = 5
							else if ( format == "h" ) currentIndex = 6
						}
					}
				}
				Rectangle
				{
					id: precisionsetting
					width: parent.width; height: settingheight; color: "transparent"
					anchors.top: resultformatsetting.bottom
					z: 10
					ComboBox
					{
						id: precisionlist
						label: "Precision"
						menu: ContextMenu
						{
							MenuItem { text: "Automatic" }
							MenuItem { text: "0" } MenuItem { text: "1" }
							MenuItem { text: "2" } MenuItem { text: "3" }
							MenuItem { text: "4" } MenuItem { text: "6" }
							MenuItem { text: "8" } MenuItem { text: "12" }
						}
						onCurrentIndexChanged:
						{
							if ( currentIndex == 0 )
								manager.setPrecision("")
							else
								manager.setPrecision(currentItem.text)
						}
						function setPrecision(precision)
						{
							if ( precision == "0" ) currentIndex = 1
							else if ( precision == "1" ) currentIndex = 2
							else if ( precision == "2" ) currentIndex = 3
							else if ( precision == "3" ) currentIndex = 4
							else if ( precision == "4" ) currentIndex = 5
							else if ( precision == "6" ) currentIndex = 6
							else if ( precision == "8" ) currentIndex = 7
							else if ( precision == "12" ) currentIndex = 8
							else currentIndex = 0;
						}
					}
				}
/*
				Rectangle
				{
					id: expressionsetting
					width: parent.width; height: settingheight; color: "transparent"
					anchors.top: precisionsetting.bottom
					TextSwitch
					{
						id: expressionswitch
						checked: true
						text: "Leave Last Expression"
//						description: "Leave Last Expression"
					}
				}
				Rectangle
				{
					id: historysetting
					width: parent.width; height: settingheight; color: "transparent"
					anchors.top: decimalsetting.bottom
					TextSwitch
					{
						id: historyswitch
						checked: true
						text: "Save History on Exit"
//						description: "Save History on Exit"
					}
				}
*/
				Text
				{
					id: helptitle
					width: parent.width; color: "white"
					anchors { top: precisionsetting.bottom; left: parent.left; leftMargin: helpmargin }
					text: "Tips:"
					font.pixelSize: fontsizesmall
				}
				Column
				{
					spacing: buttonmargin
					anchors { top: helptitle.bottom; topMargin: 20 }
					Text
					{
						width: parent.width - (helpmargin * 3); color: "white"
						anchors.horizontalCenter: parent.horizontalCenter
						text: "Swipe left/right on the keypad for more functions."
						font.pixelSize: fontsizetiny; wrapMode: Text.WordWrap
					}
					Text
					{
						width: parent.width - (helpmargin * 3); color: "white"
						anchors.horizontalCenter: parent.horizontalCenter
						text: "Tap on the expression twice to edit it with the full\nkeyboard, for advanced formulas."
						font.pixelSize: fontsizetiny; wrapMode: Text.WordWrap
					}
					Text
					{
						width: parent.width - (helpmargin * 3); color: "white"
						anchors.horizontalCenter: parent.horizontalCenter
						text: "Tap on any line on the history to insert result value\nto the running expression."
						font.pixelSize: fontsizetiny; wrapMode: Text.WordWrap
					}
					Text
					{
						width: parent.width - (helpmargin * 3); color: "white"
						anchors.horizontalCenter: parent.horizontalCenter
						text: "Tap and hold on any line on the history to replace\nthe running expression with it."
						font.pixelSize: fontsizetiny; wrapMode: Text.WordWrap
					}
					Text
					{
						width: parent.width - (helpmargin * 3); color: "white"
						anchors.horizontalCenter: parent.horizontalCenter
						text: "Tap and hold on buttons 1-6 to insert hexadecimal\nletters A-F. Tap and hold on 0x to insert 0b."
						font.pixelSize: fontsizetiny; wrapMode: Text.WordWrap
					}
				}
			}
		}
	}

	Component.onCompleted:
	{
		textfield.softwareInputPanelEnabled = false
		textfield.forceActiveFocus()

		angleunitlist.setAngleUnit(manager.getAngleUnit())
		resultformatlist.setResultFormat(manager.getResultFormat())
		precisionlist.setPrecision(manager.getPrecision())
	}

	function evaluate()
	{
		if ( textfield.text != "" )
		{
			window.latestExpression = manager.autoFix(textfield.text)
			window.latestResult = manager.calculate(textfield.text);
			if ( window.latestResult !== "" )
				resultsList.append({"text": window.latestExpression + " = " + window.latestResult, "value" : window.latestResult, "steps" : window.latestExpression})
			else
				resultsList.append({"text": window.latestExpression, "value" : "", "steps": window.latestExpression})
			resultsview.positionViewAtEnd()
			resultsview.currentIndex = resultsview.count - 1
			textfield.text = ""
		}
	}

	function setButtonLabels()
	{
		var format = manager.getResultFormat()
		if ( format == "h" )
		{
			button1.text = "1 A"; button2.text = "2 B"; button3.text = "3 C"
			button4.text = "4 D"; button5.text = "5 E"; button6.text = "6 F"
		}
		else
		{
			button1.text = "1"; button2.text = "2"; button3.text = "3"
			button4.text = "4"; button5.text = "5"; button6.text = "6"
		}
		if ( format == "h" || format == "b" || format == "o" )
			buttonbase.text = "0x 0b"
		else
			buttonbase.text = "0x"
	}
}
