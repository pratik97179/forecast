import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import 'package:weather_app/src/screens/home_screen%20/home_screen_provider.dart';
import 'package:weather_app/src/screens/weather_widget/weather_widget.dart';
import 'package:weather_app/src/util/util_functions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeScreenProvider>(
      create: (context) => HomeScreenProvider(),
      child: Builder(
        builder: (context) {
          return Consumer<HomeScreenProvider>(
            builder: (context, provider, _) {
              return HomeScreenChild(provider: provider);
            },
          );
        },
      ),
    );
  }
}

class HomeScreenChild extends StatefulWidget {
  final HomeScreenProvider provider;

  const HomeScreenChild({Key key, this.provider}) : super(key: key);

  @override
  _HomeScreenChildState createState() => _HomeScreenChildState();
}

class _HomeScreenChildState extends State<HomeScreenChild>
    with SingleTickerProviderStateMixin {
  HomeScreenProvider provider;

  bool isLogoTapped = false;
  AnimationController _ac;
  final double screenHeight = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.provider != null) {
      provider = widget.provider;
    }
    provider.callGeocodingApi(context);
    provider.callWeatherApi(context);
    _ac = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 400,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _ac,
        builder: (context, child) => Stack(
          children: <Widget>[
            appBackgroundImage(_height, _width),
            if (_ac.isAnimating || _ac.isCompleted) weatherCard(context),
            appLogo(context),
            if (!_ac.isCompleted) appTitleAndCopyright(_height, _width),
          ],
        ),
      ),
    );
  }

  Container appBackgroundImage(double _height, double _width) {
    return Container(
      height: _height,
      width: _width,
      child: Image.asset(
        DateTime.now().hour >= 18 || DateTime.now().hour <= 4
            ? "assets/night.jpeg"
            : "assets/day.jpeg",
        fit: BoxFit.cover,
      ),
    );
  }

  Widget weatherCard(BuildContext context) {
    return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..translate(
                0.0,
                MediaQuery.of(context).size.height * (1.125 - _ac.value),
                0.0,
              ),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.875,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: Util().weatherCardGrad(),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                  bottomLeft: Radius.zero,
                  bottomRight: Radius.zero,
                ),
              ),
              child: WeatherWidget(provider: provider),
            ),
          );
  }

  Widget appTitleAndCopyright(double _height, double _width) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: _height * 0.13),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            appTitle(_width, _height),
            copyrightText(_width, _height),
          ],
        ),
      ),
    );
  }

  Widget copyrightText(double _width, double _height) {
    return Transform(
      transform: Matrix4.identity()
        ..translate(0.0, _height * 0.3 * _ac.value, 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            "© 2022 Weather forecasting App.",
            style: TextStyle(
              color: DateTime.now().hour >= 18 || DateTime.now().hour <= 4
                  ? Colors.white70
                  : Colors.black87,
              fontSize: _width >= 300 ? 15.0 : 11.5,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: _height * 0.02,
          ),
          Text(
            "All rights reserved.",
            style: TextStyle(
              color: DateTime.now().hour >= 18 || DateTime.now().hour <= 4
                  ? Colors.white70
                  : Colors.black87,
              fontSize: _width >= 300 ? 15.0 : 11.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget appTitle(double _width, double _height) {
    return Transform(
      transform: Matrix4.identity()
        ..translate(0.0, _height * -0.3 * _ac.value, 0.0),
      child: Text(
        "FORECAST",
        style: TextStyle(
          fontFamily: "Abel-Regular",
          fontSize: _width >= 300 ? 40.0 : 30.5,
          color: DateTime.now().hour >= 18 || DateTime.now().hour <= 4
              ? Colors.white70
              : Colors.black87,
        ),
      ),
    );
  }

  Widget appLogo(BuildContext context) {
    return GestureDetector(
      onTap: () {
        provider.toggleLogoTapBool();
        provider.isLogoTapped ? _ac.forward() : _ac.reverse();
      },
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..translate(
            0.0,
            MediaQuery.of(context).size.height * -0.375 * (_ac.value),
            0.0,
          )
          ..scale((1 - _ac.value) + 0.5),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.width * 0.4,
            child: Image.asset(
              DateTime.now().hour >= 18 || DateTime.now().hour <= 4
                  ? "assets/moon2.png"
                  : "assets/appLogo.png",
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ),
    );
  }
}
