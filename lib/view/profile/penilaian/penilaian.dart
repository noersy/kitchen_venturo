import 'dart:convert';
import 'dart:io';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kitchen/providers/lang_providers.dart';
import 'package:kitchen/view/profile/penilaian/post_penilaian.dart';
import 'package:kitchen/widget/appbar.dart';

class Penilaian extends StatefulWidget {
  const Penilaian({Key? key}) : super(key: key);

  @override
  _PenilaianState createState() => _PenilaianState();
}

class _PenilaianState extends State<Penilaian> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: LangProviders(),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: const CostumeAppBar(
              title: '',
              profileTitle: 'Penilaian',
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
                        Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF6F6F6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(left: 10, top: 10),
                                        child: Text(
                                          'Berikan Penilaianmu',
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                        ),
                                        child: Column(
                                          children: [
                                            RatingBar.builder(
                                              initialRating: 3,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4.0),
                                              itemBuilder: (context, _) =>
                                                  const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {
                                                // ignore: avoid_print
                                                setState(() {
                                                  score = rating;
                                                  if (rating == 1) {
                                                    RatingText = 'jelek sekali';
                                                  }
                                                  if (rating == 1.5) {
                                                    RatingText = 'jelek';
                                                  }
                                                  if (rating == 2) {
                                                    RatingText = 'biasa sekali';
                                                  }
                                                  if (rating == 2.5) {
                                                    RatingText = 'biasa';
                                                  }
                                                  if (rating == 3) {
                                                    RatingText = 'lumayan';
                                                  }
                                                  if (rating == 3.5) {
                                                    RatingText = 'cukup';
                                                  }
                                                  if (rating == 4) {
                                                    RatingText = 'cukup baik';
                                                  }
                                                  if (rating == 4.5) {
                                                    RatingText = 'baik';
                                                  }
                                                  if (rating == 5) {
                                                    RatingText = 'bagus banget';
                                                  }
                                                });
                                                // print(rating);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  widgetTextRating(RatingText)
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            widgetType(context),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  List listType = [
    'Harga',
    'Rasa',
    'Penyajian Makanan',
    'Pelayanan',
    'Fasilitas'
  ];
  TextEditingController textReviewController = TextEditingController();
  Container widgetType(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: const Color(0xFFF6F6F6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            const Text('Apa yang bisa ditingkatkan?'),
            Wrap(
              children: [
                for (var i in listType) widgetButtonType(i),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(
                thickness: 2,
              ),
            ),
            const Text('Tulis Review'),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                enabled: true,
                style: const TextStyle(fontSize: 12),
                maxLines: 5,
                controller: textReviewController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '',
                    fillColor: Colors.white,
                    filled: true),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      postPenilaian(score, selectedType,
                              textReviewController.text, base64Image)
                          .then((value) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              if (value.toString().contains('berhasil')) {
                                return AlertDialog(
                                  title: const Text('Alert!'),
                                  content: Text('$value'),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          textReviewController.clear();
                                        },
                                        child: const Text('Close')),
                                  ],
                                );
                              } else {
                                return AlertDialog(
                                  title: const Text('Gagal!'),
                                  content: Text('$value'),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          textReviewController.clear();
                                        },
                                        child: const Text('Close')),
                                  ],
                                );
                              }
                            });
                        imageBytes = [];
                        base64Image = '';
                        // print(
                        //     'clearing imageBytes:${imageBytes.length} | base64Image:${base64Image}');
                      });
                    },
                    child: const Text('Kirim Penilaian'),
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    )))),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  width: 40,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromRGBO(0, 154, 173, 1), width: 2),
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      _showPicker(context);
                    },
                    icon: const Icon(
                      Icons.add_photo_alternate,
                      size: 20.0,
                      color: Color.fromRGBO(0, 154, 173, 1),
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }

  // ignore: avoid_init_to_null
  File? _image = null;

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              color: Colors.white,
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      tileColor: Colors.white,
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Galeri'),
                      onTap: () {
                        _imgGaleri();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Kamera'),
                    onTap: () {
                      _imgKamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  List<int> imageBytes = [];
  // ignore: prefer_typing_uninitialized_variables
  var base64Image;
  void submit() async {
    imageBytes = _image!.readAsBytesSync();
    base64Image = base64Encode(imageBytes);
  }

  _imgKamera() async {
    final picker = ImagePicker();
    final image =
        await picker.getImage(source: ImageSource.camera, imageQuality: 20);
    setState(() {
      _image = File(image!.path);
    });
    submit();
  }

  _imgGaleri() async {
    final picker = ImagePicker();
    final image = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 600,
        maxWidth: 600);
    setState(() {
      _image = File(image!.path);
    });
    submit();
  }

  var selectedType = 'Fasilitas';
  Widget widgetButtonType(i) {
    if (i == selectedType) {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: TextButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side:
                          const BorderSide(color: Color.fromRGBO(0, 154, 173, 1))))),
          onPressed: () {},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$i'),
              const SizedBox(
                width: 5,
              ),
              const Icon(Icons.check_circle)
            ],
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: TextButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: const BorderSide(
                          color: Color.fromRGBO(170, 170, 170, 1))))),
          onPressed: () {
            setState(() {
              selectedType = i;
            });
          },
          child: Text(
            '$i',
            style: const TextStyle(color: Color.fromRGBO(170, 170, 170, 1)),
          ),
        ),
      );
    }
  }

  String RatingText = 'rating now';
  double score = 1.0;
  Widget widgetTextRating(text) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Text('$text'),
    );
  }

  String directoryYellow = 'assert/image/icons/star_yellow.png';
  String directoryGray = 'assert/image/icons/star_yellow.png';
}
