import QtQuick 2.9
import QtQuick.Controls 2.2

Page
{
	Rectangle
	{
		anchors.fill: parent
		color: "lightGray"

		Label
		{
			text: qsTr("You are on Page 3.")
			anchors.centerIn: parent
		}
	}
}
