#include "nmealog.h"

NmeaLog::NmeaLog(QObject *parent)
        : QNmeaPositionInfoSource(QNmeaPositionInfoSource::SimulationMode,
                                  parent)
{
    setUpdateInterval(1000);
    this->connect(this, &NmeaLog::positionUpdated,
                  this, &NmeaLog::onPositionUpdated);
}

NmeaLog::NmeaLog(QString fileName, QObject *parent)
    : NmeaLog(fileName, 1000, parent)
{
}

NmeaLog::NmeaLog(QString fileName, long interval, QObject *parent)
        : QNmeaPositionInfoSource(QNmeaPositionInfoSource::SimulationMode,
                                  parent),
          m_logFile(new QFile(fileName))
{
    setUpdateInterval(interval);
    m_setDevice();
    this->connect(this, &NmeaLog::positionUpdated,
                  this, &NmeaLog::onPositionUpdated);
}

void NmeaLog::setLogFile(QString fileName)
{
    if (m_logFile)
    {
        qInfo() << "NMEA Log file can only be set once, update failed.";
        qInfo() << "Current LogFile: " << m_logFile->fileName();
    } else {
        m_logFile.reset(new QFile(fileName));
        m_setDevice();
    }
}

QGeoCoordinate NmeaLog::coordinate()
{
    return m_coordinate;
}

void NmeaLog::setCoordinate(QGeoCoordinate coord)
{
    m_coordinate = coord;
    emit coordinateChanged(m_coordinate);
}

QString NmeaLog::logFile()
{
    return m_logFile->fileName();
}

void NmeaLog::printUpdates()
{
    QObject::connect(this, &NmeaLog::positionUpdated,
                     this, &NmeaLog::m_printUpdate);
}

QGeoCoordinate NmeaLog::lastKnownCoordinate(bool fromSatellitePositioningMethodsOnly) const
{
    return QNmeaPositionInfoSource::lastKnownPosition(
                fromSatellitePositioningMethodsOnly).coordinate();
}

void NmeaLog::m_printUpdate(QGeoPositionInfo position)
{
    qInfo() << "Latitude: " << position.coordinate().latitude()
            << ", Longitude: " << position.coordinate().longitude();
}

void NmeaLog::onPositionUpdated(QGeoPositionInfo position)
{
    m_coordinate = position.coordinate();
    emit coordinateChanged(m_coordinate);
}

void NmeaLog::m_setDevice()
{
    if (!m_logFile->open(QIODevice::ReadOnly | QIODevice::Text))
    {
        qInfo() << "Error opening NMEA log " << m_logFile->fileName();
    } else {
        setDevice(m_logFile.get());
    }
}
