import 'package:flutter/material.dart';
import 'package:kitchen/transision/route_transisition.dart';
import 'package:kitchen/view/auth/findlocation_page.dart';
import 'package:kitchen/view/auth/login_page.dart';
import 'package:kitchen/view/dashboard_page.dart';
import 'package:kitchen/view/offline/offline_page.dart';
import 'package:kitchen/view/orders/detailvoucher_page.dart';
import 'package:kitchen/view/orders/ongoingorder_page.dart';
import 'package:kitchen/view/orders/ordersdetail_page.dart';
import 'package:kitchen/view/orders/selection_vocher_page.dart';

class Navigate {
  static void toFindLocation(context) => Navigator.of(context)
      .pushReplacement(routeTransition(const FindLocationPage()));
  static void toDashboard(context) => Navigator.of(context)
      .pushReplacement(routeTransition(const DashboardPage()));
  static void toLogin(context) =>
      Navigator.of(context).pushReplacement(routeTransition(const LoginPage()));
  static Future toSelectionVoucherPage(context,
          {Map<String, dynamic>? initialData}) async =>
      await Navigator.of(context).push(
          routeTransition(SelectionVoucherPage(initialData: initialData)));
  static Future<bool>? toDetailVoucherPage(context,
          {required String urlImage, required String title}) async =>
      await Navigator.of(context).push(routeTransition(DetailVoucherPage(
        urlImage: urlImage,
        title: title,
      ))) ??
      false;
  // static Future toDetailMenu(context,
  //         {required Map<String, dynamic> data, required int countOrder}) =>
  //     Navigator.of(context).push(
  //         routeTransition(DetailMenu(data: data, countOrder: countOrder)));
  static void toDetailOrder(context, {required dataOrders, onGoBack}) =>
      Navigator.of(context)
          .push(routeTransition(DetailOrder(dataOrder: dataOrders)))
          .then((onGoBack));
  static void toViewOrderKasir(context,
          {required Map<String, dynamic> dataOrders, bool? preparing}) =>
      Navigator.of(context).push(routeTransition(
          OrderDetailPage(dataOrder: dataOrders, preparing: preparing)));
  static void toOfflinePage(context, String title, {Function? then}) =>
      Navigator.of(context)
          .push(routeTransition(OfflinePage(
        title: title,
      )))
          .whenComplete(() {
        if (then != null) then();
      });

  nextPage(BuildContext context, dynamic page, {Function? then}) {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    )
        .whenComplete(() {
      if (then != null) then();
    });
  }

  nextPageNoAnimation(BuildContext context, dynamic page, {Function? then}) {
    Navigator.of(context)
        .push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionDuration: const Duration(seconds: 0),
      ),
    )
        .whenComplete(() {
      if (then != null) then();
    });
  }

  nextPageReplacement(BuildContext context, dynamic page) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  backScreen(BuildContext context) {
    Navigator.of(context).pop();
  }

  nextPageRemove(
    BuildContext context,
    dynamic page, {
    bool isforce = false,
  }) {
    if (isforce || Navigator.canPop(context)) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => page,
        ),
        (route) => false,
      );
    } else {
      nextPage(context, page);
    }
  }
}
