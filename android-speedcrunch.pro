
QT += quick qml
CONFIG += c++11

# PKGCONFIG += sailfishapp
# INCLUDEPATH += /usr/include/sailfishapp

#TARGETPATH = /usr/bin
#target.path = $$TARGETPATH

#DEPLOYMENT_PATH = /usr/share/$$TARGET
#qml.files = qml
#qml.path = $$DEPLOYMENT_PATH

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

OTHER_FILES += \
	qml/pages/erase_to_the_left.svg \
	qml/pages/cube_root.svg \
	qml/android-speedcrunch.qml \
	qml/CalcButton.qml \
	qml/Calculator.qml \
	qml/Functions.qml \
	qml/Keyboard.qml \
	qml/Settings.qml \
	rpm/android-speedcrunch.yaml

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
	qml/BackSpace.qml \
	qml/CalcButton.qml \
	qml/Functions.qml \
	qml/Calculator.qml \
	qml/Settings.qml \
	qml/Keyboard.qml

RESOURCES += qml.qrc

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
