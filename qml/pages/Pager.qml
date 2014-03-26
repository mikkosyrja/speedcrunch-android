import QtQuick 2.0

Rectangle {
    id:pager


    property bool enableKeys: true
    property QtObject model
    property bool isHorizontal: false

    property int index: view.currentIndex
    property int startIndex
    property Item item: view.currentItem

    property alias spacing: view.spacing
    property alias interactive: view.interactive
    property Item indicator

    function goToPage(page){
        view.currentIndex = page
        view.positionViewAtIndex(page)
    }

    ListView {
        id: view
        anchors.fill: pager
        model: pager.model
        orientation: if (isHorizontal){ListView.Horizontal;} else {ListView.Vertical}
        snapMode: ListView.SnapOneItem;
        flickDeceleration: 500
        currentIndex: startIndex
        boundsBehavior: Flickable.StopAtBounds
        highlightFollowsCurrentItem: true
        highlightRangeMode: ListView.StrictlyEnforceRange
        preferredHighlightBegin: 0; preferredHighlightEnd: 0
        cacheBuffer: width;
//        focus: pager.focus
        onCurrentIndexChanged: pager.indexChanged()
        Keys.onLeftPressed: {
            if (enableKeys && isHorizontal && (currentIndex > 0 ))
            currentIndex = currentIndex-1;}
        Keys.onRightPressed: {
            if (enableKeys && isHorizontal && (currentIndex < count))
            currentIndex = currentIndex+1;}
        Keys.onUpPressed: {
            if (enableKeys && !isHorizontal && (currentIndex > 0 ))
            currentIndex = currentIndex-1;}
        Keys.onDownPressed: {
            if (enableKeys && !isHorizontal && (currentIndex < count))
            currentIndex = currentIndex+1;}
        Component.onCompleted: {
            positionViewAtIndex(startIndex, ListView.Contain)
        }
    }

    Timer {
        id: pagertimer
        interval: 100; running: false; repeat: false
        onTriggered: {
            for (var i=0; i<indicator.children.length; i++) indicator.children[i].checked = false
            indicator.children[parent.index].checked = true
        }
    }

    onIndexChanged: {
        pagertimer.running = true
    }
}
