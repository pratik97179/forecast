import 'dart:async';
import 'dart:io';

class NetworkConnection {

  //Internet Connectivity
  bool checkConnection;
  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup("google.com")
          .timeout(const Duration(seconds: 5));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        checkConnection = true;
      } else {
        checkConnection = false;
      }
    } on TimeoutException catch (_) {
      checkConnection = false;
    } on SocketException catch (_) {
      checkConnection = false;
    }
    return checkConnection;
  }
}