QT += quick charts widgets

CONFIG += c++11

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

include(src/src.pri)

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    fonts/PermanentMarker-Regular.ttf \
    js/utils.js \
    qml/CitiesSuggestionBox.qml \
    qml/main.qml \
    qml/pages/CitiesListPage.qml \
    qml/pages/CityMenuPage.qml \
    qml/pages/CurrentWeatherPage.qml \
    qml/pages/HomePage.qml \
    qml/visualizations/BrokenClouds.qml \
    qml/visualizations/Cloud.qml \
    qml/visualizations/Drizzle.qml \
    qml/visualizations/FewCloudsDay.qml \
    qml/visualizations/FewCloudsNight.qml \
    qml/visualizations/Fog.qml \
    qml/visualizations/Moon.qml \
    qml/visualizations/Precipitation.qml \
    qml/visualizations/Sun.qml \
    qml/visualizations/Thunderstorm.qml \
    resources/citiesList.json
    qml/visualizations/basic/CircularArc.qml \
    resources/icons/bottomArrow.png \
    resources/icons/pinwheel2.png \
    resources/icons/topArrow.png


