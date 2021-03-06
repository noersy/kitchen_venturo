import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kitchen/constans/tools.dart';
import 'package:kitchen/theme/colors.dart';
import 'package:kitchen/theme/icons_cs_icons.dart';
import 'package:kitchen/theme/spacing.dart';
import 'package:kitchen/theme/text_style.dart';
import 'package:kitchen/widget/appbar.dart';
import 'package:kitchen/widget/listmenu_tile.dart';
import 'package:kitchen/widget/listongoing_card.dart';
import 'package:provider/provider.dart';

import '../../models/listorder.dart';
import '../../providers/order_providers.dart';

class DetailOrder extends StatefulWidget {
  final Order dataOrder;

  const DetailOrder({Key? key, required this.dataOrder}) : super(key: key);

  @override
  State<DetailOrder> createState() => _DetailOrderState();
}

class _DetailOrderState extends State<DetailOrder> {
  bool _loading = false;
  List<Menu> lDetailMenu = [];
  getListDetailMenu() async {
    if (mounted) setState(() => _loading = true);
    lDetailMenu =
        Provider.of<OrderProviders>(context, listen: false).listDetailMenu;
    lDetailMenu.clear();
    for (var item in widget.dataOrder.menu) {
      lDetailMenu.add(item);
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void initState() {
    if (widget.dataOrder.status == 1) {
      setState(() {
        _sudahDiTerima = 'sudahDiterima';
      });
    }
    if (widget.dataOrder.status == 2) {
      setState(() {
        _sudahDiTerima = 'silahkan diambil';
      });
    }
    getListDetailMenu();
    super.initState();
  }

  String _sudahDiTerima = 'belum';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSty.white,
      appBar: CostumeAppBar(
        title: '',
        back: true,
        dense: false,
        lineWidth: 190.0,
        profileTitle: "Pesanan " + widget.dataOrder.nama,
      ),
      body: SingleChildScrollView(
        primary: true,
        child: Column(
          children: [
            Column(
              children: [
                ListOrderOngoing(
                  orders: lDetailMenu,
                  title: 'Makanan',
                  type: 'makanan',
                ),
              ],
            ),
            const SizedBox(height: SpaceDims.sp24),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: ColorSty.grey80,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: SpaceDims.sp24),
            Column(
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
                          Text("(${widget.dataOrder.menu.length} Menu) :",
                              style: TypoSty.caption),
                        ],
                      ),
                      Text(
                        "Rp ${oCcy.format(widget.dataOrder.totalBayar)}",
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
                        textStylePrefix:
                            const TextStyle(color: Colors.redAccent),
                        iconSvg: SvgPicture.asset(
                            "assert/image/icons/discount-icon.svg",
                            height: 24.0),
                        onPressed: () {},
                      ),
                      TileListDMenu(
                        dense: true,
                        title: "Pembayaran",
                        prefix: "Pay Leter",
                        icon: IconsCs.coins,
                        onPressed: () {},
                      ),
                      TileListDMenu(
                        dense: true,
                        title: "Total Pembayaran",
                        prefix:
                            "Rp ${oCcy.format(widget.dataOrder.totalBayar)}",
                        textStylePrefix: TypoSty.titlePrimary,
                        onPressed: () {},
                      ),
                      const SizedBox(height: SpaceDims.sp4),
                      if (_sudahDiTerima == 'belum')
                        buttonTerimaBatalPesanan(context),
                      if (_sudahDiTerima != 'belum') statusBar(context),
                      const SizedBox(height: SpaceDims.sp20),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonTerimaBatalPesanan(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                barrierColor: ColorSty.grey.withOpacity(0.2),
                context: context,
                builder: (_) => UpdateStatusDialog(
                  onPressed: () {
                    Provider.of<OrderProviders>(context, listen: false)
                        .postUpdateStatus(context, 4, widget.dataOrder.idOrder)
                        .then((value) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });
                  },
                  title: "Batal Order",
                  iconData: Icons.remove_circle_outline_rounded,
                  caption:
                      "Apakah anda yakin akan\nmembatalkan status Pesan ini",
                  textButton: "Oke",
                ),
              );
            },
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
                barrierColor: ColorSty.grey.withOpacity(0.2),
                context: context,
                builder: (_) => UpdateStatusDialog(
                  onPressed: () {
                    Provider.of<OrderProviders>(context, listen: false)
                        .postUpdateStatus(context, 1, widget.dataOrder.idOrder)
                        .then((value) =>
                            {setState(() => _sudahDiTerima = 'sudahDiterima')});
                    Navigator.pop(context);
                  },
                  title: "Update Status",
                  iconData: Icons.update,
                  caption: "Apakah anda yakin akan\nmengubah status Pesan ini",
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
    );
  }

  Widget statusBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: SpaceDims.sp18,
        right: SpaceDims.sp18,
        // top: SpaceDims.sp12,
        // bottom: SpaceDims.sp8,
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
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(child: SizedBox()),
              buttonBottomStatusBar(
                  context, 'Silahkan diambil', 2, widget.dataOrder.idOrder),
              const Expanded(child: SizedBox()),
              buttonBottomStatusBar(
                  context, 'Pesanan selesai', 3, widget.dataOrder.idOrder),
            ],
          ),
        ],
      ),
    );
  }

  Expanded buttonBottomStatusBar(BuildContext context, text, status, idorder) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          showDialog(
            barrierColor: ColorSty.grey.withOpacity(0.2),
            context: context,
            builder: (_) => UpdateStatusDialog(
              onPressed: () {
                Provider.of<OrderProviders>(context, listen: false)
                    .postUpdateStatus(context, status, idorder)
                    .then(
                        (value) => {setState(() => _sudahDiTerima = '$text')});
                Navigator.pop(context);
              },
              title: "Update Status",
              iconData: Icons.update,
              caption: "Apakah anda yakin akan\nmengubah status Pesan ini",
              textButton: "Oke",
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (_sudahDiTerima != text && _sudahDiTerima != 'pesanan selesai')
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                child: SizedBox(
                  height: 10,
                  width: 10,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                  ),
                ),
              ),
            if (_sudahDiTerima == text || _sudahDiTerima == 'pesanan selesai')
              const Icon(
                Icons.check_circle,
                color: ColorSty.primary,
              ),
            const SizedBox(height: SpaceDims.sp4),
            Padding(
              padding: const EdgeInsets.all(SpaceDims.sp2),
              child: SizedBox(
                width: 60,
                child: Text(
                  "$text",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 10),
                ),
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
                  style: TypoSty.title.copyWith(fontSize: 20.0),
                ),
                const SizedBox(height: SpaceDims.sp4),
                Text(
                  caption,
                  textAlign: TextAlign.center,
                  style: TypoSty.caption
                      .copyWith(fontSize: 12.0, color: ColorSty.black60),
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
