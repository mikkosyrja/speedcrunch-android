import QtQuick 2.9
import QtQuick.Controls 2.3

Rectangle
{
	property int buttoncols: 10
	property int buttonrows: 3
	property var buttonobjects: []

	property int swipecount: 1
	property int swipeindex: 0

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
	}

	function setButtonLabels()
	{
/*
		var format = manager.getResultFormat()
		if ( format === "h" )
		{
			button1.text = "1 A"; button2.text = "2 B"; button3.text = "3 C"
			button4.text = "4 D"; button5.text = "5 E"; button6.text = "6 F"
		}
		else
		{
			button1.text = "1"; button2.text = "2"; button3.text = "3"
			button4.text = "4"; button5.text = "5"; button6.text = "6"
		}
		if ( format === "h" || format === "b" || format === "o" )
			buttonbase.text = "0x 0b"
		else
			buttonbase.text = "0x"
		if ( manager.getComplexNumber() !== "d" )
			button9.text = "9 j"
		else
			button9.text = "9"
*/
	}
}
