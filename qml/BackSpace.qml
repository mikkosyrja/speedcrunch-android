import QtQuick 2.9
import QtQuick.Controls 2.3

CalcButton
{
	image: "back.png"
	special: true
/*
	Image
	{
		width: parent.width / 2; height: parent.height / 2
		anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }
		source: "back.png"
	}
*/
	onRunFunction:
	{
		var pos = textfield.cursorPosition;
		if ( textfield.text === "" || pos === 0 )
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
}
