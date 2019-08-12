import QtQuick 2.9
import QtQuick.Controls 2.3

Rectangle
{
	property int buttoncols: 5
	property int buttonrows: 5
	property var buttonobjects: [[], []]

	property int swipecount: swipe.count
	property int swipeindex: swipe.currentIndex
	property alias interactive: swipe.interactive

	clip: true
	color: backgroundcolor

	SwipeView
	{
		id: swipe
		anchors.fill: parent
		Page
		{
			Rectangle
			{
				anchors.fill: parent
				color: backgroundcolor
				Grid
				{
					id: leftpanel
					anchors { fill: parent; margins: itemspacing }
					columns: buttoncols
					spacing: itemspacing
				}
			}
		}
		Page
		{
			Rectangle
			{
				anchors.fill: parent
				color: backgroundcolor
				Grid
				{
					id: rightpanel
					anchors { fill: parent; margins: itemspacing }
					columns: buttoncols
					spacing: itemspacing
				}
			}
		}
	}

	Component.onCompleted:
	{
//		goToPage(0);
	}

	function loadButtons()
	{
		var row, col, index, script
		var size = manager.getKeyboardSize("leftpad")
		buttoncols = size.width
		buttonrows = size.height

		for ( index = 0; index < buttonobjects[0].length; ++index )
			buttonobjects[0][index].destroy()
		buttonobjects[0].length = 0
		for ( index = 0; index < buttonobjects[1].length; ++index )
			buttonobjects[1][index].destroy()
		buttonobjects[1].length = 0

		for ( row = 0; row < buttonrows; ++row )
		{
			for ( col = 0; col < buttoncols; ++col )
			{
				script = manager.getKeyScript("leftpad", row, col)
				buttonobjects[0].push(Qt.createQmlObject(script, leftpanel));
				script = manager.getKeyScript("rightpad", row, col)
				buttonobjects[1].push(Qt.createQmlObject(script, rightpanel));
			}
		}

		script = manager.getKeyScript("editkey", 0, 0)
		var editbutton = Qt.createQmlObject(script, leftpanel);
		evaluatebutton.text = editbutton.text
		evaluatebutton.value = editbutton.value
		evaluatebutton.second = editbutton.second
		editbutton.destroy()
	}
}
