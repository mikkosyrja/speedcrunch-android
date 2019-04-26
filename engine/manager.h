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

#ifndef MANAGER_H
#define MANAGER_H

#include <QObject>
#include <QString>
#include <QStringList>
#include <QDebug>
#include <QClipboard>
#include <QTranslator>

#include "core/evaluator.h"
#include "core/settings.h"
#include "core/constants.h"
#include "math/units.h"

#include "keypad.h"

class Manager : public QObject
{
	Q_OBJECT

public:
	explicit Manager(QObject* parent = nullptr);

	Q_INVOKABLE void saveSession();

	Q_INVOKABLE QString autoCalc(const QString& input);
	Q_INVOKABLE QString autoFix(const QString& input);
	Q_INVOKABLE QString calculate(const QString& input);
	Q_INVOKABLE QString getError();

	Q_INVOKABLE QString getHistory(int);
	Q_INVOKABLE QString getFunctions(const QString& filter, const QString& type, int);

	Q_INVOKABLE void setAngleUnit(const QString& unit);
	Q_INVOKABLE QString getAngleUnit() const;
	Q_INVOKABLE void setResultFormat(const QString& format);
	Q_INVOKABLE QString getResultFormat() const;
	Q_INVOKABLE void setPrecision(const QString& precision);
	Q_INVOKABLE QString getPrecision() const;
	Q_INVOKABLE void setComplexNumber(const QString& complex);
	Q_INVOKABLE QString getComplexNumber() const;
	Q_INVOKABLE void setFontSize(const QString& size);
	Q_INVOKABLE QString getFontSize() const;

	Q_INVOKABLE void setSessionSave(bool save);
	Q_INVOKABLE bool getSessionSave() const;
	Q_INVOKABLE void setClickInsert(bool click);
	Q_INVOKABLE bool getClickInsert() const;

	Q_INVOKABLE void clearHistory(int index);

	Q_INVOKABLE QString getAssignId() const;
	Q_INVOKABLE void clearVariable(const QString& variable);
	Q_INVOKABLE void clearFunction(const QString& function);

	Q_INVOKABLE bool updateRecent(const QString& name);
	Q_INVOKABLE bool removeRecent(const QString& name);

	Q_INVOKABLE void setClipboard(const QString& text) const;
	Q_INVOKABLE QString getClipboard() const;

	Q_INVOKABLE bool setKeyboard(const QString& text);
	Q_INVOKABLE QString getKeyboard() const;
	Q_INVOKABLE int getKeyboardIndex() const;

	Q_INVOKABLE QString getKeyboards() const;
	Q_INVOKABLE QSize getKeyboardSize(const QString& name) const;
	Q_INVOKABLE QString getKeyScript(const QString& name, int row, int col) const;

private:
	bool checkRecent(const QString& name) const;

	Session* session;						//!< Current session.
	Evaluator* evaluator;					//!< Expression evaluator.
	Settings* settings;						//!< Settings storage.
	QClipboard* clipboard;					//!< System clipboard.

	QTranslator engineTranslator;			//!< Engine translator.
	QTranslator backupTranslator;			//!< UI backup translator.
	QTranslator localeTranslator;			//!< UI locale translator.

	QStringList recent;						//!< Recent functions.
	QStringList identifiers;				//!< Function identifiers.
	QStringList functions;					//!< Function names.

	QList<Unit> units;						//!< Available units.
	QList<Constant> constants;				//!< Available constants.

	QJsonParseError parseError;				//!< Parse error handling.
	QMap<QString, QString> keyboards;		//!< Keyboard names and paths.
	Keyboard keyboard;						//!< Current keyboard.
};

#endif
