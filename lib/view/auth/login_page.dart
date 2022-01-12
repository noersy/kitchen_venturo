import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchen/route/route.dart';
import 'package:kitchen/theme/colors.dart';
import 'package:kitchen/theme/spacing.dart';
import 'package:kitchen/theme/text_style.dart';
import 'package:kitchen/widget/button_login.dart';
import 'package:kitchen/widget/form_login.dart';


class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    print(connectivityResult);
  }

  @override
  Widget build(BuildContext context) {
  final safeTopPadding = MediaQuery.of(context).padding.vertical;
  final height = MediaQuery.of(context).size.height;

  checkConnectivity();

  return ScreenUtilInit(
      builder: () {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                height: height <= 780 ? height+safeTopPadding+20 : height ,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 35.0.w,
                          vertical: 35.0.h,
                      ),
                      child: Image.asset("assert/image/bg_login.png"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 26.0.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(height: 70.0.h),
                          Image.asset("assert/image/javacode_logo.png"),
                          SizedBox(height: 80.0.h),
                           SizedBox(
                            width: 339.0.w,
                            child: Text('Masuk untuk melanjutkan!',
                                style: TypoSty.title,
                            ),
                          ),
                          SizedBox(height: 25.0.h),
                          FormLogin(
                            title: 'Alamat Email',
                            hint: 'Lorem.ipsum@gmail.com',
                            type: TextInputType.emailAddress,
                            editingController: _controllerEmail,
                          ),
                          SizedBox(height: 25.0.h),
                          FormLogin(
                            title: 'Kata Sandi',
                            hint: '****************',
                            type: TextInputType.visiblePassword,
                            editingController: _controllerPassword,
                          ),
                          SizedBox(height: 25.0.h),
                          ButtonLogin(
                            title: 'Masuk',
                            onPressed: ()=> Navigate.toFindLocation(context),
                            bgColors: ColorSty.primary,
                          ),
                          SizedBox(height: 40.0.h),
                          Row(
                            children: [
                              const Expanded(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(color: ColorSty.grey),
                                  child: SizedBox(height: 1),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: SpaceDims.sp8),
                                child: Text("atau", style: TypoSty.caption2),
                              ),
                              const Expanded(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(color: ColorSty.grey),
                                  child: SizedBox(height: 1),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: SpaceDims.sp16.h),
                          ButtonLogin(
                            title: 'Masuk menggunakan',
                            boldTitle: "Google",
                            bgColors: ColorSty.white,
                            icon: "assert/image/icon_google.png",
                            onPressed: () {},
                          ),
                          SizedBox(height: SpaceDims.sp8.h),
                          ButtonLogin(
                            title: 'Masuk menggunakan',
                            boldTitle: "Apple",
                            icon: "assert/image/icon_apple.png",
                            bgColors: ColorSty.black,
                            onPressed: () {},
                          ),
                          SizedBox(height: SpaceDims.sp22.h)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
