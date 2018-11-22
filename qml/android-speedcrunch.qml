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

	property real fontsize: (height / (landscape ? 24 : 36))
	property real fontscale: 1.0
	property real fontsizelist: fontsize * fontscale

	property int fontsizemenu: fontsize * 1.3
	property int lineheight: fontsizelist * 1.5
	property int menuheight: fontsizemenu * 2

	property int buttoncols: landscape ? 10 : 5
	property int buttonrows: landscape ? 3 : 5
	property int cornerradius: width / buttoncols / 15
	property int itemspacing: width / buttoncols / 15

	property alias functions: functions
	property alias history: calculator.history
	property alias editor: calculator.editor
	property alias keyboard: calculator.keyboard
	property alias settings: settings
	property alias interactive: swipe.interactive

	onLandscapeChanged: { history.updateHistory() }

	id: window
	visible: true
	color: backgroundcolor

	header: Row
	{
		width: parent.width; height: fontsize * 3
		Rectangle
		{
			id: titleindicator
			width: (keyboard.buttonwidth + itemspacing) * 2
			height: parent.height; color: backgroundcolor
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
			id: titlestatus
			width: (landscape ? (keyboard.buttonwidth + itemspacing) * 5 : 0);
			height: parent.height; color: backgroundcolor
			clip: true
			Label
			{
				id: resultformat
				width: parent.width * 3 / 5; height: parent.height
				anchors { bottom: parent.bottom; left: parent.left; leftMargin: itemspacing }
				verticalAlignment: Text.AlignVCenter
				font { pixelSize: fontsize }
				text: settings.resultformat
			}
			Label
			{
				id: angleunit
				width: parent.width * 2 / 5; height: parent.height
				anchors { bottom: parent.bottom; right: parent.right; rightMargin: itemspacing }
				verticalAlignment: Text.AlignVCenter
				font { pixelSize: fontsize }
				text: settings.angleunit
			}
		}
		Rectangle
		{
			width: parent.width - titleindicator.width - titlestatus.width - speedcrunch.width - menubutton.width
			height: parent.height; color: backgroundcolor
		}
		Rectangle
		{
			id: speedcrunch
			width: (keyboard.buttonwidth + itemspacing) * 3
			height: parent.height; color: backgroundcolor
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
			id: menubutton
			width: parent.height; height: parent.height
			color: backgroundcolor
			Button
			{
				anchors	{ fill: parent; margins: 5 }
				background: Rectangle { radius: cornerradius }
				font.pixelSize: fontsize * 2
				text: "\u2261"	// hamburger
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
					width: window.width * 2 / 3
					x: window.width / 3; y: menubutton.height - itemspacing
					closePolicy : Popup.NoAutoClose | Popup.CloseOnPressOutsideParent
					MenuItem
					{
						text: qsTrId("id-copy-result")
						height: menuheight; width: parent.width; font.pixelSize: fontsizemenu
						onTriggered: { manager.setClipboard(latestResult) }
					}
					MenuItem
					{
						text: qsTrId("id-copy-expression")
						height: menuheight; width: parent.width; font.pixelSize: fontsizemenu
						onTriggered: { manager.setClipboard(latestExpression + " = " + latestResult) }
					}
					MenuItem
					{
						text: qsTrId("id-paste")
						height: menuheight; width: parent.width; font.pixelSize: fontsizemenu
						onTriggered:
						{
							var text = editor.text; var pos = editor.cursorPosition
							editor.text = text.substring(0, pos) + manager.getClipboard() + text.substring(pos, text.length)
							editor.cursorPosition = pos + value.length
						}
					}
					MenuItem
					{
						text: qsTrId("id-clear-history")
						height: menuheight; width: parent.width; font.pixelSize: fontsizemenu
						onTriggered:
						{
							manager.clearHistory(-1)
							history.updateHistory()
						}
					}
					MenuSeparator { }
					MenuItem
					{
						text: "SpeedCrunch Android 0.3"
						height: menuheight; width: parent.width; font.pixelSize: fontsizemenu
						onTriggered: { Qt.openUrlExternally("https://openrepos.net/content/syrja/speedcrunch") }
					}
					MenuItem
					{
						text: "SpeedCrunch 0.12"
						height: menuheight; width: parent.width; font.pixelSize: fontsizemenu
						onTriggered: { Qt.openUrlExternally("http://speedcrunch.org/") }
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
