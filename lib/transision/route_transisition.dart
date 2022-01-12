import 'package:flutter/material.dart';

// slide leftIn and rightOut Transisition
// how to use :
//Navigator.of(widget.ctx).push(
//       createRoute(target),
//     )
Route routeTransition(Widget target) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => target,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = const Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.easeInOutQuart;

      var tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
