## SpeedCrunch Android

SpeedCrunch is a high-precision scientific calculator supporting expression editing, history stack,
unit conversions, radix systems, complex numbers and user defined variables.

Android port of [SpeedCrunch](http://speedcrunch.org) calculator.

User interface is based on the original Sailfish port by @qwazix. Current sailfish version is
available in [openrepos.net](https://openrepos.net/content/syrja/speedcrunch)

Features:
- Calculations with up to 50 digits of precision
- History stack with value or expression recall
- Expression editing with system virtual keyboard
- Fixed decimal, scientific or engineering formats
- Decimal, binary, octal and hexadecimal bases
- Built-in functions, constants and units with search
- User defined variables and functions

Translations in [Transifex](https://www.transifex.com/mikkosyrja/speedcrunch-mobile)

### Usage

User interface consists three pages and two keyboard panes. Leftmost page has function list,
central page is the calculator itself and rightmost page contains some settings. Sideways swiping
on the upper side of screen switches between pages and swiping on the keyboard switches either
between pages or between keyboard panes.

Top right menu has functions for copying latest result or expression to clipboard, pasting
clipboard contents to the expression field and clearing the history list.

#### Function and settings pages

Leftmost page has function list containing all SpeedCrunch engine functions, units, constants and
user defined items. Topmost filter list selection can be used to show only built-in functions,
units, constants or user defined variables and functions. Search field below it performs additional
filtering by name.

Long press on list item opens context menu with options. First menu item displays list item
content. For functions it is usage with parameter names. For constants and variables it is value
and for units it is just unit name. Selecting it inserts item to the expression editing field and
activates the main calculator page.

Used items are collected to recent item stack and displayed at the top of the list with bold font.
Newly created user variables and functions are automatically considered recently used. Other items
come after them in alphabetical order. Recent item stack size is not currently limited, but recent
menu items has additional context menu item for removing them from the recent stack. Also, user
defined functions and variables have context menu item for deleting them.

Rightmost page contains some settings. These are mostly same as desktop version settings and more
or less self-explanatory. If the Direct Insert from Lists setting is turned on, pointing item in
function or history list inserts it directly to the expression edit field. Note that user defined
variables and functions are saved with the history list.

#### Expression editing and history list

At the top of the main calculator page is history list. All calculated expressions and their
results are stored there. Latest result is displayed with bold font.

Long press on list item opens context menu with three options. First item inserts result to the
expression editing and second item recalls the whole expression for editing. Third item allows item
removing from history list.

Below the history list is expression editing field. It can be edited either by calculator key panes
or system virtual keyboard. Enter key on the virtual keyboard just closes it.

Desktop-like popup message above edit field displays current result or error message.

#### Keyboard and pulley menu

Most keys are familiar to anyone ever used handheld calculator. Key 0x is for entering hexadecimal
values (0xFF). Key x is for variable name x and key X= is for user variable or function definition
(x=42). Big arrow on the right side of second pane is for unit conversion (1 inch -> foot). Bottom
row arrow keys and backspace are for expression field editing.

Some keys have secondary function available with long press:
- Keys 1-6 produce hexadecimal values A-F
- Key 9 produces j for complex number imaginary part
- Key 0x produces 0b for binary values (0b1010)
- Key x produces character y for another variable name
- Key X= produces (x)= for function definition (foo(x)=)
- Keys ← and → move cursor to start or end of expression

For more information, see desktop SpeedCrunch [documentation](http://speedcrunch.org/userguide/index.html).

### License

This program is free software; you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation; either version 2 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
[GNU General Public License](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html) for more
details.

