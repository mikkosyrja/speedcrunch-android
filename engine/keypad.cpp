// This file is part of the SpeedCrunch project
// Copyright (C) 2014 @qwazix
// Copyright (C) 2018 Mikko Syrjä
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; see the file COPYING.  If not, write to
// the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
// Boston, MA 02110-1301, USA.

#include "keypad.h"

#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

//
//	key functions
//
//! Relabel single key label.
/*!
	\param settings		Current settings.
*/
void Keyboard::Panel::Key::relabel(const Settings* settings)
{
	if ( label == "[1H]" )
		label = (settings->resultFormat == 'h' ? "1 A" : "1");
	else if ( label == "[2H]" )
		label = (settings->resultFormat == 'h' ? "2 B" : "2");
	else if ( label == "[3H]" )
		label = (settings->resultFormat == 'h' ? "3 C" : "3");
	else if ( label == "[4H]" )
		label = (settings->resultFormat == 'h' ? "4 D" : "4");
	else if ( label == "[5H]" )
		label = (settings->resultFormat == 'h' ? "5 E" : "5");
	else if ( label == "[6H]" )
		label = (settings->resultFormat == 'h' ? "6 F" : "6");
	else if ( label == "[9C]" )
		label = (settings->complexNumbers ? "9 j" : "9");

	else if ( label == "[0S]" )
		label = (settings->resultFormat == 's' ? "0 °" : "0");
	else if ( label == "[.S]" )
		label = (settings->resultFormat == 's' ? ". '" : ".");
	else if ( label == "[,S]" )
		label = (settings->resultFormat == 's' ? ", '" : ",");
	else if ( label == "[;S]" )
		label = (settings->resultFormat == 's' ? "; :" : ";");

	else if ( label == "[XO]" )
		label = (settings->resultFormat == 'o' ? "0o" : "0x");
}

//! Get QML script for a key.
/*!
	\return				QML script string.
*/
QString Keyboard::Panel::Key::getScript() const
{
	QString script = "CalcButton { ";
	if ( !label.isEmpty() )
	{
		script += "text: \"";
		if ( bold )
			script += "<b>";
		script += label;
		if ( bold )
			script += "</b>";
		script += "\"; ";
	}
	if ( !value.isEmpty() )
		script += "value: \"" + value + "\"; ";
	if ( !second.isEmpty() )
		script += "second: \"" + second + "\"; ";
	if ( color )
		script += "highlight: true; ";
	script += "}";
	return script.replace("\\", "\\\\");
}

//
//	panel functions
//
//! Load panel from JSON file.
/*!
	\param root			JSON file root object .
	\return				True for change.
*/
bool Keyboard::Panel::load(QJsonObject& root)
{
	Settings* settings = Settings::instance();
	virtualKeyboard = true;
	keys.clear();

	QJsonValue value = root.value(name);
	if ( value != QJsonValue::Undefined )
	{
		QJsonValue panelsettings = value.toObject().value("settings");
		if ( panelsettings != QJsonValue::Undefined )
		{
			QJsonValue virtualkeyboard = panelsettings.toObject().value("virtual");
			if ( virtualkeyboard != QJsonValue::Undefined )
				virtualKeyboard = virtualkeyboard.toBool();
		}
		QJsonValue rows = value.toObject().value("rows");
		if ( rows != QJsonValue::Undefined )
		{
			int rowCount = 0;
			for ( auto row : rows.toArray() )
			{
				keys.push_back(std::vector<Key>());
				QJsonValue keyrow = row.toObject().value("keys");
				if ( keyrow != QJsonValue::Undefined )
				{
					int keyCount = 0;
					for ( auto keydata : keyrow.toArray() )
					{
						QJsonObject object = keydata.toObject();

						Key key;
						key.label = object.value("label").toString();
						key.value = object.value("value").toString();
						key.second = object.value("second").toString();
						key.tip = object.value("tip").toString();
						key.color = object.value("color").toBool();
						key.bold = object.value("bold").toBool();
						key.row = rowCount;
						key.col = keyCount;

						key.relabel(settings);

						if ( key.value.isEmpty() )
							key.value = key.label;
						if ( key.second.isEmpty() )
							key.second = key.value;
						if ( key.tip.isEmpty())
							key.tip = key.value;
#ifdef Q_OS_ANDROID
						if ( key.label == "&" )
							key.label = "&&";
						if ( key.value == "<back>" )
							key.label = "";
#endif
						keys.back().push_back(key);
						++keyCount;
					}
				}
				++rowCount;
			}
			return true;
		}
	}
	return false;
}

//! Get QML script for a key.
/*!
	\param row			Row index.
	\param col			Column index.
	\return				QML script string.
*/
QString Keyboard::Panel::getKeyScript(int row, int col) const
{
	if ( row < static_cast<int>(keys.size()) )
	{
		if ( col < static_cast<int>(keys.at(row).size()) )
			return keys.at(row).at(col).getScript();
	}
	return QString();
}

//
//	keyboard functions
//
//! Constructor.
Keyboard::Keyboard() : editkey("editkey"), leftpad("leftpad"), rightpad("rightpad"), landscape("landscape")
{

}

//! Load keyboard from JSON file.
/*!
	\param path			JSON file path.
	\param error		Error object.
	\return				True for change.
*/
bool Keyboard::load(const QString& path, QJsonParseError& error)
{
	QFile file(path);
	if ( file.open(QIODevice::ReadOnly) )
	{
		auto json = QJsonDocument::fromJson(file.readAll(), &error);
		if ( !json.isNull() )
		{
			QJsonObject root = json.object();
			return (editkey.load(root) && leftpad.load(root) && rightpad.load(root) && landscape.load(root));
		}
	}
	return false;
}

//! Get QML script for a key.
/*!
	\param name			Keyboard name.
	\param row			Row index.
	\param col			Column index.
	\return				QML script string.
*/
QString Keyboard::getKeyScript(const QString& name, int row, int col) const
{
	if ( name == "leftpad" )
		return leftpad.getKeyScript(row, col);
	if ( name == "rightpad" )
		return rightpad.getKeyScript(row, col);
	if ( name == "landscape" )
		return landscape.getKeyScript(row, col);
	return editkey.getKeyScript(row, col);
}

//! Get virtual keyboard state for a given panel.
/*!
	\param name			Keyboard panel name.
	\return				True if virtual keyboard is allowed with panel.
*/
bool Keyboard::getVirtualKeyboard(const QString& name) const
{
	if ( name == "leftpad" )
		return leftpad.virtualKeyboard;
	if ( name == "rightpad" )
		return rightpad.virtualKeyboard;
	if ( name == "landscape" )
		return landscape.virtualKeyboard;
	return true;
}
