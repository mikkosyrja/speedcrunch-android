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

	Q_INVOKABLE QString autoCalc(const QString&);
	Q_INVOKABLE QString calculate(const QString&);
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

#endif // MANAGER_H
