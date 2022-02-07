import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:weather_app/src/screens/home_screen%20/home_screen_provider.dart';

class WeatherWidget extends StatefulWidget {
  final HomeScreenProvider provider;

  const WeatherWidget({Key key, this.provider}) : super(key: key);

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: _height * 0.06),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          dateRow(_width),
          SizedBox(height: _height * 0.025),
          cityName(_width),
          weatherLogo(_height, _width),
          weatherType(_width),
          SizedBox(height: _height * 0.03),
          temperatureRow(_width),
          SizedBox(height: _height * 0.03),
          weatherDetailCard(_height, _width),
        ],
      ),
    );
  }

  Widget dateRow(double _width) {
    return Expanded(
      flex: 0,
      child: Text(
        widget.provider.getDateFormat(),
        style: TextStyle(
          fontSize: _width >= 300 ? 22.0 : 18.0,
          color: DateTime.now().hour >= 18 || DateTime.now().hour <= 4 ? Colors.white70 : Colors.black87
        ),
      ),
    );
  }

  Widget cityName(double _width) {
    return Expanded(
      flex: 0,
      child: Text(
        widget.provider.cityName ?? "",
        style: TextStyle(
          fontSize: _width >= 300 ? 27.0 : 20.0,
          fontWeight: FontWeight.bold,
          color: const Color(0xff502064),
        ),
      ),
    );
  }

  Widget weatherLogo(double _height, double _width) {
    return Expanded(
      flex: 2,
      child: Container(
        margin: EdgeInsets.fromLTRB(0.0, _height * 0.02, 0.0, _height * 0.03),
        width: _width * 0.4,
        child: Image.asset(
          "assets/${widget.provider.getWeatherIconPath()}",
        ),
      ),
    );
  }

  Widget weatherType(double _width) {
    return Expanded(
      flex: 0,
      child: Text(
        widget.provider.weatherResponse.weather[0].main,
        style: TextStyle(
          fontSize: _width >= 300 ? 35.0 : 25.0,
          fontWeight: FontWeight.bold,
          color: const Color(0xff502064),
        ),
      ),
    );
  }

  Widget temperatureRow(double _width) {
    return Expanded(
      flex: 0,
      child: Text(
        "${widget.provider.weatherResponse.main.temp.toString()}°C",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: _width >= 300 ? 60.0 : 40.0,
          color: DateTime.now().hour >= 18 || DateTime.now().hour <= 4 ? const Color(0xffC996CC) : const Color(0xff14279B),
        ),
      ),
    );
  }

  Widget weatherDetailCard(double _height, double _width) {
    return Expanded(
      flex: 2,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 15.0),
        width: _width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: const Color(0xffFFAEBC),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            weatherDetails(
              argName: "Wind",
              iconPath: "assets/wind.png",
              value: widget.provider.weatherResponse.wind.speed,
              siUnit: "m/s",
            ),
            weatherDetails(
              argName: "Humid",
              iconPath: "assets/humidity.png",
              value: widget.provider.weatherResponse.main.humidity.toString(),
              siUnit: "%",
            ),
            weatherDetails(
              argName: "Feels",
              iconPath: "assets/thermometer.png",
              value: widget.provider.weatherResponse.main.feelsLike.toString(),
              siUnit: "°C",
            ),
          ],
        ),
      ),
    );
  }

  Widget weatherDetails(
      {String argName, String iconPath, String value, String siUnit}) {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            argName,
            style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w700,
                color: Color(0xff502064)),
          ),
          const SizedBox(height: 8.0),
          FractionallySizedBox(
            widthFactor: 0.5,
            child: Image.asset(
              iconPath,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            "$value$siUnit",
            style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w700,
                color: Color(0xff502064)),
          ),
        ],
      ),
    );
  }
}
