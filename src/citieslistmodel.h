#ifndef CITIESLISTMODEL_H
#define CITIESLISTMODEL_H

#include <QAbstractListModel>
#include <QSortFilterProxyModel>

#include <QtQml>

typedef QPair<QString, QString> CityCountryPair;
typedef QPair<double, double> Coordinates;

// The model provides the set of data that is used to create the items in the view.
// Models can be created directly in QML using ListModel, ObjectModel, or provided by
// C++ model classes. If a C++ model class is used, it must be a subclass of
// QAbstractItemModel or a simple list.
class CitiesListModel : public QAbstractListModel // Data is stored in a one-dimensional array
{
     Q_OBJECT

public:
    // Pogled će tražiti podatke s dva parametra: indeksom i ulogom.
    // role - pridružuje svakom elementu podataka oznaku kako bi pogled znao koja je kategorija podataka prikazana.
    // model ima podatke -> svaka skupina podataka u modelu ima svoju ROLE koju definiramo
    // Uloge koristi pogled da naznače modelu koju vrstu podataka treba.
    // Prilagođeni modeli trebali bi vraćati podatke u tim vrstama.
    enum Roles {
        CityRole = Qt::UserRole + 1, // Za korisničke uloge, na programeru je da odluči koje će tipove koristiti i osigurati da komponente koriste ispravne tipove prilikom pristupa i postavljanja podataka.
        CountryRole = Qt::UserRole + 2,
        LongitudeRole = Qt::UserRole + 3,
        LatitudeRole = Qt::UserRole + 4
    };

    CitiesListModel(QObject* parent = 0);

    // ************************************ reading part of the model *****************************************

    // When subclassing QAbstractListModel, you must provide implementations of the rowCount() and data() functions
    // ----
    // used to get the list size.
    int rowCount(const QModelIndex& parent = QModelIndex()) const override; // Data is stored in a one-dimensional array - ROWS

    // used to get a specific piece of information about the data to display.
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;

    // This function is used to indicate the name for each "role" to the framework
    // The library we are currently building will be used for QML, which is why we override this function.
    QHash<int, QByteArray> roleNames() const override;

    // ************************************ ************************* *****************************************

    // setdata()
    // To change model data, you can assign updated values to the model properties. The QML ListModel is editable by default whereas C++ models must implement setData() to become editable. Integer and JavaScript array models are read-only.
protected:
    void readCities(); // funkcija čita sve dostupne gradove za prognozu iz .json datoteke - trebam li je smjetit u cities.h jer je ovo samo za model

private:
    bool isIndexValid(const QModelIndex& index) const;

    QString mCitiesFileName; // ime datoteke u kojoj se nalaze gradovi za koje se može prikazati vremenska prognoza

    // Each time the model interacts with the view (to notify us about changes or to serve data),
    // mCities will be used. Because it is in memory only, reading will be very fast.
    QList<CityCountryPair> mCities;

    // lista parova (longitude, latitude) za svaki grad na i tom mjestu
    // potrebna na dohvaćanje prognoze za više dana koja ne može ići preko imena grada
    QList<Coordinates> mCoordinates;

};


//filter proxy model

/*
This is possible in Qt with the use of the QAbstractProxyModel class and its subclasses. The goal of
this class is to process data from a QAbstractItemModel base (sorting, filtering, adding data, and so
on) and present it to the view by proxying the original model. To take a database analogy, you
can view it as a projection over a table.
*/

class CitiesProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT

public:
    CitiesProxyModel(QObject* parent = 0);

    Q_INVOKABLE void setFilterString(QString string);

    // moja funkcija kojom za određeni QModelIndex dohvaćam ime grada na tom indexu
    Q_INVOKABLE QString getCityName(const QModelIndex &index);

    Q_INVOKABLE double getCityLongitude(const QModelIndex &index);
    Q_INVOKABLE double getCityLatitude(const QModelIndex &index);
};

QML_DECLARE_TYPE(CitiesListModel)

#endif // CITIESLISTMODEL_H
