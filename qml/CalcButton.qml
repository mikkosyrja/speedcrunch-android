import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4

Button
{
	property bool special;
	signal runFunction
	signal callback
	property bool isFunction: false
	property string value: calcButton.text + (isFunction ? "()" : "")
	property string secondary: value
	property string image: ""

	width: parent.width / parent.buttoncols - parent.spacing + parent.spacing / parent.buttoncols
	height: parent.height / parent.buttonrows - parent.spacing + parent.spacing / parent.buttonrows

	font.pixelSize: Qt.application.font.pixelSize

	background: Rectangle { radius: 5 }
}
