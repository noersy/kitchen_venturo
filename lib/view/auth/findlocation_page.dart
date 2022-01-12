import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchen/route/route.dart';
import 'package:kitchen/theme/spacing.dart';
import 'package:kitchen/theme/text_style.dart';

class FindLocationPage extends StatefulWidget {
  const FindLocationPage({Key? key}) : super(key: key);

  @override
  State<FindLocationPage> createState() => _FindLocationPageState();
}

class _FindLocationPageState extends State<FindLocationPage> {
  _startTime() async {
    var _duration = const Duration(seconds: 3);
    return Timer(_duration, _navigationPage);
  }

  void _navigationPage() async => Navigate.toDashboard(context);

  @override
  void initState() {
    _startTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: () {
      return Scaffold(
        body: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 35.0.w,
                  vertical: 35.0.h,
                ),
                child: Image.asset('assert/image/bg_findlocation.png'),
              ),
              SizedBox(
                height: 380.0.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Mencari Lokasimu ...",
                      textAlign: TextAlign.center,
                      style: TypoSty.title2,
                    ),
                    Image.asset("assert/image/maps_ilustrasion.png"),
                    const SizedBox(height: SpaceDims.sp8),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: SpaceDims.sp16,
                      ),
                      child: Text(
                        "Perumahan Griyashanta Permata N-524, Mojolangu, Kec. Lowokwaru, Kota Malang",
                        textAlign: TextAlign.center,
                        style: TypoSty.title,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
