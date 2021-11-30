import QtQuick 2.0
import QtQml.XmlListModel // In Qt6, XmlListModel was moved from QtQuick to QtQml as indicated in the docs so you must change to

import "../../js/config.js" as Config

XmlListModel {
    id: currentWeatherXmlModel

    property string city

    // omogućit odabir jedinica za temperaturu, inače u celsiusima
    //    For temperature in Fahrenheit use units=imperial
    //    For temperature in Celsius use units=metric
    //    Temperature in Kelvin is used by default, no need to use units parameter in API call
    property string units: "celsius"
    function encodeUnits(units) {
        if (units === "celsius")
            return "metric"
        else if (units === "fahrenheit")
            return "imperial"
        return "metric";     // meni je po defaultu u Celsiusima
    }

    // dodat jezik 'lang=' ako ubacim translations
    source: "https://api.openweathermap.org/data/2.5/weather?appid=" + Config.api_key + "&mode=xml&q=" + city + ( units ? "&units=" + encodeUnits(units) : "")
    query: "/current"


    XmlListModelRole { name: "longitude"; elementName: "city/coord"; attributeName: "lon" }
    XmlListModelRole { name: "latitude"; elementName: "city/coord"; attributeName: "lat" }
    XmlListModelRole { name: "sunrise"; elementName: "city/sun"; attributeName: "rise" }
    XmlListModelRole { name: "sunset"; elementName: "city/sun"; attributeName: "set" }
    XmlListModelRole { name: "temperature"; elementName: "temperature"; attributeName: "value" }
    XmlListModelRole { name: "temperature_min"; elementName: "temperature"; attributeName: "min" }
    XmlListModelRole { name: "temperature_max"; elementName: "temperature"; attributeName: "max" }
    XmlListModelRole { name: "temperature_units"; elementName: "temperature"; attributeName: "unit" }
    XmlListModelRole { name: "feels_like"; elementName: "feels_like"; attributeName: "value" }
    XmlListModelRole { name: "humidity"; elementName: "humidity"; attributeName: "value" }
    XmlListModelRole { name: "humidity_unit"; elementName: "humidity"; attributeName: "unit" }
    XmlListModelRole { name: "pressure"; elementName: "pressure"; attributeName: "value" }
    XmlListModelRole { name: "pressure_unit"; elementName: "pressure"; attributeName: "unit" }
    XmlListModelRole { name: "wind_speed"; elementName: "wind/speed"; attributeName: "value" }
    XmlListModelRole { name: "wind_speed_unit"; elementName: "wind/speed"; attributeName: "unit" }
    XmlListModelRole { name: "wind_direction"; elementName: "wind/direction"; attributeName: "name" }
    XmlListModelRole { name: "wind_direction_code"; elementName: "wind/direction"; attributeName: "code" }
    XmlListModelRole { name: "visibility"; elementName: "visibility"; attributeName: "value" }
    XmlListModelRole { name: "weather"; elementName: "weather"; attributeName: "value" }
    XmlListModelRole { name: "weather_code"; elementName: "weather"; attributeName: "number" }
    XmlListModelRole { name: "weather_icon"; elementName: "weather"; attributeName: "icon" }


    onStatusChanged: {


//        XmlListModel.Null - No XML data has been set for this model. STATUS=0
//        XmlListModel.Ready - The XML data has been loaded into the model. STATUS=1
//        XmlListModel.Loading - The model is in the process of reading and loading XML data. STATUS=2
//        XmlListModel.Error - An error occurred while the model was loading. See errorString() for details about the error. STATUS=3

        console.log("status changed. " + status)

        if (status === XmlListModel.Error)
            console.log(errorString())
        else if (status === XmlListModel.Null)
            console.log("No XML data has been set for this model.")
    }
}
