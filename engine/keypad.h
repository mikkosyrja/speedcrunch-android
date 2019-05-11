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

#ifndef KEYPAD_H
#define KEYPAD_H

#include <QString>
#include <QJsonParseError>

#include <vector>

//! Keyboard data.
class Keyboard
{
public:
	Keyboard();

	class Panel								//!< Key panel data.
	{
	public:
		//! Constructor.
		/*!
			\param panelname	Panel name.
		*/
		Panel(const QString& panelname) : name(panelname) { }

		class Key							//!< Single key data.
		{
		public:
			//! Constructor.
			Key() : color(false), bold(false ), row(0), col(0) { }

			QString getScript() const;

			QString label;					//!< Key label.
			QString value;					//!< Key primary value.
			QString second;					//!< Key secondary value.
			QString tooltip;				//!< Key tooltip text.
			bool color;						//!< True for highlight.
			bool bold;						//!< True for bold text.
			int row;						//!< Key row index.
			int col;						//!< Key column index.
		};

		bool load(QJsonObject& root);
		QString getKeyScript(int row, int col) const;

		QString name;						//!< Panel name.
		std::vector<std::vector<Key>> keys;	//!< Panel keys.
	};

	bool load(const QString& path, QJsonParseError& error);
	QString getKeyScript(const QString& name, int row, int col) const;

	Panel editkey;							//!< Edit row key (mobile).
	Panel leftpad;							//!< Left key panel (mobile portrait).
	Panel rightpad;							//!< Right key panel (mobile portrait).
	Panel landscape;						//!< Landscape panel (mobile landscale or desktop).
};

#endif // KEYPAD_H
