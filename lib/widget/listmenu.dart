
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kitchen/theme/colors.dart';
import 'package:kitchen/theme/spacing.dart';
import 'package:kitchen/theme/text_style.dart';
import 'package:kitchen/widget/menuberanda_card.dart';

class ListMenu extends StatefulWidget {
  final String type, title;

  const ListMenu({
    Key? key,
    required this.type,
    required this.title,
  }) : super(key: key);

  @override
  State<ListMenu> createState() => _ListMenuState();
}


class _ListMenuState extends State<ListMenu> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: SpaceDims.sp22),
        Padding(
          padding: const EdgeInsets.only(left: SpaceDims.sp24),
          child: Row(
            children: [
              widget.type == "makanan"
                  ? SvgPicture.asset(
                      "assert/image/icons/ep_food.svg",
                      height: 22,
                    )
                  : SvgPicture.asset(
                      "assert/image/icons/ep_coffee.svg",
                      height: 26,
                    ),
              const SizedBox(width: SpaceDims.sp4),
              Text(
                widget.title,
                style: TypoSty.title.copyWith(color: ColorSty.primary),
              ),
            ],
          ),
        ),
        const SizedBox(height: SpaceDims.sp12),
        SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                  if (widget.type == "makanan")
                    for (Map<String, dynamic> item in datafakeMakanan)
                      CardMenu(data: item),
                  if (widget.type == "minuman")
                    for (Map<String, dynamic> item in datafakeMinuman)
                      CardMenu(data: item),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

List<Map<String, dynamic>> datafakeMakanan = [
  {
    "id": "1",
    "jenis": "makanan",
    "image": "assert/image/menu/1637916792.png",
    "harga": "Rp 10.000",
    "name": "Chicken Katsu",
    "amount": 99,
  },
  {
    "id": "2",
    "jenis": "makanan",
    "image": "assert/image/menu/1637916829.png",
    "harga": "Rp 10.000",
    "name": "Chicken Slam",
    "amount": 99,
  },
  {
    "id": "3",
    "jenis": "makanan",
    "image": "assert/image/menu/167916789.png",
    "harga": "Rp 10.000",
    "name": "Fried Rice",
    "amount": 0,
  },
];

List<Map<String, dynamic>> datafakeMinuman = [
  {
    "id": "4",
    "jenis": "minuman",
    "image": "assert/image/menu/1637916759.png",
    "harga": "Rp 10.000",
    "name": "Es Jeruk",
    "amount": 99,
  },
];
