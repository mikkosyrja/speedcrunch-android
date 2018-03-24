import QtQuick 2.2
import Sailfish.Silica 1.0

Button
{
	id: calcButton

	property alias text: calcButton.text
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

	function insertValue(text)
	{
		var txt = textfield.text
		var res;
		var pos = textfield.cursorPosition
		if ( txt == "" )
			textfield.text = text
		else
		{
			if ( textfield.selectionStart - textfield.selectionEnd != 0 )
			{
				var firstpart = txt.slice(0, textfield.selectionStart);
				var lastpart = txt.slice(textfield.selectionEnd);
				res = firstpart + text + lastpart
			}
			else
			{
				if ( pos == 0 )
					res= text + textfield.text
				else if ( pos == textfield.text.length )
				{
					console.log(0)
					res = textfield.text + text;
				}
				else
				{
					var rgx = new RegExp("(.{1," + pos + "})(.*)");
					var chunks = txt.match(rgx);
					chunks = chunks.slice(1)
					console.log(chunks)
					res = chunks.join(text);
				}
			}
			textfield.text = res;
			textfield.cursorPosition = pos + text.length
		}
		if ( text.slice(-2) == "()" )
			textfield.cursorPosition--
		calcButton.callback();
	}




	onClicked:
	{
		if ( !special )
		{
/*
			var txt = textfield.text
			var res;
			var pos = textfield.cursorPosition
			if ( txt == "" )
				textfield.text = value
			else
			{
				if ( textfield.selectionStart - textfield.selectionEnd != 0 )
				{
					var firstpart = txt.slice(0, textfield.selectionStart);
					var lastpart = txt.slice(textfield.selectionEnd);
					res = firstpart + value + lastpart
				}
				else
				{
					if ( pos == 0 )
						res= value + textfield.text
					else if ( pos == textfield.text.length )
					{
						console.log(0)
						res = textfield.text + value;
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
				textfield.cursorPosition = pos + value.length
			}
			if ( value.slice(-2) == "()" )
				textfield.cursorPosition--
			calcButton.callback();
*/
			insertValue(value)
		}
		else
			calcButton.runFunction();
	}

	onPressAndHold:
	{
		insertValue(secondary)
	}
}
