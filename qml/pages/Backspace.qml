import QtQuick 2.2
import Sailfish.Silica 1.0

CalcButton
{
	image: "erase_to_the_left.png"
	special: true;

	onRunFunction:
	{
		var txt = textfield.text
		var res;
		var pos = textfield.cursorPosition;
		if ( txt == "" || pos == 0 )
			return;
		if ( textfield.selectionStart - textfield.selectionEnd != 0 )
		{
			var firstpart = txt.slice(0, textfield.selectionStart);
			var lastpart = txt.slice(textfield.selectionEnd);
			res = firstpart + "" + lastpart
			return
		}
		if ( pos == textfield.text.length )
		{
			textfield.text = textfield.text.slice(0, textfield.text.length - 1)
			return
		}
		if ( pos < textfield.text.length )
		{
			textfield.text = txt.slice(0, pos - 1) + txt.slice(pos)
			textfield.cursorPosition = pos - 1
		}
	}
}
