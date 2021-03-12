#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSettings>
#include <QDebug>
#include "nmealog/nmealog.h"
#include "hotreload/hotreloadqmlapplicationengine.h"

int main(int argc, char *argv[])
{

    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication::setApplicationName(CMAKE_PROJECT_NAME);
    QGuiApplication::setOrganizationName("MKerr");
    QSettings settings(QGuiApplication::organizationName(),
                       QGuiApplication::applicationName());
    settings.sync();

    QGuiApplication application(argc, argv);
    // WARNING: remove QML HotReload for production
//    QQmlApplicationEngine engine;
    HotReloadQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("$QmlEngine", &engine);


    qmlRegisterType<NmeaLog>("com.mkerr.navi", 1, 0, "NmeaLog");
//    qmlRegisterSingletonType(QUrl("qrc://singletons/GlobalStatus.qml"),
//                             "GlobalStatus", 1, 0, "GlobalStatus");
    QUrl status("file:" + qgetenv("GLOBALSTATUS_QML"));
    qmlRegisterSingletonType(status,
                             "GlobalStatus", 1, 0, "GlobalStatus");

    // WARNING: remove qgetenv for production
//    QUrl url(QStringLiteral("qrc:///main.qml"));
    QUrl url(qgetenv("MAIN_QML"));
    QObject::connect(&engine, SIGNAL(quit()), qApp, SLOT(quit()));

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &application, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return application.exec();
}
