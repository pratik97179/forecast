import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/src/api/api_key.dart';

import 'package:weather_app/src/model/geocoding_response_model.dart';

class GeocodingRepo {
  static Future<GeocodingResponseModel> geoCodingApi(
      BuildContext context, String cityName) async {
    GeocodingResponseModel geoCodingResponse;
    await http
        .get(Uri.parse(
            "https://api.mapbox.com/geocoding/v5/mapbox.places/'${cityName}'.json?access_token=${ApiKey.GEOCODING_API_KEY}"))
        .then(
      (response) {
        if (response != null) {
          var resp = jsonDecode(response.body);
          geoCodingResponse = GeocodingResponseModel.fromJson(resp);
        } else {
          geoCodingResponse = null;
        }
      },
    );
    return geoCodingResponse;
  }
}
