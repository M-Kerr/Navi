#include "hotreloadqmlapplicationengine.h"

HotReloadQmlApplicationEngine::HotReloadQmlApplicationEngine(QObject *parent)
    : QQmlApplicationEngine(parent) {}

void HotReloadQmlApplicationEngine::clearCache()
{
    this->clearComponentCache();
}
