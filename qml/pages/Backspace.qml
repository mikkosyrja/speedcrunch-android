import QtQuick 2.2
import Sailfish.Silica 1.0

CalcButton
{
	image: "erase_to_the_left.png"
	special: true;

	onRunFunction:
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
}
