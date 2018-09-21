import QtQuick 2.9
import QtQuick.Controls 2.3

ApplicationWindow
{
	property string latestExpression: ""
	property string latestResult: ""

	property string backgroundcolor: "lightGray"
	property string settingscolor: "silver"
	property bool landscape: height < width
	property bool oneclickinsert: false

	property int fontsize: (height / (landscape ? 24 : 36))
	property int fontsizelist: fontsize
	property int fontsizemenu: fontsize * 1.3
	property int lineheight: fontsizelist * 1.5
	property int menuheight: fontsizemenu * 2

//	property int buttoncols: landscape ? 10 : 5
//	property int buttonrows: landscape ? 4 : 5
	property int buttoncols: 5
	property int buttonrows: 5
	property int cornerradius: width / buttoncols / 15
	property int itemspacing: width / buttoncols / 15

	property alias functions: functions
	property alias history: calculator.history
	property alias editor: calculator.editor
	property alias keyboard: calculator.keyboard
	property alias settings: settings

	id: window
	visible: true
	color: backgroundcolor
	title: qsTr("Tabs")

	header: Row
	{
		width: parent.width; height: fontsize * 3
		Rectangle
		{
			width: fontsize * 5; height: parent.height; color: backgroundcolor
			PageIndicator
			{
				id: pageindicator
				anchors.fill: parent
				count: swipe.count
				currentIndex: swipe.currentIndex

				delegate: Rectangle
				{
					implicitWidth: parent.height / 3
					implicitHeight: parent.height / 3
					color: (index === pageindicator.currentIndex ? "dimgrey" : "silver")
					anchors.verticalCenter: parent.verticalCenter
					radius: width / 2
				}
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
				font.pixelSize: fontsize * 1.5
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
				font.pixelSize: fontsize * 2
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
					width: window.width / 2
					x: window.width / 2
					y: menuButton.height - itemspacing
					closePolicy : Popup.NoAutoClose | Popup.CloseOnPressOutsideParent

					MenuItem
					{
						text: qsTr("Copy result")
						height: menuheight
						font.pixelSize: fontsizemenu
						onTriggered: { manager.setClipboard(latestResult) }
					}
					MenuItem
					{
						text: qsTr("Copy expression")
						height: menuheight
						font.pixelSize: fontsizemenu
						onTriggered: { manager.setClipboard(latestExpression + " = " + latestResult) }
					}
					MenuItem
					{
						text: qsTr("Paste")
						height: menuheight
						font.pixelSize: fontsizemenu
						onTriggered:
						{
							var text = editor.text; var pos = editor.cursorPosition
							editor.text = text.substring(0, pos) + manager.getClipboard() + text.substring(pos, text.length)
							editor.cursorPosition = pos + value.length
						}
					}
//					MenuSeparator { }
					MenuItem
					{
						text: qsTr("Clear history")
						height: menuheight
						font.pixelSize: fontsizemenu
						onTriggered:
						{
							manager.clearHistory(-1)
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
}
