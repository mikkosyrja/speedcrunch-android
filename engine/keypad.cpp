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
	QJsonValue value = root.value(name);
	if ( value != QJsonValue::Undefined )
	{
		QJsonValue rows = value.toObject().value("rows");
		if ( rows != QJsonValue::Undefined )
		{
			keys.clear();
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
						key.tooltip = object.value("tooltip").toString();
						key.color = object.value("color").toBool();
						key.bold = object.value("bold").toBool();
						key.row = rowCount;
						key.col = keyCount;

						if ( key.value.isEmpty() )
							key.value = key.label;
						if ( key.second.isEmpty() )
							key.second = key.value;
						if ( key.tooltip.isEmpty())
						key.tooltip = key.value;

						if ( key.label == "&" )
							key.label = "&&";

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
