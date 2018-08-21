import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4

Button
{
	signal runFunction
	property bool special: false;
	property bool isFunction: false
	property string value: text + (isFunction ? "()" : "")
	property string secondary: value
	property string image: ""

	width: parent.width / parent.buttoncols - parent.spacing + parent.spacing / parent.buttoncols
	height: parent.height / parent.buttonrows - parent.spacing + parent.spacing / parent.buttonrows

	font.pixelSize: Qt.application.font.pixelSize

	background: Rectangle { radius: 3 }

	Image
	{
//		visible: image.length
		width: parent.height / 1; height: parent.height / 1
		anchors.centerIn: parent
		source: image
//		anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }
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
