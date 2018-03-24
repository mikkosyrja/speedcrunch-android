import QtQuick 2.2
import Sailfish.Silica 1.0

CoverBackground
{
	property int statusmargin: window.height / 16
	property int buttonmargin: window.width / 50

	property int fontsizebig: statusmargin * 2 / 3
	property int fontsizesmall: statusmargin / 2

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
		text: window.latestExpression == "" ? "" : window.latestExpression + " ="
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
