import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kitchen/providers/lang_providers.dart';
import 'package:kitchen/route/route.dart';
import 'package:kitchen/widget/appbar.dart';
import 'fetch_rating.dart';

class DaftarPenilaian extends StatefulWidget {
  const DaftarPenilaian({Key? key}) : super(key: key);

  @override
  _DaftarPenilaianState createState() => _DaftarPenilaianState();
}

class _DaftarPenilaianState extends State<DaftarPenilaian>
    with TickerProviderStateMixin {
  loadReview() {
    Future data = getAllReview();
    data.then((value) {
      if (value != null) {
        Map json = jsonDecode(value);
        for (var i in json['data']) {
          Review rv = Review.fromJson(i);
          listReview.add(rv);
        }
        setState(() {
          widgetListReview();
        });
      }
    });
  }

  @override
  void initState() {
    clearList();
    loadReview();
    super.initState();
  }

  clearList() {
    listReview.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: LangProviders(),
        builder: (context, snapshot) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Container(
                width: 60,
                height: 60,
                child: const Icon(
                  Icons.add,
                  size: 40,
                ),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [
                      Color.fromARGB(255, 64, 179, 174),
                      Color.fromARGB(255, 1, 154, 173),
                    ])),
              ),
              onPressed: () => Navigate.toPenilaian(context),
            ),
            appBar: const CostumeAppBar(
              title: '',
              profileTitle: 'Daftar Penilaian',
              // profileTitle: lang.profile.title,
              back: true,
            ),
            body: Stack(
              children: [
                Image.asset("assert/image/bg_daftarpenilaian.png"),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        widgetListReview(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  ListView widgetListReview() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: listReview.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // print('review detail id: ${listReview[index].id_review}');
              Navigate.toBalasanReview(context, listReview[index].id_review);
            },
            // onTap: () => Navigate.toChattReview(context),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F6F6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 10),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assert/image/icons/kalender.svg",
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              '${listReview[index].type}',
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 1, 154, 173)),
                            ),
                            RatingBar.builder(
                              ignoreGestures: true,
                              itemSize: 20.0,
                              initialRating: listReview[index].score.toDouble(),
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {},
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 10),
                        child: Text(
                          '${listReview[index].review}',
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        });
  }
}
