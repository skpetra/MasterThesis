#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "citieslistmodel.h"
#include <QQmlContext>



int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    QQmlContext* context = engine.rootContext();

    // ---------------- model za prikaz CitiesSuggestionBox-a ----------------
    CitiesListModel citiesListModel;
    context->setContextProperty("cityModel", &citiesListModel);

    CitiesProxyModel citiesFilterModel;
    citiesFilterModel.setSourceModel(&citiesListModel);
    citiesFilterModel.setFilterRole(CitiesListModel::Roles::CityRole); //CityRole Qt::UserRole + 1
    citiesFilterModel.setSortRole(CitiesListModel::Roles::CountryRole);
    context->setContextProperty("filterModel", &citiesFilterModel);
    // ---------------- ---------------- ---------------- ---------------- ---


    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}