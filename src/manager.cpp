#include "manager.h"
#include <QFile>
#include <QDir>
#include <QGuiApplication>
#if !defined(Q_WS_SIMULATOR) && !defined(SAILFISH)
#include <MGConfItem>
#endif
#include "core/functions.h"
#include "core/constants.h"
//save the active keyboard
manager::manager()
{
    evl = Evaluator::instance();
    settings = Settings::instance();
    clipboard = QGuiApplication::clipboard();
}

QString manager::autoCalc(const QString &input){

    const QString str = evl->autoFix( input );
    if ( str.isEmpty() )
        return QString("");

    // very short (just one token) and still no calculation, then skip
    //if ( ! d->ansAvailable ) {
//        const Tokens tokens = evl->scan( input );
//        if ( tokens.count() < 2 )
//            return "";
    //}

    // too short even after autofix ? do not bother either...
    const Tokens tokens = evl->scan( str );
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
    evl->setExpression( str );
    const HNumber num = evl->evalNoAssign();

    return QString(HMath::format(num,'g',4));
}

QString manager::calc(const QString &input){
    const QString str = evl->autoFix( input );
    evl->setExpression( str );
    const HNumber num = evl->eval();
    return QString(HMath::format(num,'g',4));
}


void manager::loadLayouts()
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
        for (int i=0; i<availableLayouts.size()-1; i+=2) {
            if (old!=availableLayouts.at(i+1)) {
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
        foreach (QString layout, availableLayouts) {
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

            if (!(QDir(pathToCreate).exists())) {
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


void manager::restoreLayouts()
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
    while (!in.atEnd()) {
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

QString manager::getFunctions(QString needle){
    QStringList functionNames = Functions::instance()->names();
    QString str = "[";
     for (int k = 0; k < functionNames.count(); ++k)
     {
         Function *f = Functions::instance()->function(functionNames.at(k));
         if (!f)
             continue;

         if (needle=="" || f->name().toLower().contains(needle.toLower()) || f->identifier().toLower().contains(needle.toLower()))
            str += "{ val:'" + f->identifier()+ "' , name: '" + f->name() + "' , func: true},";

     }
     QList<Constant> constantNames = Constants::instance()->list();
     for (int k = 0; k < constantNames.count(); ++k){
         //QString name = ;
         if (needle=="" || constantNames.at(k).value.contains(needle, Qt::CaseInsensitive) || constantNames.at(k).name.contains(needle, Qt::CaseInsensitive))
            str += "{ val:'" +constantNames.at(k).value + "' , name: \"" + constantNames.at(k).name +"\", func: false},";
         //if (k==2) qDebug()<<name.replace("'","\\\'");
     }

     str += "]";
     return str;

    // return Functions::instance()->names();
}

void manager::setABC()
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

void manager::setNumbers()
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

void manager::setAngleModeRadian()
{
    if ( settings->angleUnit == 'r' )
        return;
    qDebug()<<settings->angleUnit;
    settings->angleUnit = 'r';
    settings->save();

}

void manager::setAngleModeDegree()
{

    if ( settings->angleUnit == 'd' )
        return;
//     qDebug()<<settings->angleUnit;
     settings->angleUnit = 'd';
     settings->save();
}

QString manager::getAngleMode()
{
    settings->load();
    qDebug()<<settings->angleUnit;
    return QString(settings->angleUnit);
}


void manager::setClipboard(QString text){
        clipboard->setText(text, QClipboard::Clipboard);
        clipboard->setText(text, QClipboard::Selection);
    }


