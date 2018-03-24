import QtQuick 2.2
import Sailfish.Silica 1.0

Button
{
	id: calcButton

	property bool special;
	signal runFunction
	signal callback
	property bool isFunction: false
	property string value: calcButton.text + (isFunction ? "()" : "")
	property string secondary: value
	property string image: ""

	implicitWidth: parent.width / parent.columns - parent.spacing * (parent.columns - 1) / parent.columns;

	Image
	{
		visible: image.length
		source: image
		anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }
	}

	text: " "

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
		if ( value.slice(-2) == "()" )
			textfield.cursorPosition--
		calcButton.callback();
	}

	onClicked:
	{
		if ( special )
			calcButton.runFunction();
		else
			insertValue(value)
	}

	onPressAndHold: { insertValue(secondary) }
}
