// ignore_for_file: prefer_adjacent_string_concatenation

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:kitchen/constans/hosts.dart';
import 'package:kitchen/constans/key_prefens.dart';
import 'package:kitchen/models/loginuser.dart';
import 'package:kitchen/models/userdetail.dart';
import 'package:kitchen/singletons/shared_preferences.dart';
import 'package:kitchen/singletons/user_instance.dart';
import 'package:logging/logging.dart';

class AuthProviders extends ChangeNotifier {
  static LoginUser? _loginUser;
  static UserDetail? _user;
  static const _headers = {
    "Content-Type": "application/json",
    "token": "m_app"
  };
  static final _log = Logger('AuthProvider');

  DUser? user() {
    if (_user != null) return _user!.data;
    return null;
  }

  Future<bool> login(
    String email,
    String? password, {
    bool? isGoogle = false,
    String? nama = "",
  }) async {
    final Uri _api = Uri.http(host, "$sub/api/auth/login");
    try {
      final body = <String, dynamic>{
        "email": email,
        "password": password,
        "nama": nama,
        "is_google": isGoogle! ? "is_google" : "",
      };

      _log.fine("Tray to login." + '\n$email' + '\n$password');
      final response = await http.post(
        _api,
        headers: _headers,
        body: json.encode(body),
      );
      if (response.statusCode == 200 &&
          json.decode(response.body)["status_code"] == 200) {
        _loginUser = loginUserFromJson(response.body);
        if (_loginUser == null) _log.info("Login failed");
        if (_loginUser != null) _log.fine("Login successes"); 
        Preferences.getInstance()
            .setIntValue(KeyPrefens.loginID, _loginUser!.data.user.idUser);
        getUser(id: _loginUser!.data.user.idUser);
        notifyListeners();
        if (_loginUser != null) {
          return true;
        } else {
          return false;
        }
      }
    } catch (e, r) {
      _log.warning(e);
      _log.warning(r);
    }
    return false;
  }

  Future<bool> getUser({id}) async {
    final user = UserInstance.getInstance().user;
    if (user == null && id == null) return false; //@todo make new exception

    final _id = id ?? user!.data.idUser;
    final Uri _api = Uri.http(host, "$sub/api/user/detail/$_id");

    try {
      _log.fine("Tray to get data user.");
      final response = await http.get(_api, headers: _headers);

      if (response.statusCode == 200 &&
          json.decode(response.body)["status_code"] == 200) {
        _user = userDetailFromJson(response.body);
        if (_user == null) _log.info("Failed get data user.");
        if (_user != null) _log.fine("Success get data user.");
        UserInstance.getInstance().initialize(user: _user!);
        notifyListeners();
        return true;
      }
    } catch (e, r) {
      _log.warning(e);
      _log.warning(r);
    }

    return false;
  }

  Future<bool> update({id, key, value}) async {
    final user = UserInstance.getInstance().user;
    if (user == null) return false;

    final _id = user.data.idUser;
    final Uri _api = Uri.http(host, "/api/user/update/$_id");
    // print('ker: $key | value: $value');
    try {
      final body = jsonEncode({"$key": "$value"});

      _log.fine("Tray update user profile.");
      final response = await http.post(_api, headers: _headers, body: body);
      // print('response edit nama ${response.body}');
      if (response.statusCode == 200 &&
          json.decode(response.body)["status_code"] == 200) {
        _log.fine("Success update $key user.");
        getUser();
        return true;
      }
    } catch (e, r) {
      _log.warning(e);
      _log.warning(r);
    }
    return false;
  }

  Future<bool> uploadProfileImage(String base64) async {
    final user = UserInstance.getInstance().user;

    if (user == null) return false;

    final Uri _api = Uri.http(
      host,
      "$sub/api/user/profil/${user.data.idUser}",
    );

    try {
      final body = {"image": base64};

      _log.fine("Try update profile image.");
      final response = await http.post(
        _api,
        headers: _headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 &&
          json.decode(response.body)["status_code"] == 200) {
        if (_user == null) _log.info("Failed Upload profile image.");
        if (_user != null) _log.fine("Susses Upload profile image.");
        getUser();
        return true;
      }
    } catch (e) {
      // return false;
    }
    return false;
  }

  Future<bool> uploadKtp(String base64) async {
    final user = UserInstance.getInstance().user;

    if (user == null) return false;
    final Uri _api = Uri.http(host, "$sub/api/user/ktp/${user.data.idUser}");

    try {
      final body = {"image": base64};

      _log.fine("Tray upload ktp");
      final response = await http.post(
        _api,
        headers: _headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 &&
          json.decode(response.body)["status_code"] == 200) {
        _log.fine("Successes upload ktp");
        getUser();
        return true;
      }
    } catch (e, r) {
      _log.warning(e);
      _log.warning(r);
    }
    return false;
  }
}
