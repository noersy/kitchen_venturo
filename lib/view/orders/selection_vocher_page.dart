import 'package:flutter/material.dart';
import 'package:kitchen/route/route.dart';
import 'package:kitchen/theme/colors.dart';
import 'package:kitchen/theme/icons_cs_icons.dart';
import 'package:kitchen/theme/spacing.dart';
import 'package:kitchen/theme/text_style.dart';
import 'package:kitchen/widget/silver_appbar.dart';

class SelectionVoucherPage extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const SelectionVoucherPage({Key? key, this.initialData}) : super(key: key);

  @override
  State<SelectionVoucherPage> createState() => _SelectionVoucherPageState();
}

class _SelectionVoucherPageState extends State<SelectionVoucherPage> {
  Map<String, dynamic> _selectedVoucher = {};

  @override
  void initState() {
    if (widget.initialData != null) {
      _selectedVoucher.addAll(widget.initialData!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSty.white,
      body: SilverAppBar(
        pinned: true,
        floating: true,
        back: true,
        title: Row(
          children: [
            const Icon(IconsCs.voucher, color: ColorSty.primary),
            const SizedBox(width: SpaceDims.sp18),
            Text("Pilih Voucher", style: TypoSty.title),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: SpaceDims.sp24,
              horizontal: SpaceDims.sp24,
            ),
            child: Column(
              children: [
                if (_selectedVoucher.isEmpty)
                  for (Map<String, dynamic> item in dataVoucher)
                    VoucherCard(
                      isChecked: false,
                      onChanged: (String value){
                        setState(() => _selectedVoucher.addAll(item));
                      },
                      onPressed: (String value) {
                        setState(() => _selectedVoucher.addAll(item));
                      },
                      urlImage: item["urlImage"] ?? "",
                      title: item["title"] ?? "",
                    ),
                if (_selectedVoucher.isNotEmpty)
                  VoucherCard(
                    isChecked: true,
                    onPressed: (String value) {
                      setState(() => _selectedVoucher.clear());
                    },
                    urlImage: _selectedVoucher["urlImage"] ?? "",
                    title: _selectedVoucher["title"] ?? "",
                  )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 106.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ColorSty.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          boxShadow: [
            for (int index in Iterable.generate(15))
              BoxShadow(
                offset: const Offset(0, -3),
                color: ColorSty.grey80.withOpacity(0.02),
                spreadRadius: index.toDouble(),
              ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SpaceDims.sp22),
          child: Column(
            children: [
              const SizedBox(height: SpaceDims.sp14),
              Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: ColorSty.primary,
                    size: 18.0,
                  ),
                  const SizedBox(width: SpaceDims.sp8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Penggunaan voucher tidak dapat digabung dengan"),
                      Text(
                        "discount employee reward program",
                        style: TextStyle(
                          color: ColorSty.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: SpaceDims.sp8),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(_selectedVoucher),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Oke", style: TypoSty.button),
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

class VoucherCard extends StatefulWidget {
  final bool isChecked;
  final String urlImage, title;
  final Function(String string) onPressed;
  final ValueChanged<String>? onChanged;

  const VoucherCard({
    Key? key,
    required this.urlImage,
    required this.title,
    required this.onPressed,
    required this.isChecked,
    this.onChanged,
  }) : super(key: key);

  @override
  _VoucherCardState createState() => _VoucherCardState();
}

class _VoucherCardState extends State<VoucherCard> {
  bool _isSelected = false;

  @override
  void initState() {
    _isSelected = widget.isChecked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SpaceDims.sp8),
      child: ElevatedButton(
        clipBehavior: Clip.antiAlias,
        onPressed: () async{
          _isSelected = (await Navigate.toDetailVoucherPage(
            context,
            title: widget.title,
            urlImage: widget.urlImage,
          )) ?? false;

          if(_isSelected && widget.onChanged != null) widget.onChanged!(widget.title);
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(0),
          primary: ColorSty.bg2,
          onPrimary: ColorSty.grey80,
          // elevation: 5,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: SpaceDims.sp18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: TypoSty.button.copyWith(color: ColorSty.black60),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() => _isSelected = !_isSelected);
                      widget.onPressed(widget.title);
                    },
                    icon: widget.isChecked
                        ? const Icon(
                            Icons.check_box_outlined,
                            color: ColorSty.black60,
                          )
                        : const Icon(
                            Icons.check_box_outline_blank_sharp,
                            color: ColorSty.black60,
                          ),
                  )
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.asset(widget.urlImage, filterQuality: FilterQuality.medium),
            ),
          ],
        ),
      ),
    );
  }
}

List<Map<String, dynamic>> dataVoucher = [
  {
    "title": "Friend Referral Retention",
    "urlImage": "assert/image/voucher/Voucher Java Code app-01.jpg",
    "harga": "Rp 100.000"
  },
  {
    "title": "Koordinator Program Kekompakan",
    "urlImage": "assert/image/voucher/Voucher Java Code app-02.jpg",
    "harga": "Rp 100.000"
  },
  {
    "title": "Birthday",
    "urlImage": "assert/image/voucher/Voucher Java Code app-03.jpg",
    "harga": "Rp 100.000"
  },
  {
    "title": "Friend Referral Retention",
    "urlImage": "assert/image/voucher/Voucher Java Code app-04.jpg",
    "harga": "Rp 100.000"
  },
  {
    "title": "Friend Referral Retention",
    "urlImage": "assert/image/voucher/Voucher Java Code app-05.jpg",
    "harga": "Rp 100.000"
  },
];
