import QtQuick 2.9
import QtQuick.Controls 2.3

Rectangle
{
	property int buttoncols: 10
	property int buttonrows: 3
	property var buttonobjects: []

	property int swipecount: 1
	property int swipeindex: 0

	property bool virtualkeys: true

	clip: true
	color: backgroundcolor

	Grid
	{
		id: panel
		anchors { fill: parent; margins: itemspacing }
		columns: buttoncols
		spacing: itemspacing
	}

	function loadButtons()
	{
		var row, col, index, script
		var size = manager.getKeyboardSize("landscape")
		buttoncols = size.width
		buttonrows = size.height

		for ( index = 0; index < buttonobjects.length; ++index )
			buttonobjects[index].destroy()
		buttonobjects.length = 0

		for ( row = 0; row < buttonrows; ++row )
		{
			for ( col = 0; col < buttoncols; ++col )
			{
				script = manager.getKeyScript("landscape", row, col)
				buttonobjects.push(Qt.createQmlObject(script, panel));
			}
		}

		virtualkeys = manager.getVirtualKeyboard("landscape")
	}
}
