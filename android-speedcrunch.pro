# This file is part of the SpeedCrunch project
# Copyright (C) 2014 @qwazix
# Copyright (C) 2018 Mikko Syrjä
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; see the file COPYING.  If not, write to
# the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
# Boston, MA 02110-1301, USA.

QT += quick qml
CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

DEFINES += SPEEDCRUNCH_VERSION=\\\"master\\\"

SOURCES += \
	math/floatcommon.c \
	math/floatconst.c \
	math/floatconvert.c \
	math/floaterf.c \
	math/floatexp.c \
	math/floatgamma.c \
	math/floathmath.c \
	math/floatincgamma.c \
	math/floatio.c \
	math/floatipower.c \
	math/floatlog.c \
	math/floatlogic.c \
	math/floatlong.c \
	math/floatnum.c \
	math/floatpower.c \
	math/floatseries.c \
	math/floattrig.c \
	math/hmath.cpp \
	math/number.c \
	core/constants.cpp \
	core/evaluator.cpp \
	core/functions.cpp \
	core/settings.cpp \
	src/manager.cpp \
	src/android-speedcrunch.cpp \
	math/rational.cpp \
	math/units.cpp \
	core/numberformatter.cpp \
	math/quantity.cpp \
	math/cmath.cpp \
	core/opcode.cpp \
	core/variable.cpp \
	core/userfunction.cpp \
	core/session.cpp \
	core/sessionhistory.cpp \
	math/cnumberparser.cpp

HEADERS += \
	math/floatcommon.h \
	math/floatconfig.h \
	math/floatconst.h \
	math/floatconvert.h \
	math/floaterf.h \
	math/floatexp.h \
	math/floatgamma.h \
	math/floathmath.h \
	math/floatincgamma.h \
	math/floatio.h \
	math/floatipower.h \
	math/floatlog.h \
	math/floatlogic.h \
	math/floatlong.h \
	math/floatnum.h \
	math/floatpower.h \
	math/floatseries.h \
	math/floattrig.h \
	math/hmath.h \
	math/number.h \
	core/constants.h \
	core/errors.h \
	core/evaluator.h \
	core/functions.h \
	core/settings.h \
	src/manager.h \
	math/rational.h \
	math/units.h \
	core/numberformatter.h \
	math/quantity.h \
	math/cmath.h \
	core/opcode.h \
	core/variable.h \
	core/userfunction.h \
	core/session.h \
	core/sessionhistory.h \
	math/cnumberparser.h

DISTFILES += \
	CHANGELOG.md \
	README.md \
	qml/android-speedcrunch.qml \
	qml/BackSpace.qml \
	qml/CalcButton.qml \
	qml/Functions.qml \
	qml/Calculator.qml \
	qml/Settings.qml \
	qml/Keyboard.qml \
	qml/Landscape.qml \
	icons/android-speedcrunch.svg \
	icons/back.svg \
	icons/clear.svg \
	icons/cuberoot.svg \
	android/AndroidManifest.xml \
	android/gradle/wrapper/gradle-wrapper.jar \
	android/gradlew \
	android/res/values/libs.xml \
	android/build.gradle \
	android/gradle/wrapper/gradle-wrapper.properties \
	android/gradlew.bat \
	translations/android-speedcrunch-fi.ts

RESOURCES += qml.qrc \
	translations.qrc

lupdate_only{
SOURCES += qml/*.qml
}

TRANSLATIONS += translations/android-speedcrunch-fi.ts

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
