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

#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include "core/evaluator.h"
#include "src/manager.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/qml/android-speedcrunch.qml")));
    if ( engine.rootObjects().isEmpty() )
        return -1;

    return app.exec();
/*
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine("qml/harbour-speedcrunch.qml");
    return app.exec();
*/
/*
    QGuiApplication app(argc, argv);

    QQuickView *view = new QQuickView;
    view->setSource(QUrl::fromLocalFile("myqmlfile.qml"));
    view->show();

    QQuickView view;
    view.set setSource(QUrl("qml/helloWorldQT5/main.qml"));
    viewer->show();


    app.

    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    QScopedPointer<QQuickView> view(SailfishApp::createView());

    qmlRegisterType<Manager>("harbour.speedcrunch.Manager", 1, 0, "Manager");

    view->setSource(SailfishApp::pathToMainQml());
    view->showFullScreen();

    return app->exec();


    //    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

//    Manager manager;
//	qmlRegisterType<Manager>("harbour.speedcrunch.Manager", 1, 0, "Manager");
//	view->rootContext()->setContextProperty("mn",&mn );

    return app.exec();
//	return SailfishApp::main(argc, argv);
*/
}

