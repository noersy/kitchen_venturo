import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:kitchen/models/listhistory.dart';
import 'package:kitchen/theme/colors.dart';
import 'package:kitchen/theme/icons_cs_icons.dart';
import 'package:kitchen/theme/spacing.dart';
import 'package:kitchen/theme/text_style.dart';
import 'package:kitchen/tools/check_connectivity.dart';
import 'package:kitchen/widget/appbar.dart';
import 'package:loadmore/loadmore.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_animation/skeleton_animation.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../constans/tools.dart';
import '../../models/listorder.dart';
import '../../providers/order_providers.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  static List<Order> _data = [];
  static List<Order> _orders = [];
  static final DateTime _dateNow = DateTime.now();
  static DateTime? _dateStart = DateTime(_dateNow.year, _dateNow.month - 1);
  static DateTime? _dateEnd = _dateNow;
  final String _dateRange =
      dateFormat.format(_dateStart!) + " - " + dateFormat.format(_dateEnd!);
  int statusCode = 3;
  String _dropdownValue = 'Semua Status';
  final List<String> _item = ["Semua Status", "Selesai", "Dibatalkan"];
  bool _loading = true;
  bool isFinisfLoadmore = false;
  bool _loadingLoadMore = false;
  int totalHistory = 0;
  int totalPrice = 0;

  Future<void> _onRefresh() async {
    if (mounted) {
      _loadStart();
    }
  }

  checkConnectivity() async {
    bool isAnyConnection = await checkConnection();
    if (isAnyConnection) {
      _loadStart();
    } else {
      Provider.of<OrderProviders>(context, listen: false).setNetworkError(
        true,
        context: context,
        title: 'Koneksi anda terputus',
        then: () => checkConnectivity(),
      );
    }
  }

  @override
  void initState() {
    checkConnectivity();
    super.initState();
  }

  void _pickDateRange() async {
    final value = await showDialog(
      barrierColor: ColorSty.grey.withOpacity(0.2),
      context: context,
      builder: (_) => const DateRangePickerDialog(),
    );

    if (value != null) {
      final val = (value as PickerDateRange);

      _dateStart = val.startDate;
      _dateEnd = val.endDate;
      _data = Provider.of<OrderProviders>(context, listen: false)
          .listHistorys
          .where((element) =>
              (element.tglDatetime.compareTo(_dateStart!) >= 0 &&
                  element.tglDatetime.compareTo(_dateEnd!) <= 0))
          .toList();
    }
  }

  Future<bool> _loadMore() async {
    if (!_loadingLoadMore) {
      if (_data.length < totalHistory) {
        await getMoredata();
      } else {
        LoadMoreStatus.nomore;
        if (mounted) {
          setState(() {
            isFinisfLoadmore = true;
          });
        }
      }
    }
    return true;
  }

  getMoredata() async {
    if (mounted) {
      setState(() => _loadingLoadMore = true);
      ListHistory? dataOrder =
          await Provider.of<OrderProviders>(context, listen: false)
              .getOrderLimit(
        context,
        10,
        0,
        _dateStart == null ? '' : DateFormat('yyyy-MM-dd').format(_dateStart!),
        _dateEnd == null ? '' : DateFormat('yyyy-MM-dd').format(_dateEnd!),
      );

      if (mounted) {
        setState(() {
          _data.addAll(dataOrder!.data);
          totalHistory = dataOrder.totalOrder;
          totalPrice = dataOrder.totalPrice;
          _loadingLoadMore = false;
        });
      }
    }
  }

  Future<void> _loadStart() async {
    _orders.clear();
    _data.clear();
    var _duration = const Duration(seconds: 1);
    if (mounted) {
      setState(() => _loading = true);

      ListHistory? dataOrder =
          await Provider.of<OrderProviders>(context, listen: false)
              .getOrderLimit(
        context,
        10,
        0,
        _dateStart == null ? '' : DateFormat('yyyy-MM-dd').format(_dateStart!),
        _dateEnd == null ? '' : DateFormat('yyyy-MM-dd').format(_dateEnd!),
      );

      Timer(_duration, () {
        if (mounted) {
          setState(() {
            _orders = dataOrder!.data;
            _data = dataOrder.data;
            totalHistory = dataOrder.totalOrder;
            totalPrice = dataOrder.totalPrice;
            _loading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CostumeAppBar(
        title: "",
        profileTitle: "Riwayat",
        dense: true,
      ),
      body: _loading
          ? const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SpaceDims.sp18,
                vertical: SpaceDims.sp14,
              ),
              child: SkeletonOrderCad(),
            )
          : RefreshIndicator(
              onRefresh: _onRefresh,
              child: LoadMore(
                textBuilder: DefaultLoadMoreTextBuilder.english,
                isFinish: isFinisfLoadmore,
                onLoadMore: _loadMore,
                whenEmptyLoad: false,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SpaceDims.sp18,
                        vertical: SpaceDims.sp14,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                  right: SpaceDims.sp8,
                                  left: SpaceDims.sp12,
                                  bottom: SpaceDims.sp4,
                                  top: SpaceDims.sp4,
                                ),
                                width: 160.0,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: ColorSty.white80,
                                    border: Border.all(color: ColorSty.primary),
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: DropdownButton<String>(
                                  isDense: true,
                                  value: _dropdownValue,
                                  alignment: Alignment.topCenter,
                                  borderRadius: BorderRadius.circular(30.0),
                                  icon: const Icon(Icons.arrow_drop_down),
                                  style: TypoSty.caption2.copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                      color: ColorSty.black),
                                  onChanged: (String? newValue) {
                                    setState(() => {
                                          _dropdownValue = newValue!,
                                          // "Semua Status", "Selesai", "Dibatalkan
                                          if (_dropdownValue == 'Selesai')
                                            statusCode = 3,
                                          if (_dropdownValue == 'Dibatalkan')
                                            statusCode = 4,
                                          if (_dropdownValue == 'Semua Status')
                                            statusCode = 5,
                                        });
                                  },
                                  items: [
                                    for (String item in _item)
                                      DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(item),
                                      ),
                                  ],
                                ),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: ColorSty.white80,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      color: ColorSty.primary,
                                    ),
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                                onPressed: _pickDateRange,
                                child: SizedBox(
                                  width: 160.0,
                                  child: Row(
                                    children: [
                                      const SizedBox(width: SpaceDims.sp12),
                                      Text(
                                        _dateRange,
                                        style: TypoSty.caption2.copyWith(
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(width: SpaceDims.sp8),
                                      const Icon(IconsCs.date,
                                          size: 18.0, color: ColorSty.primary),
                                      const SizedBox(width: SpaceDims.sp8),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              //  tampil order history card
                              for (final item in _data)
                                OrderHistoryCard(
                                  onPressed: () {},
                                  data: item,
                                ),
                              const SizedBox(height: 10.0)
                            ],
                          ),
                          // // for (var item
                          // //     in Provider.of<OrderProviders>(context, listen: false)
                          // //         .listHistorys)
                          // for (var item in _data)
                          //   if (item.status == statusCode)
                          //     // OrderHistoryCard(onPressed: () {}),
                          //     _loading
                          //         ? const SkeletonOrderCad()
                          //         : OrderHistoryCard(
                          //             onPressed: () {},
                          //             data: item,
                          //           ),
                          // // for (var item
                          // //     in Provider.of<OrderProviders>(context, listen: false)
                          // //         .listHistorys)
                          // for (var item in _data)
                          //   if (5 == statusCode &&
                          //       (item.status == 3 || item.status == 4))
                          //     // OrderHistoryCard(onPressed: () {}),
                          //     _loading
                          //         ? const SkeletonOrderCad()
                          //         : OrderHistoryCard(
                          //             onPressed: () {},
                          //             data: item,
                          //           ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class OrderHistoryCard extends StatelessWidget {
  final VoidCallback onPressed;
  final Order data;
  const OrderHistoryCard({
    Key? key,
    required this.onPressed,
    required this.data,
  }) : super(key: key);

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
                // child: data.menu[0].foto != null
                //     ? Image.network(data.menu[0].foto ?? '')
                //     : Image.asset("assert/image/menu/1637916792.png"),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: SpaceDims.sp12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: SpaceDims.sp12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data.tgl,
                              style: TypoSty.mini
                                  .copyWith(color: Colors.grey, fontSize: 12.0),
                            ),
                            Row(
                              children: [
                                if (data.status == 4)
                                  Text(
                                    "Dibatalkan",
                                    style: TypoSty.mini.copyWith(
                                        color: const Color.fromARGB(
                                            255, 212, 40, 40),
                                        fontSize: 12.0),
                                  ),
                                if (data.status == 3)
                                  Text(
                                    "Selesai",
                                    style: TypoSty.mini.copyWith(
                                        color: ColorSty.primary,
                                        fontSize: 12.0),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: SpaceDims.sp4),
                      Text(
                        data.nama,
                        style: TypoSty.title.copyWith(fontSize: 18.0),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: SpaceDims.sp4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Rp ${oCcy.format(data.totalBayar)}",
                            style: TypoSty.mini.copyWith(
                                fontSize: 12.0, color: ColorSty.primary),
                          ),
                          const SizedBox(width: SpaceDims.sp8),
                          Text(
                            "(${data.menu.length} Menu)",
                            style: TypoSty.mini.copyWith(
                              fontSize: 12.0,
                              color: ColorSty.grey,
                            ),
                          ),
                        ],
                      ),
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

class SkeletonOrderCad extends StatelessWidget {
  const SkeletonOrderCad({Key? key}) : super(key: key);

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
                padding: const EdgeInsets.only(
                  top: SpaceDims.sp8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: SpaceDims.sp18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          SizedBox(
                            width: 40.0,
                            child: SkeletonText(height: 11),
                          ),
                          SizedBox(
                            width: 90.0,
                            child: SkeletonText(height: 11),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: SpaceDims.sp12),
                    const SkeletonText(height: 26.0),
                    const SizedBox(height: SpaceDims.sp8),
                    Expanded(
                      child: Row(
                        children: const [
                          SizedBox(
                            width: 60.0,
                            child: SkeletonText(height: 14.0),
                          ),
                          SizedBox(width: SpaceDims.sp8),
                          SizedBox(
                            width: 30.0,
                            child: SkeletonText(height: 12.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DateRangePickerDialog extends StatelessWidget {
  const DateRangePickerDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: () {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(SpaceDims.sp12),
          child: SizedBox(
            height: 0.5.sh,
            width: double.infinity,
            child: SfDateRangePicker(
              onSubmit: (value) {
                if (value.runtimeType == PickerDateRange &&
                    (value as PickerDateRange).endDate != null) {
                  Navigator.pop(context, value);
                }
              },
              onCancel: () => Navigator.pop(context),
              showActionButtons: true,
              selectionMode: DateRangePickerSelectionMode.range,
              extendableRangeSelectionDirection:
                  ExtendableRangeSelectionDirection.both,
              view: DateRangePickerView.month,
            ),
          ),
        ),
      );
    });
  }
}
