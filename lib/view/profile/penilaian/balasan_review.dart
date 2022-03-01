import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kitchen/providers/lang_providers.dart';
import 'package:kitchen/theme/colors.dart';

import 'get_all_chat.dart';

class BalasanReview extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final idReview;
  const BalasanReview({Key? key, this.idReview}) : super(key: key);

  @override
  _BalasanReviewState createState() => _BalasanReviewState();
}

class _BalasanReviewState extends State<BalasanReview> {
  List listBoxChat = [
    true,
    false,
  ];
  loadChat() {
    listChat.clear();
    Future data = getAllChat(widget.idReview);
    data.then((value) {
      print('loadChat: $value');
      Map json = jsonDecode(value);
      // print('json: ${json['data']}');
      var jsonData = json['data'];
      // var getidReview = jsonData['review'];
      // print('getidReview ${getidReview['id_review']}');
      for (var i in jsonData['answer']) {
        // print('i: $i');
        Answer ans = Answer.fromJson(i);
        listChat.add(ans);
      }
      setState(() {
        widgetListChat();
        // idReview = getidReview['id_review'];
      });
    });
  }

  sendChat(answer, idReview) {
    Future data = postChat(answer, idReview);
    data.then((value) {
      loadChat();
      // print('value post chat: $value');
    });
  }

  @override
  void initState() {
    loadChat();
    super.initState();
  }

  final TextEditingController _pesanController = TextEditingController();
  AppBar widgetAppBar() {
    return AppBar(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        )),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: ColorSty.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Balasan Review',
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.center));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: LangProviders(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 229, 229, 229),
            appBar: widgetAppBar(),
            body: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  // borderRadius: BorderRadius.only(
                  //   topLeft: Radius.circular(40.0),
                  //   topRight: Radius.circular(40.0),
                  //   bottomLeft: Radius.circular(40.0),
                  //   bottomRight: Radius.circular(40.0),
                  // )
                ),
                child: Stack(
                  children: [
                    Image.asset("assert/image/bg_daftarpenilaian.png"),
                    widgetListChat(),
                  ],
                )),
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(30.0),
                //   topRight: Radius.circular(30.0),
                // )
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 18.0,
                          top: 5,
                          bottom:
                              MediaQuery.of(context).viewInsets.bottom + 10),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color.fromRGBO(46, 46, 46, 0.25)),
                            color: const Color.fromRGBO(255, 255, 255, 1),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(40.0),
                              topRight: Radius.circular(40.0),
                              bottomLeft: Radius.circular(40.0),
                              bottomRight: Radius.circular(40.0),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 15.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _pesanController,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Tulis Pesan ...'),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                      Icons.add_photo_alternate_outlined)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          right: 15,
                          bottom: MediaQuery.of(context).viewInsets.bottom + 5),
                      child: IconButton(
                        onPressed: () {
                          // print(
                          //     'pesan: ${_pesanController.text} | id review: ${widget.idReview}');
                          sendChat(_pesanController.text, widget.idReview);
                          _pesanController.clear();
                        },
                        icon: const Icon(Icons.send),
                        color: const Color.fromRGBO(0, 154, 173, 1),
                      )),
                ],
              ),
            ),
          );
        });
  }

  ListView widgetListChat() {
    return ListView.builder(
      itemCount: listChat.length,
      itemBuilder: (context, index) {
        return boxChat(context, listChat[index].is_customer, index);
      },
    );
  }

  Padding boxChat(BuildContext context, positionBox, index) {
    var colorBoxChat = const Color.fromRGBO(223, 239, 241, 0.5);
    // ignore: prefer_typing_uninitialized_variables
    var timeBoxChat;
    if (positionBox == true) {
      positionBox = Alignment.topRight;
      colorBoxChat = const Color.fromRGBO(223, 239, 241, 0.5);
      timeBoxChat = Row(children: [
        Text(
          listChat[index].created_at.toString().substring(12, 17),
        ),
        const Icon(Icons.person)
      ]);
    } else if (positionBox == false) {
      positionBox = Alignment.centerLeft;
      colorBoxChat = const Color.fromRGBO(240, 240, 240, 0.5);
      timeBoxChat = Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(
              Icons.person,
              color: Color.fromRGBO(0, 154, 173, 1),
            ),
            Text(
              '${listChat[index].nama} ',
              style: const TextStyle(
                color: Color.fromRGBO(0, 154, 173, 1),
              ),
            ),
            const Text(
              '05.05',
              textAlign: TextAlign.right,
            ),
          ]);
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: positionBox,
        child: FittedBox(
          child: Container(
              decoration: BoxDecoration(
                  color: colorBoxChat,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.circular(40.0),
                  )),
              child: Column(
                children: [
                  timeBoxChat,
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 8.0, right: 10, left: 20),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        '${listChat[index].answer}',
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
