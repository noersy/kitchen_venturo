import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kitchen/providers/order_providers.dart';
import 'package:kitchen/route/route.dart';
import 'package:kitchen/theme/colors.dart';
import 'package:kitchen/theme/icons_cs_icons.dart';
import 'package:kitchen/theme/spacing.dart';
import 'package:kitchen/theme/text_style.dart';
import 'package:kitchen/widget/appbar.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skeleton_animation/skeleton_animation.dart';

import '../../models/orderdetail.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  OrderDetail? data;
  bool _isLoading = false;
  getListOrder() async {
    if (mounted) setState(() => _loading = true);
    Provider.of<OrderProviders>(context, listen: false).listOrders.clear();
    await Provider.of<OrderProviders>(context, listen: false).getListOrder();
    if (mounted) setState(() => _loading = false);
  }

  onGoBack(dynamic value) {
    setState(() {
      getListOrder();
    });
  }

  @override
  void initState() {
    getListOrder();
    super.initState();
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool _loading = false;

  Future<void> _onRefresh() async {
    var _duration = const Duration(seconds: 2);

    getListOrder();
    if (mounted) {
      setState(() => _loading = true);
      Timer(_duration, () {
        setState(() => _loading = false);
        _refreshController.refreshCompleted();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CostumeAppBar(
        title: "",
        profileTitle: "Pesanan",
        dense: true,
      ),
      body: SmartRefresher(
        onRefresh: _onRefresh,
        controller: _refreshController,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              right: SpaceDims.sp18,
              left: SpaceDims.sp18,
              top: SpaceDims.sp12,
            ),
            child: AnimatedBuilder(
              animation: OrderProviders(),
              builder: (BuildContext context, Widget? child) {
                final _orderOngoing =
                    Provider.of<OrderProviders>(context).listOrders;
                if (_orderOngoing.isNotEmpty) {
                  return _loading
                      ? const SkeletonOrderMenuCard()
                      : Column(
                          children: [
                            for (final item in _orderOngoing)
                              if (item.status == 0 ||
                                  item.status == 1 ||
                                  item.status == 2)
                                OrderMenuCard(
                                  onPressed: () => Navigate.toDetailOrder(
                                      context,
                                      dataOrders: item,
                                      onGoBack: onGoBack),
                                  date:
                                      item.tanggal.toString().substring(0, 10),
                                  // harga: item["orders"][0]["harga"],
                                  // title: item["orders"][0]["name"],
                                  // urlImage: item["orders"][0]["image"],

                                  harga: '${item.totalBayar}',
                                  kodeStatus: item.status,
                                  title: '${item.nama}',
                                  jumlahMenu: item.menu.length,
                                  urlImage: "assert/image/menu/1637916792.png",
                                ),
                          ],
                        );
                } else {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height - 200,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset("assert/image/bg_findlocation.png"),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              IconsCs.order,
                              size: 120,
                              color: ColorSty.primary,
                            ),
                            const SizedBox(height: SpaceDims.sp22),
                            Text(
                              "Sudah Pesan?\nLacak pesananmu\ndi sini.",
                              textAlign: TextAlign.center,
                              style: TypoSty.title2,
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class OrderMenuCard extends StatelessWidget {
  final String urlImage, title, date, harga;
  final VoidCallback onPressed;
  final jumlahMenu;
  final kodeStatus;
  const OrderMenuCard(
      {Key? key,
      required this.urlImage,
      required this.title,
      required this.date,
      required this.harga,
      required this.onPressed,
      required this.jumlahMenu,
      this.kodeStatus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: ColorSty.white80,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        height: 100,
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: InkWell(
          onTap: onPressed,
          child: Row(
            children: [
              Container(
                width: 90,
                height: 90,
                padding: const EdgeInsets.all(SpaceDims.sp14),
                margin: const EdgeInsets.all(SpaceDims.sp8),
                decoration: BoxDecoration(
                  color: ColorSty.grey60,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Image.asset(urlImage),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: SpaceDims.sp12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: SpaceDims.sp18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  size: 18.0,
                                  color: ColorSty.primary,
                                ),
                                const SizedBox(width: SpaceDims.sp4),
                                if (kodeStatus == 0)
                                  Text(
                                    "Dalam Antrian",
                                    style: TypoSty.mini
                                        .copyWith(color: ColorSty.primary),
                                  ),
                                if (kodeStatus == 1)
                                  Text(
                                    "Sedang Siapkan",
                                    style: TypoSty.mini
                                        .copyWith(color: ColorSty.primary),
                                  ),
                                if (kodeStatus == 2)
                                  Text(
                                    "Bisa Diambil",
                                    style: TypoSty.mini
                                        .copyWith(color: ColorSty.primary),
                                  ),
                              ],
                            ),
                            Text(
                              "20 Menit",
                              style: TypoSty.mini.copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: SpaceDims.sp4),
                      Text(
                        title,
                        style: TypoSty.title.copyWith(fontSize: 20.0),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: SpaceDims.sp2),
                      Row(
                        children: [
                          Text(
                            "Rp $harga",
                            style: TypoSty.mini.copyWith(
                                fontSize: 14.0, color: ColorSty.primary),
                          ),
                          const SizedBox(width: SpaceDims.sp24),
                          Text(
                            "($jumlahMenu Menu)",
                            style: TypoSty.mini.copyWith(
                              fontSize: 12.0,
                              color: ColorSty.grey,
                            ),
                          ),
                        ],
                      ),
                      // const SizedBox(height: SpaceDims.sp12),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SkeletonOrderMenuCard extends StatelessWidget {
  const SkeletonOrderMenuCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 4,
          color: ColorSty.white80,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            height: 100,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  margin: const EdgeInsets.all(SpaceDims.sp8),
                  decoration: BoxDecoration(
                    color: ColorSty.grey60,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Skeleton(),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: SpaceDims.sp12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: SpaceDims.sp18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: const [
                                  SizedBox(
                                    width: 14.0,
                                    child: SkeletonText(height: 14.0),
                                  ),
                                  SizedBox(width: SpaceDims.sp4),
                                  SizedBox(
                                    width: 90.0,
                                    child: SkeletonText(height: 11.0),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 56.0,
                                child: SkeletonText(height: 11.0),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: SpaceDims.sp14),
                        const SkeletonText(height: 26.0),
                        const SizedBox(height: SpaceDims.sp8),
                        Row(
                          children: const [
                            SizedBox(
                              width: 60.0,
                              child: SkeletonText(height: 14.0),
                            ),
                            SizedBox(width: SpaceDims.sp8),
                            SizedBox(
                              width: 40.0,
                              child: Align(
                                alignment: Alignment.center,
                                child: SkeletonText(height: 12.0),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Card(
          elevation: 4,
          color: ColorSty.white80,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            height: 100,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  margin: const EdgeInsets.all(SpaceDims.sp8),
                  decoration: BoxDecoration(
                    color: ColorSty.grey60,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Skeleton(),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: SpaceDims.sp12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: SpaceDims.sp18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: const [
                                  SizedBox(
                                    width: 14.0,
                                    child: SkeletonText(height: 14.0),
                                  ),
                                  SizedBox(width: SpaceDims.sp4),
                                  SizedBox(
                                    width: 90.0,
                                    child: SkeletonText(height: 11.0),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 56.0,
                                child: SkeletonText(height: 11.0),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: SpaceDims.sp14),
                        const SkeletonText(height: 26.0),
                        const SizedBox(height: SpaceDims.sp8),
                        Row(
                          children: const [
                            SizedBox(
                              width: 60.0,
                              child: SkeletonText(height: 14.0),
                            ),
                            SizedBox(width: SpaceDims.sp8),
                            SizedBox(
                              width: 40.0,
                              child: Align(
                                alignment: Alignment.center,
                                child: SkeletonText(height: 12.0),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
