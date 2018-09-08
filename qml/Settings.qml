import QtQuick 2.9
import QtQuick.Controls 2.3

Page
{
	property int labelwidth: window.width * 2 / 5 - itemspacing
	property int combowidth: window.width - labelwidth - itemspacing * 2
	property int comboheight: fontsize * 2.5
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
					text: qsTr("Result Format")
				}
				ComboBox
				{
					id: resultformatsetting
					width: combowidth; height: comboheight
					background: Rectangle { radius: cornerradius; color: settingscolor }
					font.pixelSize: fontsize
					model: [ "General decimal", "Fixed decimal", "Engineering decimal",
						"Scientific decimal", "Binary", "Octal", "Hexadecimal" ]
//					model: [ "General decimal", "Fixed decimal", "Engineering decimal",
//						"Scientific decimal", "Binary", "Octal", "Hexadecimal", "Sexagesimal" ]
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
					text: qsTr("Precision")
				}
				ComboBox
				{
					id: precisionsetting
					width: combowidth; height: comboheight
					background: Rectangle { radius: cornerradius; color: settingscolor }
					font.pixelSize: fontsize
					model: [ "Automatic", "0", "1", "2", "3", "4", "6", "8", "12", "16", "20" ]
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
					text: qsTr("Angle Unit")
				}
				ComboBox
				{
					id: angleunitsetting
					width: combowidth; height: comboheight
					background: Rectangle { radius: cornerradius; color: settingscolor }
					font.pixelSize: fontsize
					model: [ "Degree", "Radian" ]
//					model: [ "Degree", "Radian", "Gradian" ]
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
					text: qsTr("Complex Numbers")
				}
				ComboBox
				{
					id: complexnumbersetting
					width: combowidth; height: comboheight
					background: Rectangle { radius: cornerradius; color: settingscolor }
					font.pixelSize: fontsize
					model: [ "Disabled", "Cartesian", "Polar" ]
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
			CheckBox
			{
				id: historysavesetting
				width: combowidth; height: comboheight
				font.pixelSize: fontsize
				text: qsTr("Save History on Exit")

//				indicator: Rectangle { radius: cornerradius; color: settingscolor }
//				CheckBox.background: Rectangle { radius: cornerradius; color: settingscolor }
				checked: true
				onCheckedChanged: { manager.setSessionSave(checked) }
				function setHistorySave(save) { checked = save }
			}
			Row
			{
				Label
				{
					width: labelwidth
					anchors.verticalCenter: parent.verticalCenter
					font.pixelSize: fontsize
					text: qsTr("List Font Size")
				}
				ComboBox
				{
					id: fontsizesetting
					width: combowidth; height: comboheight
					background: Rectangle { radius: cornerradius; color: settingscolor }
					font.pixelSize: fontsize
					model: [ "Small", "Medium", "Large" ]
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
