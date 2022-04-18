import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchen/theme/colors.dart';
import 'package:kitchen/widget/custom_button.dart';
import 'package:kitchen/widget/custom_text.dart';

showSimpleDialog(
  BuildContext context,
  String body, {
  Function? onClose,
  String? title,
  String? lableClose,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              alignment: Alignment.center,
              child: CustomText(
                text: body,
                useMaxline: false,
                align: TextAlign.center,
                fontSize: ScreenUtil().setSp(16.0),
              ),
            ),
            const SizedBox(height: 20),
            Material(
              child: CustomButton(
                label: lableClose ?? 'Oke',
                onTap: () {
                  Navigator.pop(context);
                  if (onClose != null) {
                    onClose();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

showCustomDialog(
  BuildContext context, {
  String? bodyText,
  Function? onClose,
  Function? onYes,
  String? titleText,
  String? labelYes,
  String? labelClose,
  Widget? body,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (titleText != null) const SizedBox(height: 10),
            if (titleText != null)
              CustomText(
                text: titleText,
                useMaxline: false,
                maxLines: 5,
                align: TextAlign.center,
                isOverflow: false,
                fontSize: ScreenUtil().setSp(18.0),
                isBold: true,
              ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: body ??
                      CustomText(
                        text: bodyText ?? 'Lorem Ipsum',
                        useMaxline: false,
                        maxLines: 5,
                        align: TextAlign.center,
                        isOverflow: false,
                        fontSize: ScreenUtil().setSp(18.0),
                      ),
                ),
                // const Icon(
                //   Icons.warning_amber_outlined,
                //   size: 50,
                //   color: ColorSty.primary,
                // ),
                // const SizedBox(width: 10),
                // Expanded(
                //   child: CustomText(
                //     text: 'Apakah Anda yakin ingin membatalkan pesanan ini?',
                //     useMaxline: false,
                //     maxLines: 5,
                //     align: TextAlign.start,
                //     isOverflow: false,
                //     fontSize: 16,
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (labelClose != null)
                  Material(
                    child: CustomButton(
                      label: labelClose,
                      onTap: () => onClose!(),
                      backgroundColor: Colors.white,
                      fontColor: ColorSty.primary,
                    ),
                  ),
                if (labelYes != null)
                  Material(
                    child: CustomButton(
                      label: labelYes,
                      onTap: () => onYes!(),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
