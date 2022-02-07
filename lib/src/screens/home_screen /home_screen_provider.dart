import 'package:flutter/material.dart';

import 'package:weather_app/src/model/weather_response_model.dart';
import 'package:weather_app/src/model/weather_repo.dart';
import 'package:weather_app/src/model/geocoding_response_model.dart';
import 'package:weather_app/src/model/geocoding_repo.dart';
import 'package:weather_app/src/util/network_connection.dart';
import 'package:weather_app/src/util/util_functions.dart';

class HomeScreenProvider extends ChangeNotifier {
  bool _geocodeApiRunning = false;
  bool _weatherApiRunning = false;

  WeatherResponseModel _weatherResponse = WeatherResponseModel();
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

  //Function to set coordinate of the entered city and also format the city name
  void setLatLongCityName(GeocodingResponseModel resp) {
    _longLat.clear();
    _longLat.add(resp.features[0].center[0]);
    _longLat.add(resp.features[0].center[1]);

    _cityName =
        "${resp.query[0].substring(0, 1).toUpperCase()}${resp.query[0].substring(1)}";
    if (resp.query.length > 1) {
      for (int i = 1; i < resp.query.length; i++) {
        _cityName =
            "$_cityName ${resp.query[i].substring(0, 1).toUpperCase()}${resp.query[i].substring(1)}";
      }
    }
    notifyListeners();
  }

  //Api to get weather report
  Future<WeatherResponseModel> getWeatherApi(BuildContext context) async {
    WeatherResponseModel resp;
    await WeatherRepository.weatherApi(context, _longLat[1], _longLat[0])
        .then((response) {
      if (response != null) {
        resp = response;
        _weatherResponse = resp;
        notifyListeners();
      } else {
        _weatherResponse = null;
        resp = null;
        return resp;
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
                  _weatherApiRunning = false;
                  notifyListeners();
                } else {
                  Util.showToast("Error fetching weather details");
                }
              }
            },
          );
        } else {
          Util.showToast("No Internet");
        }
      },
    );
  }

  //Api to get geocoding wrt to the entered city name
  Future<GeocodingResponseModel> getGeoCodingApi(BuildContext context) async {
    GeocodingResponseModel geocodingResp;
    await GeocodingRepo.geoCodingApi(context, _cityName).then(
      (response) {
        if (response != null) {
          geocodingResp = response;
        } else {
          geocodingResp = null;
        }
      },
    );
    return geocodingResp;
  }

  //Function to call geocoding api
  void callGeocodingApi(BuildContext context) async {
    await NetworkConnection().checkInternetConnection().then(
      (internet) async {
        if (internet) {
          await getGeoCodingApi(context).then(
            (response) {
              if (response != null) {
                setLatLongCityName(response);
                _geocodeApiRunning = false;
                notifyListeners();
              } else {
                Util.showToast("Error fetching geo-codes");
              }
            },
          );
        } else {
          Util.showToast("No Internet");
        }
      },
    );
  }

  //getter and setter

  bool get geocodeApiRunning => _geocodeApiRunning;
  set geocodeApiRunning(bool value) {
    _geocodeApiRunning = value;
    notifyListeners();
  }

  bool get weatherApiRunning => _weatherApiRunning;
  set weatherApiRunning(bool value) {
    _weatherApiRunning = value;
    notifyListeners();
  }

  WeatherResponseModel get weatherResponse => _weatherResponse;
  set weatherResponse(WeatherResponseModel value) {
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
