import QtQuick 2.9
import QtQuick.Controls 2.2

ApplicationWindow
{
	id: window

	visible: true
	title: qsTr("Tabs")

	property int fontsizesmall: window.height / 32
	property int lineheight: fontsizesmall * 1.5

	header: TabBar
	{
		id: tabbar
		currentIndex: swipeView.currentIndex

		font.pixelSize: Qt.application.font.pixelSize * 2 / 3

		TabButton { text: qsTr("Functions") }
		TabButton { text: qsTr("SpeedCrunch") }
		TabButton { text: qsTr("Settings") }
	}

	SwipeView
	{
		id: swipeView
		anchors.fill: parent
		currentIndex: tabbar.currentIndex

		Functions
		{
			id: functions
		}

		Calculator
		{
			id: calculator
		}

		Settings
		{
			id: settings
		}
	}

	footer: Page
	{
		id: statusbar

		font.pixelSize: Qt.application.font.pixelSize * 2 / 3

		Label
		{
			text: qsTr("Status bar")
			anchors.centerIn: parent
		}
	}

//	Component.onCompleted: { functionlist.updatemodel++ }
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
