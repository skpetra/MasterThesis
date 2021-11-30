
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
        weatherAnimationLoader.setSource("../qml/visualizations/Thunderstorm.qml",
                                        {  precipitationType: weatherConditionCode_1 === 0 || weatherConditionCode_1 === 3 ? "rain" : "", // ako je kod 200, 201, 202 ili 230, 231, 232 --- onda su kapljice
                                           precipitationIntensity: weatherConditionCode_2 + 2,
                                           width: item_width,
                                           height: item_height
                                        })
    }
    else if (weatherConditionCode_0 === 3) {
        weatherAnimationLoader.setSource("../qml/visualizations/Drizzle.qml",
                                        {   dropOfRainSize: weatherConditionCode_1 === 0 ? "small" : "big",
                                            rainIntensity: weatherConditionCode_1 !== 2 ? weatherConditionCode_2 + 2 : 6,
                                            width: item_width,
                                            height: item_height
                                        })
    }
    else if (weatherConditionCode_0 === 5) {
        weatherAnimationLoader.setSource("../qml/visualizations/Rain.qml" ,
                                        {   timeOfDay: weatherConditionCode_1 === 0 ? timeOfDay : "", // ako je 300-304 bitno nam je sunce ili mjesec
                                            isFreezingRain: weatherConditionCode_1 === 1,
                                            rainIntensity: setRainIntensity(weatherConditionCode_1, weatherConditionCode_2),
                                            dropOfRainSize: weatherConditionCode_1 === 0 ? "small" : "big",
                                            width: item_width,
                                            height: item_height
                                        })
    }
    else if (weatherConditionCode_0 === 6) {
        weatherAnimationLoader.setSource("../qml/visualizations/Snow.qml" ,
                                        {   snowIntensity: setSnowIntensity(weatherConditionCode_1, weatherConditionCode_2),
                                            snowflakeSize: weatherConditionCode_1 === 2 ? "big" : "small",
                                            isSleet: weatherConditionCode_1 === 1,
                                            sleetIntensity: weatherConditionCode_1 === 1 ? weatherConditionCode_2 : 0,
                                            width: item_width,
                                            height: item_height
                                        })
    }
    else if (weatherConditionCode_0 === 7) {
        weatherAnimationLoader.setSource("../qml/visualizations/Atmosphere.qml" ,
                                        {
                                             fogIntensity: weatherConditionCode_1 < 4 ? false : true,
                                             intensity: weatherConditionCode_1 > 5 ? true : false,
                                             width: item_width,
                                             height: item_height
                                        })

    }
    else if (weatherConditionCode_0 === 8) {

        if (weatherConditionCode_2 === 0){
            if (timeOfDay === 'd')
                weatherAnimationLoader.setSource("../qml/visualizations/basic/Sun.qml",
                                                {
                                                    radius: item_width*0.2,
                                                    x: item_width*0.2,
                                                    y: item_width*0.15,
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
            weatherAnimationLoader.setSource("../qml/visualizations/Clouds.qml",
                                            {
                                                 timeOfDay: timeOfDay,
                                                 width: item_width,
                                                 height: item_height
                                            })
        else if (weatherConditionCode_2 === 2)
            weatherAnimationLoader.setSource("../qml/visualizations/Clouds.qml",
                                            {
                                                width: item_width,
                                                height: item_height
                                            })
        else // 3 ili 4
            weatherAnimationLoader.setSource("../qml/visualizations/Clouds.qml",
                                            {
                                                brokenClouds: true,
                                                width: item_width,
                                                height: item_height
                                            })
    }
}

// ---------------------------- ---------------------------- ----------------------------
