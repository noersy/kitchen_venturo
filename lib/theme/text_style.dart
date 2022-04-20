import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchen/theme/colors.dart';

class TypoSty {
  static TextStyle heading = TextStyle(
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w700,
    fontSize: ScreenUtil().setSp(24.0),
  );

  static TextStyle title = TextStyle(
    fontFamily: "Montserrat",
    fontWeight: FontWeight.bold,
    color: ColorSty.black,
    fontSize: ScreenUtil().setSp(14.0),
  );

  static TextStyle titlePrimary = TextStyle(
    fontFamily: "Montserrat",
    fontWeight: FontWeight.bold,
    color: ColorSty.primary,
    fontSize: ScreenUtil().setSp(14.0),
  );

  static TextStyle subtitle = TextStyle(
    fontFamily: "Montserrat",
    fontWeight: FontWeight.bold,
    fontSize: ScreenUtil().setSp(14.0),
  );

  static TextStyle subtitle2 = TextStyle(
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w600,
    fontSize: ScreenUtil().setSp(14.0),
  );

  static TextStyle title2 = TextStyle(
    fontFamily: "Montserrat",
    fontWeight: FontWeight.normal,
    fontSize: ScreenUtil().setSp(18.0),
  );

  static TextStyle caption = TextStyle(
    fontFamily: "Montserrat",
    fontWeight: FontWeight.normal,
    fontSize: ScreenUtil().setSp(14.0),
  );

  static TextStyle captionSemiBold = TextStyle(
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w600,
    fontSize: ScreenUtil().setSp(14.0),
  );

  static TextStyle captionBold = TextStyle(
    fontFamily: "Montserrat",
    fontWeight: FontWeight.bold,
    fontSize: ScreenUtil().setSp(14.0),
  );

  static TextStyle caption2 = TextStyle(
    fontFamily: "Montserrat",
    fontWeight: FontWeight.bold,
    color: Colors.grey,
    fontSize: ScreenUtil().setSp(14.0),
  );

  static TextStyle caption3 = TextStyle(
    fontFamily: "Montserrat",
    color: Colors.grey,
    fontSize: ScreenUtil().setSp(14.0),
  );

  static TextStyle button = TextStyle(
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w600,
    fontSize: ScreenUtil().setSp(12.0),
  );

  static TextStyle button2 = TextStyle(
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w600,
    fontSize: ScreenUtil().setSp(12.0),
  );

  static TextStyle mini = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: ScreenUtil().setSp(10.0),
  );
}
