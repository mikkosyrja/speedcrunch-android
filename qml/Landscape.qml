import QtQuick 2.9
import QtQuick.Controls 2.3

Rectangle
{
	property int buttonwidth: button1.width
	property int buttonheight: button1.height
	property int swipecount: 1
	property int swipeindex: 0

	clip: true
	color: backgroundcolor

	Grid
	{
		anchors { fill: parent; margins: itemspacing }
		columns: buttoncols
		spacing: itemspacing

		CalcButton { id: button1; text: "1"; value: "1"; secondary: "A" }
		CalcButton { id: button2; text: "2"; value: "2"; secondary: "B" }
		CalcButton { id: button3; text: "3"; value: "3"; secondary: "C" }
		CalcButton { id: button4; text: "4"; value: "4"; secondary: "D" }
		CalcButton { id: button5; text: "5"; value: "5"; secondary: "E" }
		CalcButton { id: button6; text: "6"; value: "6"; secondary: "F" }
		CalcButton { id: button7; text: "7" }
		CalcButton { id: button8; text: "8" }
		CalcButton { id: button9; text: "9"; value: "9"; secondary: "j" }
		CalcButton { text: "0" }

		CalcButton { text: "/" }
		CalcButton { text: "×"; value: "×" }
		CalcButton { text: "-" }
		CalcButton { text: "+" }

		CalcButton { text: "." }
		CalcButton { text: ";" }

		CalcButton { text: "x²"; value: "^2" }
		CalcButton { text: "√"; value: "sqrt()" }
		CalcButton { text: "1/x"; value: "1/" }
		CalcButton { id: buttonbase; text: "0x"; value: "0x"; secondary: "0b"  }

		CalcButton { text: "sin"; value: "sin()" }
		CalcButton { text: "cos"; value: "cos()" }
		CalcButton { text: "tan"; value: "tan()" }
		CalcButton { text: "Xⁿ"; value:"^" }
		CalcButton { image: "cuberoot.png"; value:"cbrt()" }

		CalcButton { text: "π"; value: "pi" }
		CalcButton { text: "e" }
		CalcButton { text: "x"; secondary: "y" }
		CalcButton { text: "X="; value: "="; secondary: "(x)=" }
		CalcButton { text: "!" }

		CalcButton { text: "&&" }
		CalcButton { text: "|" }
		CalcButton { text: "<<" }
		CalcButton { text: ">>" }
		CalcButton { text: "➔"; value: "->" }

		CalcButton { text: "(" } CalcButton { text: ")" }
		CalcButton { text: "←"; special: true; onRunFunction: { textfield.cursorPosition-- } }
		CalcButton { text: "→"; special: true; onRunFunction: { textfield.cursorPosition++ } }
		BackSpace { }
	}

	function setButtonLabels()
	{
		var format = manager.getResultFormat()
		if ( format === "h" )
		{
			button1.text = "1 A"; button2.text = "2 B"; button3.text = "3 C"
			button4.text = "4 D"; button5.text = "5 E"; button6.text = "6 F"
		}
		else
		{
			button1.text = "1"; button2.text = "2"; button3.text = "3"
			button4.text = "4"; button5.text = "5"; button6.text = "6"
		}
		if ( format === "h" || format === "b" || format === "o" )
			buttonbase.text = "0x 0b"
		else
			buttonbase.text = "0x"
		if ( manager.getComplexNumber() !== "d" )
			button9.text = "9 j"
		else
			button9.text = "9"
	}
}
