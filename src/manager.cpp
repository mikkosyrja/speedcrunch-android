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

#include "manager.h"
#include <QFile>
#include <QDir>
#include <QGuiApplication>
#include "core/functions.h"
#include "core/constants.h"
#include "core/numberformatter.h"

// save the active keyboard
Manager::Manager()
{
	evaluator = Evaluator::instance();
	settings = Settings::instance();
	clipboard = QGuiApplication::clipboard();
}

//
QString Manager::autoCalc(const QString& input)
{
#if 0
	const QString str = evaluator->autoFix(input);
	if ( str.isEmpty() )
		return QString("");

	// very short (just one token) and still no calculation, then skip
	//if ( ! d->ansAvailable ) {
//        const Tokens tokens = evaluator->scan( input );
//        if ( tokens.count() < 2 )
//            return "";
	//}

	// too short even after autofix ? do not bother either...
	const Tokens tokens = evaluator->scan(str);
	if ( tokens.count() < 2 )
		return QString("");

	// strip off assignment operator, e.g. "x=1+2" becomes "1+2" only
	// the reason is that we want only to evaluate (on the fly) the expression,
	// not to update (put the result in) the variable
	//if( tokens.count() > 2 ) // reftk
	//if( tokens.at(0).isIdentifier() )
	//if( tokens.at(1).asOperator() == Token::Equal )
	//  str.remove( 0, tokens.at(1).pos()+1 );

	// same reason as above, do not update "ans"
	evaluator->setExpression(str);
	const HNumber num = evaluator->evalNoAssign();

	return QString(HMath::format(num,'g',4));
#endif
	return QString();
}

//! Auto fix expression.
/*!
	\param input		Initial expression.
	\return				Fixed expression.
*/
QString Manager::autoFix(const QString& input)
{
	return evaluator->autoFix(input);
}

//! Calculate expression.
/*!
	\param input		Initial expression.
	\return				Result string.
*/
QString Manager::calculate(const QString& input)
{
	const QString expression = evaluator->autoFix(input);
	evaluator->setExpression(expression);
//	Quantity quantity = evaluator->eval();
	Quantity quantity = evaluator->evalUpdateAns();
//	Quantity quantity = evaluator->evalNoAssign();

	return NumberFormatter::format(quantity);
}

//
QString Manager::getFunctions(QString filter)
{
	QStringList functions = FunctionRepo::instance()->getIdentifiers();
	QString result = "[";
	for ( int index = 0; index < functions.count(); ++index )
	{
		if ( Function* function = FunctionRepo::instance()->find(functions.at(index)) )
		{
			if ( filter == "" || function->name().toLower().contains(filter.toLower())
				|| function->identifier().toLower().contains(filter.toLower()))
				result += "{ val:'" + function->identifier()+ "' , name: '" + function->name() + "' , func: true},";
		}
	}
	QList<Constant> constants = Constants::instance()->list();
	for ( int index = 0; index < constants.count(); ++index )
	{
		if ( filter == "" || constants.at(index).value.contains(filter, Qt::CaseInsensitive)
			|| constants.at(index).name.contains(filter, Qt::CaseInsensitive))
			result += "{ val:'" + constants.at(index).value + "' , name: \"" + constants.at(index).name +"\", func: false},";
	}

	return result += "]";
}

//! Set angle unit.
/*!
	\param mode			Angle unit (d, r, g).
*/
void Manager::setAngleMode(QString mode)
{
	if ( !mode.isEmpty() && mode.at(0) != settings->angleUnit )
	{
		settings->angleUnit = mode.at(0).toLatin1();
//		qDebug() << "set angle unit: " << settings->angleUnit;
		settings->save();
	}
}

//! Get angle unit.
/*!
	\return				Angle unit (d, r, g).
*/
QString Manager::getAngleMode() const
{
	settings->load();
//	qDebug() << "get angle unit: " << settings->angleUnit;
	return QString(settings->angleUnit);
}

//! Set precision.
/*!
	\param precision	Decimal precision.
*/
void Manager::setPrecision(QString precision)
{
	settings->resultPrecision = (precision.isEmpty() ? -1 : precision.toInt());
//	qDebug() << "set precision: " << settings->resultPrecision;
	settings->save();
}

//! Get precision.
/*!
	\return				Decimal precision.
*/
QString Manager::getPrecision() const
{
	settings->load();
//	qDebug() << "get precision: " << settings->resultPrecision;
	return (settings->resultPrecision < 0 ? QString() : QString::number(settings->resultPrecision));
}

//! Set clipboard text.
/*!
	\param text			Clipboard text.
*/
void Manager::setClipboard(QString text)
{
//	qDebug() << "set clipboard: " << settings->angleUnit;
	clipboard->setText(text, QClipboard::Clipboard);
	clipboard->setText(text, QClipboard::Selection);
}

