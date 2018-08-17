import QtQuick 2.9
import QtQuick.Controls 2.2

Page
{
	property alias keyboard: keyboard

	Rectangle
	{
		anchors.fill: parent

		Rectangle
		{
			id: history
			width: parent.width
			height: parent.height / 2
			anchors.top: parent.top
			color: "lightGray"

			Label
			{
				text: qsTr("You are on Page 2.")
				anchors.centerIn: parent
			}
		}

		Keyboard
		{
			id: keyboard
			width: parent.width
			height: parent.height / 2
			anchors.bottom: parent.bottom
		}

		Component.onDestruction: { manager.saveSession(); }
	}
}

