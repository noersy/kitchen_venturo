import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kitchen/theme/colors.dart';
import 'package:kitchen/theme/text_style.dart';
import 'package:kitchen/widget/vp_pin_dialog.dart';

class VFingerPrintDialog extends StatelessWidget {
  final BuildContext ctx;  final Map<String, dynamic> voucher;

  const VFingerPrintDialog({Key? key, required this.ctx, required this.voucher}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: () {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.h)),
          child: SizedBox(
            height: 0.45.sh,
            child: Padding(
              padding: EdgeInsets.only(top: 24.w),
              child: Column(
                children: [
                  Text(
                    "Verifikasi Pesanan",
                    style: TypoSty.title.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Finger Print",
                    style: TypoSty.caption2.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 28.h),
                  SvgPicture.asset("assert/image/icons/Finger-print.svg"),
                  SizedBox(height: 20.w),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 42.w),
                    child: Row(
                      children: [
                        const Expanded(child: Divider(thickness: 3)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          child:  Text("Atau", style: TypoSty.caption2),
                        ),
                        const Expanded(child: Divider(thickness: 3)),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      showDialog(context: context, builder: (_)=> VPinDialog(voucher: voucher));
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
    );
  }
}
