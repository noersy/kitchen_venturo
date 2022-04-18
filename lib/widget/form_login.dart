import 'package:flutter/material.dart';
import 'package:kitchen/theme/colors.dart';
import 'package:kitchen/theme/spacing.dart';
import 'package:kitchen/theme/text_style.dart';

class FormLogin extends StatefulWidget {
  final TextEditingController editingController;
  final String title, hint;
  final TextInputType type;

  const FormLogin({
    Key? key,
    required this.editingController,
    required this.title,
    required this.hint,
    required this.type,
  }) : super(key: key);

  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  bool isHide = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: TypoSty.caption),
        Stack(
          alignment: Alignment.centerRight,
          children: [
            TextFormField(
              controller: widget.editingController,
              keyboardType: widget.type,
              obscureText:
                  widget.type == TextInputType.visiblePassword && isHide
                      ? true
                      : false,
              decoration: InputDecoration(
                isDense: true,
                hintText: widget.hint,
                hintStyle: TypoSty.caption3,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: SpaceDims.sp8),
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorSty.primary),
                ),
              ),
            ),
            if (widget.type == TextInputType.visiblePassword)
              GestureDetector(
                onTap: () => setState(() => isHide = !isHide),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    isHide ? Icons.visibility_off : Icons.visibility,
                    color: ColorSty.grey,
                  ),
                ),
              )
          ],
        ),
      ],
    );
  }
}
