import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  //This creates the single instance by calling the `_internal` constructor specified below
  static final Preferences _singleton = Preferences._internal();

  Preferences._internal();

  //This is what's used to retrieve the instance through the app
  static Preferences getInstance() => _singleton;

  static SharedPreferences? _prefs;

  initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> setBoolValue(String key, bool value) async {
    try {
      if (_prefs == null) throw Exception("prefs not initialize yet.");

      return await _prefs!.setBool(key, value);
    } catch (e) {
      return false;
    }
  }

  Future<bool> setIntValue(String key, int value) async {
    try {
      if (_prefs == null) throw Exception("prefs not initialize yet.");

      return await _prefs!.setInt(key, value);
    } catch (e) {
      return false;
    }
  }

  Future<bool> setStringValue(String key, String value) async {
    try {
      if (_prefs == null) throw Exception("prefs not initialize yet.");

      return await _prefs!.setString(key, value);
    } catch (e) {
      return false;
    }
  }

  Future<bool> getBoolValue(String key) async {
    try {
      if (_prefs == null) await initialize();
      if (_prefs == null) throw Exception("prefs not initialize yet.");

      return _prefs!.getBool(key) ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<int> getIntValue(String key) async {
    try {
      if (_prefs == null) await initialize();
      if (_prefs == null) throw Exception("prefs not initialize yet.");

      return _prefs!.getInt(key) ?? -1;
    } catch (e) {
      return -1;
    }
  }

  Future<String?> getStringValue(String key) async {
    try {
      if (_prefs == null) await initialize();
      if (_prefs == null) throw Exception("prefs not initialize yet.");

      return _prefs!.getString(key);
    } catch (e) {
      return null;
    }
  }

  void clear() async {
    try {
      if (_prefs == null) throw Exception("prefs not initialize yet.");

      _prefs!.clear();
      return;
    } catch (e) {
      return;
    }
  }
}
