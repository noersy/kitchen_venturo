import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchen/providers/lang_providers.dart';
import 'package:kitchen/providers/order_providers.dart';
import 'package:kitchen/theme/colors.dart';
import 'package:kitchen/view/auth/login_page.dart';
import 'package:kitchen/view/dashboard_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => OrderProviders(),
        ),
        ChangeNotifierProvider(
          create: (_) => LangProviders(),
        ),
      ],
      child: ScreenUtilInit(
        builder: () => MaterialApp(
          title: 'Java Code App',
          debugShowCheckedModeBanner: false,
          initialRoute: "/",
          routes: {"dashboard": (_) => const DashboardPage()},
          theme: ThemeData.light().copyWith(
            colorScheme: ThemeData().colorScheme.copyWith(
                  primary: ColorSty.primary,
                ),
          ),
          home: LoginPage(),
        ),
      ),
    );
  }
}
