import QtQuick 2.9
import QtQuick.Controls 2.2
//import QtQuick.VirtualKeyboard 2.3

Page
{
	property string filtertype: "a"
	property int updatemodel: 0

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
					id: functionlist
					anchors.fill: parent
					model: { eval(manager.getFunctions(searchfield.text, filtertype, updatemodel)) }
					highlight: Rectangle { color: "lightsteelblue"; radius: 3 }
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
								font { pixelSize: fontsizesmall }
							}
							MouseArea
							{
								anchors.fill: parent
								onClicked:
								{
									functionlist.currentIndex = index
//									functionitem.color = Qt.rgba(Math.random(), Math.random(), Math.random(), 1);
								}
							}
/*
							menu: Component
							{
								ContextMenu
								{
									MenuItem { text: modelData.label; onClicked: insert() }
									MenuItem
									{
										text: "Remove from recent"
										visible: modelData.recent
										onClicked: remorse.execute(functionitem, "Removing", removeRecent)
									}
									MenuItem
									{
										text: "Delete user defined"
										visible: modelData.user
										onClicked: remorse.execute(functionitem, "Deleting", deleteUserDefined)
									}
								}
							}
							onClicked: insert()
*/
/*
							function removeRecent()
							{
								manager.removeRecent(modelData.name)
								functionlist.updatemodel++
							}
							function deleteUserDefined()
							{
								manager.clearFunction(modelData.value)
								manager.clearVariable(modelData.value)
								functionlist.updatemodel++
							}
							function insert()
							{
								functionlist.currentIndex = index;
								var value = modelData.value
								var text = textfield.text
								var pos = textfield.cursorPosition
								textfield.text = text.substring(0, pos) + value + text.substring(pos, text.length)
								textfield.cursorPosition = pos + value.length
								if ( modelData.usage != "" )
								{
									textfield.label = modelData.usage
									textfield.cursorPosition--
								}
								if ( manager.updateRecent(modelData.name) )
									needsupdate = true
								screen.goToPage(1)
								mouse.accepted = true;
							}
*/
						}
					}
				}
			}
		}
	}
}
