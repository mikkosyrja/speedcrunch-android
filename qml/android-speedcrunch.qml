import QtQuick 2.9
import QtQuick.Controls 2.2

ApplicationWindow
{
	property alias keyboard: calculator.keyboard

	id: window
	visible: true
	title: qsTr("Tabs")

	property int fontsizesmall: window.height / 32
	property int lineheight: fontsizesmall * 1.5

	header: TabBar
	{
		id: tabbar
		currentIndex: swipe.currentIndex

		font { pixelSize: fontsizesmall }

		TabButton { text: qsTr("Functions") }
		TabButton { text: qsTr("SpeedCrunch") }
		TabButton { text: qsTr("Settings") }
	}

	SwipeView
	{
		id: swipe
		anchors.fill: parent
		currentIndex: tabbar.currentIndex

		Functions { id: functions }
		Calculator { id: calculator }
		Settings { id: settings }
	}

	footer: Page
	{
		id: statusbar
		font.pixelSize: fontsizesmall

		Label
		{
			text: qsTr("Status bar")
			anchors.centerIn: parent
		}
	}

	Component.onCompleted:
	{
//		functionlist.updatemodel++
	}
}
