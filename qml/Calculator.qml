import QtQuick 2.9
import QtQuick.Controls 2.3

Page
{
	property int keyboardheight: (landscape ? parent.height * 3 / 5 : parent.height * 2 / 5)

	property alias history: historyview
	property alias editor: textfield
	property alias keyboard: keyboard

	Rectangle
	{
		anchors.fill: parent
		color: backgroundcolor

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
//						y: historyview.currentItem.y
//						visible: false
					}
				}
				ListView
				{
					property int updatehistory: 0

					id: historyview
					anchors { fill: parent; margins: itemspacing }
					highlight: highlight
					highlightFollowsCurrentItem: false
					model: { eval(manager.getHistory(updatehistory)) }
					delegate: Component
					{
						Item
						{
							id: resultitem
							width: parent.width; height: lineheight
							Text
							{
								anchors.verticalCenter: parent.verticalCenter
								text: modelData.expression + " = " + modelData.value
								font { pixelSize: fontsizelist; weight: (historyview.currentItem == resultitem ? Font.Bold: Font.Light) }
							}
							MouseArea
							{
								anchors.fill: parent
								onClicked: insert()
								onPressAndHold: { textfield.text = modelData.expression }
							}
							function insert()
							{
								var text = textfield.text
								var pos = textfield.cursorPosition
								textfield.text = text.substring(0, pos) + modelData.value + text.substring(pos, text.length)
								textfield.cursorPosition = pos + modelData.value.length
							}
						}
					}
					Timer
					{
						id: historyviewtimer
						interval: 50; running: false; repeat: false
						onTriggered:
						{
							historyview.positionViewAtEnd()
							historyview.currentIndex = count - 1
						}
					}

					onCountChanged:
					{
						historyview.positionViewAtEnd()
						currentIndex = count - 1
					}
					function updateHistory()
					{
						updatehistory++
						currentIndex = count - 1
						positionViewAtEnd()
						manager.saveSession()
					}
				}
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
						font.pixelSize: fontsize
						inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase;
						placeholderText: "expression"
						cursorVisible: true
						Keys.onReturnPressed: { setDefaultFocus() }
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
							anchors { fill: parent }
							onClicked: { textfield.text = "" }
						}
					}
					CalcButton
					{
						id: evaluatebutton
						width: keyboard.buttonwidth; height: keyboard.buttonheight
						text: "="
						special: true
						onRunFunction: { evaluate(); setDefaultFocus() }
					}
				}
			}
			Keyboard
			{
				id: keyboard
				width: parent.width; height: keyboardheight
			}
			Component.onCompleted: { historyviewtimer.start() }
		}
	}
	footer: Row
	{
		width: parent.width; height: fontsize * 1.5
		Rectangle
		{
			width: keyboard.buttonwidth * 2 + itemspacing * 2; height: parent.height; color: backgroundcolor
			PageIndicator
			{
				id: keyboardindicator
				anchors.fill: parent
				count: keyboard.swipecount
				currentIndex: keyboard.swipeindex
			}
		}
		Rectangle
		{
			width: parent.width - keyboardindicator.width; height: parent.height; color: backgroundcolor
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
			var assign = manager.getAssignId()
			if ( result === "NaN" )
			{
				var error = manager.getError()
				if ( error.length )
				{
//					notification.previewSummary = "Evaluation error"
//					notification.previewBody = error
				}
				else if ( assign.length )
				{
					latestExpression = manager.autoFix(textfield.text)
					latestResult = ""
					historyview.updateHistory()
					functions.updateFunctions()
//					notification.previewSummary = "Function added"
//					notification.previewBody = ""
					textfield.text = ""
				}
//				notification.publish()
			}
			else
			{
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
		cleartext.forceActiveFocus()
		textfield.cursorVisible = true
	}
}
