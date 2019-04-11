import QtQuick 2.9
import QtQuick.Controls 2.3

Rectangle
{
	property int buttoncols: 5
	property int buttonrows: 5

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
/*
					CalcButton { text: "("; color: Theme.highlightColor } CalcButton { text: ")"; color: Theme.highlightColor }
					CalcButton { text: "←"; special: true; color: Theme.highlightColor; onRunFunction: { textfield.cursorPosition-- } }
					CalcButton { text: "→"; special: true; color: Theme.highlightColor; onRunFunction: { textfield.cursorPosition++ } }
					Backspace { color: Theme.highlightColor }
*/
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
/*
					CalcButton { text: "("; color: Theme.highlightColor } CalcButton { text: ")"; color: Theme.highlightColor }
					CalcButton { text: "←"; special: true; color: Theme.highlightColor; onRunFunction: { textfield.cursorPosition-- } }
					CalcButton { text: "→"; special: true; color: Theme.highlightColor; onRunFunction: { textfield.cursorPosition++ } }
					Backspace { color: Theme.highlightColor }
*/
				}
			}
		}
	}

	Component.onCompleted:
	{
		var row, col, script
		for ( row = 0; row < buttonrows; ++row )
		{
			for ( col = 0; col < buttoncols; ++col )
			{
				script = manager.getKeyScript("leftpad", row, col)
				Qt.createQmlObject(script, leftpanel);
				script = manager.getKeyScript("rightpad", row, col)
				Qt.createQmlObject(script, rightpanel);
			}
		}

//		goToPage(0);
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
