#include "citieslistmodel.h"

// ------- readCities() ---------
#include <QFile>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>

// --------------------
#include <QCoreApplication>
#include <QDir>

CitiesListModel::CitiesListModel(QObject *parent) :
    QAbstractListModel(parent),
    mCitiesFileName(QString("citiesList.json"))
{
    readCities();
}

// Klasa QModelIndex središnji je koncept okvira Model/View u Qt-u.
// To je lagani objekt koji se koristi za lociranje podataka unutar modela.
// The model will produce indexes according to its data type and will provide these indexes to the view.
// index.row() je jedan podatak u listviewu i ima .row() funkciju za dohvat podatka
int CitiesListModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return mCities.size();
}

// view traži podatke na određenom index-u i određene uloge role
// role parameter tells us what data category should be returned.
QVariant CitiesListModel::data(const QModelIndex &index, int role) const
{
    if (!isIndexValid(index)) {
        return QVariant();
    }
    // ili
    // Q_ASSERT(!isIndexValid(index));

    switch (role) {
        case Roles::CityRole:
            return QString(mCities.at(index.row()).first);

        case Roles::CountryRole:
            return QString(mCities.at(index.row()).second);

        default: // default QVariant() if we do not handle the specified role.
            return QVariant();
    }
}

// If the views are written in QML, they will need some meta-information about the data structure.
// jer we do not know what type of view will be used to display our data.
QHash<int, QByteArray> CitiesListModel::roleNames() const
{
    QHash<int, QByteArray> rn;
    rn[Roles::CityRole] = "city";
    rn[Roles::CountryRole] = "country";
    return rn;
}

void CitiesListModel::readCities()
{
    //da može pročitat .json datoteku
    qputenv("QML_XHR_ALLOW_FILE_READ", QByteArray("1"));


    QFile cities_file(":/resources/" + mCitiesFileName);

    QString json_string;

        if(cities_file.open(QIODevice::ReadOnly | QIODevice::Text)){
            json_string = cities_file.readAll();
            cities_file.close();
        }
        else
            qDebug()<< "file not found";


        auto json_doc = QJsonDocument::fromJson(json_string.toUtf8());


        QJsonArray jArr = json_doc.array();
        QJsonValue val;
        CityCountryPair cityCountryPair;


        for(auto jsonObj : jArr)
        {
            cityCountryPair.first = jsonObj.toObject().value("name").toString();
            cityCountryPair.second = jsonObj.toObject().value("country").toString();


            mCities.append(cityCountryPair);
            //m_city.append(cityCountryPair.first);
            //qDebug() << cityCountryPair.first << " " << cityCountryPair.second;
       }
        qDebug() << mCities.size();
        qDebug() << Qt::endl;

}

bool CitiesListModel::isIndexValid(const QModelIndex &index) const
{
    return index.isValid() && index.row() < rowCount();
}



// -----------------------------------------------------------------------

CitiesProxyModel::CitiesProxyModel(QObject *parent)
    : QSortFilterProxyModel(parent)
{
    this->sort(0, Qt::AscendingOrder); // gradove za prikaz u dropdownu razvrstava po abecedi prema državi
}

void CitiesProxyModel::setFilterString(QString input)
{
    qDebug() << this;
    this->setFilterCaseSensitivity(Qt::CaseInsensitive);
    this->setFilterRegularExpression("^" + input); // ime grada počinje sa 'input'
    //this->setFilterFixedString(string);
}

QString CitiesProxyModel::getCityName(const QModelIndex &index)
{
    return this->data(index, CitiesListModel::Roles::CityRole).toString();
}

