# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = speedcrunch

CONFIG += sailfishapp
QT += webkit
QT += widgets
DEFINES += SAILFISH

SOURCES += src/speedcrunch.cpp \
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
    bison/bisonparser.cpp \
    bison/exprparser.c \
    src/manager.cpp

OTHER_FILES += qml/speedcrunch.qml \
    qml/cover/CoverPage.qml \
    rpm/speedcrunch.spec \
    rpm/speedcrunch.yaml \
    speedcrunch.desktop \
    qml/pages/Pager.qml \
    src/bison/exprparser.y \
    qml/pages/Panorama.qml \
    qml/pages/CalcButton.qml \
    qml/pages/KeyboardButton.qml \
    qml/pages/Backspace.qml \
    qml/pages/erase_to_the_left.svg \
    qml/pages/cube_root.svg

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
    bison/bison.h \
    bison/bisonparser.h \
    bison/exprparser.h \
    src/manager.h

