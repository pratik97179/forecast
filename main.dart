import 'package:flutter/material.dart';
import 'package:weather_app/src/screens/my_app.dart';

void main() => runApp(const Forecast());

class Forecast extends StatelessWidget {
  const Forecast({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Comfortaa",
      ),
      home: const MyApp(),
    );
  }
}
