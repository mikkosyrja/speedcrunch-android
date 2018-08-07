import QtQuick 2.9
import QtQuick.Controls 2.2

ApplicationWindow
{
	id: window

	visible: true
	width: 1280
	height: 960
	title: qsTr("Tabs")

	SwipeView
	{
		id: swipeView
		anchors.fill: parent
		currentIndex: tabBar.currentIndex

		Functions
		{
			id: functions

			width: 600
			height: 400
		}

		Calculator
		{
			id: calculator

			width: 600
			height: 400
		}

		Settings
		{
			id: settings

			width: 600
			height: 400
		}
	}

	footer: TabBar
	{
		id: tabBar
		currentIndex: swipeView.currentIndex

		TabButton { text: qsTr("Functions") }
		TabButton { text: qsTr("SpeedCrunch") }
		TabButton { text: qsTr("Settings") }
	}
}

/*
ApplicationWindow
{
	id: window

	initialPage: Qt.resolvedUrl("pages/Panorama.qml")

	property string latestExpression: ""
	property string latestResult: ""

	cover: Qt.resolvedUrl("cover/CoverPage.qml")

	Manager { id: manager }
}
*/
