import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/src/api/api_key.dart';

import 'package:weather_app/src/model/weather_response_model.dart';

class WeatherRepository {
  static Future<WeatherResponseModel> weatherApi(
      BuildContext context, double latitude, double longitude) async {
    WeatherResponseModel weatherResponse;
    await http
        .get(Uri.parse(
            "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=metric&appid=${ApiKey.OPENWEATHER_API_KEY}"))
        .then((response) {
      if (response != null) {
        var resp = jsonDecode(response.body);
        weatherResponse = WeatherResponseModel.fromJson(resp);
      } else {
        weatherResponse = null;
      }
    });
    return weatherResponse;
  }
}
