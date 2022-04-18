import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String? text;
  final bool? isBold;
  final Color? color;
  final FontWeight? weight;
  final bool? isNormalHeight;
  final int? maxLines;
  final bool? useMaxline;
  final TextAlign? align;
  final FontStyle style;
  final double? spacing;
  final double? fontSize;
  final bool? isOverflow;
  final double? opacity;

  // ignore: prefer_const_constructors_in_immutables
  CustomText({
    Key? key,
    this.text,
    this.isBold = false,
    this.color = Colors.black87,
    this.isNormalHeight = false,
    this.maxLines,
    this.useMaxline = true,
    this.align = TextAlign.start,
    this.style = FontStyle.normal,
    this.fontSize,
    this.isOverflow = true,
    this.opacity = 1,
    this.weight,
    this.spacing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      style: TextStyle(
        fontFamily: "Montserrat",
        color: color!.withOpacity(opacity ?? 1.0),
        fontSize: fontSize ?? 12,
        fontWeight: isBold! ? FontWeight.bold : weight ?? FontWeight.normal,
        height: 1,
        fontStyle: style,
      ),
      textAlign: align,
      maxLines: useMaxline! ? maxLines ?? 1 : null,
      overflow: isOverflow! ? TextOverflow.ellipsis : null,
    );
  }
}
