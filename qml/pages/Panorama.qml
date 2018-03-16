import QtQuick 2.2
import Sailfish.Silica 1.0

Page
{
	property int statusmargin: window.height / 16
	property int buttonmargin: window.width / 50
	property int helpmargin: buttonmargin * 2

	property int buttoncolumns: 5	//## more with tablet
	property int buttonrows: 4

	property int fontsizebig: statusmargin * 2 / 3
	property int fontsizesmall: statusmargin / 2
	property int fontsizetiny: statusmargin / 3
	property int lineheight: fontsizesmall * 1.3	//##
	property int settingheight: statusmargin * 1.3	//##

	property int resultheight: lineheight
	property int keyboardheight: window.height * 45 / 100	//## is 45% always true?
	property int historyheight: window.height - keyboardheight - textfield.height - statusmargin - resultheight

	property int buttonwidth: (width - buttonmargin) / buttoncolumns - buttonmargin
	property int bulletwidth: window.width / 20

	allowedOrientations: Orientation.Portrait

	Row		// screen indicators
	{
		id: header
		spacing: bulletwidth / 2
		anchors.top: parent.top;
		anchors { left: parent.left; leftMargin: spacing }
		height: statusmargin
		z: 10
		Switch
		{
			width: bulletwidth
			anchors.verticalCenter: parent.verticalCenter
			onClicked: screen.goToPage(0)
		}
		Switch
		{
			width: bulletwidth
			anchors.verticalCenter: parent.verticalCenter
			checked: true
			onClicked: screen.goToPage(1)
		}
		Switch
		{
			width: bulletwidth
			anchors.verticalCenter: parent.verticalCenter
			onClicked: screen.goToPage(2)
		}
	}
	Pager	// screen pager
	{
		id: screen
		isHorizontal: true
		anchors.fill: parent
		model: pages
		color: "transparent"
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
//				if ( parent.index == 1 )
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
		Rectangle	/////////////////////////////// page 1
		{
			width: window.width
			height: window.height
			color: "transparent"
			Rectangle
			{
				id: header1
//				anchors.top: parent.top
				width: parent.width
				height: statusmargin
				color: "transparent"
				Text
				{
					anchors { right: parent.right; rightMargin: bulletwidth / 2 }
					anchors.verticalCenter: parent.verticalCenter
					text: "Functions"		//%%
					font.pixelSize: fontsizebig
					color: Theme.highlightColor
				}
			}
			TextField
			{
				id: searchFunctions
				placeholderText: "search"
				inputMethodHints: Qt.ImhNoPredictiveText;
				width: parent.width
				anchors.top: header1.bottom
				anchors.horizontalCenter: parent.horizontalCenter
			}
			ListView
			{
				id: functions
				clip: true
				width: parent.width
				anchors.top: searchFunctions.bottom
				anchors.bottom: parent.bottom
				model: { eval(manager.getFunctions(searchFunctions.text)) }
				delegate: Rectangle
				{
					property bool isCurrentItem: ListView.isCurrentItem
					color: "transparent"
					width: parent.width
					height: lineheight
					Text
					{
						id:textitem
						color: "white"
						text: modelData.name
						width: parent.width - 40	//##
						font.pixelSize: fontsizesmall
						font.weight: (parent.isCurrentItem ? Font.Bold: Font.Light)
						anchors.centerIn: parent
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
		Rectangle	/////////////////////////////// page 2
		{
			width: window.width
			height: window.height
			color: "transparent"
			Column
			{
				anchors.fill: parent
				anchors.margins: 10
				ListModel { id: resultsList }
				Rectangle	// page indicator
				{
					id: header2
//					anchors.top: parent.top
					width: parent.width
					height: statusmargin
					color: "transparent"
					Text
					{
						anchors { right: parent.right; rightMargin: bulletwidth / 2 }
						anchors.verticalCenter: parent.verticalCenter
						text: "SpeedCrunch"
						font.pixelSize: fontsizebig
						color: Theme.highlightColor
					}
				}
//				Rectangle { height: 100 }	// margin
				Rectangle	// history list
				{
//					anchors.topMargin: 100
//					anchors.bottomMargin: 100
					height: historyheight
					width: parent.width
					color: "transparent"
					ListView
					{
						clip: true
						id: resultsview
						snapMode: "SnapOneItem"
						height: parent.height
						width: parent.width
						model: resultsList
						delegate: Rectangle
						{
							property bool isCurrentItem: ListView.isCurrentItem
							color: "transparent"
							width: parent.width
							height: lineheight
							Text
							{
								id: resultitem
								color: "white"
								text: model.text
								width: parent.width - 40	//##
								font.pixelSize: fontsizesmall
								font.weight: (parent.isCurrentItem ? Font.Bold: Font.Light)
								anchors.centerIn: parent
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
				Item	// result line
				{
					width: parent.width
					height: resultheight
					Text	// autocalc result, currently just empty placeholder
					{
						id: result
//						text: "xxx"
//						color: "yellow"
						font.pixelSize: fontsizesmall * 2 / 3
						width: parent.width
						anchors { left: parent.left; leftMargin: buttonmargin * 2 }
						anchors.verticalCenter: parent.verticalCenter
					}
				}
				Item	// edit line
				{
					width: parent.width
					height: textfield.height
					TextField	// edit field
					{
						id: textfield
						anchors.left: parent.left
						anchors.right: cleartext.left
						inputMethodHints:  Qt.ImhPreferNumbers
						placeholderText: "expression"
						softwareInputPanelEnabled: false
						Keys.onReturnPressed: { evaluate(); }
						onClicked:
						{
							textfield.softwareInputPanelEnabled = true
//							parent.forceActiveFocus()
							textfield.forceActiveFocus()
//							InputMethod.show()
						}
						onFocusChanged:		// keep focus after keyboard close
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
						anchors { right: evaluatebutton.left; rightMargin: buttonmargin }
						anchors.verticalCenter: evaluatebutton.verticalCenter
						fillMode: Image.PreserveAspectFit
						smooth: true;
						visible: textfield.text
						source: "clear.png"		//## too small in xperia
						height: buttonheight
						width: buttonwidth / 2
						MouseArea
						{
							id: cleararea
							anchors.fill: parent
							anchors.margins: -10
							onClicked:
							{
								textfield.text = ""
								textfield.forceActiveFocus()
							}
						}
					}
					Button	// evaluate button
					{
						id: evaluatebutton
						text: "="
						anchors { top: textfield.top; topMargin: buttonmargin }
						anchors.right: parent.right
						width: buttonwidth
						onClicked: { evaluate(); }
					}
				}
				Pager	// keyboard pager
				{
					id: keyboard
					isHorizontal: true
					color: "transparent"
					enableKeys: false
					focus: false

					anchors.top: textfield.bottom
//					anchors.bottom: footer.top

					startIndex: -1
					indicator: footer
					width: parent.width
					height: keyboardheight - statusmargin
					spacing: buttonmargin
					model: VisualItemModel
					{
						Grid	// Page 1
						{
							rows: buttonrows
							columns: buttoncolumns
							width: parent.parent.width
							height: parent.parent.height
							spacing: parent.parent.spacing

	CalcButton { text: "7" } CalcButton { text: "8" } CalcButton { text: "9" } CalcButton { text: "+" } Backspace { }
	CalcButton { text: "4" } CalcButton { text: "5" } CalcButton { text: "6" } CalcButton { text: "-" } CalcButton { text: "(" }
	CalcButton { text: "1" } CalcButton { text: "2" } CalcButton { text: "3" } CalcButton { text: "*" } CalcButton { text: ")" }
	CalcButton { text: "." } CalcButton { text: "0" } CalcButton { text: "000" } CalcButton { text: "/" } CalcButton { text: "^" }

						}
						Grid	// Page 2
						{
							rows: buttonrows
							columns: buttoncolumns
							width: parent.parent.width
							height: parent.parent.height
							spacing: parent.parent.spacing

	CalcButton { text: "sin"; isFunction: true } CalcButton { text: "cos"; isFunction: true } CalcButton { text: "tan"; isFunction: true }
		CalcButton { text: "pi"} Backspace { }
	CalcButton { text: "asin"; isFunction: true } CalcButton { text: "acos"; isFunction: true } CalcButton { text: "atan"; isFunction: true }
		CalcButton { text: "√"; value: "sqrt()" } CalcButton { image: "cube_root.png"; /*text: "∛"; */ value:"^(1/3)"; onCallback: { textfield.cursorPosition -= 3 } }
	CalcButton { text: "(" } CalcButton { text: "!" } CalcButton { text: "e" } CalcButton { text: "%" } CalcButton { text: ")" }
	CalcButton { text: "x=" } CalcButton { text: "home"; special: true;	onRunFunction: textfield.cursorPosition = 0 }
		CalcButton { text: "←"; special: true; onRunFunction: { textfield.cursorPosition-- } }
		CalcButton { text: "→"; special: true; onRunFunction: { textfield.cursorPosition++ } }
		CalcButton { text: "end"; special: true; onRunFunction: { textfield.cursorPosition = textfield.text.length } }

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
			Row		// footer
			{
				id: footer
				spacing: bulletwidth / 2
				anchors.bottom: parent.bottom
				anchors { left: parent.left; leftMargin: spacing }
				height: statusmargin
				Switch
				{
					width: bulletwidth
					anchors.verticalCenter: parent.verticalCenter
					onClicked: keyboard.goToPage(0)
				}
				Switch
				{
					width: bulletwidth
					anchors.verticalCenter: parent.verticalCenter
					onClicked: keyboard.goToPage(1)
				}
			}
		}
		Rectangle	/////////////////////////////// page 3
		{
			width: window.width
			height: window.height
			color: "transparent"
			Column
			{
				anchors.fill: parent
//				spacing: buttonmargin
				Rectangle
				{
					id: header3
					anchors.top: parent.top
					width: parent.width
					height: statusmargin
					color: "transparent"
					Text
					{
						anchors { right: parent.right; rightMargin: bulletwidth / 2 }
						anchors.verticalCenter: parent.verticalCenter
						text: "Settings"	//%%
						font.pixelSize: fontsizebig
						color: Theme.highlightColor
					}
				}
				Rectangle
				{
					id: angleunitsetting
					color: "transparent"
					anchors.top: header3.bottom
					width: parent.width
					height: settingheight
					z: 20
					ComboBox
					{
						id: angleunitlist
						label: "Angle Unit"		//%%
						menu: ContextMenu
						{
							MenuItem { text: "Degree" }		//%%
							MenuItem { text: "Radian" }		//%%
//							MenuItem { text: "Gradian" }	//%%
						}
						onCurrentIndexChanged:
						{
							if ( currentIndex == 0 ) { manager.setAngleMode("d") }
							else if ( currentIndex == 1 ) { manager.setAngleMode("r") }
//							else if ( currentIndex == 2 ) { manager.setAngleMode("g") }
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
					id: precisionsetting
					color: "transparent"
					anchors.top: angleunitsetting.bottom
					width: parent.width
					height: settingheight
					z: 10
					ComboBox
					{
						id: precisionlist
						label: "Precision"	//%%
						menu: ContextMenu
						{
							MenuItem { text: "Automatic" }	//%%
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
					color: "transparent"
					anchors.top: precisionsetting.bottom
					width: parent.width
					height: settingheight
					TextSwitch
					{
						id: expressionswitch
						checked: true
						text: "Leave Last Expression"	//%%
//						description: "Leave Last Expression"
					}
				}
				Rectangle
				{
					id: historysetting
					color: "transparent"
					anchors.top: decimalsetting.bottom
					width: parent.width
					height: settingheight
					TextSwitch
					{
						id: historyswitch
						checked: true
						text: "Save History on Exit"	//%%
//						description: "Save History on Exit"
					}
				}
*/
				Text
				{
					id: helptitle
					text: "Tips:"
					width: parent.width
					color: "white"
					font.pixelSize: fontsizesmall
					anchors { left: parent.left; leftMargin: helpmargin }
					anchors.top: precisionsetting.bottom
				}
				Column
				{
					anchors { top: helptitle.bottom; topMargin: 20 }
					spacing: buttonmargin
					Text
					{
						text: "Swipe left/right on the keypad for more functions."
						color: "white"
						width: parent.width - (helpmargin * 3)
						font.pixelSize: fontsizetiny
						wrapMode: Text.WordWrap
						anchors.horizontalCenter: parent.horizontalCenter
					}
					Text
					{
						text: "Tap on the expression twice to edit it with the full\nkeyboard, for advanced formulas."
						color: "white"
						width: parent.width - (helpmargin * 3)
						font.pixelSize: fontsizetiny
						wrapMode: Text.WordWrap
						anchors.horizontalCenter: parent.horizontalCenter
					}
					Text
					{
						text: "When you want to go back to basic mode,\nslide the keyboard down."
						width: parent.width - (helpmargin * 3)
						font.pixelSize: fontsizetiny
						wrapMode: Text.WordWrap
						color: "white"
						anchors.horizontalCenter: parent.horizontalCenter
					}
					Text
					{
						text: "Tap on any function in the functions page to insert\nit to the running expression."
						color: "white"
						width: parent.width - (helpmargin * 3)
						font.pixelSize: fontsizetiny
						wrapMode: Text.WordWrap
						anchors.horizontalCenter: parent.horizontalCenter
					}
					Text
					{
						text: "Tap on any result on the history to insert\nresult value to the running expression."
						width: parent.width - (helpmargin * 3)
						font.pixelSize: fontsizetiny
						wrapMode: Text.WordWrap
						color: "white"
						anchors.horizontalCenter: parent.horizontalCenter
					}
					Text
					{
						text: "Tap and hold on any result expression on the history\nto replace the running expression with it."
						width: parent.width - (helpmargin * 3)
						font.pixelSize: fontsizetiny
						wrapMode: Text.WordWrap
						color: "white"
						anchors.horizontalCenter: parent.horizontalCenter
					}
				}
			}
		}
	}

	Component.onCompleted:
	{
		textfield.softwareInputPanelEnabled = false
		textfield.forceActiveFocus()

		angleunitlist.setAngleUnit(manager.getAngleMode())
		precisionlist.setPrecision(manager.getPrecision())
	}

	function evaluate()
	{
		if ( textfield.text != "" )
		{
			window.latestResultExpr = textfield.text
//			result.text = textfield.text
			if ( manager.calculate(textfield.text) !== "" )
			{
				window.latestResult = manager.calculate(textfield.text);
				resultsList.append({"text": textfield.text + " = " + manager.calculate(textfield.text), "value" : manager.calculate(textfield.text), "steps" : textfield.text})
			}
			else
			{
				window.latestResult = "";
				resultsList.append({"text": textfield.text, "value" : textfield.text, "steps": textfield.text})
			}
			resultsview.positionViewAtEnd()
			resultsview.currentIndex = resultsview.count - 1
			textfield.text = ""
		}
	}
}
