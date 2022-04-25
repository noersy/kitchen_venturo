import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:kitchen/constans/get_header.dart';
import 'package:kitchen/route/route.dart';
import 'package:kitchen/tools/random_string.dart';
import 'package:http/http.dart' as http;
import 'package:kitchen/widget/custom_dialog.dart';
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
  static bool? _isNetworkError = false;
  bool? get isNetworkError => _isNetworkError;

  List<Map<String, dynamic>> get orderProgress => _orderInProgress;
  clear() {
    _checkOrder = {};
    _orderInProgress = [];
    _orders = [];
    notifyListeners();
  }

  setNetworkError(
    bool status, {
    BuildContext? context,
    String? title,
    Function? then,
  }) {
    if (!_isNetworkError! && status) {
      _isNetworkError = status;
      notifyListeners();
      if (context != null) {
        notifyListeners();
        Navigate.toOfflinePage(
          context,
          title!,
          then: () {
            if (then != null) {
              then();
            }
          },
        );
      }
    } else {
      _isNetworkError = status;
    }
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

  Future<bool> getListOrder(BuildContext context) async {
    if (_isNetworkError!) return false;
    try {
      final _api = Uri.http(host, "$sub/api/order/all");
      final response = await http.post(
        _api,
        headers: await getHeader(),
      );

      var responseBody = json.decode(response.body);
      if (response.statusCode == 200 && responseBody["status_code"] == 200) {
        await setNetworkError(false);
        _orders = listOrderFromJson(response.body).data;
        notifyListeners();
        return true;
      } else {
        _orders = [];
      }
      return false;
    } on SocketException {
      setNetworkError(
        true,
        context: context,
        title: 'Terjadi masalah dengan server.',
      );
      return false;
    } on TimeoutException {
      setNetworkError(
        true,
        context: context,
        title: 'Koneksi time out.',
      );
      return false;
    }
    // catch (e) {
    //   setNetworkError(
    //     true,
    //     context: context,
    //     title: 'Terjadi masalah dengan server.',
    //   );
    //   return false;
    // }
  }

  Future<bool> getListHistory(BuildContext context) async {
    if (_isNetworkError!) return false;
    try {
      final _api = Uri.http(host, "$sub/api/order/all");
      final response = await http
          .get(_api, headers: await getHeader())
          .timeout(const Duration(seconds: 4));

      var responseBody = json.decode(response.body);
      if (response.statusCode == 200 && responseBody["status_code"] == 200) {
        await setNetworkError(false);
        _histories = listOrderFromJson(response.body).data;
        notifyListeners();
        return true;
      } else {
        _histories = [];
      }
      return false;
    } on SocketException {
      setNetworkError(
        true,
        context: context,
        title: 'Terjadi masalah dengan server.',
      );
      return false;
    } on TimeoutException {
      setNetworkError(
        true,
        context: context,
        title: 'Koneksi time out.',
      );
      return false;
    }
    // catch (e) {
    //   setNetworkError(
    //     true,
    //     context: context,
    //     title: 'Terjadi masalah dengan server.',
    //   );
    //   return false;
    // }
  }

  Future<bool> postUpdateStatus(BuildContext context, status, idOrder) async {
    if (_isNetworkError!) return false;
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

      var responseBody = json.decode(response.body);
      if (response.statusCode == 200 && responseBody["status_code"] == 200) {
        await setNetworkError(false);
        _orders = listOrderFromJson(response.body).data;
        notifyListeners();
        return true;
      } else {
        _orders = [];
        showSimpleDialog(
          context,
          responseBody['message'] ?? responseBody['errors']?[0] ?? '',
        );
      }
      return false;
    } on SocketException {
      setNetworkError(
        true,
        context: context,
        title: 'Terjadi masalah dengan server.',
      );
      return false;
    } on TimeoutException {
      setNetworkError(
        true,
        context: context,
        title: 'Koneksi time out.',
      );
      return false;
    }
    // catch (e) {
    //   setNetworkError(
    //     true,
    //     context: context,
    //     title: 'Terjadi masalah dengan server.',
    //   );
    //   return false;
    // }
  }

  Future<ListOrder?> getOrderLimit(
    BuildContext context,
    limit,
    start,
    String startDate,
    String endDate,
  ) async {
    if (_isNetworkError!) return null;

    try {
      Map<String, dynamic>? request = {
        "limit": limit,
        "offset": start,
        "tanggal": {"startDate": startDate, "endDate": endDate},
      };

      final response = await http
          .post(
            Uri.http(host, '$sub/api/order/all'),
            body: jsonEncode(request),
            headers: await getHeader(),
          )
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200 &&
          json.decode(response.body)["status_code"] == 200) {
        await setNetworkError(false);
        ListOrder listOrder = listOrderFromJson(response.body);
        return listOrder;
      }
      return null;
    } on SocketException {
      setNetworkError(
        true,
        context: context,
        title: 'Terjadi masalah dengan server.',
      );
      return null;
    } on TimeoutException {
      setNetworkError(
        true,
        context: context,
        title: 'Koneksi time out.',
      );
      return null;
    }
    // catch (e) {
    //   setNetworkError(
    //     true,
    //     context: context,
    //     title: 'Terjadi masalah dengan server.',
    //   );
    //   return null;
    // }
  }
}
