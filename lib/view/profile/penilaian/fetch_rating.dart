// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

library java_code_app.fetch_rating;

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kitchen/constans/hosts.dart';
import 'package:kitchen/singletons/user_instance.dart';
import 'package:logging/logging.dart' as logging;

final _log = logging.Logger('OrderProvider');
const headers = {"Content-Type": "application/json", "token": "m_app"};

class Review {
  var id_review, id_user, nama, score, type, review, image, created_at;
  Review(
      {this.id_review,
      this.id_user,
      this.nama,
      this.score,
      this.type,
      this.review,
      this.image,
      this.created_at});
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id_review: json['id_review'],
      id_user: json['id_user'],
      nama: json['nama'],
      score: json['score'],
      type: json['type'],
      review: json['review'],
      image: json['image'],
      created_at: json['created_at'],
    );
  }
  Map<String, dynamic> toJson() => {
        'id_review': id_review,
        'id_user': id_user,
        'nama': nama,
        'score': score,
        'type': type,
        'review': review,
        'image': image,
        'created_at': created_at,
      };
}

List listReview = [];
Future getAllReview() async {
  final user = UserInstance.getInstance().user;
  if (user == null) return null;
  try {
    _log.fine("Try to get list review");
    final response = await http.get(
        // Uri.parse("https://$host/api/review/${user.data.idUser}"),
        Uri.parse("https://$host/api/review"),
        headers: headers);
    if (response.statusCode == 204) {
      _log.info("review if empty");
      // return [];
    }

    if (response.statusCode == 200 &&
        json.decode(response.body)["status_code"] == 200) {
      _log.fine("Success get all review:");
      return (response.body);
      // print('body sukses:\n${response.body}');
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
