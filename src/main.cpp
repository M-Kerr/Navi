#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSettings>
#include "nmealog/nmealog.h"

int main(int argc, char *argv[])
{

    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication::setApplicationName(CMAKE_PROJECT_NAME);
    QGuiApplication::setOrganizationName("MKerr");
    QSettings settings(QGuiApplication::organizationName(),
                       QGuiApplication::applicationName());
    settings.sync();

    QGuiApplication application(argc, argv);
    QQmlApplicationEngine engine;

    qmlRegisterType<NmeaLog>("com.mkerr.navi", 1, 0, "NmeaLog");

    // TODO delete this line
//    engine.addImportPath(QStringLiteral(":/imports"));
    QUrl url(QStringLiteral("qrc:///main.qml"));
    QObject::connect(&engine, SIGNAL(quit()), qApp, SLOT(quit()));

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &application, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return application.exec();
}
