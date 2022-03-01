import 'package:flutter/material.dart';
import 'package:kitchen/providers/order_providers.dart';
import 'package:kitchen/theme/spacing.dart';
import 'package:kitchen/theme/text_style.dart';
import 'package:provider/provider.dart';

class InfoDiscountDialog extends StatelessWidget {
  const InfoDiscountDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _discount = Provider
        .of<OrderProviders>(context, listen: false)
        .listDiscount;
    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0))
      ),
      child: SizedBox(
        height: 195.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SpaceDims.sp32),
          child: Column(
            children: [
              const SizedBox(height: SpaceDims.sp24),
              Text("Info Discount", style: TypoSty.titlePrimary),
              Column(
                children: [
                  const SizedBox(height: SpaceDims.sp24),
                  for(final item in _discount) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.nama, style: TypoSty.caption),
                        Text("${item.diskon} %", style: TypoSty.captionBold),
                      ],
                    ),
                    const SizedBox(height: SpaceDims.sp4),
                  ],
                ],
              ),
              const SizedBox(height: SpaceDims.sp22),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                  ),
                ),
                child: const SizedBox(
                  width: 90.0,
                  child: Align(alignment: Alignment.center, child: Text("Oke")),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

