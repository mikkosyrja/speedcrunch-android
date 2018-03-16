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

CoverBackground
{
	property int statusmargin: window.height / 16
	property int buttonmargin: window.width / 50

	property int fontsizebig: statusmargin * 2 / 3
	property int fontsizesmall: statusmargin / 2

/*
	Image
	{
		source:"../coverdia.png"
		anchors.centerIn: parent
		anchors.horizontalCenterOffset: -40
		anchors.verticalCenterOffset: -50
//		anchors.horizontalCenter: parent.horizontalCenter
//		opacity: label.text==""?1:0.2
		width: 300
		height: 300
		fillMode: Image.PreserveAspectFit
	}
*/
	Label
	{
		id: labelTitle
		anchors { top: parent.top; topMargin: 20 }
		anchors.left: parent.left
		anchors.right: parent.right
		horizontalAlignment: Text.AlignHCenter
		font.pixelSize: fontsizesmall
//		color: Theme.highlightColor
		text: "SpeedCrunch"
	}
	Label
	{
		id: labelExpression
		anchors { top: labelTitle.bottom; topMargin: 30 }
		anchors { left: parent.left; leftMargin: 20 }
		anchors.right: parent.right
		wrapMode: Text.WrapAnywhere
		font.pixelSize: fontsizesmall
//		color: Theme.highlightColor
		text: window.latestResultExpr == "" ? "" : window.latestResultExpr + " ="
	}
	Label
	{
		id: labelResult
		anchors { top: labelExpression.bottom; topMargin: 10 }
		anchors { left: parent.left; leftMargin: 20 }
		anchors.right: parent.right
		width: parent.width
		truncationMode: TruncationMode.Fade
		font.pixelSize: fontsizebig
		text: window.latestResult
	}
	CoverActionList
	{
		id: coverAction

		CoverAction
		{
			iconSource: "../copy.png"
			onTriggered: { manager.setClipboard(window.latestResult) }
		}
//		CoverAction
//		{
//			iconSource: "image://theme/icon-cover-pause"
//		}
	}
}
