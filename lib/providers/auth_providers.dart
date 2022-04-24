// ignore_for_file: prefer_adjacent_string_concatenation

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:kitchen/constans/get_header.dart';
import 'package:kitchen/constans/hosts.dart';
import 'package:kitchen/constans/key_prefens.dart';
import 'package:kitchen/models/loginuser.dart';
import 'package:kitchen/models/userdetail.dart';
import 'package:kitchen/providers/order_providers.dart';
import 'package:kitchen/singletons/shared_preferences.dart';
import 'package:kitchen/singletons/user_instance.dart';
import 'package:kitchen/widget/custom_dialog.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class AuthProviders extends ChangeNotifier {
  static LoginUser? _loginUser;
  static UserDetail? _user;
  static final _log = Logger('AuthProvider');

  DUser? user() {
    if (_user != null) return _user!.data;
    return null;
  }

  Future<Map> login(
    BuildContext context,
    String email,
    String? password, {
    bool? isGoogle = false,
    String? nama = "",
  }) async {
    OrderProviders orderProviders =
        Provider.of<OrderProviders>(context, listen: false);

    if (orderProviders.isNetworkError!) {
      return {
        'status': false,
        'message': 'Login gagal',
      };
    }

    try {
      final Uri _api = Uri.http(host, "$sub/api/auth/login");
      final body = <String, dynamic>{
        "email": email,
        "password": password,
        "nama": nama,
        "is_google": isGoogle! ? "is_google" : "",
      };

      _log.fine("Tray to login." + '\n$email' + '\n$password');
      final response = await http.post(
        _api,
        headers: await getHeader(),
        body: json.encode(body),
      );
      var responseBody = jsonDecode(response.body);
      if (response.statusCode == 200 && responseBody["status_code"] == 200) {
        _loginUser = loginUserFromJson(response.body);
        Preferences.getInstance().setIntValue(
          KeyPrefens.loginID,
          _loginUser!.data.user.idUser,
        );
        Preferences.getInstance().setStringValue(
          'token',
          responseBody['data']['token'],
        );
        _user = userDetailFromJson(response.body);
        UserInstance.getInstance().initialize(user: _user);
        // getUser(id: _loginUser!.data.user.idUser);
        notifyListeners();
        if (_loginUser != null) {
          return {
            'status': true,
            'message': 'Login Berhasil',
          };
        } else {
          return {
            'status': true,
            'message': responseBody['errors'] != null
                ? responseBody['errors'][0]
                : responseBody['message'] ?? 'Login gagal',
          };
        }
      }
    } on SocketException {
      orderProviders.setNetworkError(
        true,
        context: context,
        title: 'Terjadi masalah dengan server.',
      );

      return {
        'status': false,
        'message': 'Login gagal',
      };
    } on TimeoutException {
      orderProviders.setNetworkError(
        true,
        context: context,
        title: 'Koneksi time out.',
      );
      return {
        'status': false,
        'message': 'Login gagal',
      };
    } catch (e) {
      orderProviders.setNetworkError(
        true,
        context: context,
        title: 'Terjadi masalah dengan server.',
      );
      return {
        'status': false,
        'message': 'Login gagal',
      };
    }
    return {
      'status': false,
      'message': 'Login gagal',
    };
  }

  Future<bool> getUser(BuildContext context, {id}) async {
    OrderProviders orderProviders =
        Provider.of<OrderProviders>(context, listen: false);

    if (orderProviders.isNetworkError!) {
      return false;
    }

    final user = UserInstance.getInstance().user;
    if (user == null && id == null) return false; //@todo make new exception

    try {
      final _id = id ?? user!.data.idUser;
      final Uri _api = Uri.http(host, "$sub/api/user/detail/$_id");
      final response = await http.get(
        _api,
        headers: await getHeader(),
      );

      if (response.statusCode == 200 &&
          json.decode(response.body)["status_code"] == 200) {
        _user = userDetailFromJson(response.body);
        if (_user == null) _log.info("Failed get data user.");
        if (_user != null) _log.fine("Success get data user.");
        UserInstance.getInstance().initialize(user: _user!);
        notifyListeners();
        return true;
      }
    } on SocketException {
      orderProviders.setNetworkError(
        true,
        context: context,
        title: 'Terjadi masalah dengan server.',
      );
      return false;
    } on TimeoutException {
      orderProviders.setNetworkError(
        true,
        context: context,
        title: 'Koneksi time out.',
      );
      return false;
    } catch (e) {
      orderProviders.setNetworkError(
        true,
        context: context,
        title: 'Terjadi masalah dengan server.',
      );
      return false;
    }
    return false;
  }

  Future<bool> update(BuildContext context, {id, key, value}) async {
    OrderProviders orderProviders =
        Provider.of<OrderProviders>(context, listen: false);

    if (orderProviders.isNetworkError!) {
      return false;
    }

    final user = UserInstance.getInstance().user;
    if (user == null) return false;

    final _id = user.data.idUser;
    final Uri _api = Uri.http(host, "/api/user/update/$_id");
    // print('ker: $key | value: $value');
    try {
      final body = jsonEncode({"$key": "$value"});

      _log.fine("Tray update user profile.");
      final response = await http.post(
        _api,
        headers: await getHeader(),
        body: body,
      );

      var responseBody = json.decode(response.body);
      if (response.statusCode == 200 && responseBody["status_code"] == 200) {
        getUser(context);
        return true;
      } else {
        showSimpleDialog(
          context,
          responseBody['message'] ?? responseBody['errors']?[0] ?? '',
        );
      }
    } on SocketException {
      orderProviders.setNetworkError(
        true,
        context: context,
        title: 'Terjadi masalah dengan server.',
      );
      return false;
    } on TimeoutException {
      orderProviders.setNetworkError(
        true,
        context: context,
        title: 'Koneksi time out.',
      );
      return false;
    } catch (e) {
      orderProviders.setNetworkError(
        true,
        context: context,
        title: 'Terjadi masalah dengan server.',
      );
      return false;
    }
    return false;
  }

  Future<bool> uploadProfileImage(BuildContext context, String base64) async {
    OrderProviders orderProviders =
        Provider.of<OrderProviders>(context, listen: false);

    if (orderProviders.isNetworkError!) {
      return false;
    }

    final user = UserInstance.getInstance().user;
    if (user == null) return false;
    try {
      final Uri _api = Uri.http(
        host,
        "$sub/api/user/profil/${user.data.idUser}",
      );

      final body = {"image": base64};

      _log.fine("Try update profile image.");
      final response = await http.post(
        _api,
        headers: await getHeader(),
        body: jsonEncode(body),
      );

      var responseBody = json.decode(response.body);
      if (response.statusCode == 200 && responseBody["status_code"] == 200) {
        if (_user == null) _log.info("Failed Upload profile image.");
        if (_user != null) _log.fine("Susses Upload profile image.");
        getUser(context);
        return true;
      } else {
        showSimpleDialog(
          context,
          responseBody['message'] ?? responseBody['errors']?[0] ?? '',
        );
      }
    } on SocketException {
      orderProviders.setNetworkError(
        true,
        context: context,
        title: 'Terjadi masalah dengan server.',
      );
      return false;
    } on TimeoutException {
      orderProviders.setNetworkError(
        true,
        context: context,
        title: 'Koneksi time out.',
      );
      return false;
    } catch (e) {
      orderProviders.setNetworkError(
        true,
        context: context,
        title: 'Terjadi masalah dengan server.',
      );
      return false;
    }
    return false;
  }

  Future<bool> uploadKtp(BuildContext context, String base64) async {
    OrderProviders orderProviders =
        Provider.of<OrderProviders>(context, listen: false);

    if (orderProviders.isNetworkError!) {
      return false;
    }

    final user = UserInstance.getInstance().user;
    if (user == null) return false;

    try {
      final Uri _api = Uri.http(host, "$sub/api/user/ktp/${user.data.idUser}");
      final body = {"image": base64};

      final response = await http.post(
        _api,
        headers: await getHeader(),
        body: jsonEncode(body),
      );

      var responseBody = json.decode(response.body);
      if (response.statusCode == 200 && responseBody["status_code"] == 200) {
        getUser(context);
        return true;
      } else {
        showSimpleDialog(
          context,
          responseBody['message'] ?? responseBody['errors']?[0] ?? '',
        );
      }
    } on SocketException {
      orderProviders.setNetworkError(
        true,
        context: context,
        title: 'Terjadi masalah dengan server.',
      );
      return false;
    } on TimeoutException {
      orderProviders.setNetworkError(
        true,
        context: context,
        title: 'Koneksi time out.',
      );
      return false;
    } catch (e) {
      orderProviders.setNetworkError(
        true,
        context: context,
        title: 'Terjadi masalah dengan server.',
      );
      return false;
    }
    return false;
  }
}
