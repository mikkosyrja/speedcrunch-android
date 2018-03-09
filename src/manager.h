#ifndef MANAGER_H
#define MANAGER_H

#include <QObject>				//IMP
#include <QString>
#include <QStringList>
#include "core/evaluator.h"
#include "core/settings.h"
#include <QDebug>
#include <QClipboard>

class Manager : public QObject	//IMP
{
	Q_OBJECT					//IMP

public:
	Manager();

	Q_INVOKABLE QString autoCalc(const QString&);
	Q_INVOKABLE QString calculate(const QString&);
	Q_INVOKABLE void loadLayouts();
	Q_INVOKABLE void restoreLayouts();
	Q_INVOKABLE QString getFunctions(QString filter);
	Q_INVOKABLE void setABC();
	Q_INVOKABLE void setNumbers();
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

#endif // MANAGER_H
