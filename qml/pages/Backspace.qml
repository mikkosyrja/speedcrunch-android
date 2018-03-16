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

CalcButton
{
//	text: "⌫"
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
//			var firstpart = ;
//			var lastpart = ;
			textfield.text = txt.slice(0, pos - 1) + txt.slice(pos)
			textfield.cursorPosition = pos - 1
		}
	}
}
