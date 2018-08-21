import QtQuick 2.9
import QtQuick.Controls 2.2

Page
{
//	property int virtualkeyboardheight: Qt.inputMethod.keyboardRectangle.height
	property int virtualkeyboardheight: parent.height / 2
	property alias keyboard: keyboard

	Rectangle
	{
		anchors.fill: parent
		color: "lightGray"

		Column
		{
			anchors.fill: parent

			ListView
			{
				property int updatehistory: 0

				id: resultsview
				width: parent.width; height: parent.height - keyboard.height - editrow.height
				model: { eval(manager.getHistory(updatehistory)) }
/*
				delegate: Component
				{
					ListItem
					{
						id: resultitem
						contentHeight: lineheight
						onClicked: insert()
						Text
						{
							id:textitem
							width: parent.width - 40; color: "white"
							anchors.centerIn: parent
							text: modelData.expression + " = " + modelData.value
							font { pixelSize: fontsizesmall; weight: (parent.isCurrentItem ? Font.Bold: Font.Light) }
						}
						function insert()
						{
							var text = textfield.text
							var pos = textfield.cursorPosition
							textfield.text = text.substring(0, pos) + modelData.value + text.substring(pos, text.length)
							textfield.cursorPosition = pos + modelData.value.length
						}
						onPressAndHold: { textfield.text = modelData.expression }
					}
				}
*/
				function updateHistory()
				{
					resultsview.updatehistory++
					resultsview.positionViewAtEnd()
					resultsview.currentIndex = resultsview.count - 1
				}
			}
/*
			Rectangle
			{
				id: history
				width: parent.width
				height: parent.height / 2 - editrow.height
				color: "lightGray"

				Label
				{
					text: qsTr("You are on Page 2.")
					anchors.centerIn: parent
				}
			}
*/
			Rectangle
			{
				id: editrow
				width: parent.width; height: keyboard.buttonheight + keyboard.keyspacing * 2
				color: "darkGray"
				Row
				{
					anchors { left: parent.left; right: parent.right }
					leftPadding: keyboard.keyspacing; topPadding: keyboard.keyspacing
					spacing: keyboard.keyspacing

					TextField
					{
						id: textfield
						width: parent.width - evaluatebutton.width - cleartext.width - keyboard.keyspacing * 4
						height: keyboard.buttonheight
						inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase;
						placeholderText: "expression"
//						softwareInputPanelEnabled: false
						Keys.onReturnPressed: { evaluate(); }
					}
					Rectangle
					{
						id: cleartext
						width: keyboard.buttonheight; height: keyboard.buttonheight
						color: "darkGray"
						Image
						{
							width: keyboard.buttonheight / 2; height: keyboard.buttonheight / 2
							anchors.centerIn: parent
							source: "clear.png"
//							fillMode: Image.PreserveAspectFit
//							visible: textfield.text
							MouseArea
							{
								id: cleararea
								anchors { fill: parent }
								onClicked:
								{
									textfield.text = "";
//									textfield.forceActiveFocus()
								}
							}
						}
					}
					CalcButton
					{
						id: evaluatebutton
						width: keyboard.buttonwidth; height: keyboard.buttonheight
						text: "="
						onClicked: { evaluate(); }
					}
				}
			}
			Keyboard
			{
				id: keyboard
				width: parent.width; height: virtualkeyboardheight
			}
		}

		Component.onDestruction: { manager.saveSession(); }
	}

	function evaluate()
	{
		if ( textfield.text != "" )
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
					functionlist.updatemodel++
					window.latestExpression = manager.autoFix(textfield.text)
					window.latestResult = ""
					resultsview.updateHistory()
//					notification.previewSummary = "Function added"
//					notification.previewBody = ""
					textfield.text = ""
				}
//				notification.publish()
			}
			else
			{
				window.latestExpression = manager.autoFix(textfield.text)
				window.latestResult = result
				resultsview.updateHistory()
				textfield.text = ""
				if ( assign.length )
					functionlist.updatemodel++
			}
		}
	}
}
