// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

library java_code_app.get_all_chat;

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kitchen/constans/hosts.dart';
import 'package:kitchen/singletons/user_instance.dart';
import 'package:logging/logging.dart' as logging;

final _log = logging.Logger('OrderProvider');
const headers = {"Content-Type": "application/json", "token": "m_app"};

class Answer {
  var id_answer,
      id_user,
      nama,
      answer,
      created_at,
      is_customer,
      image,
      is_kitchen;
  Answer(
      {this.id_answer,
      this.id_user,
      this.nama,
      this.answer,
      this.created_at,
      this.is_customer,
      this.image,
      this.is_kitchen});
  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id_answer: json['id_answer'],
      id_user: json['id_user'],
      nama: json['nama'],
      answer: json['answer'],
      created_at: json['created_at'],
      is_customer: json['is_customer'],
      is_kitchen: json['is_kitchen'],
    );
  }
  Map<String, dynamic> toJson() => {
        'id_answer': id_answer,
        'id_user': id_user,
        'nama': nama,
        'answer': answer,
        'created_at': created_at,
        'is_customer': is_customer,
        'is_kitchen': is_kitchen,
      };
}

List<Answer> listChat = [];
Future getAllChat(idReview) async {
  final user = UserInstance.getInstance().user;
  if (user == null) return null;
  try {
    _log.fine("Try to get list review");
    final response = await http.get(
        Uri.parse("https://$host/api/review/detail/$idReview"),
        headers: headers);
    print('id review: $idReview | body sukses:\n${response.body}');
    if (response.statusCode == 204) {
      _log.info("review if empty");
      // return [];
    }

    if (response.statusCode == 200 &&
        json.decode(response.body)["status_code"] == 200) {
      _log.fine("Success get all review:");
      return (response.body);
      // return listHistoryFromJson(response.body).data;
    }
    _log.info("Fail to get list review");
    _log.info(response.body);
  } catch (e, r) {
    _log.warning(e);
    _log.warning(r);
  }
  return null;
}

Future postChat(answer, idReview) async {
  final user = UserInstance.getInstance().user;
  if (user == null) return null;

  try {
    final bodys = jsonEncode(<String, dynamic>{
      'answer': '$answer',
      'id_user': '${user.data.idUser}',
      'id_review': '$idReview'
    });
    _log.fine("Try to get postChat $bodys");
    final response = await http.post(
        Uri.parse("https://$host/api/review/answer/add"),
        headers: headers,
        body: bodys);
    if (response.statusCode == 204) {
      _log.info("postChat empty");
      // return [];
    }

    if (response.statusCode == 200 &&
        json.decode(response.body)["status_code"] == 200) {
      _log.fine("Success get all review:");
      return (response.body);
      // print('body sukses:\n${response.body}');
      // return listHistoryFromJson(response.body).data;
    }
    _log.info("Fail to post answer");
    _log.info(response.body);
  } catch (e, r) {
    _log.warning(e);
    _log.warning(r);
  }
  return null;
}
