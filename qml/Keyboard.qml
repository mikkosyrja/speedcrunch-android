import QtQuick 2.9
import QtQuick.Controls 2.2

Rectangle
{
	SwipeView
	{
		anchors.fill: parent

		Page
		{
			Rectangle
			{
				anchors.fill: parent
				color: "darkGray"

				Grid
				{
					anchors.fill: parent
					anchors.margins: 10
					columns: 5
					spacing: 10

					property int buttoncols: 5
					property int buttonrows: 5

					CalcButton { id: button7; text: "7" } CalcButton { id: button8; text: "8" }
					CalcButton { id: button9; text: "9"; value: "9"; secondary: "j" }
					CalcButton { text: "/" } CalcButton { text: "x²"; value: "^2" }
					CalcButton { id: button4; text: "4"; value: "4"; secondary: "D" }
					CalcButton { id: button5; text: "5"; value: "5"; secondary: "E" }
					CalcButton { id: button6; text: "6"; value: "6"; secondary: "F" }
					CalcButton { text: "×"; value: "×" } CalcButton { text: "√"; value: "sqrt()" }
					CalcButton { id: button1; text: "1"; value: "1"; secondary: "A" }
					CalcButton { id: button2; text: "2"; value: "2"; secondary: "B" }
					CalcButton { id: button3; text: "3"; value: "3"; secondary: "C" }
					CalcButton { text: "-" } CalcButton { text: "1/x"; value: "1/" }
					CalcButton { text: "0" } CalcButton { text: "." } CalcButton { text: ";" } CalcButton { text: "+" }
					// long press: 0 -> °(degree), . -> '(minute), ; -> :(minute), where to put "(second)?
					CalcButton { id: buttonbase; text: "0x"; value: "0x"; secondary: "0b"  }

					CalcButton { text: "(" } CalcButton { text: ")" }
					CalcButton { text: "←"; special: true } CalcButton { text: "→"; special: true }
					CalcButton { text: "BS" }
/*
					CalcButton { text: "("; color: Theme.highlightColor } CalcButton { text: ")"; color: Theme.highlightColor }
					CalcButton { text: "←"; special: true; color: Theme.highlightColor; onRunFunction: { textfield.cursorPosition-- } }
					CalcButton { text: "→"; special: true; color: Theme.highlightColor; onRunFunction: { textfield.cursorPosition++ } }
					Backspace { color: Theme.highlightColor }
*/
				}
			}
		}

		Page
		{
			Rectangle
			{
				anchors.fill: parent
				color: "darkGray"

				Grid
				{
					anchors.fill: parent
					anchors.margins: 10
					columns: 5
					spacing: 10

					property int buttoncols: 5
					property int buttonrows: 5

					CalcButton { text: "sin"; isFunction: true } CalcButton { text: "cos"; isFunction: true }
					CalcButton { text: "tan"; isFunction: true } CalcButton { text: "ln"; isFunction: true }
					CalcButton { text: "Xⁿ"; value:"^" }

					CalcButton { text: "asin"; value: "arcsin()" } CalcButton { text: "acos"; value: "arccos()" }
					CalcButton { text: "atan"; value: "arctan()" } CalcButton { text: "exp"; isFunction: true }
					CalcButton { text: "∛"; value:"cbrt()" }

					CalcButton { text: "π"; value: "pi" } CalcButton { text: "e" } CalcButton { text: "x"; secondary: "y" }
					CalcButton { text: "X="; value: "="; secondary: "(x)=" } CalcButton { text: "!" }

					CalcButton { text: "&&" } CalcButton { text: "|" } CalcButton { text: "<<" } CalcButton { text: ">>" }
					CalcButton { text: "➔"; value: "->" }

					CalcButton { text: "(" } CalcButton { text: ")" }
					CalcButton { text: "←"; special: true } CalcButton { text: "→"; special: true }
					CalcButton { text: "BS" }
/*
					CalcButton { text: "("; color: Theme.highlightColor } CalcButton { text: ")"; color: Theme.highlightColor }
					CalcButton { text: "←"; special: true; color: Theme.highlightColor; onRunFunction: { textfield.cursorPosition-- } }
					CalcButton { text: "→"; special: true; color: Theme.highlightColor; onRunFunction: { textfield.cursorPosition++ } }
					Backspace { color: Theme.highlightColor }
*/
				}
			}
		}
	}
}
