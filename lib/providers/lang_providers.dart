import 'package:flutter/material.dart';
import 'package:kitchen/constans/languages.dart';
import 'package:kitchen/models/lang.dart';

class LangProviders extends ChangeNotifier {
  static final List<Lang> languages = [
    ConstLang.ind,
    ConstLang.eng,
  ];
  static int _indexLang = 0;

  Lang get lang => languages[_indexLang];
  bool get isIndo => _indexLang == 0;

  changeLang(bool isIndo) async {
    if(isIndo) _indexLang = 0;
    if(!isIndo) _indexLang = 1;
    notifyListeners();
  }
}
