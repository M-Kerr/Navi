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

/*******************************
    Production objects, uncomment for production

    qmlRegisterSingletonType(QUrl("qrc://singletons/AppUtil.qml"),
                             "AppUtil", 1, 0, "AppUtil");
    qmlRegisterSingletonType(QUrl("qrc://singletons/MapboxPlugin.qml"),
                             "MapboxPlugin", 1, 0, "MapboxPlugin");
    qmlRegisterSingletonType(QUrl("qrc://singletons/EsriPlugin.qml"),
                            "EsriPlugin", 1, 0, "EsriPlugin");
    qmlRegisterSingletonType(QUrl("qrc://singletons/EsriSearchModel.qml"),
                             "EsriSearchModel", 1, 0, "EsriSearchModel");
    qmlRegisterSingletonType(QUrl("qrc://singletons/EsriRouteModel.qml"),
                             "EsriRouteModel", 1, 0, "EsriRouteModel");

    QUrl url(QStringLiteral("qrc:///main.qml"));
 *******************************/

/*******************************
    Dev Objects, delete for production
 *******************************/
    QUrl appUtil("file:" + qgetenv("SINGLETONS_QML") + "AppUtil.qml");
    qmlRegisterSingletonType(appUtil,
                             "AppUtil", 1, 0, "AppUtil");

    QUrl mapboxPlugin("file:" + qgetenv("SINGLETONS_QML") + "MapboxPlugin.qml");
    qmlRegisterSingletonType(mapboxPlugin,
                             "MapboxPlugin", 1, 0, "MapboxPlugin");

    QUrl esriPlugin("file:" + qgetenv("SINGLETONS_QML") + "EsriPlugin.qml");
    qmlRegisterSingletonType( esriPlugin, "EsriPlugin", 1, 0, "EsriPlugin" );

    QUrl EsriSearchModel("file:" + qgetenv("SINGLETONS_QML") + "EsriSearchModel.qml");
    qmlRegisterSingletonType(EsriSearchModel,
                             "EsriSearchModel", 1, 0, "EsriSearchModel");
    QUrl EsriRouteModel("file:" + qgetenv("SINGLETONS_QML") + "EsriRouteModel.qml");
    qmlRegisterSingletonType(EsriRouteModel,
                             "EsriRouteModel", 1, 0, "EsriRouteModel");


    QUrl url(qgetenv("MAIN_QML"));
/*******************************
    /DevObjects
 *******************************/

    QObject::connect(&engine, SIGNAL(quit()), qApp, SLOT(quit()));

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &application, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return application.exec();
}
