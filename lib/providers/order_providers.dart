import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:kitchen/constans/get_header.dart';
import 'package:kitchen/tools/random_string.dart';
import 'package:http/http.dart' as http;
import '../constans/hosts.dart';
import '../models/listhistory.dart';
import '../models/listorder.dart';

class OrderProviders extends ChangeNotifier {
  static Map<String, dynamic> _checkOrder = {};
  static List<Map<String, dynamic>> _orderInProgress = [];
  static List<Order> _orders = [];
  static final List<Menu> _detailMenu = [];
  static List<Order> _histories = [];
  List<Menu> get listDetailMenu => _detailMenu;
  List<Order> get listOrders => _orders;
  List<Order> get listHistorys => _histories;
  Map<String, dynamic> get checkOrder => _checkOrder;

  List<Map<String, dynamic>> get orderProgress => _orderInProgress;
  clear() {
    _checkOrder = {};
    _orderInProgress = [];
    _orders = [];
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
    _checkOrder = {};
    notifyListeners();
  }

  Future<bool> getListOrder() async {
    try {
      final _api = Uri.http(host, "$sub/api/order/all");
      final response = await http.get(
        _api,
        headers: await getHeader(),
      );
      if (response.statusCode == 204 ||
          json.decode(response.body)["status_code"] == 204) {
        _orders = [];
      }
      if (response.statusCode == 200 &&
          json.decode(response.body)["status_code"] == 200) {
        _orders = listOrderFromJson(response.body).data;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> getListHistory() async {
    try {
      final _api = Uri.http(host, "$sub/api/order/all");
      final response = await http.get(
        _api,
        headers: await getHeader(),
      );
      if (response.statusCode == 204 ||
          json.decode(response.body)["status_code"] == 204) {
        _histories = [];
      }
      if (response.statusCode == 200 &&
          json.decode(response.body)["status_code"] == 200) {
        _histories = listOrderFromJson(response.body).data;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
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
      final response = await http.post(
        _api,
        headers: await getHeader(),
      );

      if (response.statusCode == 204 ||
          json.decode(response.body)["status_code"] == 204) {
        _orders = [];
      }
      if (response.statusCode == 200 &&
          json.decode(response.body)["status_code"] == 200) {
        _orders = listOrderFromJson(response.body).data;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<List<Order>?> getOrderLimit(limit, start) async {
    try {
      final response = await http.get(
        Uri.parse("https://$host/api/order/all?limit=$limit&offset=$start"),
        headers: await getHeader(),
      );

      if (response.statusCode == 204) {
        return [];
      }
      if (response.statusCode == 200 &&
          json.decode(response.body)["status_code"] == 200) {
        return listHistoryFromJson(response.body).data;
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
