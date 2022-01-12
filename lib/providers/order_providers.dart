import 'package:flutter/cupertino.dart';
import 'package:kitchen/tools/random_string.dart';

class OrderProviders extends ChangeNotifier {
  // static int _orderInProgress = 0;
  // static int _checkOrder = 0;
  static Map<String, dynamic> _checkOrder = {};
  static List<Map<String, dynamic>> _orderInProgress = [];

  Map<String, dynamic> get checkOrder => _checkOrder;

  List<Map<String, dynamic>> get orderProgress => _orderInProgress;

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
}
