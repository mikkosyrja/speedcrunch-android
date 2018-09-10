import QtQuick 2.9
import QtQuick.Controls 2.3

Page
{
	property string filtertype: "a"
	property bool needsupdate: false

	Rectangle
	{
		anchors.fill: parent
		color: backgroundcolor

		Column
		{
			anchors { fill: parent; margins: itemspacing }
			spacing: itemspacing

			Row
			{
				Label
				{
					width: settings.labelwidth
					anchors.verticalCenter: parent.verticalCenter
					font.pixelSize: fontsize
					text: qsTr("Type Filter")
				}
				ComboBox
				{
					id: filtersetting
					width: settings.combowidth; height: settings.comboheight
					background: Rectangle { radius: cornerradius; color: settingscolor }
					font.pixelSize: fontsize
					model: [ "All", "Functions", "Units", "Constants", "User defined" ]
					delegate: ItemDelegate { text: modelData; font.pixelSize: fontsize }
					onCurrentIndexChanged:
					{
						if ( currentIndex == 0 ) { filtertype = "a" }
						else if ( currentIndex == 1 ) { filtertype = "f" }
						else if ( currentIndex == 2 ) { filtertype = "u" }
						else if ( currentIndex == 3 ) { filtertype = "c" }
						else if ( currentIndex == 4 ) { filtertype = "v" }
					}
				}
			}
			Rectangle
			{
				id: searchrow
				width: parent.width; height: keyboard.buttonheight + itemspacing
				color: backgroundcolor
				Row
				{
					anchors { left: parent.left; right: parent.right }
					spacing: itemspacing

					TextField
					{
						id: searchfield
						width: parent.width - cleartext.width - itemspacing
						height: keyboard.buttonheight
						background: Rectangle { radius: cornerradius; color: settingscolor }
						font.pixelSize: fontsize
						inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase;
						placeholderText: "search"
						Keys.onReturnPressed: { setDefaultFocus() }
					}
					Rectangle
					{
						id: cleartext
						width: keyboard.buttonheight; height: keyboard.buttonheight
						color: backgroundcolor
						Image
						{
							width: keyboard.buttonheight / 2; height: keyboard.buttonheight / 2
							anchors.centerIn: parent
							source: "clear.png"
						}
						MouseArea
						{
							id: cleararea
							anchors { fill: parent }
							onClicked: { searchfield.text = "" }
						}
					}
				}
			}
			Rectangle
			{
				width: parent.width; height: parent.height - filtersetting.height - searchrow.height
				color: backgroundcolor
				clip: true

				Component
				{
					id: highlight
					Rectangle
					{
						width: parent.width; height: lineheight
						color: "lightsteelblue"; radius: cornerradius
						y: functionlist.currentItem.y
					}
				}
				ListView
				{
					property int updatemodel: 0

					id: functionlist
					anchors.fill: parent
					highlight: highlight
					highlightFollowsCurrentItem: false
					model: { eval(manager.getFunctions(searchfield.text, filtertype, updatemodel)) }
					delegate: Component
					{
						Item
						{
							id: functionitem
//							RemorseItem { id: remorse }
							width: parent.width; height: lineheight
							Text
							{
								anchors.verticalCenter: parent.verticalCenter
								text: modelData.name
								font { pixelSize: fontsizelist; weight: (modelData.recent ? Font.Bold: Font.Light) }
							}
							MouseArea
							{
								property bool acceptclic: false

								anchors.fill: parent

								Timer
								{
									id: highlighttimer
									interval: 100; running: false; repeat: false
									onTriggered: { functionlist.currentIndex = index }
								}
								onClicked:
								{
									functionlist.currentIndex = -1
									if ( popupmenu.opened )
										popupmenu.close()
									else if ( acceptclic )
										insert()
								}
								onPressed:
								{
									acceptclic = true
									highlighttimer.start()
									Qt.inputMethod.hide()
								}
								onPositionChanged:
								{
									acceptclic = false
									highlighttimer.stop()
									functionlist.currentIndex = -1
								}
								onReleased:
								{
									highlighttimer.stop()
									functionlist.currentIndex = -1
								}
								onPressAndHold:
								{
									functionlist.currentIndex = -1
									popupmenu.open()
								}
							}
							Menu
							{
								id: popupmenu
								modal: true
								y: functionitem.height
								width: parent.width
								closePolicy : Popup.NoAutoClose | Popup.CloseOnPressOutsideParent

								MenuItem
								{
									text: modelData.label;
									height: menuheight
									font.pixelSize: fontsizemenu
									onClicked: insert()
								}
								MenuItem
								{
									text: qsTr("Remove from Recent")
									id: removerecent
									height: (modelData.recent ? menuheight : 0)
									font.pixelSize: fontsizemenu
									visible: modelData.recent
									onTriggered: { removeRecent() }
//									onClicked: remorse.execute(functionitem, "Removing", removeRecent)
								}
								MenuItem
								{
									text: qsTr("Delete User Defined")
									id: deleteuserdefined
									height: (modelData.user ? menuheight : 0)
									font.pixelSize: fontsizemenu
									visible: modelData.user
									onTriggered: { deleteUserDefined() }
//									onClicked: remorse.execute(functionitem, "Deleting", deleteUserDefined)
								}
							}

							function removeRecent()
							{
								manager.removeRecent(modelData.name)
								updateFunctions()
							}
							function deleteUserDefined()
							{
								manager.clearFunction(modelData.value)
								manager.clearVariable(modelData.value)
								updateFunctions()
							}
							function insert()
							{
								var value = modelData.value
								var text = editor.text
								var pos = editor.cursorPosition
								editor.text = text.substring(0, pos) + value + text.substring(pos, text.length)
								editor.cursorPosition = pos + value.length
								if ( modelData.usage !== "" )
								{
//									editor.label = modelData.usage
									editor.cursorPosition--
								}
								if ( manager.updateRecent(modelData.name) )
									needsupdate = true
								swipe.currentIndex = 1
								forceActiveFocus()
							}
						}
					}
					onCountChanged: { functionlist.currentIndex = -1 }
				}
			}
			Component.onCompleted: { functionlist.currentIndex = -1 }
		}
	}

	function updateFunctions()
	{
		functionlist.updatemodel++
		functionlist.positionViewAtBeginning()
		functionlist.currentIndex = -1
		manager.saveSession()
	}

	function setDefaultFocus()
	{
		Qt.inputMethod.hide()
		cleartext.forceActiveFocus()
	}
}
