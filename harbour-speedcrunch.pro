# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = harbour-speedcrunch

#CONFIG += sailfishapp

# Start of temporary fix for the icon for the Nov 2013 harbour requirements by (thanks to AgileArtem :))
# QML files and folders
QT += quick qml
CONFIG += link_pkgconfig
PKGCONFIG += sailfishapp
INCLUDEPATH += /usr/include/sailfishapp

TARGETPATH = /usr/bin
target.path = $$TARGETPATH

DEPLOYMENT_PATH = /usr/share/$$TARGET
qml.files = qml
qml.path = $$DEPLOYMENT_PATH

desktop.files = harbour-speedcrunch.desktop
desktop.path = /usr/share/applications

icon.files = harbour-speedcrunch.png
icon.path = /usr/share/icons/hicolor/86x86/apps

# moving mixpanel to harbour.wikipedia.Mixpanel location to satisfy new harbour requirements
# qml.files/path will deploy a copy to the old location, but it's ok, it's not going to be used
mixpanel.files = qml/components/Mixpanel/src/Mixpanel
mixpanel.path = $$DEPLOYMENT_PATH/qml/components/harbour/wikipedia

INSTALLS += target icon desktop mixpanel qml
# End of nov 2013 fix
DEFINES += SAILFISH
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
	src/harbour-speedcrunch.cpp \
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
	math/cnumberparser.cpp \
    thirdparty/binreloc/binreloc.c

OTHER_FILES += \
	qml/cover/CoverPage.qml \
	harbour-speedcrunch.desktop \
	qml/pages/Pager.qml \
	qml/pages/Panorama.qml \
	qml/pages/CalcButton.qml \
	qml/pages/Backspace.qml \
	qml/pages/erase_to_the_left.svg \
	qml/pages/cube_root.svg \
	qml/harbour-speedcrunch.qml \
	rpm/harbour-speedcrunch.yaml

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
	math/cnumberparser.h \
    thirdparty/binreloc/binreloc.h

DISTFILES += \
    bison/exprparser.y

