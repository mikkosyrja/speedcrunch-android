import QtQuick 2.9
import QtQuick.Controls 2.2

Page
{
	property int labelwidth: window.width * 2 / 5 - 5
	property int combowidth: window.width - labelwidth - 10
	property bool initialized: false

//	property alias resultformat: resultformatlist.value
//	property alias angleunit: angleunitlist.value

	Rectangle
	{
		anchors.fill: parent
		color: "lightGray"

		Column
		{
			anchors.fill: parent
			anchors.margins: 5
			spacing: 5

			Row
			{
				Label
				{
					width: labelwidth
					anchors.verticalCenter: parent.verticalCenter
					font { pixelSize: fontsizesmall }
					text: "Result format"
				}
				ComboBox
				{
					id: resultformatsetting
					width: combowidth
					font { pixelSize: fontsizesmall }
					model: [ "General decimal", "Fixed decimal", "Engineering decimal",
						"Scientific decimal", "Binary", "Octal", "Hexadecimal" ]
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
							window.keyboard.setButtonLabels()
//							resultsview.updateHistory()
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
					}
				}
			}
			Row
			{
				Label
				{
					width: labelwidth
					anchors.verticalCenter: parent.verticalCenter
					font { pixelSize: fontsizesmall }
					text: "Precision"
				}
				ComboBox
				{
					id: precisionsetting
					width: combowidth
					font { pixelSize: fontsizesmall }
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
					font { pixelSize: fontsizesmall }
					text: "Angle Unit"
				}
				ComboBox
				{
					id: angleunitsetting
					width: combowidth
					font { pixelSize: fontsizesmall }
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
					font { pixelSize: fontsizesmall }
					text: "Complex Numbers"
				}
				ComboBox
				{
					id: complexnumbersetting
					width: combowidth
					font { pixelSize: fontsizesmall }
					model: [ "Disabled", "Cartesian", "Polar" ]
					onCurrentIndexChanged:
					{
						if ( initialized )
						{
							if ( currentIndex == 0 ) manager.setComplexNumber("d")
							else if ( currentIndex == 1 ) manager.setComplexNumber("c")
							else if ( currentIndex == 2 ) manager.setComplexNumber("p")
							window.keyboard.setButtonLabels()
//							resultsview.updateHistory()
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
				font { pixelSize: fontsizesmall }
				text: "Save History on Exit"
				checked: true
				onCheckedChanged: { manager.setSessionSave(checked) }
				function setHistorySave(save) { checked = save }
			}
		}
		Component.onCompleted:
		{
			resultformatsetting.setResultFormat(manager.getResultFormat())
			precisionsetting.setPrecision(manager.getPrecision())
			angleunitsetting.setAngleUnit(manager.getAngleUnit())
			complexnumbersetting.setComplexNumber(manager.getComplexNumber())
			historysavesetting.setHistorySave(manager.getSessionSave())
			window.keyboard.setButtonLabels()
			initialized = true;
		}
	}
}
