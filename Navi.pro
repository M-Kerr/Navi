CONFIG += sdk_no_version_check c++17

QT -=   gui

QT +=   quick quickcontrols2 \
        positioning location

SOURCES +=      src/main.cpp \
                src/third_party/qmapboxglapp/src/qcheapruler.cpp \
                src/hotreload/hotreloadqmlapplicationengine.cpp
#                src/nmealog/nmealog.cpp

HEADERS +=      src/third_party/qmapboxglapp/include/mapbox/qcheapruler.hpp \
                src/hotreload/hotreloadqmlapplicationengine.h


INCLUDEPATH +=  src/third_party/qmapboxglapp/include

#****************************************
# Hacky way of adding the sched_setscheduler symbol missing from emscripten's
# c library.
#SOURCES += /Users/milokerr/Development/tools/emsdk/upstream/emscripten/system/lib/libc/musl/src/sched/sched_setscheduler.c
#HEADERS += /Users/milokerr/Development/tools/emsdk/upstream/emscripten/system/include/libc/sched.h
#INCLUDEPATH +=  /Users/milokerr/Development/tools/emsdk/upstream/emscripten/system/include/libc \
#                /Users/milokerr/Development/tools/emsdk/upstream/emscripten/system/lib/libc/musl/src/internal
#****************************************

RESOURCES +=    src/qml/qml.qrc \
                src/qml/resources/resources.qrc \
                src/qml/components/SoftUI/SoftUI.qrc

DEFINES += CMAKE_PROJECT_NAME='\\"Navi\\"'
