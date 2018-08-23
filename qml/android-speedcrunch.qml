import QtQuick 2.9
import QtQuick.Controls 2.2

ApplicationWindow
{
	property string latestExpression: ""
	property string latestResult: ""

	property int fontsizesmall: window.height / 36
	property int lineheight: fontsizesmall * 1.5

	property alias history: calculator.history
	property alias editor: calculator.editor
	property alias keyboard: calculator.keyboard

	id: window
	visible: true
	title: qsTr("Tabs")

	header: Row
	{
		TabBar
		{
			id: tabbar
			width: parent.width - menuButton.width
			currentIndex: swipe.currentIndex

			font { pixelSize: fontsizesmall }

			TabButton { text: qsTr("Functions") }
			TabButton { text: qsTr("SpeedCrunch") }
			TabButton { text: qsTr("Settings") }
		}

		Button
		{
			id: menuButton
			width: tabbar.height; height: tabbar.height
			font { pixelSize: fontsizesmall * 2 }
			text: "\u2261"
			onClicked:
			{
//				if ( menu.opened )
//					menu.close()
//				else
					menu.open()
			}

			Menu
			{
				id: menu
				y: menuButton.height

				MenuItem
				{
					text: qsTr("Copy result")
					onTriggered: { manager.setClipboard(window.latestResult) }
				}
				MenuItem
				{
					text: qsTr("Copy expression")
					onTriggered: { manager.setClipboard(window.latestExpression + " = " + window.latestResult) }
				}
				MenuItem
				{
					text: qsTr("Paste")
					onTriggered:
					{
						var text = editor.text; var pos = editor.cursorPosition
						editor.text = text.substring(0, pos) + manager.getClipboard() + text.substring(pos, text.length)
						editor.cursorPosition = pos + value.length
					}
				}
				MenuItem
				{
					text: qsTr("Clear history")
					onTriggered:
					{
						manager.clearHistory()
						history.updateHistory()
					}
				}
			}
		}
	}

	SwipeView
	{
		id: swipe
		anchors.fill: parent
		currentIndex: tabbar.currentIndex

		Functions { id: functions }
		Calculator { id: calculator }
		Settings { id: settings }
	}

	footer: Page
	{
		id: statusbar
		font.pixelSize: fontsizesmall

		Label
		{
			text: qsTr("Status bar")
			anchors.centerIn: parent
		}
	}

	Component.onCompleted:
	{
//		functionlist.updatemodel++
	}
}
