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
#include <QJsonDocument>

#include "core/session.h"
#include "core/functions.h"
#include "core/numberformatter.h"

//! Constructor.
/*!
	\param paren							//!< Optional parent.
*/
Manager::Manager(QObject* parent) : QObject(parent)
{
	session = new Session;

	evaluator = Evaluator::instance();
	evaluator->setSession(session);

	settings = Settings::instance();
	settings->load();

	evaluator->initializeBuiltInVariables();
	DMath::complexMode = settings->complexNumbers;

	QDir directory;		// configuration path
	QString configpath = Settings::getConfigPath();
	directory.mkpath(configpath);

	QString historypath = configpath + "/history.json";
	QFile historyfile(historypath);
	if ( historyfile.open(QIODevice::ReadOnly) )
	{
		QByteArray data = historyfile.readAll();
		QJsonDocument doc(QJsonDocument::fromJson(data));
		session->deSerialize(doc.object(), true);
		historyfile.close();
	}

	QString recentpath = configpath + "/recent.json";
	QFile recentfile(recentpath);
	if ( recentfile.open(QIODevice::ReadOnly) )
	{
		QByteArray data = recentfile.readAll();
		QJsonDocument doc(QJsonDocument::fromJson(data));
		QJsonObject json = doc.object();
		if ( json.contains("recent") )
		{
			QJsonArray entries = json["recent"].toArray();
			int count = entries.size();
			for( int index = 0; index < count; ++index )
				recent.push_back(entries[index].toObject()["item"].toString());
		}
		recentfile.close();
	}

	clipboard = QGuiApplication::clipboard();

	identifiers = FunctionRepo::instance()->getIdentifiers();
	for ( int index = 0; index < identifiers.count(); ++index )
	{
		if ( const Function* function = FunctionRepo::instance()->find(identifiers.at(index)) )
			functions.push_back(function->name());
	}
	functions.sort(Qt::CaseInsensitive);

	units = Units::getList();
	qSort(units.begin(), units.end(), [](const Unit& first, const Unit& second)
		{ return first.name.compare(second.name, Qt::CaseInsensitive) < 0; });

	constants = Constants::instance()->list();
	qSort(constants.begin(), constants.end(), [](const Constant& first, const Constant& second)
		{ return first.name.compare(second.name, Qt::CaseInsensitive) < 0; });
}

//! Save session on exit.
void Manager::saveSession()
{
	QString path = Settings::getConfigPath();
	path.append("/history.json");

	QFile historyfile(path);
	if ( historyfile.open(QIODevice::WriteOnly) )
	{
		QJsonObject json;
		session->serialize(json);
		QJsonDocument document(json);
		historyfile.write(document.toJson());
		historyfile.close();
	}

	path = Settings::getConfigPath();
	path.append("/recent.json");

	QFile recentfile(path);
	if ( recentfile.open(QIODevice::WriteOnly) )
	{
		QJsonObject json;
		QJsonArray entries;
		for ( const auto& item : recent )
		{
			QJsonObject object;
			object["item"] = item;
			entries.append(object);
		}
		json["recent"] = entries;
		QJsonDocument document(json);
		recentfile.write(document.toJson());
		recentfile.close();
	}
}

//! Auto calculate expression.
/*!
	\param input		Expression.
	\return				Result string.
*/
QString Manager::autoCalc(const QString& input)
{
	const QString expression = evaluator->autoFix(input);
	evaluator->setExpression(expression);
	Quantity quantity = evaluator->evalNoAssign();
	if ( quantity.isNan() )
		return "NaN";
	return NumberFormatter::format(quantity);
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
	\param input		Expression.
	\return				Result string.
*/
QString Manager::calculate(const QString& input)
{
	const QString expression = evaluator->autoFix(input);
	evaluator->setExpression(expression);
	Quantity quantity = evaluator->evalUpdateAns();
	if ( quantity.isNan() )
	{
		if ( evaluator->isUserFunctionAssign() )
		{
			updateRecent(evaluator->getAssignId() + "()");
			if ( evaluator->error().isEmpty() )
				session->addHistoryEntry(HistoryEntry(expression, quantity));
		}
		return "NaN";
	}
	else	// user variable
	{
		QString assign = evaluator->getAssignId();
		if ( !assign.isEmpty() )
			updateRecent(assign);
	}
	session->addHistoryEntry(HistoryEntry(expression, quantity));
	return NumberFormatter::format(quantity);
}

//! Get latest error as string.
/*!
	\return				Error string.
*/
QString Manager::getError()
{
	QString error = evaluator->error();
	error.remove("<b>").remove("</b>");
	return error;
}

//! Get history list.
/*!
	\return				History list in JavaScript format.

	Last integer parameter is just for triggering update in QML.
*/
QString Manager::getHistory(int)
{
	QString result = "[";
	for ( const auto& entry : session->historyToList() )
		result += "{expression:\"" + entry.expr() + "\",value:\"" + NumberFormatter::format(entry.result()) + "\"},";
	return result += "]";
}

//! Get functions, constants and units.
/*!
	\param filter		Filter string.
	\param type			Function type (a, f, u, c, v).
	\return				Function list in JavaScript format.

	Last integer parameter is just for triggering update in QML.
*/
QString Manager::getFunctions(const QString& filter, const QString& type, int)
{
	QList<Variable> variables = evaluator->getVariables();
	qSort(variables.begin(), variables.end(), [](const Variable& first, const Variable& second)
		{ return first.identifier().compare(second.identifier(), Qt::CaseInsensitive) < 0; });

	QList<UserFunction> userfunctions = evaluator->getUserFunctions();
	qSort(userfunctions.begin(), userfunctions.end(), [](const UserFunction& first, const UserFunction& second)
		{ return first.name().compare(second.name(), Qt::CaseInsensitive) < 0; });

	QString result = "[";

	auto appendfunction = [&](const Function* function, bool recent)
	{
		if ( filter.isEmpty() || function->name().contains(filter, Qt::CaseInsensitive)
			|| function->identifier().contains(filter, Qt::CaseInsensitive) )
		{
			QString usage = function->identifier() + "(" + function->usage() + ")";
			usage.remove("<sub>").remove("</sub>");
			result += "{value:\"" + function->identifier() + "()"
				+ "\",name:\"" + function->name() + "\",usage:\"" + usage
				+ "\",label:\"" + usage + "\",user:false,"
				+ "recent:" + (recent ? "true" : "false") + "},";
		}
	};

	auto findfunction = [&](const QString& name) -> const Function*
	{
		for ( int index = 0; index < identifiers.count(); ++index )
		{
			if ( const Function* function = FunctionRepo::instance()->find(identifiers.at(index)) )
			{
				if ( function->name() == name )
					return function;
			}
		}
		return nullptr;
	};

	auto appendunit = [&](const Unit& unit, bool recent)
	{
		if ( filter.isEmpty() || unit.name.contains(filter, Qt::CaseInsensitive))
			result += "{value:\"" + unit.name
				+ "\", name:\"" + unit.name + "\",usage:\""
				+ "\",label:\"" + unit.name + "\",user:false,"
				+ "recent:" + (recent ? "true" : "false") + "},";
	};

	auto findunit = [&](const QString& name) -> const Unit*
	{
		for ( const auto& unit : units ) if ( unit.name == name )
			return &unit;
		return nullptr;
	};

	auto appendconstant = [&](const Constant& constant, bool recent)
	{
		if ( filter.isEmpty() || constant.value.contains(filter, Qt::CaseInsensitive)
			|| constant.name.contains(filter, Qt::CaseInsensitive))
			result += "{value:\"" + constant.value
				+ "\",name:\"" + constant.name + "\",usage:\""
				+ "\",label:\"" + constant.value + "\",user:false,"
				+ "recent:" + (recent ? "true" : "false") + "},";
	};

	auto findconstant = [&](const QString& name) -> const Constant*
	{
		for ( const auto& constant : constants ) if ( constant.name == name )
			return &constant;
		return nullptr;
	};

	auto appendvariable = [&](const Variable& variable, bool recent)
	{
		if ( variable.type() == Variable::UserDefined
			 && (filter.isEmpty() || variable.identifier().contains(filter, Qt::CaseInsensitive)) )
		{
			QString value = DMath::format(variable.value(), HNumber::Format::Fixed());
			result += "{value:\"" + variable.identifier()
				+ "\",name:\"" + variable.identifier() + "\",usage:\""
				+ "\",label:\"" + value + "\",user:true,"
				+ "recent:" + (recent ? "true" : "false") + "},";
		}
	};

	auto findvariable = [&](const QString& name) -> const Variable*
	{
		for ( const auto& variable : variables ) if ( variable.identifier() == name )
			return &variable;
		return nullptr;
	};

	auto appenduserfunction = [&](const UserFunction& function, bool recent)
	{
		if ( filter.isEmpty() || function.name().contains(filter, Qt::CaseInsensitive) )
		{
			QString usage = function.name() + "(";
			for ( const auto& argument : function.arguments() )
				usage += argument + ";";
			if ( usage.at(usage.size() - 1) == ';' )
				usage.chop(1);
			usage += ")";
			result += "{value:\"" + function.name() + "()"
				+ "\",name:\"" + function.name() + "()\",usage:\"" + usage
				+ "\",label:\"" + usage + "\",user:true,"
				+ "recent:" + (recent ? "true" : "false") + "},";
		}
	};

	auto finduserfunction = [&](const QString& name) -> const UserFunction*
	{
		for ( const auto& function : userfunctions ) if ( function.name() == name )
			return &function;
		return nullptr;
	};

	QStringList list(recent);	// recent items first
	for ( auto iterator = list.begin(); iterator != list.end(); )
	{
		if ( auto function = findfunction(*iterator) )
		{
			if ( type == "a" || type == "f" )
				appendfunction(function, true);
			iterator = list.erase(iterator);
			continue;
		}
		if ( auto unit = findunit(*iterator) )
		{
			if ( type == "a" || type == "u" )
				appendunit(*unit, true);
			iterator = list.erase(iterator);
			continue;
		}
		if ( auto constant = findconstant(*iterator) )
		{
			if ( type == "a" || type == "c" )
				appendconstant(*constant, true);
			iterator = list.erase(iterator);
			continue;
		}
		if ( auto variable = findvariable(*iterator) )
		{
			if ( type == "a" || type == "v" )
				appendvariable(*variable, true);
			iterator = list.erase(iterator);
			continue;
		}
		QString name = *iterator;
		name.chop(2);	// chop parenthesis
		if ( auto function = finduserfunction(name) )
		{
			if ( type == "a" || type == "v" )
				appenduserfunction(*function, true);
			iterator = list.erase(iterator);
			continue;
		}

		++iterator;
	}

	for ( const auto& name : list )		// remove items not found from any list
		removeRecent(name);

	if ( type == "a" || type == "f" ) for ( const auto& name : functions )
	{
		if ( !checkRecent(name) ) if ( auto function = findfunction(name) )
			appendfunction(function, false);
	}
	if ( type == "a" || type == "u" ) for ( const auto& unit : units )
	{
		if ( !checkRecent(unit.name) )
			appendunit(unit, false);
	}
	if ( type == "a" || type == "c" ) for ( const auto& constant : constants )
	{
		if ( !checkRecent(constant.name) )
			appendconstant(constant, false);
	}

	if ( type == "a" || type == "v" )	// variables and user functions
	{
		for ( const auto& variable : variables )
		{
			if ( !checkRecent(variable.identifier()) )
				appendvariable(variable, false);
		}
		for ( const auto& function : userfunctions )
		{
			if ( !checkRecent(function.name() + "()") )
				appenduserfunction(function, false);
		}
	}

	return result += "]";
}

//! Set angle unit.
/*!
	\param unit			Angle unit (d, r, g).
*/
void Manager::setAngleUnit(const QString& unit)
{
	if ( !unit.isEmpty() && unit.at(0) != settings->angleUnit )
	{
		settings->angleUnit = unit.at(0).toLatin1();
		evaluator->initializeAngleUnits();
		settings->save();
	}
}

//! Get angle unit.
/*!
	\return				Angle unit (d, r, g).
*/
QString Manager::getAngleUnit() const
{
	return QString(settings->angleUnit);
}

//! Set result format.
/*!
	\param format		Result format (g, f, n, e, b, o, h).
*/
void Manager::setResultFormat(const QString& format)
{
	if ( !format.isEmpty() && format.at(0) != settings->resultFormat )
	{
		settings->resultFormat = format.at(0).toLatin1();
		settings->save();
	}
}

//! Get result format.
/*!
	\return				Result format (g, f, n, e, b, o, h).
*/
QString Manager::getResultFormat() const
{
	return QString(settings->resultFormat);
}

//! Set precision.
/*!
	\param precision	Decimal precision.
*/
void Manager::setPrecision(const QString& precision)
{
	settings->resultPrecision = (precision.isEmpty() ? -1 : precision.toInt());
	settings->save();
}

//! Get precision.
/*!
	\return				Decimal precision.
*/
QString Manager::getPrecision() const
{
	return (settings->resultPrecision < 0 ? QString() : QString::number(settings->resultPrecision));
}

//! Set complex number mode.
/*!
	\param complex		Complex number mode (d, c, p).
*/
void Manager::setComplexNumber(const QString& complex)
{
	if ( complex == "d" )
		settings->complexNumbers = false;
	else
	{
		settings->complexNumbers = true;
		settings->resultFormatComplex = complex.at(0).toLatin1();
	}
	evaluator->initializeBuiltInVariables();
	DMath::complexMode = settings->complexNumbers;
	settings->save();
}

//! Get complex number mode.
/*!
	\return				Complex number mode (d, c, p).
*/
QString Manager::getComplexNumber() const
{
	if ( settings->complexNumbers )
		return QString(settings->resultFormatComplex);
	return "d";
}

//! Set session save setting.
/*!
	\param save			Session save setting.
*/
void Manager::setSessionSave(bool save)
{
	settings->sessionSave = save;
	settings->save();
}

//! Get session save setting.
/*!
	\return				Session save setting.
*/
bool Manager::getSessionSave() const
{
	return settings->sessionSave;
}

//! Clear whole history.
void Manager::clearHistory()
{
	session->clearHistory();
}

//! Get assigned user variable or function id.
/*!
	\return				Variable or function id.
*/
QString Manager::getAssignId() const
{
	return evaluator->getAssignId();
}

//! Clear user variable.
/*!
	\param variable		Variable name.
*/
void Manager::clearVariable(const QString& variable)
{
	evaluator->unsetVariable(variable);
}

//! Clear user function.
/*!
	\param function		Function name.
*/
void Manager::clearFunction(const QString& function)
{
	QString name = function;
	name.chop(2);	// remove parenthesis
	evaluator->unsetUserFunction(name);
}

//! Update recent list.
/*!
	\param name			Item name.
	\return				True if list needs update.
*/
bool Manager::updateRecent(const QString& name)
{
	for ( auto iterator = recent.begin(); iterator != recent.end(); ++iterator )
	{
		if ( *iterator == name )
		{
			if ( iterator == recent.begin() )	// already first
				return false;
			recent.erase(iterator);
			break;
		}
	}
	recent.insert(recent.begin(), name);
	return true;
}

//! Remove item from recent list.
/*!
	\param name			Item name.
	\return				True if list needs update.
*/
bool Manager::removeRecent(const QString& name)
{
	for ( auto iterator = recent.begin(); iterator != recent.end(); ++iterator )
	{
		if ( *iterator == name )
		{
			recent.erase(iterator);
			return true;
		}
	}
	return false;
}

//! Set clipboard text.
/*!
	\param text			Clipboard text.
*/
void Manager::setClipboard(const QString& text) const
{
	clipboard->setText(text);
}

//! Get clipboard text.
/*!
	\return				Clipboard text.
*/
QString Manager::getClipboard() const
{
	return clipboard->text();
}

//! Check if the name is in recent list.
/*!
	\param name			Checked name.
	\return				True if found from recent list.
*/
bool Manager::checkRecent(const QString& name) const
{
	for ( const auto& item : recent )
	{
		if ( item == name )
			return true;
	}
	return false;
}
