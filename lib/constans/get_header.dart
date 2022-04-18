import 'package:kitchen/singletons/shared_preferences.dart';

getHeader() async {
  String? token = await Preferences.getInstance().getStringValue('token');
  return {'Content-Type': 'application/json', 'token': "$token"};
}
