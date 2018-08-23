import QtQuick 2.9
import QtQuick.Controls 2.2

Page
{
	property string filtertype: "a"
	property int updatemodel: 0

	Rectangle
	{
		anchors.fill: parent
		color: backgroundcolor

		ListView
		{
			id: functionlist
			anchors { fill: parent; margins: 5 }
//			model: { eval(manager.getFunctions(searchfunctions.text, filtertype, updatemodel)) }
			model: { eval(manager.getFunctions("", filtertype, updatemodel)) }
			highlight: Rectangle { color: "lightsteelblue"; radius: 3 }
			delegate: Component
			{
				Item
				{
					id: functionitem
//					RemorseItem { id: remorse }
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
//							functionitem.color = Qt.rgba(Math.random(), Math.random(), Math.random(), 1);
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
