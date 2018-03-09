import QtQuick 2.2
import Sailfish.Silica 1.0

Button
{
	id: keyboardButton
	property alias text: keyboardButton.text
	signal callback
	signal beforeClicked
	property variant value: keyboardButton.text
	onClicked:
	{
		keyboardButton.beforeClicked()
		var txt = textfield.text
		var res;
		var pos = textfield.cursorPosition
		if ( txt == "" )
			textfield.text = value
		else
		{
			if (textfield.selectionStart - textfield.selectionEnd !=0)
			{
				var firstpart = txt.slice(0, textfield.selectionStart);
				var lastpart = txt.slice(textfield.selectionEnd);
				res = firstpart + "" + value + "" + lastpart
			}
			else
			{
				if ( pos == 0 )
					res= value + "" + textfield.text
				else if ( pos == textfield.text.length )
				{
					console.log(0)
					res=textfield.text +""+ value;
				}
				else
				{
					var rgx = new RegExp("(.{1," + pos + "})(.*)");
					var chunks = txt.match(rgx);
					chunks = chunks.slice(1)
					console.log(chunks)
					res = chunks.join(value);
				}
			}
			textfield.text = res;
			textfield.cursorPosition = pos+value.length
		}
		if ( value.slice(-2) == "()" )
			textfield.cursorPosition--
		keyboardButton.callback();
	}
}
