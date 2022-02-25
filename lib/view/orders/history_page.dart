import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchen/theme/colors.dart';
import 'package:kitchen/theme/icons_cs_icons.dart';
import 'package:kitchen/theme/spacing.dart';
import 'package:kitchen/theme/text_style.dart';
import 'package:kitchen/widget/appbar.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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
  static DateTime? _dateStart;
  static DateTime? _dateEnd;
  static int _status = 0;
  static List<Order> _data = [];
  static List<Order> _orders = [];
  static final DateTime _dateNow = DateTime.now();
  String _dateRange = dateFormat.format(_dateNow) +
      " - " +
      dateFormat.format(
        DateTime(_dateNow.year, _dateNow.month, _dateNow.day + 7),
      );
  int statusCode = 3;
  String _dropdownValue = 'Semua Status';
  final List<String> _item = ["Semua Status", "Selesai", "Dibatalkan"];
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool _loading = false;
  getListHisory() async {
    if (mounted) setState(() => _loading = true);
    Provider.of<OrderProviders>(context, listen: false).listHistorys.clear();
    await Provider.of<OrderProviders>(context, listen: false).getListHistory();
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _onRefresh() async {
    var _duration = const Duration(seconds: 2);

    if (mounted) {
      setState(() => _loading = true);
      Timer(_duration, () {
        setState(() => _loading = false);
        _refreshController.refreshCompleted();
      });
    }
  }

  @override
  void initState() {
    getListHisory();
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
      _status = 0;
      _dropdownValue = "Semua Status";
      _data = _orders
          .where((element) => (element.tanggal.compareTo(_dateStart!) >= 0 &&
              element.tanggal.compareTo(_dateEnd!) <= 0))
          .toList();

      _dateRange = dateFormat.format(val.startDate!) +
          " - " +
          dateFormat.format(val.endDate!);
      setState(() {});
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
      body: SmartRefresher(
        onRefresh: _onRefresh,
        controller: _refreshController,
        child: SingleChildScrollView(
          child: Padding(
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
                            color: ColorSty.grey60,
                            border: Border.all(color: ColorSty.primary),
                            borderRadius: BorderRadius.circular(30.0)),
                        child: DropdownButton<String>(
                          isDense: true,
                          value: _dropdownValue,
                          alignment: Alignment.topCenter,
                          borderRadius: BorderRadius.circular(30.0),
                          icon: const Icon(Icons.arrow_drop_down),
                          style: TypoSty.caption2.copyWith(
                              fontSize: 14.0,
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
                          backgroundColor: ColorSty.grey60,
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
                                "25/12/21 - 30/12/21",
                                style: TypoSty.caption2.copyWith(
                                    fontSize: 13.0,
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
                  for (var item
                      in Provider.of<OrderProviders>(context, listen: false)
                          .listHistorys)
                    if (item.status == statusCode)
                      // OrderHistoryCard(onPressed: () {}),
                      _loading
                          ? const SkeletonOrderCad()
                          : OrderHistoryCard(
                              onPressed: () {},
                              data: item,
                            ),
                  for (var item
                      in Provider.of<OrderProviders>(context, listen: false)
                          .listHistorys)
                    if (5 == statusCode &&
                        (item.status == 3 || item.status == 4))
                      // OrderHistoryCard(onPressed: () {}),
                      _loading
                          ? const SkeletonOrderCad()
                          : OrderHistoryCard(
                              onPressed: () {},
                              data: item,
                            ),
                  const SizedBox(height: 100),
                ],
              )),
        ),
      ),
    );
  }
}

class OrderHistoryCard extends StatelessWidget {
  final VoidCallback onPressed;
  final Order data;
  const OrderHistoryCard(
      {Key? key, required this.onPressed, required this.data})
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
                child: Image.asset("assert/image/menu/1637916792.png"),
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
                              "${data.tanggal.toString().substring(0, 10)}",
                              style: TypoSty.mini
                                  .copyWith(color: Colors.grey, fontSize: 14.0),
                            ),
                            Row(
                              children: [
                                if (data.status == 4)
                                  Text(
                                    "Dibatalkan",
                                    style: TypoSty.mini.copyWith(
                                        color: Color.fromARGB(255, 212, 40, 40),
                                        fontSize: 14.0),
                                  ),
                                if (data.status == 3)
                                  Text(
                                    "Selesai",
                                    style: TypoSty.mini.copyWith(
                                        color: ColorSty.primary,
                                        fontSize: 14.0),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: SpaceDims.sp4),
                      Text(
                        data.nama,
                        style: TypoSty.title.copyWith(fontSize: 20.0),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: SpaceDims.sp4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Rp 20.000",
                            style: TypoSty.mini.copyWith(
                                fontSize: 14.0, color: ColorSty.primary),
                          ),
                          const SizedBox(width: SpaceDims.sp8),
                          Text(
                            "(3 Menu)",
                            style: TypoSty.mini.copyWith(
                              fontSize: 14.0,
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
