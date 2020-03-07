import QtQuick 2.9
import QtQuick.Controls 2.3

Page
{
	property int keyboardheight: parent.height * (landscape ? 13 : 9) * keyboard.buttonrows / 100
	property string notification: ""

	property alias history: historyview
	property alias editor: textfield
	property alias keyboard: keyboard
	property alias textfield: textfield

	Rectangle
	{
		anchors.fill: parent
		color: backgroundcolor
		Timer
		{
			id: historytimer
			interval: 250; running: false; repeat: false
			onTriggered: { historyview.updateHistory() }
		}
		Column
		{
			anchors.fill: parent
			Rectangle
			{
				width: parent.width; height: parent.height - keyboard.height - editrow.height
				color: backgroundcolor
				clip: true
				Component
				{
					id: highlight
					Rectangle
					{
						width: parent.width; height: lineheight
						color: "lightsteelblue"; radius: cornerradius
						y: historyview.currentItem.y
					}
				}
				ListView
				{
					property int updatehistory: 0
					id: historyview
					anchors { fill: parent; margins: itemspacing }
					snapMode: "SnapToItem"
					highlight: highlight; highlightFollowsCurrentItem: false
					model: { eval(manager.getHistory(updatehistory)) }
					delegate: Component
					{
						Item
						{
							id: historyitem
							width: parent.width; height: lineheight
							Text
							{
								anchors.verticalCenter: parent.verticalCenter
								text: modelData.expression + " = " + modelData.value
								font { pixelSize: fontsizelist; weight: (index === historyview.count - 1 ? Font.Bold: Font.Light) }
							}
							MouseArea
							{
								property bool acceptclic: false
								anchors.fill: parent
								Timer
								{
									id: highlighttimer
									interval: 100; running: false; repeat: false
									onTriggered: { historyview.currentIndex = index }
								}
								onClicked:
								{
									if ( oneclickinsert )
										insertitem()
									else
									{
										historyview.currentIndex = -1
										if ( popupmenu.opened )
											popupmenu.close()
									}
								}
								onPressed:
								{
									acceptclic = true
									highlighttimer.start()
									Qt.inputMethod.hide()
								}
								onPositionChanged:
								{
									acceptclic = false
									highlighttimer.stop()
									historyview.currentIndex = -1
								}
								onReleased:
								{
									highlighttimer.stop()
									historyview.currentIndex = -1
								}
								onPressAndHold:
								{
									historyview.currentIndex = -1
									popupmenu.open()
								}
							}
							Menu
							{
								id: popupmenu
								modal: true
								y: historyitem.height; width: parent.width
								closePolicy : Popup.NoAutoClose | Popup.CloseOnPressOutside
								MenuItem
								{
									text: qsTrId("id-insert-item") + " " + modelData.value;
									height: menuheight; font.pixelSize: fontsizemenu
									onTriggered: insertitem()
								}
								MenuItem
								{
									text: qsTrId("id-edit-item") + " " + modelData.expression
									height: menuheight; font.pixelSize: fontsizemenu
									onTriggered: { textfield.text = modelData.expression }
								}
								MenuItem
								{
									text: qsTrId("id-remove-from-history")
									height: menuheight; font.pixelSize: fontsizemenu
									onTriggered: removeHistory()
								}
							}
							function removeHistory()
							{
								manager.clearHistory(index)
								historyview.updateHistory()
							}
							function insertitem()
							{
								var text = textfield.text
								var pos = textfield.cursorPosition
								textfield.text = text.substring(0, pos) + modelData.value + text.substring(pos, text.length)
								textfield.cursorPosition = pos + modelData.value.length
							}
						}
					}
					function updateHistory()
					{
						updatehistory++
						currentIndex = -1
						positionViewAtEnd()
						manager.saveSession()
					}
				}
				Component.onCompleted: { historyview.currentIndex = -1 }
			}
			Rectangle
			{
				id: editrow
				width: parent.width; height: keyboard.buttonheight + itemspacing * 2
				color: backgroundcolor
				Row
				{
					anchors { left: parent.left; right: parent.right }
					leftPadding: itemspacing; topPadding: itemspacing
					spacing: itemspacing

					TextField
					{
						id: textfield
						width: parent.width - evaluatebutton.width - cleartext.width - itemspacing * 4
						height: keyboard.buttonheight
						background: Rectangle { radius: cornerradius; color: settingscolor }
						font.pixelSize: fontsizeedit
						inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase;
						placeholderText: qsTrId("id-expression")
						cursorVisible: true
						ToolTip
						{
							parent: textfield
							x: parent.x
							font.pixelSize: fontsizelist
							closePolicy: Popup.NoAutoClose
							visible: (swipe.currentIndex === 1 && notification !== "" && textfield.text !== "")
							text: notification
						}
						onTextChanged:
						{
							var result = manager.autoCalc(text);
							if ( result !== "NaN" )
								notification = "= " + result
							else
								notification = manager.getError()
						}
						Keys.onReturnPressed:
						{
							evaluate()
							setDefaultFocus()
						}
					}
					Rectangle
					{
						id: cleartext
						width: keyboard.buttonheight; height: keyboard.buttonheight
						color: backgroundcolor
						Image
						{
							width: keyboard.buttonheight / 2; height: keyboard.buttonheight / 2
							anchors.centerIn: parent
							source: "clear.png"
						}
						MouseArea
						{
							id: cleararea
							anchors.fill: parent
							onPressed: { window.interactive = false; keyboard.interactive = false }
							onReleased: { window.interactive = true; keyboard.interactive = true }
							onExited: { window.interactive = true; keyboard.interactive = true }
							onCanceled: { window.interactive = true; keyboard.interactive = true }
							onClicked: { textfield.text = "" }
						}
					}
					CalcButton
					{
						id: evaluatebutton
						width: keyboard.buttonwidth; height: keyboard.buttonheight
						text: "="; value: "<evaluate>"; second: "ans"
					}
				}
			}
			Rectangle
			{
				property int buttoncols: landscape ? landscapekeyboard.buttoncols : portraitkeyboard.buttoncols
				property int buttonrows: landscape ? landscapekeyboard.buttonrows : portraitkeyboard.buttonrows
				property int buttonwidth: (width - itemspacing) / buttoncols - itemspacing
				property int buttonheight: (keyboardheight - itemspacing) / buttonrows - itemspacing

				property alias swipecount: portraitkeyboard.swipecount
				property alias swipeindex: portraitkeyboard.swipeindex
				property alias interactive: portraitkeyboard.interactive

				id: keyboard
				width: parent.width; height: keyboardheight

				Keyboard { id: portraitkeyboard; anchors.fill: parent; visible: !landscape }
				Landscape { id: landscapekeyboard; anchors.fill: parent; visible: landscape }

				function loadButtons()
				{
					portraitkeyboard.loadButtons()
					landscapekeyboard.loadButtons()
				}
			}
			Component.onCompleted:
			{
				historytimer.start()
				setDefaultFocus()
			}
		}
	}
	footer: Row
	{
		width: parent.width; height: fontsize * 1.5
		visible: !landscape
		Rectangle
		{
			width: keyboard.buttonwidth * 2 + itemspacing * 2; height: parent.height; color: backgroundcolor
			PageIndicator
			{
				id: keyboardindicator
				anchors.fill: parent
				count: keyboard.swipecount
				currentIndex: keyboard.swipeindex
				delegate: Rectangle
				{
					implicitWidth: parent.height * 0.8
					implicitHeight: parent.height * 0.8
					color: (index === keyboardindicator.currentIndex ? "dimgrey" : "silver")
					anchors.verticalCenter: parent.verticalCenter
					radius: width / 2
				}
			}
		}
		Rectangle
		{
			width: parent.width - keyboardindicator.width; height: parent.height; color: backgroundcolor
			clip: true
			Label
			{
				id: resultformat
				width: keyboard.buttonwidth * 2; height: parent.height
				anchors { bottom: parent.bottom; left: parent.left; leftMargin: itemspacing }
				verticalAlignment: Text.AlignVCenter
				font { pixelSize: fontsize }
				text: settings.resultformat
			}
			Label
			{
				id: angleunit
				width: keyboard.buttonwidth; height: parent.height
				anchors { bottom: parent.bottom; right: parent.right; rightMargin: itemspacing }
				verticalAlignment: Text.AlignVCenter
				font { pixelSize: fontsize }
				text: settings.angleunit
			}
		}
	}
	function evaluate()
	{
		if ( textfield.text !== "" )
		{
			var result = manager.calculate(textfield.text)
			if ( result === "NaN" )
				notification = manager.getError()
			else
			{
				var assign = manager.getAssignId()
				latestExpression = manager.autoFix(textfield.text)
				latestResult = result
				historyview.updateHistory()
				textfield.text = ""
				if ( assign.length )
					functions.updateFunctions()
			}
		}
	}
	function setDefaultFocus()
	{
		Qt.inputMethod.hide()
		textfield.cursorVisible = true
		textfield.forceActiveFocus()
	}
}
