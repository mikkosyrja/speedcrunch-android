// This file is part of the SpeedCrunch project
// Copyright (C) 2014 @qwazix
// Copyright (C) 2018 Mikko Syrjä
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; see the file COPYING.  If not, write to
// the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
// Boston, MA 02110-1301, USA.

import QtQuick 2.2
import Sailfish.Silica 1.0

Rectangle
{
	property bool enableKeys: true
	property QtObject model
	property bool isHorizontal: false

	property int index: view.currentIndex
	property int startIndex
	property Item item: view.currentItem

	property alias spacing: view.spacing
	property alias interactive: view.interactive
	property Item indicator

	ListView
	{
		id: view
		anchors.fill: parent
		model: parent.model
		orientation: if ( isHorizontal ) { ListView.Horizontal } else { ListView.Vertical }
		snapMode: ListView.SnapOneItem;
		flickDeceleration: 500
		maximumFlickVelocity: parent.width * 5
		currentIndex: startIndex
		boundsBehavior: Flickable.StopAtBounds
		highlightFollowsCurrentItem: true
		highlightRangeMode: ListView.StrictlyEnforceRange
		preferredHighlightBegin: 0
		preferredHighlightEnd: 0
		cacheBuffer: width;
//		focus: parent.focus
		onCurrentIndexChanged: parent.indexChanged()
/*
		Keys.onLeftPressed:
		{
			if ( enableKeys && isHorizontal && (currentIndex > 0) )
				currentIndex = currentIndex-1;
		}
		Keys.onRightPressed:
		{
			if ( enableKeys && isHorizontal && (currentIndex < count) )
				currentIndex = currentIndex+1;
		}
		Keys.onUpPressed:
		{
			if ( enableKeys && !isHorizontal && (currentIndex > 0 ) )
				currentIndex = currentIndex-1;
		}
		Keys.onDownPressed:
		{
			if ( enableKeys && !isHorizontal && (currentIndex < count) )
				currentIndex = currentIndex+1;
		}
*/
		Component.onCompleted:
		{
			positionViewAtIndex(startIndex, ListView.Contain)
		}
	}

	Timer
	{
		id: pagertimer
		interval: 250; running: false; repeat: false
		onTriggered:
		{
			for ( var index = 0; index < indicator.children.length; index++ )
				indicator.children[index].checked = false
			indicator.children[parent.index].checked = true
		}
	}

	onIndexChanged: { pagertimer.running = true }

	function goToPage(page)
	{
		view.currentIndex = page
		view.positionViewAtIndex(page, ListView.Beginning)
	}
}
