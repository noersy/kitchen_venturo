import 'dart:math';

class RanString {
  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  static final Random _rnd = Random();

  //This creates the single instance by calling the `_internal` constructor specified below
  static final RanString _singleton = RanString._internal();
  RanString._internal();

  //This is what's used to retrieve the instance through the app
  static RanString getInstance() => _singleton;


  String getRandomString(int length) => String.fromCharCodes(
        Iterable.generate(
          length,
          (_) => _chars.codeUnitAt(
            _rnd.nextInt(_chars.length),
          ),
        ),
      );
}

