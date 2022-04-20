import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchen/theme/colors.dart';
import 'package:kitchen/theme/spacing.dart';
import 'package:kitchen/theme/text_style.dart';
import 'package:kitchen/widget/orderdone_dialog.dart';
import 'package:pinput/pin_put/pin_put.dart';

class VPinDialog extends StatefulWidget {
  final Map<String, dynamic>? voucher;
  final String? title;
  final ValueChanged<void>? onComplete;

  const VPinDialog(
      {Key? key,
      this.voucher,
      this.title = "Verifikasi Pesanan",
      this.onComplete})
      : super(key: key);

  @override
  State<VPinDialog> createState() => _VPinDialogState();
}

class _VPinDialogState extends State<VPinDialog> {
  final TextEditingController _pinPutController = TextEditingController();

  final FocusNode _pinPutFocusNode = FocusNode();
  bool _isHide = true;

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: ColorSty.primary),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.h)),
      child: SizedBox(
        height: 0.19.sh,
        child: Padding(
          padding: EdgeInsets.only(top: 24.w),
          child: Column(
            children: [
              Text(
                widget.voucher != null
                    ? "Verifikasi Pesanan"
                    : widget.title ?? "",
                style: TypoSty.title.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Masukan kode Pin",
                style: TypoSty.caption2.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 10.w,
                  left: 18.w,
                  right: 18.w,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: PinPut(
                        fieldsCount: 6,
                        focusNode: _pinPutFocusNode,
                        controller: _pinPutController,
                        obscureText: _isHide ? "*" : null,
                        textStyle: TypoSty.button,
                        eachFieldConstraints: const BoxConstraints(
                            minHeight: 30.0, minWidth: 30.0),
                        onSubmit: (_) {
                          Navigator.pop(context);
                          if (widget.onComplete != null) {
                            widget.onComplete!(null);
                          }
                          showDialog(
                            context: context,
                            builder: (_) =>
                                OrderDoneDialog(voucher: widget.voucher),
                          );
                        },
                        separator: Padding(
                          padding: const EdgeInsets.all(SpaceDims.sp4),
                          child: SizedBox(
                            width: 8.w,
                            height: 2,
                            child: const DecoratedBox(
                              decoration: BoxDecoration(
                                color: ColorSty.grey,
                              ),
                            ),
                          ),
                        ),
                        separatorPositions: const [2, 4],
                        submittedFieldDecoration: _pinPutDecoration.copyWith(
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                        selectedFieldDecoration: _pinPutDecoration,
                        followingFieldDecoration: _pinPutDecoration.copyWith(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                            color: ColorSty.primary.withOpacity(.5),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: SpaceDims.sp12),
                      child: GestureDetector(
                        onTap: () => setState(() => _isHide = !_isHide),
                        child: const Icon(Icons.visibility_off,
                            color: ColorSty.grey),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
