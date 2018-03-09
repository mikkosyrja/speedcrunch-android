/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
	* Redistributions of source code must retain the above copyright
	  notice, this list of conditions and the following disclaimer.
	* Redistributions in binary form must reproduce the above copyright
	  notice, this list of conditions and the following disclaimer in the
	  documentation and/or other materials provided with the distribution.
	* Neither the name of the Jolla Ltd nor the
	  names of its contributors may be used to endorse or promote products
	  derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
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
