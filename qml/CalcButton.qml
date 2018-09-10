import QtQuick 2.9
import QtQuick.Controls 2.3

Button
{
	signal runFunction

	property bool special: false
	property string value: text
	property string secondary: value
	property string image: ""

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

	onClicked:
	{
		if ( special )
			runFunction();
		else
			insertValue(value)
	}
	onPressAndHold:
	{
		if ( text == "←" )
			textfield.cursorPosition = 0
		else if ( text == "→" )
			textfield.cursorPosition = textfield.text.length
		else
			insertValue(secondary)
	}
}
