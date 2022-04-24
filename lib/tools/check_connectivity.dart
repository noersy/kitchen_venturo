

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kitchen/constans/hosts.dart';

Future<bool> checkConnection({
  BuildContext? context,
  String? titleInput,
}) async {
  bool hasConnection = true;

  try {
    final resultHost = await InternetAddress.lookup(
      host,
    );

    if (resultHost.isNotEmpty && resultHost[0].rawAddress.isNotEmpty) {
      hasConnection = true;
    } else {
      hasConnection = false;
    }
  } on SocketException catch (_) {
    hasConnection = false;
  }

  return hasConnection;
}
