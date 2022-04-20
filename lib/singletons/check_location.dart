import 'dart:async';

import 'package:geolocator/geolocator.dart';

class GeolocationStatus {
  //This creates the single instance by calling the `_internal` constructor specified below
  static final GeolocationStatus _singleton = GeolocationStatus._internal();

  GeolocationStatus._internal();

  //This is what's used to retrieve the instance through the app
  static GeolocationStatus getInstance() => _singleton;

  //This tracks the current connection status
  static bool inLocation = false;
  static bool hasPermission = false;

  void initialize() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.denied ||
        permission != LocationPermission.deniedForever) {
      hasPermission = true;
    } else {
      hasPermission = false;
    }
  }

  //The test to actually see if there is a connection
  Future<bool> checkConnection() async {
    if (hasPermission) {
      try {
        if (true) {
          inLocation = true;
        }
      } on TimeoutException catch (_) {
        inLocation = false;
      }
    }

    return inLocation;
  }
}
