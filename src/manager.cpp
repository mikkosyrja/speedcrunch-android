#include "manager.h"
#include <QFile>
#include <QDir>
#include <QGuiApplication>
#if !defined(Q_WS_SIMULATOR) && !defined(SAILFISH)
#include <MGConfItem>
#endif
#include "core/functions.h"
#include "core/constants.h"

// save the active keyboard
Manager::Manager()
{
	evaluator = Evaluator::instance();
	settings = Settings::instance();
	clipboard = QGuiApplication::clipboard();
}

//
QString Manager::autoCalc(const QString &input)
{
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
}

QString Manager::calculate(const QString &input)
{
	const QString str = evaluator->autoFix(input);
	evaluator->setExpression(str);
	const HNumber number = evaluator->eval();
	return QString(HMath::format(number, settings->resultPrecision < 0 ? 'g' : 'f', settings->resultPrecision));
}

//
void Manager::loadLayouts()
{
#if !defined(Q_WS_SIMULATOR) && !defined(SAILFISH)
		//constants
		QString settingsPath = QDir::homePath() + QDir::separator() + ".mobileCrunch" + QDir::separator();

		//load gconf to memory
		MGConfItem configuredLayoutsActive("/meegotouch/inputmethods/onscreen/active");
		MGConfItem configuredLayoutsEnabled("/meegotouch/inputmethods/onscreen/enabled");

		//save old config
		QStringList availableLayouts;
		if (!(QDir(settingsPath).exists())) QDir().mkpath(settingsPath);
		//enabled
		qDebug()<<"saving available layouts to file";

		QVariant layouts = configuredLayoutsEnabled.value();
		if (layouts.type() == QVariant::StringList) availableLayouts = layouts.toStringList();
		if (availableLayouts.contains("mobileCrunchVkb_1.xml")) return; //if mobilecrunch layouts are already loaded abort
		QFile file(settingsPath + "oldEnabledKb");
		//file.open(QIODevice::Truncate); file.close();
		file.open(QIODevice::WriteOnly);
		QString old ="";
		QTextStream out2(&file);
		for (int i=0; i<availableLayouts.size()-1; i+=2)
		{
			if (old!=availableLayouts.at(i+1))
			{
				out2 << availableLayouts.at(i) << "\n"; //bug in the system?? it duplicates the active layout
				out2 << availableLayouts.at(i+1) << "\n"; //bug in the system?? it duplicates the active layout
				qDebug()<<availableLayouts.at(i+1);
			}
			old=availableLayouts.at(i+1);
		}
		file.close();

		//active
		layouts.clear();
		layouts = configuredLayoutsActive.value();
		qDebug()<<"saving active layout to file";
		//availableLayouts.empty();
		if (layouts.type() == QVariant::StringList) availableLayouts = layouts.toStringList();
		if (availableLayouts.contains("mobileCrunchVkb_1.xml")) return; //if mobilecrunch layouts are already loaded abort
		file.setFileName(settingsPath + "oldActiveKb");
		//file.open(QIODevice::Truncate); file.close();
		file.open(QIODevice::WriteOnly | QIODevice::Text);
		QTextStream out(&file);
		foreach (QString layout, availableLayouts)
		{
			out << layout << "\n";
			qDebug()<<layout;
		}
		file.close();


		//start loading our layouts

		QString binFilename(QString("libmeego-keyboard.so"));
		QStringList mobileCrunchLayouts;
		QStringList mobileCrunchActiveLayout;
		mobileCrunchActiveLayout.empty();
		mobileCrunchActiveLayout.append(binFilename);
		mobileCrunchActiveLayout.append("mobileCrunchVkb_1.xml");
		mobileCrunchLayouts.empty();

		int i = 1;
		do {
			QString layout; layout.setNum(i);
			QString layoutFilename(QString("mobileCrunchVkb_") + layout + QString(".xml"));
			QString pathToCreate = QDir::homePath() + QDir::separator() + QString(".config/meego-keyboard/layouts/");

			if (!(QDir(pathToCreate).exists()))
			{
				QDir().mkpath(pathToCreate);
				qDebug() << "Created dir: " << pathToCreate; // Check the result
			}

			qDebug() << "Depositing: " << pathToCreate + layoutFilename;
			QFile::remove(pathToCreate + layoutFilename);
			QFile::copy("/opt/mobilecrunch/mobileCrunchVkb_"+layout+".xml",pathToCreate + layoutFilename);
			mobileCrunchLayouts.append(binFilename);
			qDebug()<<layoutFilename;
			mobileCrunchLayouts.append(layoutFilename);
			i++;
		} while (QFile::exists("/opt/mobilecrunch/mobileCrunchVkb_"+QString::number(i)+".xml"));

		configuredLayoutsEnabled.set(mobileCrunchLayouts);
		configuredLayoutsActive.set(mobileCrunchActiveLayout);
		//have to add additional layouts later to ensure active layout remains the above
		mobileCrunchLayouts.append(binFilename);
		mobileCrunchLayouts.append("en_us.xml");
		configuredLayoutsEnabled.set(mobileCrunchLayouts);
#endif
}

//
void Manager::restoreLayouts()
{
#if !defined(Q_WS_SIMULATOR) && !defined(SAILFISH)
	qDebug()<<"destroy";
	//constants
	QString settingsPath = QDir::homePath() + QDir::separator() + ".mobileCrunch" + QDir::separator();

	//load gconf to memory
	MGConfItem configuredLayoutsActive("/meegotouch/inputmethods/onscreen/active");
	MGConfItem configuredLayoutsEnabled("/meegotouch/inputmethods/onscreen/enabled");

	//load old config
	//enabled
	QStringList availableLayouts;
	QFile file(settingsPath + "oldEnabledKb");
	file.open(QIODevice::ReadOnly | QIODevice::Text);
	QTextStream in(&file);
	while (!in.atEnd())
	{
		//qDebug()<<"*";
		availableLayouts.append(in.readLine());
	}
	file.close();

	QStringList enabledLayouts;
	QVariant layouts = configuredLayoutsEnabled.value();
	if (layouts.type() == QVariant::StringList) enabledLayouts = layouts.toStringList();
	if (!enabledLayouts.contains("mobileCrunchVkb_1.xml")) return; //do not restore false layouts


	configuredLayoutsEnabled.set(availableLayouts);

	//active
	availableLayouts.empty();
	file.setFileName(settingsPath + "oldActiveKb");
	file.open(QIODevice::ReadOnly | QIODevice::Text);
	availableLayouts.empty();
	while (!in.atEnd()) {
		//qDebug()<<"*";
		availableLayouts.append(in.readLine());
	}
	file.close();
	configuredLayoutsActive.set(availableLayouts);

#endif
}

//
QString Manager::getFunctions(QString filter)
{
	QStringList functions = Functions::instance()->names();
	QString result = "[";
	for ( int index = 0; index < functions.count(); ++index )
	{
		if ( Function* function = Functions::instance()->function(functions.at(index)) )
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

//! Set letter keyboard.
void Manager::setABC()
{
#if !defined(Q_WS_SIMULATOR) && !defined(SAILFISH)
	//load gconf to memory
	MGConfItem configuredLayoutsActive("/meegotouch/inputmethods/onscreen/active");
	QString binFilename(QString("libmeego-keyboard.so"));
	QStringList currentLayout;
	currentLayout.append(binFilename);
	currentLayout.append("en_us.xml");
	configuredLayoutsActive.set(currentLayout);
#endif
}

//! Set numeric keyboard.
void Manager::setNumbers()
{
#if !defined(Q_WS_SIMULATOR) && !defined(SAILFISH)
	//load gconf to memory
	MGConfItem configuredLayoutsActive("/meegotouch/inputmethods/onscreen/active");
	QString binFilename(QString("libmeego-keyboard.so"));
	QStringList currentLayout;
	currentLayout.append(binFilename);
	currentLayout.append("mobileCrunchVkb_1.xml");
	configuredLayoutsActive.set(currentLayout);
#endif
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

