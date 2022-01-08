QT += quick charts

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
    qml/main.qml \
    qml/controls/CitiesSuggestionBox.qml \
    qml/controls/PageToolBar.qml \
    qml/controls/RoundPane.qml \
    qml/controls/Spinner.qml \
    qml/controls/UnitsToggleButton.qml \
    qml/pages/CurrentWeatherPage.qml \
    qml/pages/HomePage.qml \
    qml/pages/SevenDaysWeatherPage.qml \
    qml/visualizations/animations/HangingElementsAnimation.qml \
    qml/visualizations/basic/CircularArc.qml \
    qml/visualizations/basic/Cloud.qml \
    qml/visualizations/basic/Fog.qml \
    qml/visualizations/basic/HangingElement.qml \
    qml/visualizations/basic/Moon.qml \
    qml/visualizations/basic/Preticipation.qml \
    qml/visualizations/basic/Sun.qml \
    qml/visualizations/basic/Windmill.qml \
    qml/visualizations/weather_conditions/Atmosphere.qml \
    qml/visualizations/weather_conditions/Clouds.qml \
    qml/visualizations/weather_conditions/Drizzle.qml \
    qml/visualizations/weather_conditions/Rain.qml \
    qml/visualizations/weather_conditions/Snow.qml \
    qml/visualizations/weather_conditions/Thunderstorm.qml \
    qml/visualizations/widgets/CurrentWeatherWidget.qml \
    qml/visualizations/widgets/DailyWindWidget.qml \
    qml/visualizations/widgets/HourlyDetailsWidget.qml \
    qml/visualizations/widgets/HourlyPrecipitationWidget.qml \
    qml/visualizations/widgets/HourlyPressureWidget.qml \
    qml/visualizations/widgets/HourlyWindWidget.qml \
    qml/visualizations/widgets/HumidityWidget.qml \
    qml/visualizations/widgets/LongTermDayWidget.qml \
    qml/visualizations/widgets/OneHourWidget.qml \
    qml/visualizations/widgets/SunsetSunriseWidget.qml \
    qml/visualizations/widgets/UVIndexWidget.qml \
    qml/visualizations/main.qml \
    fonts/RemachineScript.ttf \
    js/config.js \
    js/utils.js \
    resources/citiesList.json \
    resources/icons/backspace.png \
    resources/icons/bottomArrow.png \
    resources/icons/home.png \
    resources/icons/icon.png \
    resources/icons/line.png \
    resources/icons/magnifier.png \
    resources/icons/pinwheel.png \
    resources/icons/pressure.png \
    resources/icons/rain.png \
    resources/icons/snow.png \
    resources/icons/thunderbolt.png \
    resources/icons/topArrow.png \
    resources/icons/triangleBottomIcon.png \
    resources/icons/umbrella.png \
    resources/icons/wind.png \
    resources/icons/windDirection.png

