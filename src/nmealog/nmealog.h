#pragma once
#include <QNmeaPositionInfoSource>
#include <QQmlEngine>
#include <QFile>
#include <QScopedPointer>
#include <QDebug>

class NmeaLog : public QNmeaPositionInfoSource
{
    Q_OBJECT
    Q_PROPERTY(QString logFile READ logFile WRITE setLogFile)
    Q_PROPERTY(QGeoCoordinate coordinate READ coordinate NOTIFY coordinateChanged)

public:
    explicit NmeaLog(QObject *parent = nullptr);
    explicit NmeaLog(QString fileName, QObject *parent = nullptr);
    explicit NmeaLog(QString fileName, long interval, QObject *parent = nullptr);

    QString logFile();
    void setLogFile(QString fileName);

    QGeoCoordinate coordinate();

    //! Debugging function to see if NMEA sentences are reading
    Q_INVOKABLE void printUpdates();

    Q_INVOKABLE QGeoCoordinate lastKnownCoordinate(bool = false) const;

signals:
    void coordinateChanged(QGeoCoordinate);

private slots:
    void m_printUpdate(QGeoPositionInfo);
    void onPositionUpdated(QGeoPositionInfo);

private:
    QScopedPointer<QFile> m_logFile;
    QGeoCoordinate m_coordinate;

    void m_setDevice();
};


// signal
// positionUpdated(const QGeoPositionInfo &)
