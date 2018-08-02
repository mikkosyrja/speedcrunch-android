import QtQuick 2.9
import QtQuick.Controls 2.2
//import Sailfish.Silica 1.0
//import "pages"
//import harbour.speedcrunch.Manager 1.0

ApplicationWindow
{
    visible: true
    width: 640
    height: 480
    title: qsTr("Tabs")

    SwipeView
    {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        Page
        {
            width: 600
            height: 400

            header: Label
            {
                text: qsTr("Page 1")
                font.pixelSize: Qt.application.font.pixelSize * 2
                padding: 10
            }

            Label
            {
                text: qsTr("You are on Page 1.")
                anchors.centerIn: parent
            }
        }

        Page
        {
            width: 600
            height: 400

            header: Label
            {
                text: qsTr("Page 2")
                font.pixelSize: Qt.application.font.pixelSize * 2
                padding: 10
            }

            Label
            {
                text: qsTr("You are on Page 2.")
                anchors.centerIn: parent
            }
        }
    }

    footer: TabBar
    {
        id: tabBar
        currentIndex: swipeView.currentIndex

        TabButton { text: qsTr("Page 1") }
        TabButton { text: qsTr("Page 2") }
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
