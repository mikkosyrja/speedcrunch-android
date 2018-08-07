import QtQuick 2.9
import QtQuick.Controls 2.2

Page
{
	header: Label
	{
//		text: qsTr("SpeedCrunch")
		text: manager.getAngleUnit()
		font.pixelSize: Qt.application.font.pixelSize * 2
		padding: 10
	}

	Label
	{
		text: qsTr("You are on Page 2.")
		anchors.centerIn: parent
	}

	SwipeView
	{
		id: keyboard
		anchors.fill: parent

		Page
		{
			width: 600
			height: 400

			header: Label
			{
				text: qsTr("xxx")
				font.pixelSize: Qt.application.font.pixelSize * 2
				padding: 10
			}

			Label
			{
				text: qsTr("You are on Keyboard 1.")
				anchors.centerIn: parent
			}
		}

		Page
		{
			width: 600
			height: 400

			header: Label
			{
				text: qsTr("yyy")
				font.pixelSize: Qt.application.font.pixelSize * 2
				padding: 10
			}

			Label
			{
				text: qsTr("You are on Keyboard 2.")
				anchors.centerIn: parent
			}
		}
	}
}

