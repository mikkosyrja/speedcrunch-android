import QtQuick 2.9
import QtQuick.Controls 2.3

Page
{
	property int labelwidth: window.width / 2  - itemspacing
	property int combowidth: window.width - labelwidth - itemspacing * 2
//	property int comboheight: fontsize * 2.5
	property int comboheight: menuheight
	property bool initialized: false

	property alias resultformat: resultformatsetting.currentText
	property alias angleunit: angleunitsetting.currentText

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
					width: labelwidth
					anchors.verticalCenter: parent.verticalCenter
					font.pixelSize: fontsize
					text: qsTrId("id-result-format")
				}
				ComboBox
				{
					id: resultformatsetting
					width: combowidth; height: comboheight
					background: Rectangle { radius: cornerradius; color: settingscolor }
					font.pixelSize: fontsize
					model: [ qsTrId("id-general-decimal"), qsTrId("id-fixed-decimal"),
						qsTrId("id-engineering-decimal"), qsTrId("id-scientific-decimal"),
						qsTrId("id-binary"), qsTrId("id-octal"), qsTrId("id-hexadecimal") ]
//						qsTrId("id-sexagesimal") ]
					delegate: ItemDelegate
					{
						text: modelData;
						width: parent.width
						font.pixelSize: fontsize
						highlighted: ListView.isCurrentItem
					}
					onCurrentIndexChanged:
					{
						if ( initialized )
						{
							if ( currentIndex == 0 ) { manager.setResultFormat("g") }
							else if ( currentIndex == 1 ) { manager.setResultFormat("f") }
							else if ( currentIndex == 2 ) { manager.setResultFormat("n") }
							else if ( currentIndex == 3 ) { manager.setResultFormat("e") }
							else if ( currentIndex == 4 ) { manager.setResultFormat("b") }
							else if ( currentIndex == 5 ) { manager.setResultFormat("o") }
							else if ( currentIndex == 6 ) { manager.setResultFormat("h") }
//							else if ( currentIndex == 7 ) { manager.setResultFormat("s") }
							keyboard.setButtonLabels()
							history.updateHistory()
						}
					}
					function setResultFormat(format)
					{
						if ( format === "g" ) currentIndex = 0
						else if ( format === "f" ) currentIndex = 1
						else if ( format === "n" ) currentIndex = 2
						else if ( format === "e" ) currentIndex = 3
						else if ( format === "b" ) currentIndex = 4
						else if ( format === "o" ) currentIndex = 5
						else if ( format === "h" ) currentIndex = 6
//						else if ( format === "s" ) currentIndex = 7
					}
				}
			}
			Row
			{
				Label
				{
					width: labelwidth
					anchors.verticalCenter: parent.verticalCenter
					font.pixelSize: fontsize
					text: qsTrId("id-precision")
				}
				ComboBox
				{
					id: precisionsetting
					width: combowidth; height: comboheight
					background: Rectangle { radius: cornerradius; color: settingscolor }
					font.pixelSize: fontsize
					model: [ qsTrId("id-automatic"), "0", "1", "2", "3", "4", "6", "8", "12", "16", "20" ]
					delegate: ItemDelegate
					{
						text: modelData;
						width: parent.width
						font.pixelSize: fontsize
						highlighted: ListView.isCurrentItem
					}
					onCurrentIndexChanged:
					{
						if ( initialized ) switch ( currentIndex )
						{
							case 1:		manager.setPrecision("0"); break
							case 2:		manager.setPrecision("1"); break
							case 3:		manager.setPrecision("2"); break
							case 4:		manager.setPrecision("3"); break
							case 5:		manager.setPrecision("4"); break
							case 6:		manager.setPrecision("6"); break
							case 7:		manager.setPrecision("8"); break
							case 8:		manager.setPrecision("12"); break
							case 9:		manager.setPrecision("16"); break
							case 10:	manager.setPrecision("20"); break
							default:	manager.setPrecision("")
							history.updateHistory()
						}
					}
					function setPrecision(precision)
					{
						if ( precision === "0" ) currentIndex = 1
						else if ( precision === "1" ) currentIndex = 2
						else if ( precision === "2" ) currentIndex = 3
						else if ( precision === "3" ) currentIndex = 4
						else if ( precision === "4" ) currentIndex = 5
						else if ( precision === "6" ) currentIndex = 6
						else if ( precision === "8" ) currentIndex = 7
						else if ( precision === "12" ) currentIndex = 8
						else if ( precision === "16" ) currentIndex = 9
						else if ( precision === "20" ) currentIndex = 10
						else currentIndex = 0;
					}
				}
			}
			Row
			{
				Label
				{
					width: labelwidth
					anchors.verticalCenter: parent.verticalCenter
					font.pixelSize: fontsize
					text: qsTrId("id-angle-unit")
				}
				ComboBox
				{
					id: angleunitsetting
					width: combowidth; height: comboheight
					background: Rectangle { radius: cornerradius; color: settingscolor }
					font.pixelSize: fontsize
					model: [ qsTrId("id-degree"), qsTrId("id-radian") ]
//						qsTrId("id-gradian") ]
					delegate: ItemDelegate
					{
						text: modelData;
						width: parent.width
						font.pixelSize: fontsize
						highlighted: ListView.isCurrentItem
					}
					onCurrentIndexChanged:
					{
						if ( initialized )
						{
							if ( currentIndex == 0 ) manager.setAngleUnit("d")
							else if ( currentIndex == 1 ) manager.setAngleUnit("r")
//							else if ( currentIndex == 2 ) manager.setAngleUnit("g")
						}
					}
					function setAngleUnit(unit)
					{
						if ( unit === "d" ) currentIndex = 0
						else if ( unit === "r" ) currentIndex = 1
//						else if ( unit === "g" ) currentIndex = 2
					}
				}
			}
			Row
			{
				Label
				{
					width: labelwidth
					anchors.verticalCenter: parent.verticalCenter
					font.pixelSize: fontsize
					text: qsTrId("id-complex-numbers")
				}
				ComboBox
				{
					id: complexnumbersetting
					width: combowidth; height: comboheight
					background: Rectangle { radius: cornerradius; color: settingscolor }
					font.pixelSize: fontsize
					model: [ qsTrId("id-disabled"), qsTrId("id-cartesian"), qsTrId("id-polar") ]
					delegate: ItemDelegate
					{
						text: modelData;
						width: parent.width
						font.pixelSize: fontsize
						highlighted: ListView.isCurrentItem
					}
					onCurrentIndexChanged:
					{
						if ( initialized )
						{
							if ( currentIndex == 0 ) manager.setComplexNumber("d")
							else if ( currentIndex == 1 ) manager.setComplexNumber("c")
							else if ( currentIndex == 2 ) manager.setComplexNumber("p")
							keyboard.setButtonLabels()
							history.updateHistory()
						}
					}
					function setComplexNumber(complex)
					{
						if ( complex === "d" ) currentIndex = 0
						else if ( complex === "c" ) currentIndex = 1
						else if ( complex === "p" ) currentIndex = 2
					}
				}
			}
			Rectangle
			{
				id: settingseparator
				width: parent.width; height: parent.height - (comboheight + itemspacing) * 7 - fontsize * 1.5
				color: backgroundcolor
			}
			CheckBox
			{
				id: historysavesetting
				width: parent.width; height: comboheight
				font.pixelSize: fontsize
				text: qsTrId("id-save-history-on-exit")
				checked: true
				onCheckedChanged: { manager.setSessionSave(checked) }
				function setHistorySave(save) { checked = save }
			}
			CheckBox
			{
				id: clickinsertsetting
				width: parent.width; height: comboheight
				font.pixelSize: fontsize
				text: qsTrId("id-direct-insert-from-lists")
				checked: true
				onCheckedChanged: { oneclickinsert = checked; manager.setClickInsert(checked) }
				function setClickInsert(click) { oneclickinsert = click; checked = click }
			}
			Row
			{
				Label
				{
					width: labelwidth
					anchors.verticalCenter: parent.verticalCenter
					font.pixelSize: fontsize
					text: qsTrId("id-list-font-size")
				}
				ComboBox
				{
					id: fontsizesetting
					width: combowidth; height: comboheight
					background: Rectangle { radius: cornerradius; color: settingscolor }
					font.pixelSize: fontsize
					model: [ qsTrId("id-small"), qsTrId("id-medium"), qsTrId("id-large") ]
					delegate: ItemDelegate
					{
						text: modelData;
						width: parent.width
						font.pixelSize: fontsize
						highlighted: ListView.isCurrentItem
					}
					onCurrentIndexChanged:
					{
						if ( initialized )
						{
							if ( currentIndex == 0 )
							{
								setGlobalFontSize("s")
								manager.setFontSize("s")
							}
							else if ( currentIndex == 1 )
							{
								setGlobalFontSize("m")
								manager.setFontSize("m")
							}
							else if ( currentIndex == 2 )
							{
								setGlobalFontSize("l")
								manager.setFontSize("l")
							}
						}
					}
					function setFontSize(size)
					{
						setGlobalFontSize(size)
						if ( size === "s" ) currentIndex = 0
						else if ( size === "m" ) currentIndex = 1
						else if ( size === "l" ) currentIndex = 2
					}
				}
			}
		}
		Component.onCompleted:
		{
			resultformatsetting.setResultFormat(manager.getResultFormat())
			precisionsetting.setPrecision(manager.getPrecision())
			angleunitsetting.setAngleUnit(manager.getAngleUnit())
			complexnumbersetting.setComplexNumber(manager.getComplexNumber())
			historysavesetting.setHistorySave(manager.getSessionSave())
			clickinsertsetting.setClickInsert(manager.getClickInsert())
			fontsizesetting.setFontSize(manager.getFontSize())
			keyboard.setButtonLabels()
			initialized = true;
		}
	}
	function setGlobalFontSize(size)
	{
		if ( size === "s" ) fontsizelist = fontsize
		else if ( size === "m" ) fontsizelist = fontsize * 1.2
		else if ( size === "l" ) fontsizelist = fontsize * 1.5
	}
}
