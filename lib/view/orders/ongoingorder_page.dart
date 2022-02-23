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
  final dataOrder;

  const OngoingOrderPage({Key? key, required this.dataOrder}) : super(key: key);

  @override
  State<OngoingOrderPage> createState() => _OngoingOrderPageState();
}

class _OngoingOrderPageState extends State<OngoingOrderPage> {
  bool _sudahDiTerima = false;

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
        height: _sudahDiTerima ? 330 : 300,
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
                        if (!_sudahDiTerima)
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
                                  onPressed: () {
                                    showDialog(
                                      barrierColor:
                                          ColorSty.grey.withOpacity(0.2),
                                      context: context,
                                      builder: (_) => UpdateStatusDialog(
                                        onPressed: () {
                                          setState(() => _sudahDiTerima = true);
                                          Navigator.pop(context);
                                        },
                                        title: "Update Status",
                                        iconData: Icons.update,
                                        caption:
                                            "Apakah anda yakin akan\nmengubah status Pesan ini",
                                        textButton: "Oke",
                                      ),
                                    );
                                  },
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
                        if (_sudahDiTerima)
                          Padding(
                            padding: const EdgeInsets.only(
                              left: SpaceDims.sp18,
                              right: SpaceDims.sp18,
                              top: SpaceDims.sp12,
                              bottom: SpaceDims.sp8,
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                const Positioned(
                                  width: 90,
                                  top: 3.5,
                                  left: 50,
                                  child: Divider(thickness: 2),
                                ),
                                const Positioned(
                                  width: 90,
                                  top: 3.5,
                                  right: 50,
                                  child: Divider(thickness: 2),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: const [
                                          Icon(
                                            Icons.check_circle,
                                            color: ColorSty.primary,
                                          ),
                                          SizedBox(height: SpaceDims.sp4),
                                          SizedBox(
                                            width: 60,
                                            child: Text(
                                              "Pesanan diterima",
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Expanded(
                                        child: Divider(thickness: 0)),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            barrierColor:
                                                ColorSty.grey.withOpacity(0.2),
                                            context: context,
                                            builder: (_) => UpdateStatusDialog(
                                              onPressed: () {},
                                              title: "Update Status",
                                              iconData: Icons.update,
                                              caption:
                                                  "Apakah anda yakin akan\nmengubah status Pesan ini",
                                              textButton: "Oke",
                                            ),
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                                height: SpaceDims.sp8),
                                            SizedBox(
                                              height: 10,
                                              width: 10,
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100.0),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                                height: SpaceDims.sp6),
                                            const Padding(
                                              padding:
                                                  EdgeInsets.all(SpaceDims.sp2),
                                              child: SizedBox(
                                                width: 60,
                                                child: Text(
                                                  "Silahkan Ambil",
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Expanded(
                                        child: Divider(thickness: 0)),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            barrierColor:
                                                ColorSty.grey.withOpacity(0.2),
                                            context: context,
                                            builder: (_) => UpdateStatusDialog(
                                              onPressed: () {},
                                              title: "Update Status",
                                              iconData: Icons.update,
                                              caption:
                                                  "Apakah anda yakin akan\nmengubah status Pesan ini",
                                              textButton: "Oke",
                                            ),
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                                height: SpaceDims.sp8),
                                            SizedBox(
                                              height: 10,
                                              width: 10,
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100.0),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                                height: SpaceDims.sp6),
                                            const Padding(
                                              padding:
                                                  EdgeInsets.all(SpaceDims.sp2),
                                              child: SizedBox(
                                                width: 80,
                                                child: Text(
                                                  "Pesanan Selesai",
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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

class UpdateStatusDialog extends StatelessWidget {
  final VoidCallback onPressed;
  final String textButton, caption, title;
  final IconData iconData;

  const UpdateStatusDialog({
    Key? key,
    required this.onPressed,
    required this.textButton,
    required this.caption,
    required this.title,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 8.0,
            right: 8.0,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(SpaceDims.sp4),
                primary: ColorSty.white,
                backgroundColor: Colors.redAccent,
                minimumSize: const Size(0, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0),
                ),
              ),
              child: const Icon(Icons.clear),
            ),
          ),
          SizedBox(
            height: 290,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  iconData,
                  size: 110,
                  color: ColorSty.primary,
                ),
                Text(
                  title,
                  style: TypoSty.title.copyWith(fontSize: 23.0),
                ),
                const SizedBox(height: SpaceDims.sp4),
                Text(
                  caption,
                  textAlign: TextAlign.center,
                  style: TypoSty.caption
                      .copyWith(fontSize: 14.0, color: ColorSty.black60),
                ),
                const SizedBox(height: SpaceDims.sp12),
                TextButton(
                  onPressed: onPressed,
                  style: TextButton.styleFrom(
                    primary: ColorSty.white,
                    backgroundColor: ColorSty.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: SizedBox(
                    width: 120.0,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(textButton),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
