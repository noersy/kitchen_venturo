import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kitchen/theme/colors.dart';
import 'package:kitchen/theme/text_style.dart';
import 'package:kitchen/widget/dialog/vp_pin_dialog.dart';
import 'package:local_auth/local_auth.dart';

class VFingerPrintDialog extends StatelessWidget {
  final ValueChanged<bool> onSubmit;

  const VFingerPrintDialog({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  static final localAuth = LocalAuthentication();

  void _chekFingerPrint(context) async {
    bool canCheckBiometrics = await localAuth.canCheckBiometrics;
    // final availableBiometrics = await localAuth.getAvailableBiometrics();
    // print(availableBiometrics);

    if (canCheckBiometrics) {
      bool didAuthenticate = await localAuth.authenticate(
        biometricOnly: true,
        localizedReason: 'Please authenticate to continue',
      );

      // if(didAuthenticate) {
      onSubmit(didAuthenticate);
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.h)),
      child: SizedBox(
        height: 350,
        child: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Column(
            children: [
              Text(
                "Verifikasi Pesanan",
                style: TypoSty.title.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Finger Print",
                style: TypoSty.caption2.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.normal,
                ),
              ),
              GestureDetector(
                onTap: () => _chekFingerPrint(context),
                child: Column(
                  children: [
                    const SizedBox(height: 28),
                    SvgPicture.asset("assert/image/icons/Finger-print.svg"),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 42),
                child: Row(
                  children: [
                    const Expanded(child: Divider(thickness: 3)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text("Atau", style: TypoSty.caption2),
                    ),
                    const Expanded(child: Divider(thickness: 3)),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (_) => VPinDialog(
                            onComplete: (value) {
                              if (value.runtimeType == bool) {
                                onSubmit(value as bool);
                              }
                            },
                          ));
                },
                child: Text(
                  "Verifikasi Menggunakan PIN",
                  style: TypoSty.subtitle.copyWith(color: ColorSty.primary),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
