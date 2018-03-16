// This file is part of the SpeedCrunch project
// Copyright (C) 2014 @qwazix
// Copyright (C) 2018 Mikko Syrjä
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; see the file COPYING.  If not, write to
// the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
// Boston, MA 02110-1301, USA.

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
	property string image : ""

	implicitWidth: parent.width / parent.columns - parent.spacing * (parent.columns - 1) / parent.columns;
	implicitHeight: parent.height / parent.rows - parent.spacing * (parent.rows - 1) / parent.rows;

	Image
	{
		visible: image.length
		source: image
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.verticalCenter: parent.verticalCenter
	}

	text: " "

	onClicked:
	{
		if ( !special )
		{
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
					res = firstpart + "" + value + "" + lastpart
				}
				else
				{
					if ( pos == 0 )
						res= value + "" + textfield.text
					else if ( pos == textfield.text.length )
					{
						console.log(0)
						res = textfield.text +""+ value;
					}
					else
					{
						var rgx = new RegExp("(.{1,"+pos+"})(.*)");
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
			calcButton.callback();
		}
		else
			calcButton.runFunction();
	}
}
