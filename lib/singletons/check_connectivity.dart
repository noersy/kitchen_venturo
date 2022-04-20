import 'dart:async'; //For StreamController/Stream
import 'dart:io'; //InternetAddress utility

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:kitchen/constans/hosts.dart';
import 'package:kitchen/singletons/user_instance.dart';
import 'package:kitchen/transision/route_transisition.dart';
import 'package:kitchen/view/auth/login_page.dart';
import 'package:kitchen/view/dashboard_page.dart';
import 'package:kitchen/view/offline/offline_page.dart';

class ConnectionStatus {
  //This creates the single instance by calling the `_internal` constructor specified below
  static final ConnectionStatus _singleton = ConnectionStatus._internal();

  ConnectionStatus._internal();

  //This is what's used to retrieve the instance through the app
  static ConnectionStatus getInstance() => _singleton;

  //This tracks the current connection status
  static bool hasConnection = false;
  static int hasLock = 0;

  //This is how we'll allow subscribing to connection changes
  StreamController connectionChangeController = StreamController.broadcast();

  //flutter_connectivity
  static final Connectivity _connectivity = Connectivity();
  static GlobalKey<NavigatorState>? _navigatorKey;

  //Hook into flutter_connectivity's Stream to listen for changes
  //And check the connection status out of the gate
  void initialize(GlobalKey<NavigatorState> navigatorKey) {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
    _navigatorKey = navigatorKey;
    checkConnection();
  }

  Stream get connectionChange => connectionChangeController.stream;

  //A clean up method to close our StreamController
  //   Because this is meant to exist through the entire application life cycle this isn't
  //   really an issue
  void dispose() {
    connectionChangeController.close();
  }

  //flutter_connectivity's listener
  void _connectionChange(ConnectivityResult result) {
    checkConnection();
  }

  static const _lost = "Koneksi anda terputus";
  static const _cant = "Tidak bisa terhubung ke server";
  static String title = 'Koneksi anda terputus';

  //The test to actually see if there is a connection
  Future<bool> checkConnection() async {
    bool previousConnection = hasConnection;

    try {
      final resultHost = await InternetAddress.lookup(
        host,
      );

      final result = await InternetAddress.lookup(
        "google.com",
      );

      if (resultHost.isEmpty && resultHost[0].rawAddress.isEmpty) {
        title = _cant;
      }

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
        title = _lost;
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }

    if (UserInstance.getInstance().user != null) {
      if (!hasConnection &&
          _navigatorKey?.currentState != null &&
          hasLock <= 0) {
        hasLock++;
        _navigatorKey!.currentState!.pushNamedAndRemoveUntil('/dashboard', (_) => false);
        _navigatorKey!.currentState!.pushReplacement(routeTransition(OfflinePage(title: title)));
      } else if (hasConnection &&
          _navigatorKey?.currentState != null &&
          hasLock >= 1) {
        hasLock--;
        _navigatorKey!.currentState!.pushNamedAndRemoveUntil('/dashboard', (_) => false);
        _navigatorKey!.currentState!.pushReplacement(routeTransition(const DashboardPage()));
      }
    } else {
      if (!hasConnection &&
          _navigatorKey?.currentState != null &&
          hasLock <= 0) {
        hasLock++;
        _navigatorKey!.currentState!.pushNamedAndRemoveUntil('/', (_) => false);
        _navigatorKey!.currentState!.pushReplacement(routeTransition(OfflinePage(title: title)));
      } else if (hasConnection &&
          _navigatorKey?.currentState != null &&
          hasLock >= 1) {
        hasLock--;
        _navigatorKey!.currentState!.pushNamedAndRemoveUntil('/', (_) => false);
        _navigatorKey!.currentState!.pushReplacement(routeTransition(const LoginPage()));
      }
    }

    //The connection status changed send out an update to all listeners
    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
    }

    return hasConnection;
  }
}
