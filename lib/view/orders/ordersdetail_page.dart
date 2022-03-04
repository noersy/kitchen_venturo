import 'package:flutter/material.dart';
import 'package:kitchen/theme/colors.dart';
import 'package:kitchen/theme/icons_cs_icons.dart';
import 'package:kitchen/theme/spacing.dart';
import 'package:kitchen/theme/text_style.dart';
import 'package:kitchen/widget/appbar.dart';
import 'package:kitchen/widget/listmenu_tile.dart';
import 'package:kitchen/widget/listongoing_card.dart';

class OrderDetailPage extends StatelessWidget {
  final Map<String, dynamic> dataOrder;
  final bool? preparing;

  const OrderDetailPage({
    Key? key,
    required this.dataOrder,
    this.preparing = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSty.white,
      appBar: const CostumeAppBar(
        back: true,
        title: "Pesanan",
        icon: Icon(IconsCs.pesanan, size: 28.0, color: ColorSty.primary),
      ),
      body: SingleChildScrollView(
        primary: true,
        child: Column(
          children: [
            Column(
              children: [
                if (dataOrder["orders"]
                    .where((e) => e["jenis"] == "makanan")
                    .isNotEmpty)
                  ListOrderOngoing(
                    orders: dataOrder["orders"],
                    title: 'Makanan',
                    type: 'makanan',
                  ),
                if (dataOrder["orders"]
                    .where((e) => e["jenis"] == "minuman")
                    .isNotEmpty)
                  ListOrderOngoing(
                    orders: dataOrder["orders"],
                    title: 'Minuman',
                    type: 'minuman',
                  ),
              ],
            ),
            const SizedBox(height: SpaceDims.sp24),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 310,
        decoration: const BoxDecoration(
          color: ColorSty.grey80,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: SpaceDims.sp24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: SpaceDims.sp24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Total Pesanan",
                              style: TypoSty.captionSemiBold,
                            ),
                            Text("(3 Menu) :", style: TypoSty.caption),
                          ],
                        ),
                        Text(
                          "Rp 30.000",
                          style: TypoSty.subtitle.copyWith(
                            color: ColorSty.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: SpaceDims.sp14),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SpaceDims.sp24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TileListDMenu(
                          dense: true,
                          prefixIcon: true,
                          title: "Voucher",
                          prefixCostume: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (dataOrder["voucher"].isNotEmpty) ...[
                                Text(dataOrder["voucher"]["harga"],
                                    style: TypoSty.captionSemiBold.copyWith(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.red),
                                    textAlign: TextAlign.right),
                                Text(dataOrder["voucher"]["title"],
                                    style: TypoSty.mini,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right)
                              ] else ...[
                                Text("Rp 0",
                                    style: TypoSty.captionSemiBold.copyWith(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.red),
                                    textAlign: TextAlign.right),
                                Text("None",
                                    style: TypoSty.mini,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right)
                              ],
                            ],
                          ),
                          icon: IconsCs.voucher,
                          onPressed: () {},
                        ),
                        Stack(children: [
                          TileListDMenu(
                            dense: true,
                            title: "Pembayaran",
                            prefix: "Pay Later",
                            icon: IconsCs.coins,
                            onPressed: () {},
                          ),
                        ]),
                        TileListDMenu(
                          dense: true,
                          title: "Total Pembayaran",
                          prefix: "Rp 4.000",
                          textStylePrefix: TypoSty.titlePrimary,
                          icon: Icons.wine_bar,
                          onPressed: () {},
                        ),
                        const SizedBox(height: SpaceDims.sp18),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(SpaceDims.sp12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              )),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                preparing ?? false
                                    ? "Pesanan Selesai"
                                    : "Terima Pesanan",
                                style: TypoSty.button,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
