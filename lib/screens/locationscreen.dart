import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:clima/screens/cityscreen.dart';
import 'package:clima/services/networking.dart';
import 'package:clima/services/response.dart';
import 'package:clima/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constant.dart';
import 'package:flutter/widgets.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({this.locationWeather});

  final locationWeather;

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();
  int temperature = 0;
  // int condition = 0;
  String weatherIcon = "blank";
  String cityName = "xyz";
  String weatherMessage = "Play";

  @override
  void initState() {
    super.initState();
    print(widget.locationWeather);
    updateUI(widget.locationWeather);
  }

  // void updateUI(dynamic weatherData) {
  //   setState(() {
  //     try {
  //       // if (weatherData == null) {
  //       //   temperature = 0;
  //       //   weatherIcon = 'error';
  //       //   weatherMessage = 'unable to get weather data';
  //       //   cityName = '';
  //       //   return;
  //       // }

  //       double temp = weatherData['main']['temp'];
  //       temperature = temp.toInt();
  //       var condition = weatherData['weather'][0]['id'];
  //       weatherIcon = weather.getWeatherIcon(condition);
  //       weatherMessage = weather.getMessage(temperature);
  //       cityName = weatherData['name'];
  //     } catch (error) {
  //       temperature = 0;
  //       weatherIcon = 'error';
  //       weatherMessage = 'Error: $error';
  //       cityName = 'Error';
  //     }
  //   });
  // }

  void updateUI(dynamic weatherData) {
    setState(() {
      try {
        if (weatherData == null) {
          temperature = 0;
          weatherIcon = 'error';
          weatherMessage =
              'Unable to fetch weather data check for another location.';
          cityName = 'Error';
          return;
        }
        if (weatherData['main'] == null ||
            weatherData['weather'] == null ||
            weatherData['name'] == null) {
          temperature = 0;
          weatherIcon = 'error';
          weatherMessage = 'Weather data format is incorrect.';
          cityName = 'Error';
          return;
        }

        double temp = weatherData['main']['temp'];
        temperature = temp.toInt();
        var condition = weatherData['weather'][0]['id'];
        weatherIcon = weather.getWeatherIcon(condition);
        weatherMessage = weather.getMessage(temperature);
        cityName = weatherData['name'];
      } catch (error) {
        temperature = 0;
        weatherIcon = 'error';
        // To print on  screen if error occurred
        weatherMessage = 'Error';
        // weatherMessage = 'Error: $error';
        cityName = 'Error';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.jpg'),
            fit: BoxFit.cover,
            // colorFilter: ColorFilter.mode(
            //     Color.fromARGB(255, 236, 228, 228).withOpacity(0.8),
            //     BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      onTap: () async {
                        var weatherData = await weather.getLocationWeather();
                        updateUI(weatherData);
                      },
                      child: Icon(
                        Icons.near_me,
                        size: 50.0,
                        color: Colors.white,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        var typedName = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CityScreen()),
                        );
                        if (typedName != null) {
                          var weatherData =
                              await weather.getCityWeather(typedName);
                          updateUI(weatherData);
                        }
                      },
                      child: Icon(
                        Icons.account_balance,
                        color: Colors.white,
                        size: 50.0,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          '$temperature°',
                          style: kTempTextStyle,
                        ),
                      ),
                      Text(
                        weatherIcon,
                        style: kConditionTextStyle,
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                    child: Text(
                      "$weatherMessage in $cityName",
                      textAlign: TextAlign.right,
                      style: kMessageTextStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
