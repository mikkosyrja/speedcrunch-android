import QtQuick 2.9
import QtQuick.Controls 2.3

Page
{
	property int keyboardheight: (landscape ? parent.height * 3 / 5 : parent.height / 2)

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

				ListView
				{
					property int updatehistory: 0

					id: historyview
					anchors { fill: parent; margins: itemspacing }

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
//								font { pixelSize: fontsizesmall }
								font { pixelSize: fontsizesmall; weight: (historyview.currentItem == resultitem ? Font.Bold: Font.Light) }
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
					function updateHistory()
					{
						updatehistory++
						positionViewAtEnd()
						currentIndex = count - 1
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
						font { pixelSize: fontsizesmall }
						inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase;
						placeholderText: "expression"
						cursorVisible: true
//						softwareInputPanelEnabled: false
						Keys.onReturnPressed: { evaluate(); }
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
//							fillMode: Image.PreserveAspectFit
//							visible: textfield.text
						}
						MouseArea
						{
							id: cleararea
							anchors { fill: parent }
							onClicked:
							{
								textfield.text = "";
//								textfield.forceActiveFocus()
							}
						}
					}
					CalcButton
					{
						id: evaluatebutton
						width: keyboard.buttonwidth; height: keyboard.buttonheight
						text: "="
						special: true
						onRunFunction: { evaluate() }
					}
				}
			}
			Keyboard
			{
				id: keyboard
				width: parent.width; height: keyboardheight
			}
		}

		Component.onCompleted:
		{
//			textfield.softwareInputPanelEnabled = false
//			textfield.forceActiveFocus()
			historyview.updateHistory()
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
}
