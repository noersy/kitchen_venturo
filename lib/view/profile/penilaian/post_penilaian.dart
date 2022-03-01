// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

library java_code_app.post_penilaian;

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kitchen/constans/hosts.dart';
import 'package:kitchen/singletons/user_instance.dart';
import 'package:logging/logging.dart' as logging;

final _log = logging.Logger('OrderProvider');
var img =
    'iVBORw0KGgoAAAANSUhEUgAAAQ4AAAC7CAMAAACjH4DlAAAAXVBMVEUpMTRnjLEiJiNcfJxrkbgkKSgoLzEmLS5EWWxXdpM0QkxAVGUuOT9kiKslKytSbohPaYJggqM+UF8wO0I6SldIX3Q2RE9LY3oyP0crNDk+UWFWdJA7S1lPaH9jhacMRR/OAAADlElEQVR4nO3c7XKqMBSFYSi4CSCB8CGkKvd/mUfAVoNgHUiPdbuef51aprwDAQLiOAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA.........';
const headers = {"Content-Type": "application/json", "token": "m_app"};
Future postPenilaian(score, type, review, img) async {
  final user = UserInstance.getInstance().user;
  if (user == null) return null;
  try {
    // print('score: $score | type: $type | review: $review  | image: $img ');
    final body = <String, dynamic>{
      'id_user': '${user.data.idUser}',
      'score': '$score',
      'type': '$type',
      'review': '$review',
      'image': img
    };
    _log.fine("Try to post review");
    final response = await http.post(Uri.parse("https://$host/api/review/add"),
        headers: headers, body: json.encode(body));
    // print('response: ${response.body}');
    if (response.statusCode == 204) {
      _log.info("review if empty");
      return [];
    }

    if (response.statusCode == 200 &&
        json.decode(response.body)["status_code"] == 200) {
      _log.fine("Success get all review:");
      // print('body sukses:\n${response.body}');
      return 'input berhasil!';
      // return listHistoryFromJson(response.body).data;
    }
    _log.info("Fail to get list review");
    _log.info(response.body);
  } catch (e, r) {
    _log.warning(e);
    _log.warning(r);
  }
  return 'mohon maaf, anda sudah pernah menginputkan di bulan ini';
}
