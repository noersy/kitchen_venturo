import 'package:flutter/material.dart';
import 'package:kitchen/theme/colors.dart';
import 'package:kitchen/theme/spacing.dart';
import 'package:kitchen/theme/text_style.dart';

class BottomSheetDetailMenu extends StatelessWidget {
  final Widget content;
  final double? heightGp;
  final String title;

  const BottomSheetDetailMenu({
    Key? key,
    required this.content,
    required this.title, this.heightGp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      padding: const EdgeInsets.symmetric(vertical: SpaceDims.sp12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: SpaceDims.sp16),
        child: Column(
          children: [
            SizedBox(
              width: 104.0,
              height: 4.0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: ColorSty.grey,
                    borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            const SizedBox(height: SpaceDims.sp16),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Text(title, style: TypoSty.title),
            ),
            SizedBox(height: heightGp ?? 0.0),
            content,
          ],
        ),
      ),
    );
  }
}
