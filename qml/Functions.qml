import QtQuick 2.9
import QtQuick.Controls 2.3
//import QtQuick.VirtualKeyboard 2.3

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
					font { pixelSize: fontsizesmall }
					text: qsTr("Type Filter")
				}
				ComboBox
				{
					id: filtersetting
					width: settings.combowidth; height: settings.comboheight
					font { pixelSize: fontsizesmall }
					model: [ "All", "Functions", "Units", "Constants", "User defined" ]
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
						font { pixelSize: fontsizesmall }
						inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase;
						placeholderText: "search"
						Keys.onReturnPressed:
						{
//							evaluate();
						}
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
//							fillMode: Image.PreserveAspectFit
//							visible: textfield.text
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

				ListView
				{
					property int updatemodel: 0

					id: functionlist
					anchors.fill: parent
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
								anchors.fill: parent
								onClicked:
								{
									if ( popupmenu.opened )
										popupmenu.close()
									else
										insert()
								}
								onPressAndHold:
								{
/*
									popupmenu.removeItem(removerecent)
									popupmenu.removeItem(deleteuserdefined)
									if ( modelData.recent )
										popupmenu.insertItem(removerecent)
									if ( modelData.user )
										popupmenu.insertItem(deleteuserdefined)
*/
									popupmenu.open()
								}
							}
							Menu
							{
								id: popupmenu
								y: functionitem.height
								closePolicy : Popup.NoAutoClose | Popup.CloseOnPressOutsideParent

								MenuItem { text: modelData.label; onClicked: insert() }
								MenuItem
								{
									id: removerecent
									text: qsTr("Remove from Recent")
									visible: modelData.recent
									onTriggered: { removeRecent() }
//									onClicked: remorse.execute(functionitem, "Removing", removeRecent)
								}
								MenuItem
								{
									id: deleteuserdefined
									text: qsTr("Delete User Defined")
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
				}
			}
		}
	}

	function updateFunctions()
	{
		functionlist.updatemodel++
		functionlist.positionViewAtBeginning()
		functionlist.currentIndex = 0
		manager.saveSession()
	}
}
