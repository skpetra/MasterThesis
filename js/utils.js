// .pragma library ?

// ---------------------------- CurrentWeatherPage ----------------------------

function setRainIntensity(weather_code_1, weather_code_2){
    if (weather_code_1 === 0)
        return weather_code_2 + 1
    else if (weather_code_1 === 1)// freezing rain
        return 4
    else if (weather_code_1 === 2)
        return weather_code_2 + 3
    else // 531 - ragged shower rain
        return 6
}

function setSnowIntensity(weather_code_1, weather_code_2){
    if (weather_code_1 === 0)
        return weather_code_2 + 1
    else if (weather_code_1 === 1) // srednji snijeg + kisa
        return 4
    else if (weather_code_1 === 2)
        return weather_code_2 + 3
}

function setWeatherAnimation(weatherAnimationLoader, weather_code, weather_icon, item_width, item_height) {
    var weatherConditionCode_0 = parseInt(weather_code.charAt(0)) // grupa vremenskih uvjeta
    var weatherConditionCode_1 = parseInt(weather_code.charAt(1)) // podgrupa ovisno o intenzitetu
    var weatherConditionCode_2 = parseInt(weather_code.charAt(2)) // intenziteti podgrupe
    var timeOfDay = weather_icon.charAt(2)

    if (weatherConditionCode_0 === 2) {
        weatherAnimationLoader.setSource("../qml/visualizations/weather_conditions/Thunderstorm.qml",
                                        {  precipitationType: weatherConditionCode_1 === 0 || weatherConditionCode_1 === 3 ? "rain" : "", // ako je kod 200, 201, 202 ili 230, 231, 232 --- onda su kapljice
                                           precipitationIntensity: weatherConditionCode_2 + 2,
                                           width: item_width,
                                           height: item_height
                                        })
    }
    else if (weatherConditionCode_0 === 3) {
        weatherAnimationLoader.setSource("../qml/visualizations/weather_conditions/Drizzle.qml",
                                        {   dropOfRainSize: weatherConditionCode_1 === 0 ? "small" : "big",
                                            rainIntensity: weatherConditionCode_1 !== 2 ? weatherConditionCode_2 + 2 : 6,
                                            width: item_width,
                                            height: item_height
                                        })
    }
    else if (weatherConditionCode_0 === 5) {
        weatherAnimationLoader.setSource("../qml/visualizations/weather_conditions/Rain.qml" ,
                                        {   timeOfDay: weatherConditionCode_1 === 0 ? timeOfDay : "", // ako je 300-304 bitno nam je sunce ili mjesec
                                            isFreezingRain: weatherConditionCode_1 === 1,
                                            rainIntensity: setRainIntensity(weatherConditionCode_1, weatherConditionCode_2),
                                            dropOfRainSize: weatherConditionCode_1 === 0 ? "small" : "big",
                                            width: item_width,
                                            height: item_height
                                        })
    }
    else if (weatherConditionCode_0 === 6) {
        weatherAnimationLoader.setSource("../qml/visualizations/weather_conditions/Snow.qml" ,
                                        {   snowIntensity: setSnowIntensity(weatherConditionCode_1, weatherConditionCode_2),
                                            snowflakeSize: weatherConditionCode_1 === 2 ? "big" : "small",
                                            isSleet: weatherConditionCode_1 === 1,
                                            sleetIntensity: weatherConditionCode_1 === 1 ? weatherConditionCode_2 : 0,
                                            width: item_width,
                                            height: item_height
                                        })
    }
    else if (weatherConditionCode_0 === 7) {
        weatherAnimationLoader.setSource("../qml/visualizations/weather_conditions/Atmosphere.qml" ,
                                        {
                                             fogIntensity: weatherConditionCode_1 < 4 ? false : true,
                                             intensity: weatherConditionCode_1 > 5 ? true : false,
                                             y: weatherConditionCode_1 > 5 ? item_height * 0.05 : item_height * 0.1,
                                             width: item_width,
                                             height: item_height
                                        })

    }
    else if (weatherConditionCode_0 === 8) {

        if (weatherConditionCode_2 === 0){
            if (timeOfDay === 'd')
                weatherAnimationLoader.setSource("../qml/visualizations/basic/Sun.qml",
                                                {
                                                    radius: item_width * 0.3,
                                                    x: item_width * 0.2,
                                                    y: item_width * 0.15,
                                                    width: item_width,
                                                    height: item_height
                                                })
            else
                weatherAnimationLoader.setSource("../qml/visualizations/basic/Moon.qml",
                                                {
                                                    width: item_width,
                                                    height: item_height
                                                })
        }
        else if (weatherConditionCode_2 === 1)
            weatherAnimationLoader.setSource("../qml/visualizations/weather_conditions/Clouds.qml",
                                            {
                                                 timeOfDay: timeOfDay,
                                                 width: item_width,
                                                 height: item_height,
                                                 y: item_height * 0.2
                                            })
        else if (weatherConditionCode_2 === 2)
            weatherAnimationLoader.setSource("../qml/visualizations/weather_conditions/Clouds.qml",
                                            {
                                                width: item_width,
                                                height: item_height,
                                                y: item_height * 0.2
                                            })
        else // 3 ili 4
            weatherAnimationLoader.setSource("../qml/visualizations/weather_conditions/Clouds.qml",
                                            {
                                                brokenClouds: true,
                                                width: item_width,
                                                height: item_height,
                                                y: item_height * 0.2
                                            })
    }
}

// ---------------------------- ---------------------------- ----------------------------


// ---------------------------- CurrentWeatherXmlModel, SevenDaysWeatherModel ----------------------------

function encodeUnits(units) {
    if (units === "celsius")
        return "metric"
    else if (units === "fahrenheit")
        return "imperial"
    return "metric";     // meni je po defaultu u Celsiusima
}

// ---------------------------- ---------------------------- ----------------------------

// ---------------------------- datetime funkcije ----------------------------

// Funkcija iz vraća datum oblika '12.12.2021.' iz unix time stamp formata.
function getDate(unix_timestamp) {
    unix_timestamp = parseInt(unix_timestamp)
    // Create a new JavaScript Date object based on the timestamp
    // multiplied by 1000 so that the argument is in milliseconds, not seconds.
    var date = new Date(unix_timestamp * 1000);
    var weekDay = dayOfWeekAsString(date.getDay());
    var month = ("" + date).substr(4, 3);
    var day = ("" + date).substr(8, 2);
    // Hours part from the timestamp
    var hours = date.getHours();
    // Minutes part from the timestamp
    var minutes = "0" + date.getMinutes();
    // Seconds part from the timestamp
    var seconds = "0" + date.getSeconds();

    // Will display time in 10:30:23 format
    var formattedTime = hours + ':' + minutes.substr(-2) + ':' + seconds.substr(-2);

    return day + "." + (date.getMonth()+1) + "." + date.getFullYear() + ".";
}

// Funkcija iz vraća datum ili vrijeme u zadanom formatu iz unix time stamp formata.
function getTime(unix_timestamp, format) {
    var date = new Date(unix_timestamp * 1000);
    var formattedTime = Qt.formatDateTime(date, format)

    return formattedTime;
}

// Funkcija iz vraća dan u tjednu iz unix time stamp formata.
function getWeekDay(unix_timestamp) {

    unix_timestamp = parseInt(unix_timestamp)
    var date = new Date(unix_timestamp * 1000);
    var weekDay = dayOfWeekAsString(date.getDay());

    return weekDay
}

// Funkcija po indeksu dana (0-6) vraća dan u tjednu u obliku stringa.
function dayOfWeekAsString(dayIndex) {
  return ["Sunday", "Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"][dayIndex] || '';
}


// ---------------------------- funkcije za pretvorbu temperature ----------------------------

// Funkcija koja prema dobivenoj mjernoj jedinici i vrijednosti temperature, ovisno o jedinici ostavlja
// °C nepromijenjenima ukoliko je tražena jedinica "celsius" ili pretvara vrijednost u °F ukoliko je jedinica "fahrenheit".
// Funkcija je ovako implementirana budući da se podaci o temperaturi uvijek dohvaćaju u celsiusima.
function convertTo(units, value) {
    if (units === "celsius")
        return value
    else if (units === "fahrenheit") {
        console.log("F to C")
        let fahrenheit = value * 9/5 + 32

        return fahrenheit
    }
    return null
}

function convertToF(celsius) {
  // make the given fahrenheit variable equal the given celsius value
  // multiply the given celsius value by 9/5 then add 32
  let fahrenheit = celsius * 9/5 + 32
  // return the variable fahrenheit as the answer
  return fahrenheit;
}

function convertToC(fahrenheit) {
  let celsius = (5/9) * (fahrenheit - 32)

  return celsius;
}
