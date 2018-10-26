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

INCLUDEPATH += engine

SOURCES += \
	engine/math/cmath.cpp \
	engine/math/cnumberparser.cpp \
	engine/math/floatcommon.c \
	engine/math/floatconst.c \
	engine/math/floatconvert.c \
	engine/math/floaterf.c \
	engine/math/floatexp.c \
	engine/math/floatgamma.c \
	engine/math/floathmath.c \
	engine/math/floatincgamma.c \
	engine/math/floatio.c \
	engine/math/floatipower.c \
	engine/math/floatlog.c \
	engine/math/floatlogic.c \
	engine/math/floatlong.c \
	engine/math/floatnum.c \
	engine/math/floatpower.c \
	engine/math/floatseries.c \
	engine/math/floattrig.c \
	engine/math/hmath.cpp \
	engine/math/number.c \
	engine/math/quantity.cpp \
	engine/math/rational.cpp \
	engine/math/units.cpp \
	engine/core/constants.cpp \
	engine/core/evaluator.cpp \
	engine/core/functions.cpp \
	engine/core/numberformatter.cpp \
	engine/core/opcode.cpp \
	engine/core/session.cpp \
	engine/core/sessionhistory.cpp \
	engine/core/settings.cpp \
	engine/core/userfunction.cpp \
	engine/core/variable.cpp \
	engine/manager.cpp \
	src/android-speedcrunch.cpp

HEADERS += \
	engine/math/cmath.h \
	engine/math/cnumberparser.h \
	engine/math/floatcommon.h \
	engine/math/floatconfig.h \
	engine/math/floatconst.h \
	engine/math/floatconvert.h \
	engine/math/floaterf.h \
	engine/math/floatexp.h \
	engine/math/floatgamma.h \
	engine/math/floathmath.h \
	engine/math/floatincgamma.h \
	engine/math/floatio.h \
	engine/math/floatipower.h \
	engine/math/floatlog.h \
	engine/math/floatlogic.h \
	engine/math/floatlong.h \
	engine/math/floatnum.h \
	engine/math/floatpower.h \
	engine/math/floatseries.h \
	engine/math/floattrig.h \
	engine/math/hmath.h \
	engine/math/number.h \
	engine/math/quantity.h \
	engine/math/rational.h \
	engine/math/units.h \
	engine/core/constants.h \
	engine/core/errors.h \
	engine/core/evaluator.h \
	engine/core/functions.h \
	engine/core/numberformatter.h \
	engine/core/opcode.h \
	engine/core/session.h \
	engine/core/sessionhistory.h \
	engine/core/settings.h \
	engine/core/userfunction.h \
	engine/core/variable.h \
	engine/manager.h

DISTFILES += \
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
	CHANGELOG.md \
	README.md \
	lrelease.sh \
	lupdate.sh \
	locale/mobile.en_GB.ts \
	locale/mobile.fi_FI.ts \
	locale/mobile.de_DE.ts \
	locale/mobile.it_IT.ts \
	locale/mobile.fr_FR.ts \
	locale/mobile.ru_RU.ts \
	locale/mobile.es_ES.ts \
	locale/mobile.sv_SE.ts \
	locale/mobile.pt_PT.ts \
	locale/mobile.ts

RESOURCES += qml.qrc translations.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
