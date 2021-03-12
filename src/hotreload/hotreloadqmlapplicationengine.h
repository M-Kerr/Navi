#pragma once
#include <QQmlApplicationEngine>


class HotReloadQmlApplicationEngine : public QQmlApplicationEngine
{
    Q_OBJECT
public:
    explicit HotReloadQmlApplicationEngine(QObject *parent = nullptr);

    Q_INVOKABLE void clearCache();

signals:

};

