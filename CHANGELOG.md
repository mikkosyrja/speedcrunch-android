### 0.1 (2018-09-17)

- Initial version

### 0.2 (2018-10-20)

- Fixed Save History on Exit setting behavior
- New setting Direct Insert from Lists:
	- When on inserts function instantly when clicked
	- When off inserting requires use of context menu
- Added history list popup menu:
	- First item inserts selected result
	- Second item edits selected expression
	- Third item removes line from history list
	- Follows Direct Insert from Lists setting
- Compiled with Qt version 5.11.2
- Initial localization support:
	- Function and constant translations from desktop version.
	- Id based UI translations with english as a backup
	- https://www.transifex.com/mikkosyrja/speedcrunch-mobile/
	- Currently en_GB (source) and fi_FI translations
	- Added languages de_DE, it_IT, fr_FR, es_ES, ru_RU and sv_SE
- Moved system settings to the bottom of settings page

### 0.3 (2018-11-27)

- Added spanish UI translations (thanks @carmenfdezb)
- Added french UI translations (thanks @JeanDeLaMouche)
- Added support for portuguese language pt_PT
- Adjusted settings page control widths for different languages
- Initial landscape mode support:
	- Uses single 3x10 button keyboard in landscape mode
	- Status bar is hidden in landscape mode
	- System settings at the bottom of settings page are hidden
- Some keyboard modifications:
	- Long press with square (x²) produces generic exponent
	- Long press with square root (√) produces cubic root
- Added new menu items for home pages:
	- Item SpeedCruch Android opens application home page
	- Item SpeedCruch opens SpeedCruch engine home page
- Added some flicking resistance to buttons:
	- Drag within button does not flick keyboard or page
	- Reduces unwanted flicks when pressing buttons

### 0.4 (2019-06-04)

- Added support for slovenian language sl_SL
- Added slovenian UI translations (thanks @sponka)
- Added swedish UI translations (thanks @ekrogius)
- Compiled with Qt 5.12.2 and Android NDK r19c:
    - Qt 5.12.3 has problems with android virtual keyboard
- Initial keyboard configuration:
    - Keyboard layouts are loaded from json files
	- Initially four different layouts:
	- Classic layout will stay as version 0.5 keyboard
	- Current layout will be default keyboard from now on
	- Gemini layout has only two rows in horizontal mode
	- Tablet layout has more rows or columns
	- User defined keyboards are supported
- Modifications to Current keyboard:
    - Long press with equals (=) produces previous result (ans)
	- Long press with backspace clears all
	- Long press with ln produces lg()
	- Long press with exp produces 10^
	- Long press with division (÷) produces integer division (\)
	- Long press with trigonometrics produce hyperbolic versions
- Fixed history list handling with backslash (integer division)

### 0.4.1 (2019-06-xx)

- Updated UI translations
- Added support for chinese language zh_CN

