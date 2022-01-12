import 'package:flutter/painting.dart';
import 'package:kitchen/theme/colors.dart';

class ShadowsB {
  static List<BoxShadow> boxShadow1 = [
    BoxShadow(
      offset: const Offset(0, -0.9),
      color: ColorSty.grey80.withOpacity(0.05),
      blurRadius: 3,
      spreadRadius: 10,
    ),
  ];

  static List<BoxShadow> boxShadow2 = [
    BoxShadow(
      color: ColorSty.grey80.withOpacity(0.05),
      blurRadius: 3,
      spreadRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];
}
