import QtQuick 2.9
import QtQuick.Controls 2.3

ApplicationWindow
{
	property string latestExpression: ""
	property string latestResult: ""

	property string backgroundcolor: "lightGray"
	property string settingscolor: "silver"
	property bool landscape: height < width

	property int fontsize: (height / (landscape ? 24 : 36))
	property int fontsizelist: fontsize
	property int lineheight: fontsizelist * 1.5
	property int cornerradius: 3
	property int itemspacing: 5

	property alias history: calculator.history
	property alias editor: calculator.editor
	property alias keyboard: calculator.keyboard

	id: window
	visible: true
	color: backgroundcolor
	title: qsTr("Tabs")

	header: Row
	{
		width: parent.width; height: fontsize * 3
		Rectangle
		{
			width: fontsize * 4; height: parent.height
			color: backgroundcolor
			PageIndicator
			{
				id: pageindicator
				anchors.fill: parent
//				verticalCenter: parent.verticalCenter
				count: swipe.count
				currentIndex: swipe.currentIndex
/*
				interactive: true
				onCurrentIndexChanged:
				{
					swipe.currentIndex = currentIndex
				}
*/
			}
		}
		Rectangle
		{
			width: parent.width - pageindicator.width - menuButton.width
			height: parent.height
			color: backgroundcolor
			Label
			{
				anchors	{ fill: parent; margins: itemspacing }
				horizontalAlignment: Text.AlignRight
				verticalAlignment: Text.AlignVCenter
				text: "SpeedCrunch"
				font { pixelSize: fontsize * 1.5 }
			}
		}
		Rectangle
		{
			id: menuButton
			width: parent.height; height: parent.height
			color: backgroundcolor
			Button
			{
				anchors	{ fill: parent; margins: 5 }
				background: Rectangle { radius: cornerradius }
				font { pixelSize: fontsize * 2 }
				text: "\u2261"
				onClicked:
				{
					if ( menu.opened )
						menu.close()
					else
						menu.open()
				}
				Menu
				{
					id: menu
					y: menuButton.height - itemspacing
					closePolicy : Popup.NoAutoClose | Popup.CloseOnPressOutsideParent

					MenuItem
					{
						text: qsTr("Copy result")
						onTriggered: { manager.setClipboard(latestResult) }
					}
					MenuItem
					{
						text: qsTr("Copy expression")
						onTriggered: { manager.setClipboard(latestExpression + " = " + latestResult) }
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
	}

	SwipeView
	{
		id: swipe
		anchors.fill: parent
		currentIndex: 1

		Functions { id: functions }
		Calculator { id: calculator }
		Settings { id: settings }

		onCurrentIndexChanged:
		{
			if ( currentIndex == 0 )
			{
				if ( functions.needsupdate )
				{
					functions.updateFunctions()
					functions.needsupdate = false
				}
				functions.setDefaultFocus()
			}
			else if ( currentIndex == 1 )
				calculator.setDefaultFocus()
		}
	}

	footer: Row
	{
		width: parent.width; height: fontsize * 1.5
		Rectangle
		{
			width: fontsize * 4; height: parent.height
			color: backgroundcolor
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
			width: parent.width - keyboardindicator.width
			height: parent.height
			color: backgroundcolor
			Label
			{
				anchors	{ fill: parent; margins: 10 }
				horizontalAlignment: Text.AlignHCenter
				verticalAlignment: Text.AlignVCenter
				text: qsTr("Status bar")
				font { pixelSize: fontsize }
			}
		}
	}
}
