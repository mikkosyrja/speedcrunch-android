import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"
import harbour.speedcrunch.Manager 1.0

ApplicationWindow
{
	id: window

	initialPage: Qt.resolvedUrl("pages/Panorama.qml")

	property string latestExpression: ""
	property string latestResult: ""

	cover: Qt.resolvedUrl("cover/CoverPage.qml")

	Manager { id: manager }
}
