import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:kitchen/tools/random_string.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart' as logging;
import '../constans/hosts.dart';
import '../models/listhistory.dart';
import '../models/listorder.dart';

class OrderProviders extends ChangeNotifier {
  static final _log = logging.Logger('OrderProvider');
  static const headers = {"Content-Type": "application/json", "token": "m_app"};
  // static int _orderInProgress = 0;
  // static int _checkOrder = 0;
  static Map<String, dynamic> _checkOrder = {};
  static List<Map<String, dynamic>> _orderInProgress = [];
  static List<Order> _orders = [];
  static List<Menu> _detailMenu = [];
  static List<Order> _histories = [];
  List<Menu> get listDetailMenu => _detailMenu;
  List<Order> get listOrders => _orders;
  List<Order> get listHistorys => _histories;
  Map<String, dynamic> get checkOrder => _checkOrder;

  List<Map<String, dynamic>> get orderProgress => _orderInProgress;

  clear() {
    _checkOrder = {};
    _orderInProgress = [];
    // _menuList = null;
    // _listVoucher = [];
    // _listDiscount = [];
    // _listPromo = [];
    _orders = [];

    _log.fine("clear all orders");
    notifyListeners();
  }
  addOrder({
    required Map<String, dynamic> data,
    required int jumlahOrder,
  }) async {
    _checkOrder.addAll({
      data["id"]: {
        "id": data["id"],
        "jenis": data["jenis"],
        "image": data["image"],
        "harga": data["harga"],
        "amount": data["amount"],
        "name": data["name"],
        "countOrder": jumlahOrder,
      }
    });
    notifyListeners();
  }

  deleteOrder({required String id}) async {
    _checkOrder.remove(id);
    notifyListeners();
  }

  editOrder({
    required Map<String, dynamic> data,
    required int jumlahOrder,
  }) async {
    _checkOrder.update(
      data["id"],
      (value) => {
        "id": value["id"],
        "jenis": value["jenis"],
        "image": value["image"],
        "harga": value["harga"],
        "amount": value["amount"],
        "name": value["name"],
        "countOrder": jumlahOrder,
      },
    );
    notifyListeners();
  }

  submitOrder(Map<String, dynamic>? voucher) async {
    final _id = getRandomString(5);

    _orderInProgress.add({
      "id": _id,
      "orders": _checkOrder.values.toList(),
      "voucher": voucher ?? {},
    });

    // print(_orderInProgress);
    _checkOrder = {};
    notifyListeners();
  }

  Future<bool> getListOrder() async {
    try {
      final _api = Uri.http(host, "$sub/api/order/all");
      _log.fine("Try to get order in progress");
      final response = await http.get(_api, headers: headers);
      // print('response: ${response.body}');
      if (response.statusCode == 204 ||
          json.decode(response.body)["status_code"] == 204) {
        _log.info("Order is empty");
        _orders = [];
      }
      if (response.statusCode == 200 &&
          json.decode(response.body)["status_code"] == 200) {
        _orders = listOrderFromJson(response.body).data;
        if (_orders.isEmpty) _log.info("Failed get order in progress.");
        _log.fine("Success get order in progress.");
        notifyListeners();
        return true;
      }
      _log.info("Fail to get order in progress");
      _log.info(response.body);
      return false;
    } catch (e, r) {
      _log.warning(e);
      _log.warning(r);
      return false;
    }
  }

  Future<bool> getListHistory() async {
    try {
      final _api = Uri.http(host, "$sub/api/order/all");
      _log.fine("Try to get order in progress");
      final response = await http.get(_api, headers: headers);
      // print('response: ${response.body}');
      if (response.statusCode == 204 ||
          json.decode(response.body)["status_code"] == 204) {
        _log.info("Order is empty");
        _histories = [];
      }
      if (response.statusCode == 200 &&
          json.decode(response.body)["status_code"] == 200) {
        _histories = listOrderFromJson(response.body).data;
        if (_orders.isEmpty) _log.info("Failed get order in progress.");
        _log.fine("Success get order in progress.");
        notifyListeners();
        return true;
      }
      _log.info("Fail to get order in progress");
      _log.info(response.body);
      return false;
    } catch (e, r) {
      _log.warning(e);
      _log.warning(r);
      return false;
    }
  }

  Future<bool> postUpdateStatus(status, idOrder) async {
    try {
      final Map<String, String> _queryParameters = <String, String>{
        'status': '$status',
      };
      final _api =
          Uri.http(host, "api/order/update/status/$idOrder", _queryParameters);

      // print('api: $_api');
      _log.fine("Try to get order in progress");
      final response = await http.post(_api, headers: headers);
      // print('response: ${response.body}');
      if (response.statusCode == 204 ||
          json.decode(response.body)["status_code"] == 204) {
        _log.info("Order is empty");
        _orders = [];
      }
      if (response.statusCode == 200 &&
          json.decode(response.body)["status_code"] == 200) {
        _orders = listOrderFromJson(response.body).data;
        if (_orders.isEmpty) _log.info("Failed get order in progress.");
        _log.fine("Success get order in progress.");
        notifyListeners();
        return true;
      }
      _log.info("Fail to get order in progress");
      _log.info(response.body);
      return false;
    } catch (e, r) {
      _log.warning(e);
      _log.warning(r);
      return false;
    }
  }

  Future<List<Order>?> getHistoryLimit(limit, start) async {
    // final user = UserInstance.getInstance().user;
    // print('user: ${user!.data.idUser}');
    final user = 1;
    if (user == null) return null;

    try {
      _log.fine("Try to get list history of order");
      final response = await http.get(
          // Uri.parse(
          //     "https://$host/api/order/history/${user.data.idUser}?limit=$limit&start=$start"),
          Uri.parse(
              "https://$host/api/order/history/${user}?limit=$limit&start=$start"),
          headers: headers);
      // final response = await http.get(
      //   _api,
      //   headers: headers,
      // );
      // print('response.limit: ${response.body}');
      if (response.statusCode == 204) {
        _log.info("History if empty");
        return [];
      }

      if (response.statusCode == 200 &&
          json.decode(response.body)["status_code"] == 200) {
        _log.fine("Success get list history of order:");
        // print('body sukses:\n${response.body}');
        return listHistoryFromJson(response.body).data;
      }
      _log.info("Fail to get liest history");
      _log.info(response.body);
    } catch (e, r) {
      _log.warning(e);
      _log.warning(r);
    }
    return null;
  }
}
