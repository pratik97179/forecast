import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:weather_app/src/api/api_key.dart';

import 'package:weather_app/src/model/weather_response.dart';
import 'package:weather_app/src/util/network_connection.dart';
import 'package:weather_app/src/util/util_functions.dart';

class HomeScreenProvider extends ChangeNotifier {
  WeatherResponse _weatherResponse = WeatherResponse();
  bool _isLogoTapped = false;
  final List<String> _weekdays = const [
    'Mon',
    'Tue',
    'Wed',
    'Thurs',
    'Fri',
    'Sat',
    'Sun'
  ];
  TextEditingController _cityNameController =
      TextEditingController(text: "Jharkhand");
  String _cityName = "Jharkhand";
  String _temperature;

  List<double> _longLat = [88.4067, 22.6001];

  //Function to display today's date
  String getDateFormat() {
    return "${_weekdays[DateTime.now().weekday - 1]} ${DateTime.now().day}, ${DateTime.now().year}";
  }

  //Function to get relevant weather icon path
  String getWeatherIconPath() {
    var _weatherType = _weatherResponse.weather[0].main;
    switch (_weatherType) {
      case "Thunderstorm":
        return "storm.png";
        break;
      case "Drizzle":
        return "drizzle.png";
        break;
      case "Rain":
        return "rain.png";
        break;
      case "Snow":
        return "snow.png";
        break;
      case "Clear":
        if (_weatherResponse
                .weather[0].icon[_weatherResponse.weather[0].icon.length - 1] ==
            'd') {
          return "sun.png";
        } else {
          return "moon.png";
        }
        break;
      case "Clouds":
        if (_weatherResponse
                .weather[0].icon[_weatherResponse.weather[0].icon.length - 1] ==
            'd') {
          return "cloud_day.png";
        } else {
          return "cloud_night.png";
        }
        break;
      default:
        return "fog.png";
    }
  }

  void toggleLogoTapBool() {
    _isLogoTapped = !_isLogoTapped;
    notifyListeners();
  }

  //Api to get weather report
  Future<WeatherResponse> getWeatherApi(BuildContext context) async {
    WeatherResponse resp;
    await http
        .get(Uri.parse(
            "https://api.openweathermap.org/data/2.5/weather?lat=${_longLat[1]}&lon=${_longLat[0]}&units=metric&appid=${ApiKey.OPENWEATHER_API_KEY}"))
        .then((response) {
      if (response != null) {
        _weatherResponse = WeatherResponse.fromJson(jsonDecode(response.body));
        resp = _weatherResponse;
        notifyListeners();
      } else {
        _weatherResponse = null;
        resp = null;
      }
    });
    return resp;
  }

  //Funtion to call weather api
  void callWeatherApi(BuildContext context) async {
    await NetworkConnection().checkInternetConnection().then(
      (internet) async {
        if (internet) {
          await getWeatherApi(context).then(
            (response) {
              if (response != null) {
                if (response.status == 200) {
                } else {
                  Util.showToast(response.cityName);
                }
              }
            },
          );
        } else {
          Util.showToast("Weather connection er");
        }
      },
    );
  }

  Future<List<double>> getGeoCodingApi(BuildContext context) async {
    await http
        .get(Uri.parse(
            "https://api.mapbox.com/geocoding/v5/mapbox.places/'${_cityName}'.json?access_token=${ApiKey.GEOCODING_API_KEY}"))
        .then(
      (response) {
        if (response != null) {
          _longLat.clear();
          _longLat.add(jsonDecode(response.body)['features'][0]['center'][0]);
          _longLat.add(jsonDecode(response.body)['features'][0]['center'][1]);

          var resp = jsonDecode(response.body)['query'];

          _cityName =
              "${resp[0].substring(0, 1).toUpperCase()}${resp[0].substring(1)}";
          if (resp.length > 1) {
            for (int i = 1; i < resp.length; i++) {
              _cityName =
                  "$_cityName ${resp[i][0].substring(0, 1).toUpperCase()}${resp[i].substring(1)}";
            }
            notifyListeners();
          }
          callWeatherApi(context);
          notifyListeners();
          return _longLat;
        } else {
          return <double>[];
        }
      },
    );
  }

  void callGeocodingApi(BuildContext context) async {
    await NetworkConnection().checkInternetConnection().then(
      (internet) async {
        if (internet) {
          await getGeoCodingApi(context).then(
            (response) {
              if (response != null) {
                print('done');
              } else {
                print("nah");
              }
            },
          );
        } else {
          Util.showToast('Geocoding connection er');
        }
      },
    );
  }

  //getter and setter
  WeatherResponse get weatherResponse => _weatherResponse;
  set weatherResponse(WeatherResponse value) {
    _weatherResponse = value;
    notifyListeners();
  }

  List<double> get longLat => _longLat;
  set longLat(List<double> value) {
    _longLat = value;
    notifyListeners();
  }

  String get cityName => _cityName;
  set cityName(String value) {
    _cityName = value;
    notifyListeners();
  }

  TextEditingController get cityNameController => _cityNameController;
  set cityNameController(TextEditingController value) {
    _cityNameController = value;
    notifyListeners();
  }

  String get temperature => _temperature;
  set temperature(String value) {
    _temperature = value;
    notifyListeners();
  }

  List<String> get weekdays => _weekdays;

  bool get isLogoTapped => _isLogoTapped;
  set isLogoTapped(bool value) {
    _isLogoTapped = value;
    notifyListeners();
  }
}
