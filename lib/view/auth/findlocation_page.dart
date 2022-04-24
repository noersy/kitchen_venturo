import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchen/constans/key_prefens.dart';
import 'package:kitchen/providers/auth_providers.dart';
import 'package:kitchen/providers/order_providers.dart';
import 'package:kitchen/route/route.dart';
import 'package:kitchen/singletons/shared_preferences.dart';
import 'package:kitchen/theme/spacing.dart';
import 'package:kitchen/theme/text_style.dart';
import 'package:kitchen/tools/check_connectivity.dart';
import 'package:kitchen/tools/firebase_config.dart';
import 'package:provider/provider.dart';

class FindLocationPage extends StatefulWidget {
  const FindLocationPage({Key? key}) : super(key: key);

  @override
  State<FindLocationPage> createState() => _FindLocationPageState();
}

class _FindLocationPageState extends State<FindLocationPage> {
  final Preferences _preferences = Preferences.getInstance();
  final _duration = const Duration(seconds: 3);

  _startTime() async {
    bool isAnyConnection = await checkConnection();
    if (isAnyConnection) {
      _checkPrefens();
    } else {
      Provider.of<OrderProviders>(context, listen: false).setNetworkError(
        true,
        context: context,
        title: 'Koneksi anda terputus',
        then: () => _checkPrefens(),
      );
    }
  }

  void _navigationPage() async => Navigate.toDashboard(context);

  _checkPrefens() async {
    bool _isAlreadyLogin = await _preferences.getBoolValue(KeyPrefens.login);
    if (_isAlreadyLogin) {
      subscribeTopic();
      final id = await _preferences.getIntValue(KeyPrefens.loginID);
      await Provider.of<AuthProviders>(context, listen: false)
          .getUser(context, id: id);

      return Timer(_duration, _navigationPage);
    } else {
      return Navigate.toLogin(context);
    }
  }

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
