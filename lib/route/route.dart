import 'package:flutter/material.dart';
import 'package:kitchen/transision/route_transisition.dart';
import 'package:kitchen/view/auth/findlocation_page.dart';
import 'package:kitchen/view/dashboard_page.dart';
import 'package:kitchen/view/orders/detailmenu_page.dart';
import 'package:kitchen/view/orders/detailvoucher_page.dart';
import 'package:kitchen/view/orders/ongoingorder_page.dart';
import 'package:kitchen/view/orders/ordersdetail_page.dart';
import 'package:kitchen/view/orders/selection_vocher_page.dart';

class Navigate {
  static void toFindLocation(context) => Navigator.of(context).pushReplacement(routeTransition(const FindLocationPage()));
  static void toDashboard(context) => Navigator.of(context).pushReplacement(routeTransition(const DashboardPage()));
  static Future toSelectionVoucherPage(context, {Map<String, dynamic>? initialData}) async => await Navigator.of(context).push(routeTransition(SelectionVoucherPage(initialData: initialData)));
  static Future<bool>? toDetailVoucherPage(context, {required String urlImage, required String title}) async => await Navigator.of(context).push(routeTransition(DetailVoucherPage(urlImage: urlImage, title: title,))) ?? false;
  static Future toDetailMenu(context, {required Map<String, dynamic> data, required int countOrder}) => Navigator.of(context).push(routeTransition(DetailMenu(data:data, countOrder: countOrder)));
  static void toViewOrder(context, {required Map<String, dynamic> dataOrders}) => Navigator.of(context).push(routeTransition( OngoingOrderPage(dataOrder: dataOrders)));
  static void toViewOrderKasir(context, {required Map<String, dynamic> dataOrders, bool? preparing}) => Navigator.of(context).push(routeTransition(OrderDetailPage(dataOrder: dataOrders, preparing: preparing)));
}
