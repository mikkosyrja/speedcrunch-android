import QtQuick 2.9
import QtQuick.Controls 2.3

Button
{
	signal runFunction

	property bool special
	property bool highlight
	property string value: text
	property string second: value
	property string image: (value == "<back>" ? "back.png" : (value == "cbrt()" ? "cuberoot.png" : ""))

	width: parent.width / buttoncols - parent.spacing + parent.spacing / buttoncols
	height: parent.height / buttonrows - parent.spacing + parent.spacing / buttonrows
	background: Rectangle { radius: cornerradius }
	font.pixelSize: fontsize * 1.3

	Image
	{
		width: parent.width / 2; height: parent.height / 2
		anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }
		fillMode: Image.PreserveAspectFit
		visible: image.length
		source: image
	}

	function insertValue(value)
	{
		var pos = textfield.cursorPosition
		if ( textfield.selectionStart - textfield.selectionEnd != 0 )
		{
			var firstpart = textfield.text.slice(0, textfield.selectionStart);
			var lastpart = textfield.text.slice(textfield.selectionEnd);
			textfield.text = firstpart + value + lastpart
		}
		else
			textfield.text = textfield.text.slice(0, pos) + value + textfield.text.slice(pos)
		textfield.cursorPosition = pos + value.length
		if ( value.slice(-2) === "()" )
			textfield.cursorPosition--
	}

	function backspace()
	{
		var pos = textfield.cursorPosition;
		if ( textfield.text == "" || pos == 0 )
			return;
		if ( textfield.selectionStart - textfield.selectionEnd != 0 )
		{
			var firstpart = textfield.text.slice(0, textfield.selectionStart);
			var lastpart = textfield.text.slice(textfield.selectionEnd);
			textfield.text = firstpart + lastpart
		}
		else
		{
			textfield.text = textfield.text.slice(0, pos - 1) + textfield.text.slice(pos)
			textfield.cursorPosition = pos - 1
		}
	}

	MouseArea
	{
		anchors { fill: parent }
		onPressed: { window.interactive = false; keyboard.interactive = false }
		onReleased: { window.interactive = true; keyboard.interactive = true }
		onExited: { window.interactive = true; keyboard.interactive = true }
		onCanceled: { window.interactive = true; keyboard.interactive = true }
		onClicked:
		{
			if ( value == "<left>" )
				textfield.cursorPosition--
			else if ( value == "<right>" )
				textfield.cursorPosition++
			else if ( value == "<back>" )
				parent.backspace()
			else if ( value == "<evaluate>" )
			{
				evaluate()
				setDefaultFocus()
			}
			else
				parent.insertValue(value)
		}
		onPressAndHold:
		{
			if ( value == "<left>" )
				textfield.cursorPosition = 0
			else if ( value == "<right>" )
				textfield.cursorPosition = textfield.text.length
			else
				parent.insertValue(second)
		}
	}
}
