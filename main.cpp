#include <QTextStream>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickItem>
#if QT_CONFIG(ssl)
#include <QSslSocket>
#endif
#include <QQmlContext>
#include <QSettings>
#include <QDebug>

int main(int argc, char *argv[])
{
#if QT_CONFIG(library)
    const QByteArray additionalLibraryPaths = qgetenv("QTLOCATION_EXTRA_LIBRARY_PATH");
    for (const QByteArray &p : additionalLibraryPaths.split(':'))
        QCoreApplication::addLibraryPath(QString(p));
#endif
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication::setApplicationName(CMAKE_PROJECT_NAME);
    QGuiApplication::setOrganizationName("MKerr");
    QSettings settings(QGuiApplication::organizationName(),
                       QGuiApplication::applicationName());
    settings.sync();
    qInfo() << settings.fileName();

    // map plugin parameters
    QVariantMap parameters;
    parameters["mapbox.access_token"] = settings.value("mapbox.access_token").toString();
    parameters["mapboxgl.access_token"] = settings.value("mapboxgl.access_token").toString();
    parameters["esri.token"] = settings.value("esri.token").toString();

    QGuiApplication application(argc, argv);

    QQmlApplicationEngine engine;
#if QT_CONFIG(ssl)
    engine.rootContext()->setContextProperty("supportsSsl", QSslSocket::supportsSsl());
#else
    engine.rootContext()->setContextProperty("supportsSsl", false);
#endif
    engine.addImportPath(QStringLiteral(":/imports"));
    // TODO paste default qml engine load error check boilerplate code
    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));
    QObject::connect(&engine, SIGNAL(quit()), qApp, SLOT(quit()));

    QObject *item = engine.rootObjects().first();
    Q_ASSERT(item);
    item->setProperty("parameters", parameters);
//    QMetaObject::invokeMethod(item, "initializeProviders",
//                              Q_ARG(QVariant, QVariant::fromValue(parameters)));

    return application.exec();
}
