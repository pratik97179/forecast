import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Util {
  LinearGradient weatherCardGrad() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[
        const Color(0xffFEECE9).withOpacity(0.4),
        const Color(0xffF999B7).withOpacity(0.4),
        const Color(0xffFF5677).withOpacity(0.4),
      ],
    );
  }

  static closeProgressDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  static void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        textColor: const Color(0xfff9e4d4),
        backgroundColor: const Color(0xff9c0f48),
        toastLength: Toast.LENGTH_SHORT);
  }
}
