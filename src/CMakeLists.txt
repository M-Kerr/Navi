cmake_minimum_required(VERSION 3.14)

project(Navi LANGUAGES CXX)
add_definitions(-DCMAKE_PROJECT_NAME=\"${CMAKE_PROJECT_NAME}\")

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# QtCreator supports the following variables for Android, which are identical to qmake Android variables.
# Check http://doc.qt.io/qt-5/deployment-android.html for more information.
# They need to be set before the find_package(Qt5 ...) call.

#if(ANDROID)
#    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
#    if (ANDROID_ABI STREQUAL "armeabi-v7a")
#        set(ANDROID_EXTRA_LIBS
#            ${CMAKE_CURRENT_SOURCE_DIR}/path/to/libcrypto.so
#            ${CMAKE_CURRENT_SOURCE_DIR}/path/to/libssl.so)
#    endif()
#endif()

find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Quick LinguistTools REQUIRED)
find_package(Qt${QT_VERSION_MAJOR}
    COMPONENTS Core Quick QuickControls2 LinguistTools Positioning Location REQUIRED)

set(TS_FILES Navi_en_US.ts)
set(SRC_FILES main.cpp )
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/qml)

add_library(NmeaLog nmealog/nmealog.cpp)
# WARNING: remove the QML HotReload library for production
add_library(HotReload hotreload/hotreloadqmlapplicationengine.cpp)
target_link_libraries(HotReload PUBLIC Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Quick)

target_link_libraries(NmeaLog
    PUBLIC
    Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Positioning
    Qt${QT_VERSION_MAJOR}::Quick
    )

if(ANDROID)
    add_library(Navi SHARED
        ${SRC_FILES}
        $CACHE{QRC_FILES}
        ${TS_FILES}
    )
else()
    add_executable(Navi
        ${SRC_FILES}
        #WARNING: add the qrc_files for release
#        $CACHE{QRC_FILES}
        ${TS_FILES}
    )
endif()

target_compile_definitions(Navi
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(Navi
  PRIVATE
  Qt${QT_VERSION_MAJOR}::Core
  Qt${QT_VERSION_MAJOR}::QuickControls2
  Qt${QT_VERSION_MAJOR}::Location
  NmeaLog
# WARNING: remove the QML HotReload library for production
  HotReload
  )

qt5_create_translation(QM_FILES ${CMAKE_SOURCE_DIR} ${TS_FILES})
