import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kitchen/theme/colors.dart';
import 'package:kitchen/theme/icons_cs_icons.dart';
import 'package:kitchen/theme/spacing.dart';
import 'package:kitchen/theme/text_style.dart';
import 'package:kitchen/widget/appbar.dart';
import 'package:kitchen/widget/listmenu_tile.dart';
import 'package:kitchen/widget/listongoing_card.dart';

class OngoingOrderPage extends StatefulWidget {
  final Map<String, dynamic> dataOrder;

  const OngoingOrderPage({Key? key, required this.dataOrder}) : super(key: key);

  @override
  State<OngoingOrderPage> createState() => _OngoingOrderPageState();
}

class _OngoingOrderPageState extends State<OngoingOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSty.white,
      appBar: CostumeAppBar(
        title: '',
        back: true,
        dense: false,
        lineWidth: 190.0,
        profileTitle: "Pesanan " + widget.dataOrder["name"],
      ),
      body: SingleChildScrollView(
        primary: true,
        child: Column(
          children: [
            Column(
              children: [
                if (widget.dataOrder["orders"]
                    .where((e) => e["jenis"] == "makanan")
                    .isNotEmpty)
                  ListOrderOngoing(
                    orders: widget.dataOrder["orders"],
                    title: 'Makanan',
                    type: 'makanan',
                  ),
                if (widget.dataOrder["orders"]
                    .where((e) => e["jenis"] == "minuman")
                    .isNotEmpty)
                  ListOrderOngoing(
                    orders: widget.dataOrder["orders"],
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
        height: 380,
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
                              "Total Pesanan ",
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
                          title: "Diskon 20%",
                          prefix: widget.dataOrder["voucher"]["title"] ??
                              "Rp 4.000",
                          textStylePrefix:
                              const TextStyle(color: Colors.redAccent),
                          iconSvg: SvgPicture.asset(
                              "assert/image/icons/discount-icon.svg",
                              height: 24.0),
                          onPressed: () {},
                        ),
                        Stack(children: [
                          TileListDMenu(
                            dense: true,
                            title: "Pembayaran",
                            prefix: "Pay Leter",
                            icon: IconsCs.coins,
                            onPressed: () {},
                          ),
                        ]),
                        TileListDMenu(
                          dense: true,
                          title: "Total Pembayaran",
                          prefix: "Rp 4.000",
                          textStylePrefix: TypoSty.titlePrimary,
                          onPressed: () {},
                        ),
                        const SizedBox(height: SpaceDims.sp4),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  primary: ColorSty.grey60,
                                  onPrimary: ColorSty.black60,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                                child: const Text("Batalkan"),
                              ),
                            ),
                            const SizedBox(width: SpaceDims.sp24),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                                child: const Text("Terima Pesanan"),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: SpaceDims.sp14,
                            right: SpaceDims.sp14,
                            top: SpaceDims.sp12,
                            bottom: SpaceDims.sp8,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: ColorSty.primary,
                              ),
                              const SizedBox(width: SpaceDims.sp8),
                              const Expanded(child: Divider(thickness: 2)),
                              const SizedBox(width: SpaceDims.sp8),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 10,
                                  width: 10,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: ColorSty.grey,
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: SpaceDims.sp8),
                              const Expanded(child: Divider(thickness: 2)),
                              const SizedBox(width: SpaceDims.sp8),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 10,
                                  width: 10,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: ColorSty.grey,
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: SpaceDims.sp8),
                            ],
                          ),
                        ),
                        Row(
                          children: const [
                            SizedBox(
                              width: 80,
                              child: Text("Pesanan diterima"),
                            ),
                            Expanded(child: Divider(color: Colors.transparent)),
                            SizedBox(
                              width: 80,
                              child: Text(
                                "Silahkan Ambil",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.transparent)),
                            SizedBox(
                              width: 80,
                              child: Text(
                                "Pesanan Selesai",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
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
