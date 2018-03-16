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
#include "core/evaluator.h"
#include "core/settings.h"
#include <QDebug>
#include <QClipboard>

class Manager : public QObject
{
	Q_OBJECT

public:
	Manager();

	Q_INVOKABLE QString autoCalc(const QString& input);
	Q_INVOKABLE QString calculate(const QString& input);
	Q_INVOKABLE QString getFunctions(QString filter);
	Q_INVOKABLE void setAngleMode(QString mode);
	Q_INVOKABLE QString getAngleMode() const;
	Q_INVOKABLE void setPrecision(QString precision);
	Q_INVOKABLE QString getPrecision() const;
	Q_INVOKABLE void setClipboard(QString text);


private:
	Evaluator* evaluator;
	Settings* settings;
	QClipboard* clipboard;
};

#endif
